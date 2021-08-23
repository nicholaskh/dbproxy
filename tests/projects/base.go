package projects

import (
	"database/sql"
	"fmt"
	"github.com/nicholaskh/dbproxy/tests/conf"
	"reflect"
	"strings"

	_ "github.com/go-sql-driver/mysql"
	"github.com/stretchr/testify/suite"
)

type BaseSuite struct {
	suite.Suite
	gdb *sql.DB
	db  *sql.DB
}

func (suite *BaseSuite) SetupSuite() {
	gdsn := fmt.Sprintf("%s:%s@%s(%s:%d)/%s", conf.Conf.Gaea.Username, conf.Conf.Gaea.Password, conf.Conf.Gaea.Network, conf.Conf.Gaea.Server, conf.Conf.Gaea.Port, conf.Conf.Gaea.Database)
	gdb, err := sql.Open(conf.Conf.DriverName, gdsn)
	if err != nil {
		panic(err)
	}
	suite.gdb = gdb
	dsn := fmt.Sprintf("%s:%s@%s(%s:%d)/%s", conf.Conf.Mysql.User, conf.Conf.Mysql.Password, conf.Conf.Mysql.Network, conf.Conf.Mysql.Server, conf.Conf.Mysql.Port, conf.Conf.Mysql.Database)
	db, err := sql.Open(conf.Conf.DriverName, dsn)
	if err != nil {
		panic(err)
	}
	suite.db = db
	return
}

func (suite *BaseSuite) TearDownSuite() {
	suite.gdb.Close()
	suite.db.Close()
}

func (suite *BaseSuite) GeneralSelect(sqlStr string, params []interface{}) (b bool, err error) {
	grows, err := suite.gdb.Query(sqlStr, params...)
	if err != nil {
		return false, err
	}
	gres := MapSqlDataList(grows)
	rows, err := suite.db.Query(sqlStr, params...)
	if err != nil {
		return false, err
	}
	res := MapSqlDataList(rows)
	if reflect.DeepEqual(gres, res) {
		return true, nil
	} else {
		return false, nil
	}
}

func (suite *BaseSuite) GeneralUpdate(sqlStr string, params []interface{}) (r sql.Result, err error) {
	return suite.gdb.Exec(sqlStr, params...)
}

func (suite *BaseSuite) GeneralInsert(sqlStr string, params []interface{}) (r sql.Result, err error) {
	return suite.gdb.Exec(sqlStr, params...)
}

func (suite *BaseSuite) GeneralDelete(sqlStr string, params []interface{}) (r sql.Result, err error) {
	return suite.gdb.Exec(sqlStr, params...)
}

func (suite *BaseSuite) GeneralSet(sqlStr string, params []interface{}) (r sql.Result, err error) {
	return suite.gdb.Exec(sqlStr, params...)
}

func MapSqlDataList(rows *sql.Rows) []map[string]string {
	columns, err := rows.Columns()
	if err != nil {
		panic(err.Error())
	}
	values := make([]sql.RawBytes, len(columns))
	scanArgs := make([]interface{}, len(values))
	for i := range values {
		scanArgs[i] = &values[i]
	}
	var res []map[string]string
	for rows.Next() {
		err = rows.Scan(scanArgs...)
		if err != nil {
			panic(err.Error())
		}
		rowMap := make(map[string]string)
		var value string
		for i, col := range values {
			if col != nil {
				value = string(col)
				rowMap[columns[i]] = value
			}
		}
		res = append(res, rowMap)
	}
	return res
}

func UderscoreToUpperCamelCase(s string) string {
	s = strings.Replace(s, "_", " ", -1)
	s = strings.Title(s)
	return strings.Replace(s, " ", "", -1)
}
