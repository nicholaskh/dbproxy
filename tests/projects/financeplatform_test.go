package projects

import (
	"github.com/spf13/cast"
	"github.com/stretchr/testify/suite"
	"testing"
)

type FinancePlatformSuite struct {
	BaseSuite
}

func (suite *FinancePlatformSuite) InsertSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"iSql":    "insert into `finance_sea_data_sync` (`real_price`,`stu_id`,`total_plans`,`course_period`,`goods_no`,`course_schedule_id`,`course_type`,`order_num`,`product_id`,`product_name`,`course_price`,`promotion_price`,`coupon_price`,`grade_id`,`subject_id`,`term_id`,`gongbenfei`,`refund_price`,`refund_time`,`course_time`,`pay_time`,`type`,`is_full_refund`,`confirm_time`,`create_time`,`confirm_day`) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
			"iParams": []interface{}{"572000", "188998", "22", "2", "366P013586204D0123B", "0", "3", "20200401188998115349", "5876", "新标准课春高二数学22课时", "726000", "0", "0", "12", "2", "1", "0", "0", "0000-00-00 00:00:00", "0000-00-00 00:00:00", "2020-04-01 11:56:11", "0", "0", "2020-04-01 11:53:49", "2020-09-21 16:47:21", "20180203"},
			"sql":     "select * from finance_sea_data_sync where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from finance_sea_data_sync where id = ?",
			"dParams": []interface{}{},
		},
	}
	return sql
}

func (suite *FinancePlatformSuite) TestInsert() {
	iList := suite.InsertSqlParams()
	for _, v := range iList {
		sqlParams := v.(map[string]interface{})
		iParams := sqlParams["iParams"].([]interface{})
		params := sqlParams["params"].([]interface{})
		dParams := sqlParams["dParams"].([]interface{})
		r, err := suite.GeneralInsert(cast.ToString(sqlParams["iSql"]), iParams)
		suite.NoError(err, "sql and params", cast.ToString(sqlParams["iSql"]), iParams)
		if err == nil {
			id, _ := r.LastInsertId()
			params = append(params, id)
			dParams = append(dParams, id)
			b, err := suite.GeneralSelect(cast.ToString(sqlParams["sql"]), params)
			suite.NoError(err, "sql and params", cast.ToString(sqlParams["iSql"]), iParams)
			suite.Equal(true, b, "sql and params", cast.ToString(sqlParams["iSql"]), iParams)
			suite.GeneralDelete(cast.ToString(sqlParams["dSql"]), dParams)
		}
	}
}

func TestFinancePlatform(t *testing.T) {
	t.Parallel()
	ts := &FinancePlatformSuite{}
	suite.Run(t, ts)
}
