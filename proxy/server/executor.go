// Copyright 2019 The Gaea Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package server

import (
	"fmt"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"github.com/nicholaskh/dbproxy/backend"
	"github.com/nicholaskh/dbproxy/core/errors"
	"github.com/nicholaskh/dbproxy/log"
	"github.com/nicholaskh/dbproxy/mysql"
	"github.com/nicholaskh/dbproxy/parser"
	"github.com/nicholaskh/dbproxy/parser/ast"
	"github.com/nicholaskh/dbproxy/parser/format"
	"github.com/nicholaskh/dbproxy/proxy/plan"
	"github.com/nicholaskh/dbproxy/util"
	"github.com/nicholaskh/dbproxy/util/hack"
)

const (
	// master comments
	masterDCSlaveComment = "/*master_dc_slave*/"
	// master comments
	masterComment = "/*master*/"
	// general query log variable
	gaeaGeneralLogVariable = "gaea_general_log"
)

// SessionExecutor is bound to a session, so requests are serializable
type SessionExecutor struct {
	manager *Manager

	namespace  string
	user       string
	db         string
	clientAddr string

	status       uint16
	lastInsertID uint64

	collation        mysql.CollationID
	charset          string
	sessionVariables *mysql.SessionVariables

	txConns map[string]*backend.PooledConnection
	txLock  sync.Mutex

	stmtID uint32
	stmts  map[uint32]*Stmt //prepare相关,client端到proxy的stmt

	parser *parser.Parser

	elapsedTables map[string]int64

	interactive bool //whether from interactive client, eg: mysql client, sql panel on website
}

// Response response info
type Response struct {
	RespType int
	Status   uint16
	Data     interface{}
}

const (
	// RespOK means OK message
	RespOK = iota
	// RespResult means Result message
	RespResult
	// RespError means error message
	RespError
	// RespFieldList means field list message
	RespFieldList
	// RespPrepare prepare response message
	RespPrepare
	// RespEOF means EOF message
	RespEOF
	// RespNoop means empty message
	RespNoop
)

// CreateOKResponse create ok response
func CreateOKResponse(status uint16) Response {
	return Response{
		RespType: RespOK,
		Status:   status,
	}
}

// CreateResultResponse create result response
func CreateResultResponse(status uint16, result *mysql.Result) Response {
	return Response{
		RespType: RespResult,
		Status:   status,
		Data:     result,
	}
}

// CreateErrorResponse create error response
func CreateErrorResponse(status uint16, err error) Response {
	return Response{
		RespType: RespError,
		Status:   status,
		Data:     err,
	}
}

// CreateFieldListResponse create field list response
func CreateFieldListResponse(status uint16, fl []*mysql.Field) Response {
	return Response{
		RespType: RespFieldList,
		Status:   status,
		Data:     fl,
	}
}

// CreatePrepareResponse create prepare response
func CreatePrepareResponse(status uint16, stmt *Stmt) Response {
	return Response{
		RespType: RespPrepare,
		Status:   status,
		Data:     stmt,
	}
}

// CreateEOFResponse create eof response
func CreateEOFResponse(status uint16) Response {
	return Response{
		RespType: RespEOF,
		Status:   status,
	}
}

// CreateNoopResponse no op response, for ComStmtClose
func CreateNoopResponse() Response {
	return Response{
		RespType: RespNoop,
	}
}

func newSessionExecutor(manager *Manager) *SessionExecutor {

	return &SessionExecutor{
		sessionVariables: mysql.NewSessionVariables(),
		txConns:          make(map[string]*backend.PooledConnection),
		stmts:            make(map[uint32]*Stmt),
		parser:           parser.New(),
		status:           initClientConnStatus,
		manager:          manager,
		elapsedTables:    make(map[string]int64),
	}
}

// GetNamespace return namespace in session
func (se *SessionExecutor) GetNamespace() *Namespace {
	return se.manager.GetNamespace(se.namespace)
}

// GetVariables return variables in session
func (se *SessionExecutor) GetVariables() *mysql.SessionVariables {
	return se.sessionVariables
}

func (se *SessionExecutor) setIntSessionVariable(name string, valueStr string) error {
	if strings.ToLower(valueStr) == mysql.KeywordDefault {
		se.sessionVariables.Delete(name)
		return nil
	}

	value, err := strconv.ParseInt(valueStr, 10, 64)
	if err != nil {
		return err
	}
	if err = se.sessionVariables.Set(name, value); err != nil {
		return err
	}
	return nil
}

func (se *SessionExecutor) setStringSessionVariable(name string, valueStr string) error {
	if strings.ToLower(valueStr) == mysql.KeywordDefault {
		se.sessionVariables.Delete(name)
		return nil
	}

	return se.sessionVariables.Set(name, valueStr)
}

func (se *SessionExecutor) setGeneralLogVariable(valueStr string) error {
	v, err := strconv.Atoi(valueStr)
	if err != nil {
		return errors.ErrInvalidArgument
	}
	atomic.StoreUint32(&ProcessGeneralLog, uint32(v))
	return nil
}

// GetLastInsertID return last_inert_id
func (se *SessionExecutor) GetLastInsertID() uint64 {
	return se.lastInsertID
}

// SetLastInsertID store last_insert_id
func (se *SessionExecutor) SetLastInsertID(id uint64) {
	se.lastInsertID = id
}

// GetStatus return session status
func (se *SessionExecutor) GetStatus() uint16 {
	return se.status
}

// SetStatus store status
func (se *SessionExecutor) SetStatus(status uint16) {
	se.status = status
}

// SetCollationID store collation id
func (se *SessionExecutor) SetCollationID(id mysql.CollationID) {
	se.collation = id
}

// SetNamespaceDefaultCollationID store default collation id
func (se *SessionExecutor) SetNamespaceDefaultCollationID() {
	se.collation = se.manager.GetNamespace(se.namespace).GetDefaultCollationID()
}

// GetCollationID return collation id
func (se *SessionExecutor) GetCollationID() mysql.CollationID {
	return se.collation
}

// SetCharset set session charset
func (se *SessionExecutor) SetCharset(charset string) {
	se.charset = charset
}

// SetNamespaceDefaultCharset set session default charset
func (se SessionExecutor) SetNamespaceDefaultCharset() {
	se.charset = se.manager.GetNamespace(se.namespace).GetDefaultCharset()
}

// GetCharset return charset
func (se *SessionExecutor) GetCharset() string {
	return se.charset
}

// SetDatabase set session database
func (se *SessionExecutor) SetDatabase(db string) {
	se.db = db
}

// GetDatabase return database in session
func (se *SessionExecutor) GetDatabase() string {
	return se.db
}

// ExecuteCommand execute command
func (se *SessionExecutor) ExecuteCommand(cmd byte, data []byte) Response {
	switch cmd {
	case mysql.ComQuit:
		se.handleRollback()
		// https://dev.mysql.com/doc/internals/en/com-quit.html
		// either a connection close or a OK_Packet, OK_Packet will cause client RST sometimes, but doesn't affect sql execute
		return CreateNoopResponse()
	case mysql.ComQuery: // data type: string[EOF]
		sql := string(data)
		// handle phase
		r, err := se.handleQuery(sql)
		if err != nil {
			return CreateErrorResponse(se.status, err)
		}
		return CreateResultResponse(se.status, r)
	case mysql.ComPing:
		return CreateOKResponse(se.status)
	case mysql.ComInitDB:
		db := string(data)
		// handle phase
		err := se.handleUseDB(db)
		if err != nil {
			return CreateErrorResponse(se.status, err)
		}
		return CreateOKResponse(se.status)
	case mysql.ComFieldList:
		fs, err := se.handleFieldList(data)
		if err != nil {
			return CreateErrorResponse(se.status, err)
		}
		return CreateFieldListResponse(se.status, fs)
	case mysql.ComStmtPrepare:
		sql := string(data)
		stmt, err := se.handleStmtPrepare(sql)
		if err != nil {
			return CreateErrorResponse(se.status, err)
		}
		return CreatePrepareResponse(se.status, stmt)
	case mysql.ComStmtExecute:
		values := make([]byte, len(data))
		copy(values, data)
		r, err := se.handleStmtExecute(values)
		if err != nil {
			return CreateErrorResponse(se.status, err)
		}
		return CreateResultResponse(se.status, r)
	case mysql.ComStmtClose: // no response
		if err := se.handleStmtClose(data); err != nil {
			return CreateErrorResponse(se.status, err)
		}
		return CreateNoopResponse()
	case mysql.ComStmtSendLongData: // no response
		values := make([]byte, len(data))
		copy(values, data)
		if err := se.handleStmtSendLongData(values); err != nil {
			return CreateErrorResponse(se.status, err)
		}
		return CreateNoopResponse()
	case mysql.ComStmtReset:
		if err := se.handleStmtReset(data); err != nil {
			return CreateErrorResponse(se.status, err)
		}
		return CreateOKResponse(se.status)
	case mysql.ComSetOption:
		return CreateEOFResponse(se.status)
	default:
		msg := fmt.Sprintf("command %d not supported now", cmd)
		log.Warn("dispatch command failed, error: %s", msg)
		return CreateErrorResponse(se.status, mysql.NewError(mysql.ErrUnknown, msg))
	}
}

func (se *SessionExecutor) getBackendConns(sqls map[string]map[string][]string, executeFlag int) (pcs map[string]*backend.PooledConnection, err error) {
	pcs = make(map[string]*backend.PooledConnection)
	for sliceName := range sqls {
		var pc *backend.PooledConnection
		pc, err = se.getBackendConn(sliceName, executeFlag)
		if err != nil {
			return
		}
		pcs[sliceName] = pc
	}
	return
}

func (se *SessionExecutor) getBackendConn(sliceName string, executeFlag int) (pc *backend.PooledConnection, err error) {
	if !se.isInTransaction() {
		slice := se.GetNamespace().GetSlice(sliceName)
		return slice.GetConn(executeFlag, se.GetNamespace().GetUserProperty(se.user))
	}
	return se.getTransactionConn(sliceName)
}

func (se *SessionExecutor) getTransactionConn(sliceName string) (pc *backend.PooledConnection, err error) {
	se.txLock.Lock()
	defer se.txLock.Unlock()

	var ok bool
	pc, ok = se.txConns[sliceName]

	if !ok {
		slice := se.GetNamespace().GetSlice(sliceName) // returns nil only when the conf is error (fatal) so panic is correct
		if pc, err = slice.GetMasterConn(); err != nil {
			return
		}

		if !se.isAutoCommit() {
			if err = pc.SetAutoCommit(0); err != nil {
				pc.Close()
				pc.Recycle()
				return
			}
		} else {
			if err = pc.Begin(); err != nil {
				pc.Close()
				pc.Recycle()
				return
			}
		}

		se.txConns[sliceName] = pc
	}

	return
}

func (se *SessionExecutor) executeInSlice(reqCtx *util.RequestContext, pc *backend.PooledConnection, sql string) ([]*mysql.Result, error) {
	startTime := time.Now()
	r, err := pc.Execute(sql)
	if !se.interactive {
		se.manager.RecordBackendSQLMetrics(reqCtx, se.namespace, sql, pc.GetAddr(), startTime, err)
	}

	if err != nil {
		return nil, err
	}

	return []*mysql.Result{r}, err
}

func (se *SessionExecutor) recycleBackendConn(pc *backend.PooledConnection, rollback bool) {
	if pc == nil {
		return
	}

	if se.isInTransaction() {
		return
	}

	if rollback {
		pc.Rollback()
	}

	pc.Recycle()
}

func (se *SessionExecutor) recycleBackendConns(pcs map[string]*backend.PooledConnection, rollback bool) {
	if se.isInTransaction() {
		return
	}

	for _, pc := range pcs {
		if pc == nil {
			continue
		}
		if rollback {
			pc.Rollback()
		}
		pc.Recycle()
	}
}

func initBackendConn(pc *backend.PooledConnection, phyDB string, charset string, collation mysql.CollationID, sessionVariables *mysql.SessionVariables) error {
	if err := pc.UseDB(phyDB); err != nil {
		return err
	}

	charsetChanged, err := pc.SetCharset(charset, collation)
	if err != nil {
		return err
	}

	variablesChanged, err := pc.SetSessionVariables(sessionVariables)
	if err != nil {
		return err
	}

	if charsetChanged || variablesChanged {
		if err = pc.WriteSetStatement(); err != nil {
			return err
		}
	}

	return nil
}

func (se *SessionExecutor) executeInMultiSlices(reqCtx *util.RequestContext, pcs map[string]*backend.PooledConnection,
	sqls map[string]map[string][]string) ([]*mysql.Result, error) {

	if len(pcs) != len(sqls) {
		log.Warn("Session executeInMultiSlices error, conns: %v, sqls: %v, error: %s", pcs, sqls, errors.ErrConnNotEqual.Error())
		return nil, errors.ErrConnNotEqual
	}

	var wg sync.WaitGroup

	if len(pcs) == 0 {
		return nil, errors.ErrNoPlan
	}

	wg.Add(len(pcs))

	resultCount := 0
	for _, sqlSlice := range sqls {
		for _, sqlDB := range sqlSlice {
			resultCount += len(sqlDB)
		}
	}

	rs := make([]interface{}, resultCount)

	f := func(reqCtx *util.RequestContext, rs []interface{}, i int, execSqls map[string][]string, pc *backend.PooledConnection) {
		for db, sqls := range execSqls {
			err := initBackendConn(pc, db, se.GetCharset(), se.GetCollationID(), se.GetVariables())
			if err != nil {
				rs[i] = err
				break
			}
			for _, v := range sqls {
				startTime := time.Now()
				r, err := pc.Execute(v)

				// record sql timing
				if !se.interactive {
					se.manager.RecordBackendSQLMetrics(reqCtx, se.namespace, v, pc.GetAddr(), startTime, err)
				}
				if err != nil {
					rs[i] = err
				} else {
					rs[i] = r
				}
				i++
			}
		}
		wg.Done()
	}

	offset := 0
	for sliceName, pc := range pcs {
		s := sqls[sliceName] //map[string][]string
		go f(reqCtx, rs, offset, s, pc)
		for _, sqlDB := range sqls[sliceName] {
			offset += len(sqlDB)
		}
	}

	wg.Wait()

	var err error
	r := make([]*mysql.Result, resultCount)
	for i, v := range rs {
		if e, ok := v.(error); ok {
			err = e
			break
		}
		if rs[i] != nil {
			r[i] = rs[i].(*mysql.Result)
		}
	}

	return r, err
}

func canHandleWithoutPlan(stmtType int) bool {
	return stmtType == parser.StmtShow ||
		stmtType == parser.StmtSet ||
		stmtType == parser.StmtBegin ||
		stmtType == parser.StmtCommit ||
		stmtType == parser.StmtRollback ||
		stmtType == parser.StmtSavepoint ||
		stmtType == parser.StmtUse
}

const variableRestoreFlag = format.RestoreKeyWordLowercase | format.RestoreNameLowercase

// 获取SET语句中变量的字符串值, 去掉各种引号并转换为小写
func getVariableExprResult(v ast.ExprNode) string {
	s := &strings.Builder{}
	ctx := format.NewRestoreCtx(variableRestoreFlag, s)
	v.Restore(ctx)
	return strings.ToLower(s.String())
}

func getOnOffVariable(v string) (string, error) {
	if v == "1" || v == "on" {
		return "1", nil
	} else if v == "0" || v == "off" {
		return "0", nil
	} else {
		return "", fmt.Errorf("not an on off string")
	}
}

// master-slave routing
func updateWriteTableCurrentTime(c *SessionExecutor, sql string, p plan.Plan, currentMsTime int64) {
	status := parser.Preview(sql)
	if status == parser.StmtInsert || status == parser.StmtUpdate || status == parser.StmtDelete {
		if p != nil {
			for _, val := range p.GetElapsedTables() {
				c.elapsedTables[val] = currentMsTime
			}
		}
	}
}

//表维度级别，同一个连接里，如果某个时间段内有写请求，则读请求直接走master机房
func readRequestIsReadMaster(c *SessionExecutor, currentTables []string, currentMsTime int64) bool {
	for _, val := range currentTables {
		if timeMs, ok := c.elapsedTables[val]; ok {
			elapsed := currentMsTime - timeMs
			if elapsed >= 0 && elapsed < int64(c.manager.writeElapsedInterval) {
				return true
			}
		}
	}

	return false

}

// master-slave routing
func getExecuteFlagFromSlave(c *SessionExecutor, sql string, currentTables []string, currentMsTime int64) int {
	if parser.Preview(sql) != parser.StmtSelect {
		return backend.MasterFlag
	}
	_, comments := parser.SplitMarginComments(sql)
	lcomment := strings.ToLower(strings.TrimSpace(comments.Leading))
	var flag = c.GetNamespace().GetRWSplit(c.user)

	//只有从机房才有以下两个逻辑
	masterDC := c.GetNamespace().GetMasterDC()
	if masterDC == false && (strings.ToLower(lcomment) == masterDCSlaveComment || readRequestIsReadMaster(c, currentTables, currentMsTime)) {
		flag = backend.MasterDCFlag
	}

	if strings.ToLower(lcomment) == masterComment {
		flag = backend.MasterFlag
	}

	return flag
}

// master-slave routing
func canExecuteFromSlave(c *SessionExecutor, sql string, currentTables []string, currentMsTime int64) bool {
	if parser.Preview(sql) != parser.StmtSelect {
		return false
	}

	_, comments := parser.SplitMarginComments(sql)
	lcomment := strings.ToLower(strings.TrimSpace(comments.Leading))
	var fromSlave = c.GetNamespace().IsRWSplit(c.user)
	if strings.ToLower(lcomment) == masterComment || readRequestIsReadMaster(c, currentTables, currentMsTime) {
		fromSlave = false
	}

	return fromSlave
}

// 如果是只读用户, 且SQL是INSERT, UPDATE, DELETE, 则拒绝执行, 返回true
func isSQLNotAllowedByUser(c *SessionExecutor, stmtType int) bool {
	if c.GetNamespace().IsAllowWrite(c.user) {
		return false
	}

	return stmtType == parser.StmtDelete || stmtType == parser.StmtInsert || stmtType == parser.StmtUpdate
}

func modifyResultStatus(r *mysql.Result, cc *SessionExecutor) {
	r.Status = r.Status | cc.GetStatus()
}

func createShowDatabaseResult(dbs []string) *mysql.Result {
	r := new(mysql.Resultset)

	field := &mysql.Field{}
	field.Name = hack.Slice("Database")
	r.Fields = append(r.Fields, field)

	for _, db := range dbs {
		r.Values = append(r.Values, []interface{}{db})
	}

	result := &mysql.Result{
		AffectedRows: uint64(len(dbs)),
		Resultset:    r,
	}

	plan.GenerateSelectResultRowData(result)
	return result
}

func createShowGeneralLogResult() *mysql.Result {
	r := new(mysql.Resultset)

	field := &mysql.Field{}
	field.Name = hack.Slice(gaeaGeneralLogVariable)
	r.Fields = append(r.Fields, field)

	var value string
	if OpenProcessGeneralQueryLog() {
		value = "ON"
	} else {
		value = "OFF"
	}
	r.Values = append(r.Values, []interface{}{value})
	result := &mysql.Result{
		AffectedRows: 1,
		Resultset:    r,
	}

	plan.GenerateSelectResultRowData(result)
	return result
}

func getExecuteFlag(reqCtx *util.RequestContext) int {
	executeFlag := reqCtx.Get(util.ExecuteFlag)
	if executeFlag != nil {
		return executeFlag.(int)
	}

	return backend.MasterFlag
}

func getFromSlave(reqCtx *util.RequestContext) bool {
	slaveFlag := reqCtx.Get(util.ExecuteFlag)
	if slaveFlag != nil && slaveFlag.(int) == 1 {
		return true
	}

	return false
}

func (se *SessionExecutor) isInTransaction() bool {
	return se.status&mysql.ServerStatusInTrans > 0 ||
		!se.isAutoCommit()
}

func (se *SessionExecutor) isAutoCommit() bool {
	return se.status&mysql.ServerStatusAutocommit > 0
}

func (se *SessionExecutor) handleBegin() error {
	se.txLock.Lock()
	defer se.txLock.Unlock()

	for _, co := range se.txConns {
		if err := co.Begin(); err != nil {
			return err
		}
	}
	se.status |= mysql.ServerStatusInTrans
	return nil
}

func (se *SessionExecutor) handleCommit() (err error) {
	if err := se.commit(); err != nil {
		return err
	}

	return nil

}

func (se *SessionExecutor) handleRollback() (err error) {
	return se.rollback()
}

func (se *SessionExecutor) handleRollbackTo(savepoint string) (err error) {
    return se.rollbackTo(savepoint)
}

func (se *SessionExecutor) handleSavepoint(savepoint string) (err error) {
    return se.savepoint(savepoint)
}

func (se *SessionExecutor) commit() (err error) {
	se.txLock.Lock()
	defer se.txLock.Unlock()

	se.status &= ^mysql.ServerStatusInTrans

	for _, pc := range se.txConns {
		if e := pc.Commit(); e != nil {
			err = e
		}
		pc.Recycle()
	}

	se.txConns = make(map[string]*backend.PooledConnection)
	return
}

func (se *SessionExecutor) rollback() (err error) {
	se.txLock.Lock()
	defer se.txLock.Unlock()

	se.status &= ^mysql.ServerStatusInTrans

	for _, pc := range se.txConns {
		if e := pc.Rollback(); e != nil {
			err = e
		}
		pc.Recycle()
	}

	se.txConns = make(map[string]*backend.PooledConnection)
	return
}

func (se *SessionExecutor) rollbackTo(savepoint string) (err error) {
	se.txLock.Lock()
	defer se.txLock.Unlock()

	for _, pc := range se.txConns {
		if e := pc.RollbackTo(savepoint); e != nil {
			err = e
		}
		pc.Recycle()
	}

	se.txConns = make(map[string]*backend.PooledConnection)
	return
}

func (se *SessionExecutor) savepoint(savepoint string) (err error) {
	se.txLock.Lock()
	defer se.txLock.Unlock()

	for _, pc := range se.txConns {
		if e := pc.Savepoint(savepoint); e != nil {
			err = e
		}
		pc.Recycle()
	}

	se.txConns = make(map[string]*backend.PooledConnection)
	return
}

// ExecuteSQL execute sql
func (se *SessionExecutor) ExecuteSQL(reqCtx *util.RequestContext, slice, db, sql string) (*mysql.Result, error) {
	pc, err := se.getBackendConn("slice-0", getExecuteFlag(reqCtx))
	defer se.recycleBackendConn(pc, false)
	if err != nil {
		return nil, err
	}

	phyDB, err := se.GetNamespace().GetDefaultPhyDB(db)
	if err != nil {
		return nil, err
	}

	if err = initBackendConn(pc, phyDB, se.charset, se.collation, se.sessionVariables); err != nil {
		return nil, err
	}

	// execute.sql may be rewritten in getShowExecDB
	rs, err := se.executeInSlice(reqCtx, pc, sql)
	if err != nil {
		return nil, err
	}

	if len(rs) == 0 {
		msg := fmt.Sprintf("result is empty")
		log.Warn("[server] Session handle Unsupport: %s, sql: %s", msg, sql)
		return nil, mysql.NewError(mysql.ErrUnknown, msg)
	}
	return rs[0], nil
}

// ExecuteSQLs len(sqls) must not be 0, or return error
func (se *SessionExecutor) ExecuteSQLs(reqCtx *util.RequestContext, sqls map[string]map[string][]string) ([]*mysql.Result, error) {
	if len(sqls) == 0 {
		return nil, fmt.Errorf("no sql to execute")
	}

	pcs, err := se.getBackendConns(sqls, getExecuteFlag(reqCtx))
	defer se.recycleBackendConns(pcs, false)
	if err != nil {
		log.Warn("getShardConns failed: %v", err)
		return nil, err
	}

	rs, err := se.executeInMultiSlices(reqCtx, pcs, sqls)
	if err != nil {
		log.Warn("executeInMultiSlices error: %v", err)
		return nil, err
	}
	return rs, nil
}
