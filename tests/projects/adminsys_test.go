package projects

import (
	"github.com/spf13/cast"
	"github.com/stretchr/testify/suite"
	"testing"
)

type AdminSysSuite struct {
	BaseSuite
}

func (suite *AdminSysSuite) SelectSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"sql":    "select * from data_tag where `id` = ? limit ?,?",
			"params": []interface{}{"1", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select a.app_id,a.data_tag_id,c.data_tag_type_id,b.data_tag_type_name,c.data_tag_name,c.data_tag_val,c.data_tag_des from data_tag_staffs_relate as a,data_tag_type as b, data_tag as c where a.emplid = ? and a.app_id=? and a.data_tag_id = c.id and c.data_tag_type_id = b.id and a.status = ? and b.status = ? and c.status = ?",
			"params": []interface{}{"082573", "2", "1", "1", "1"},
		},
		map[string]interface{}{
			"sql":    "select a.emplid as emplid,b.data_tag_val as data_tag_val from data_tag_staffs_relate as a,data_tag as b where a.data_tag_id = b.id and a.status = ? and b.status = ? and a.emplid = ? and a.app_id=?",
			"params": []interface{}{"1", "1", "082573", "2"},
		},
		map[string]interface{}{
			"sql":    "select a.emplid,a.creater_id,a.create_time,a.status,group_concat(a.data_tag_id) as data_tag_ids,group_concat(b.data_tag_name) as data_tag_names from data_tag_staffs_relate as a,data_tag as b where a.status = ? and b.status =? and a.app_id=? and a.data_tag_id = b.id and a.emplid in(?,?) group by emplid limit ?,?",
			"params": []interface{}{"1", "1", "2", "082573", "087516", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select app_ids,grade from admin where `emplid` = ? and `status` = ? limit ?,?",
			"params": []interface{}{"159775", "1", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select appr_tal_num,appr_name from role where `id` in(?,?) and `type` = ? and `status` = ? limit ?,?",
			"params": []interface{}{"1", "2", "2", "1", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select count(*) as total from account_relate where emplid = ?",
			"params": []interface{}{"217536"},
		},
		map[string]interface{}{
			"sql":    "select count(*) as total from application where `emplid` = ?",
			"params": []interface{}{"217536"},
		},
		map[string]interface{}{
			"sql":    "select count(*) as total from role where app_id = ? and status = ?",
			"params": []interface{}{"2", "1"},
		},
		map[string]interface{}{
			"sql":    "select count(*) as total from staff_ehr where `hr_status` = ? and `deptid` = ?",
			"params": []interface{}{"A", "D1020965"},
		},
		map[string]interface{}{
			"sql":    "select deptid from staff_ehr where `emplid` = ? and `hr_status` = ? limit ?,?",
			"params": []interface{}{"082573", "A", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select deptid,descr,descrshort,parent_dept_ids from department_ehr where `deptid` in(?,?) and `eff_status` = ? limit ?,?",
			"params": []interface{}{"D1001112", "D1001151", "A", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select emplid,name,email_addr,deptid,t_dept_descr from staff_ehr where `emplid` = ? and `empl_rcd` = ? and `hr_status` = ? limit ?,?",
			"params": []interface{}{"082573", "0", "A", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select id from role where `app_id` = ? and `status` = ? limit ?,?",
			"params": []interface{}{"2", "2", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select id from role where `app_id` = ? and `type` = ? and `status` = ? limit ?,?",
			"params": []interface{}{"2", "1", "2", "0", "5"},
		},
	}
	return sql
}

func (suite *AdminSysSuite) UpdateSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"uSql": "update application set `apply_status` = ? , `appr_callback` = ? where `order_code` = ?",
			"uParams": []interface{}{"5",
				"{\"url\":\"api\\/auth\\/approvalCallback\",\"status\":\"3\",\"content\":\"{\"app_info\":[\"\\u5e94\\u7528\\u540d\",\"\\u6743\\u9650\\u7ba1\\u7406\\u5e73\\u53f0\",\"\"],\"applied_names\":[\"\\u88ab\\u7533\\u8bf7\\u4eba\\/\\u90e8\\u95e8\",\"\\u8d75\\u7075\\u4e30\",\"\"],\"role_info\":[\"\\u89d2\\u8272\\u96c6\",\"LY\\u767d\\u540d\\u5355\\u6d4b\\u8bd5\\u89d2\\u8272\",\"\"]}\",\"orderCode\":\"QX2405410970\",\"extra\":\"\"\"\",\"appId\":\"100004\",\"timestamp\":\"1609157386\",\"sign\":\"f298d1b21d0e15f3ecc3345b94f30719\"}",
				"QX2405410970"},
			"sql":    "select * from application where order_code = ?",
			"params": []interface{}{"QX2405410970"},
		},
		map[string]interface{}{
			"uSql":    "update data_tag_staffs_relate set `modify_time` = ? , `status` = ? where `app_id` = ? and `emplid` = ? and `data_tag_id` = ?",
			"uParams": []interface{}{"2021-01-18 14:26:35", "1", "2", "182782", "2"},
			"sql":     "select * from data_tag_staffs_relate where `app_id` = ? and `emplid` = ? and `data_tag_id` = ?",
			"params":  []interface{}{"2", "182782", "2"},
		},
	}
	return sql
}

func (suite *AdminSysSuite) InsertSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"iSql":    "insert into account_relate set `emplid` = ? , `admin_id` = ? , `admin_name` = ? , `real_name` = ?",
			"iParams": []interface{}{"090633134", "12603", "090636", "宋世雄"},
			"sql":     "select * from account_relate where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from account_relate where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql": "insert into application set `emplid` = ? , `deptid` = ? , `app_id` = ? , `app_name` = ? , `name` = ? , `email` = ? , `dept_name` = ? , `apply_type` = ? , `applied_ids` = ? , `applied_names` = ? , `apply_reason` = ? , `role_ids` = ? , `role_names` = ? , `data_tag_ids` = ? , `func_perm` = ? , `tag_perm` = ? , `apply_status` = ?",
			"iParams": []interface{}{"182040", "D1011883", "2", "权限管理平台", "测试", "", "集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组", "2", "D1011883", "测试", "", "4", "测试", "",
				"[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]",
				"[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]", "1"},
			"sql":     "select * from application where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from application where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql": "insert into application set `emplid` = ? , `deptid` = ? , `app_id` = ? , `app_name` = ? , `name` = ? , `email` = ? , `dept_name` = ? , `apply_type` = ? , `applied_ids` = ? , `applied_names` = ? , `apply_reason` = ? , `role_ids` = ? , `role_names` = ? , `data_tag_ids` = ? , `func_perm` = ? , `tag_perm` = ? , `order_code` = ? , `add_callback` = ? , `apply_status` = ?",
			"iParams": []interface{}{"182040", "D1011883", "2", "权限管理平台", "测试", "", "集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组", "2", "088384", "测试", "", "4", "测试", "", "[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]",
				"[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]", "", "{\"stat\":1,\"msg\":\"ok\",\"data\":\"QX2405410970\"}", "5"},
			"sql":     "select * from application where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from application where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into data_tag_staffs_relate set `app_id` = ? , `emplid` = ? , `data_tag_id` = ? , `creater_id` = ? , `create_time` = ? , `status` = ?",
			"iParams": []interface{}{"2", "182782", "2", "065607", "2021-01-05 10:42:03", "1"},
			"sql":     "select * from data_tag_staffs_relate where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from data_tag_staffs_relate where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into staff_role_relate (emplid,app_id,role_id) values(?,?,?)",
			"iParams": []interface{}{"005753", "2", "2"},
			"sql":     "select * from staff_role_relate where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from staff_role_relate where id = ?",
			"dParams": []interface{}{},
		},
	}
	return sql
}

func (suite *AdminSysSuite) TestSelect() {
	list := suite.SelectSqlParams()
	for _, v := range list {
		vs := v.(map[string]interface{})
		vp := vs["params"].([]interface{})
		b, err := suite.GeneralSelect(cast.ToString(vs["sql"]), vp)
		suite.NoError(err, "sql and params", cast.ToString(vs["sql"]), vp)
		suite.Equal(true, b, "sql and params", cast.ToString(vs["sql"]), vp)
	}
}

func (suite *AdminSysSuite) TestUpdate() {
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

func (suite *AdminSysSuite) TestInsert() {
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

func TestAdminSys(t *testing.T) {
	t.Parallel()
	ts := &AdminSysSuite{}
	suite.Run(t, ts)
}
