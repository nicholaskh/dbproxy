package projects

import (
	"github.com/spf13/cast"
	"github.com/stretchr/testify/suite"
	"testing"
)

type NpsSuite struct {
	BaseSuite
}

func (suite *NpsSuite) InsertSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"iSql":    "insert into comment set `topic_id` = ? , `comment_id` = ? , `parent_id` = ? , `reply_id` = ? , `user_id` = ? , `real_user_id` = ? , `user_type` = ? , `nickname` = ? , `content` = ? , `voice_url` = ? , `voice_time` = ? , `reply_uid` = ? , `status` = ? , `type` = ? , `source` = ? , `pinned_time` = ? , `reply_num` = ? , `like_num` = ? , `show_index_ids` = ? , `create_time` = ? , `update_time` = ?",
			"iParams": []interface{}{"364", "3343", "0", "0", "11282", "11282", "2", "李兴部测试", "评论2", "", "0", "0", "4", "1", "0", "0", "10", "0", "3411:2901", "1587564229", "1595834030"},
			"sql":     "select * from comment where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from comment where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into comment_activity_user set `topic_id` = ? , `subject_id` = ? , `user_id` = ? , `comment_id` = ? , `data` = ? , `create_time` = ?",
			"iParams": []interface{}{"168", "1", "2433351", "9511", "{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}", "1604480969"},
			"sql":     "select * from comment_activity_user where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from comment_activity_user where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into comment_record set `item_id` = ? , `title` = ? , `creator_id` = ? , `creator_name` = ? , `online_time` = ? , `online_status` = ?",
			"iParams": []interface{}{"102006291716517514", "测试灌水后台1", "10004814", "邱学康", "1597543200", "2"},
			"sql":     "select * from comment_record where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from comment_record where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into comment_tmp set `topic_id` = ? , `parent_id` = ? , `reply_id` = ? , `user_id` = ? , `real_user_id` = ? , `user_type` = ? , `nickname` = ? , `content` = ? , `reply_uid` = ? , `reply_num` = ? , `status` = ? , `source` = ? , `create_time` = ? , `update_time` = ?",
			"iParams": []interface{}{"142", "0", "0", "58364", "58364", "1", "测试", "11", "0", "0", "6", "0", "1587616659", "1587616659"},
			"sql":     "select * from comment_tmp where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from comment_tmp where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into comment_tmp set `topic_id` = ? , `parent_id` = ? , `reply_id` = ? , `user_id` = ? , `real_user_id` = ? , `user_type` = ? , `nickname` = ? , `content` = ? , `voice_url` = ? , `voice_time` = ? , `reply_uid` = ? , `reply_num` = ? , `like_num` = ? , `status` = ? , `type` = ? , `source` = ? , `create_time` = ? , `update_time` = ?",
			"iParams": []interface{}{"142", "0", "0", "58364", "58364", "1", "测试", "11", "", "0", "0", "0", "0", "6", "1", "0", "1587616659", "1587616659"},
			"sql":     "select * from comment_tmp where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from comment_tmp where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into comment_trash set `topic_id` = ? , `user_id` = ? , `content` = ? , `wdfilter` = ? , `create_time` = ?",
			"iParams": []interface{}{"31", "59530", "测试", "{\"conclusion\":\"\u98ce\u9669\",\"conclusion_type\":1,\"hits]\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"\u4e60\u8fd1\"}],\"lib_name\":\"\u653f\u6cbb\"}]}", "1593602495"},
			"sql":     "select * from comment_trash where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from comment_trash where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into like set `user_id` = ? , `topic_id` = ? , `comment_id` = ? , `status` = ? , `like_time` = ? , `create_time` = ? , `update_time` = ?",
			"iParams": []interface{}{"11212", "1", "1", "0", "1584593496", "1584593496", "1587602627"},
			"sql":     "select * from like where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from like where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into meme_comment_face set `face_id` = ? , `comment_id` = ? , `topic_id` = ? , `status` = ?",
			"iParams": []interface{}{"28", "9998", "44", "1"},
			"sql":     "select * from meme_comment_face where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from meme_comment_face where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into meme_user set `user_id` = ? , `meme_id` = ? , `status` = ? , `add_time` = ? , `create_time` = ? , `update_time` = ?",
			"iParams": []interface{}{"59344", "13", "2", "1608299665", "1608299188", "1609326758"},
			"sql":     "select * from meme_user where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from meme_user where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into operator set `topic_id` = ? , `comment_id` = ? , `operator_msg` = ? , `operator_type` = ? , `create_time` = ?",
			"iParams": []interface{}{"364", "2", "审核通过", "4", "1587564467"},
			"sql":     "select * from operator where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from operator where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into reciter_comment set `topic_id` = ? , `resource_id` = ? , `comment_id` = ? , `user_id` = ? , `score` = ?",
			"iParams": []interface{}{"1334", "cms_lxb_reciter_test", "13323", "58371", "80"},
			"sql":     "select * from reciter_comment where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from reciter_comment where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into report set `user_id` = ? , `type` = ? , `content` = ? , `appeal_uid` = ? , `appeal_uname` = ? , `topic_id` = ? , `resource_id` = ? , `comment_id` = ? , `level2_text` = ? , `level1_text` = ? , `create_time` = ?",
			"iParams": []interface{}{"11282", "4", "引战、虚假造谣", "11212", "11212", "1", "cms_lxb_11281", "2", "11212创建的第1条评论", "", "1584975535"},
			"sql":     "select * from report where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from report where id = ?",
			"dParams": []interface{}{},
		},
		map[string]interface{}{
			"iSql":    "insert into topic set `resource_id` = ? , `first_cid` = ? , `second_cid` = ? , `title` = ? , `status` = ? , `subject_ids` = ? , `grade_ids` = ? , `teacher_ids` = ? , `finish_time` = ? , `creator_id` = ? , `create_time` = ? , `comment_num` = ? , `total_num` = ? , `update_uid` = ? , `update_time` = ?",
			"iParams": []interface{}{"102003170028268973", "1", "9999,152", "测试视频评论组件", "1", "", "3", "", "0", "7", "1585320704", "45", "0", "0", "1597331820"},
			"sql":     "select * from topic where id = ?",
			"params":  []interface{}{},
			"dSql":    "delete from topic where id = ?",
			"dParams": []interface{}{},
		},
	}
	return sql
}

func (suite *NpsSuite) SelectSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"sql":    "select * from comment where `comment_id` = ? and `status` = ? limit ?,?",
			"params": []interface{}{"2", "4", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select * from comment where `comment_id` = ? limit ?,?",
			"params": []interface{}{"2", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select * from comment where `parent_id` = ? and `status` = ? order by create_time desc",
			"params": []interface{}{"2", "4"},
		},
		map[string]interface{}{
			"sql":    "select * from comment where `parent_id` = ? and `status` = ? order by create_time desc limit ?,?",
			"params": []interface{}{"2", "4", "0", "5"},
		},
		map[string]interface{}{
			"sql":    "select * from comment where `topic_id` = ? and `status` = ? and `comment_id` in(?,?) order by comment_id desc",
			"params": []interface{}{"364", "4", "2", "2"},
		},
		map[string]interface{}{
			"sql":    "select * from comment_tmp where `id` = ? limit ?,?",
			"params": []interface{}{"56", "0", "5"},
		},
	}
	return sql
}

func (suite *NpsSuite) DeleteSqlParams() []interface{} {
	var sql = []interface{}{
		map[string]interface{}{
			"dSql":    "delete from comment_tmp where `id` = ?",
			"dParams": []interface{}{"45"},
			"sql":     "select * from comment_tmp where id = ?",
			"params":  []interface{}{"45"},
			"iSql":    "INSERT INTO comment_tmp(`id`, `topic_id`, `parent_id`, `reply_id`, `user_id`, `real_user_id`, `user_type`, `nickname`, `reply_uid`, `content`, `voice_url`, `voice_time`, `status`, `type`, `source`, `reply_num`, `like_num`, `create_time`, `update_time`) VALUES (45, 168, 0, 0, 58364, '58364', 2, 'lin林依依', 0, '兴部测试，别奇怪', '', 0, 6, 1, 0, 0, 0, 1587615456, 1587615456)",
			"iParams": []interface{}{},
		},
	}
	return sql
}

func (suite *NpsSuite) TestInsert() {
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

func (suite *NpsSuite) TestSelect() {
	list := suite.SelectSqlParams()
	for _, v := range list {
		vs := v.(map[string]interface{})
		vp := vs["params"].([]interface{})
		b, err := suite.GeneralSelect(cast.ToString(vs["sql"]), vp)
		suite.NoError(err, "sql and params", cast.ToString(vs["sql"]), vp)
		suite.Equal(true, b, "sql and params", cast.ToString(vs["sql"]), vp)
	}
}

func (suite *NpsSuite) TestDelete() {
	dList := suite.DeleteSqlParams()
	for _, v := range dList {
		sqlParams := v.(map[string]interface{})
		dParams := sqlParams["dParams"].([]interface{})
		params := sqlParams["params"].([]interface{})
		iParams := sqlParams["iParams"].([]interface{})
		_, err := suite.GeneralDelete(cast.ToString(sqlParams["dSql"]), dParams)
		suite.NoError(err, "sql and params", cast.ToString(sqlParams["dSql"]), dParams)
		b, err := suite.GeneralSelect(cast.ToString(sqlParams["sql"]), params)
		suite.NoError(err, cast.ToString(sqlParams["dSql"]), dParams)
		suite.Equal(true, b, "sql and params", cast.ToString(sqlParams["dSql"]), dParams)
		suite.GeneralInsert(cast.ToString(sqlParams["iSql"]), iParams)
	}
}

func TestNpsSuite(t *testing.T) {
	t.Parallel()
	ts := &NpsSuite{}
	suite.Run(t, ts)
}
