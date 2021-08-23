package projects

import (
	"github.com/spf13/cast"
	"github.com/stretchr/testify/suite"
	"testing"
)

type ProjectSuite struct {
	BaseSuite
}

func (suite *ProjectSuite) SelectSqlParams() []interface{} {
	var sql []interface{}
	return sql
}

func (suite *ProjectSuite) UpdateSqlParams() []interface{} {
	var sql []interface{}
	return sql
}

func (suite *ProjectSuite) InsertSqlParams() []interface{} {
	var sql []interface{}
	return sql
}

func (suite *ProjectSuite) DeleteSqlParams() []interface{} {
	var sql []interface{}
	return sql
}

func (suite *ProjectSuite) TestSelect() {
	list := suite.SelectSqlParams()
	for _, v := range list {
		vs := v.(map[string]interface{})
		vp := vs["params"].([]interface{})
		b, err := suite.GeneralSelect(cast.ToString(vs["sql"]), vp)
		suite.NoError(err, "sql and params", cast.ToString(vs["sql"]), vp)
		suite.Equal(true, b, "sql and params", cast.ToString(vs["sql"]), vp)
	}
}

func (suite *ProjectSuite) TestUpdate() {
	uList := suite.UpdateSqlParams()
	for _, v := range uList {
		sqlParams := v.(map[string]interface{})
		uParams := sqlParams["uParams"].([]interface{})
		params := sqlParams["params"].([]interface{})
		_, err := suite.GeneralUpdate(cast.ToString(sqlParams["uSql"]), uParams)
		suite.NoError(err, "sql and params", cast.ToString(sqlParams["uSql"]), uParams)
		b, err := suite.GeneralSelect(cast.ToString(sqlParams["sql"]), params)
		suite.NoError(err, "sql and params", cast.ToString(sqlParams["uSql"]), uParams)
		suite.Equal(true, b, "sql and params", cast.ToString(sqlParams["uSql"]), uParams)
	}
}

func (suite *ProjectSuite) TestInsert() {
	iList := suite.InsertSqlParams()
	for _, v := range iList {
		sqlParams := v.(map[string]interface{})
		iParams := sqlParams["iParams"].([]interface{})
		params := sqlParams["params"].([]interface{})
		r, err := suite.GeneralInsert(cast.ToString(sqlParams["iSql"]), iParams)
		suite.NoError(err, "sql and params", cast.ToString(sqlParams["iSql"]), iParams)
		if err == nil {
			id, _ := r.LastInsertId()
			params = append(params, id)
			b, err := suite.GeneralSelect(cast.ToString(sqlParams["sql"]), params)
			suite.NoError(err, "sql and params", cast.ToString(sqlParams["iSql"]), iParams)
			suite.Equal(true, b, "sql and params", cast.ToString(sqlParams["iSql"]), iParams)
		}
	}
}

func (suite *ProjectSuite) TestDelete() {
	dList := suite.DeleteSqlParams()
	for _, v := range dList {
		sqlParams := v.(map[string]interface{})
		dParams := sqlParams["dParams"].([]interface{})
		params := sqlParams["params"].([]interface{})
		_, err := suite.GeneralDelete(cast.ToString(sqlParams["dSql"]), dParams)
		suite.NoError(err, "sql and params", cast.ToString(sqlParams["dSql"]), dParams)
		b, err := suite.GeneralSelect(cast.ToString(sqlParams["sql"]), params)
		suite.NoError(err, cast.ToString(sqlParams["dSql"]), dParams)
		suite.Equal(true, b, "sql and params", cast.ToString(sqlParams["dSql"]), dParams)
	}
}

func TestProject(t *testing.T) {
	t.Parallel()
	ts := &ProjectSuite{}
	suite.Run(t, ts)
}
