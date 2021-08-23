package projects

import (
	"github.com/spf13/cast"
	"github.com/stretchr/testify/suite"
	"testing"
)

type SetSqlSuite struct {
	BaseSuite
}

func (suite *SetSqlSuite) SetSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"sql":    "set names utf8",
			"params": []interface{}{},
		},
		map[string]interface{}{
			"sql":    "set names utf8mb4",
			"params": []interface{}{},
		},
		map[string]interface{}{
			"sql":    "set character_set_connection=utf8mb4,character_set_results=utf8mb4,character_set_client=binary,sql_mode=?",
			"params": []interface{}{"ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER"},
		},
	}
	return sql
}

func (suite *SetSqlSuite) TestSetSql() {
	sList := suite.SetSqlParams()
	for _, v := range sList {
		vs := v.(map[string]interface{})
		vp := vs["params"].([]interface{})
		_, err := suite.GeneralSet(cast.ToString(vs["sql"]), vp)
		suite.NoError(err, "sql and params", cast.ToString(vs["sql"]), vp)
	}
}

func TestSetSqlSuite(t *testing.T) {
	t.Parallel()
	ts := &SetSqlSuite{}
	suite.Run(t, ts)
}
