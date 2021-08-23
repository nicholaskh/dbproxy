package projects

import (
	"github.com/spf13/cast"
	"github.com/stretchr/testify/suite"
	"testing"
)

type NebulaSuite struct {
	BaseSuite
}

func (suite *NebulaSuite) InsertSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"iSql": "insert into knowledge_nebula_send_matrix_detail (task_id,plan_id,class_id,stu_id,receiver_id,receiver_type,send_words,send_url,send_status,fail_result,send_type,created_time,updated_time) values(?,?,?,?,?,?,?,?,?,?,?,?,?)",
			"iParams": []interface{}{"31", "673178", "42633", "58364", "wxid_f1feogigh8hc21", "1", "测试一下哦林依依同学，这里是讲次19935-outline_catalog100", "https://app.xueersi.com/nebula-h5/knowledge?stu_report_id=xb-POtqtZ7Wl6di7XuMZPi-S6sBpEnXdZCtrWTgaptA", "4",
				"", "1", "2020-12-31 10:49:39", "2021-01-01 15:25:20"},
			"sql":     "select * from knowledge_nebula_send_matrix_detail where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from knowledge_nebula_send_matrix_detail where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into knowledge_nebula_send_matrix_task set `plan_id` = ? , `class_id` = ? , `send_text` = ? , `send_link_ids` = ? , `receiver_type` = ? , `task_type` = ? , `send_type` = ? , `creator_id` = ? , `task_status` = ? , `created_time` = ? , `updated_time` = ?",
			"iParams": []interface{}{"673079", "42633", "\"test 1111\"", "59062", "1", "0", "1", "0", "0", "0001-01-01 00:00:00", "0001-01-01 00:00:00"},
			"sql":     "select * from knowledge_nebula_send_matrix_task where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from knowledge_nebula_send_matrix_task where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into user_paper set `stu_id` = ? , `request_knowledge_ids` = ? , `plan_id` = ? , `class_id` = ? , `recommend_id` = ? , `create_time` = ?",
			"iParams": []interface{}{"12345", "[\"0fd03aea6e3b443282b2ff4bb264013f\", \"6oo7ryi0e79zkqai08wbmeohxn6c03b4\"]", "2", "1", "ee977d69700e43b083d7fc8f5e4dd471", "2020-12-25 14:47:43"},
			"sql":     "select * from user_paper where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from user_paper where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into user_ques_result (stu_id,paper_id,plan_id,knowledge_id,knowledge_name,nry_ques_id,wx_ques_id,ques_type,create_time,recommend_id) values(?,?,?,?,?,?,?,?,?,?)",
			"iParams": []interface{}{"2422275", "48", "673080", "64a9ce24fb574a6dbd7fe3522e49ff41", "分数", "bfeb18002ee14db69ccd769c62b3f5cd", "3441952", "2", "2020-12-29 18:32:20", "beae8331975649779970a43b4496b700"},
			"sql":     "select * from user_ques_result where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from user_ques_result where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into knowledge_nebula_teacher_talk_words set `teacher_id` = ? , `talk_words` = ? , `talk_type` = ? , `created_time` = ? , `updated_time` = ?",
			"iParams": []interface{}{"2377", "{lecture}额额额额额额{studentName}", "1", "2020-12-24 20:08:22", "2020-12-24 20:08:22"},
			"sql":     "select * from knowledge_nebula_teacher_talk_words where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from knowledge_nebula_teacher_talk_words where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into knowledge_nebula_teacher_talk_words_log set `teacher_id` = ? , `talk_words` = ? , `talk_type` = ? , `operate` = ? , `created_time` = ?",
			"iParams": []interface{}{"2377", "{lecture}撒大声地撒", "2", "1", "2020-12-25 18:36:31"},
			"sql":     "select * from knowledge_nebula_teacher_talk_words_log where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from knowledge_nebula_teacher_talk_words_log where id = ?",
			"dParams": []interface{}{},
		},
	}
	return sql
}

func (suite *NebulaSuite) SelectSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"sql":    "select * from knowledge_nebula_send_matrix_detail where `plan_id` = ? and `class_id` = ? and `send_status` = ? and `send_type` = ? limit ?,?",
			"params": []interface{}{"673178", "42633", "4", "1", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select * from knowledge_nebula_send_matrix_task where `id` = ? limit ?,?",
			"params": []interface{}{"1", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select * from knowledge_nebula_teacher_talk_words where `teacher_id` = ? and `talk_type` = ? and `is_delete` = ? limit ?,?",
			"params": []interface{}{"2377", "1", "0", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select * from user_paper where id = ? limit ?,?",
			"params": []interface{}{"1", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select * from user_ques_result where id = ? and stu_id = ? limit ?,?",
			"params": []interface{}{"8", "2422275", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select id,ques_order,answer_status from user_ques_result where paper_id = ? and stu_id = ? and ques_order > ? order by ques_order limit ?,?",
			"params": []interface{}{"48", "2422275", "0", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select * from knowledge_nebula_send_matrix_detail where `plan_id` = ? and `class_id` = ? and `send_status` = ? and `send_type` = ? group by task_id,stu_id order by task_id desc",
			"params": []interface{}{"673178", "42633", "4", "1"},
		},
		map[string]interface{}{
			"sql":    "select * from knowledge_nebula_send_matrix_detail where `task_id` = ?",
			"params": []interface{}{"31"},
		},
		map[string]interface{}{
			"sql":    "select * from knowledge_nebula_teacher_talk_words where `teacher_id` = ? and `talk_type` = ? limit ?,?",
			"params": []interface{}{"2377", "1", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select stu_id from knowledge_nebula_class_care_stu where `class_id` = ? and `care_status` = ? limit ?,?",
			"params": []interface{}{"42633", "0", "0", "5"},
		},
	}
	return sql
}

func (suite *NebulaSuite) UpdateSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"uSql":    "update knowledge_nebula_send_matrix_detail set `send_status` = ? where `task_id` = ? and `receiver_id` in(?,?)",
			"uParams": []interface{}{"4", "31", "wxid_f1feogigh8hc21", "wxid_himakoy9vaj722"},
			"sql":     "select * from knowledge_nebula_send_matrix_detail where task_id = ? and `receiver_id` in(?,?)",
			"params":  []interface{}{"31", "wxid_f1feogigh8hc21", "wxid_himakoy9vaj722"},
		},
		map[string]interface{}{
			"uSql":    "update knowledge_nebula_send_matrix_task set `task_status` = ? , `updated_time` = ? where `id` = ?",
			"uParams": []interface{}{"0", "0001-01-01 00:00:00", "1"},
			"sql":     "select * from knowledge_nebula_send_matrix_task where id = ?",
			"params":  []interface{}{"1"},
		},
		map[string]interface{}{
			"uSql":    "update knowledge_nebula_send_matrix_task set `task_status` = ? where `id` = ?",
			"uParams": []interface{}{"0", "2"},
			"sql":     "select * from knowledge_nebula_send_matrix_task where id = ?",
			"params":  []interface{}{"2"},
		},
		map[string]interface{}{
			"uSql":    "update knowledge_nebula_teacher_talk_words set `talk_words` = ? , `is_delete` = ? where `id` = ?",
			"uParams": []interface{}{"{lecture}额额额额额额{studentName}", "0", "1"},
			"sql":     "select * from knowledge_nebula_teacher_talk_words where id = ?",
			"params":  []interface{}{"1"},
		},
	}
	return sql
}

func (suite *NebulaSuite) TestUpdate() {
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

func (suite *NebulaSuite) TestInsert() {
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

func (suite *NebulaSuite) TestSelect() {
	list := suite.SelectSqlParams()
	for _, v := range list {
		vs := v.(map[string]interface{})
		vp := vs["params"].([]interface{})
		b, err := suite.GeneralSelect(cast.ToString(vs["sql"]), vp)
		suite.NoError(err, "sql and params", cast.ToString(vs["sql"]), vp)
		suite.Equal(true, b, "sql and params", cast.ToString(vs["sql"]), vp)
	}
}

func TestNebulaSuite(t *testing.T) {
	t.Parallel()
	ts := &NebulaSuite{}
	suite.Run(t, ts)
}
