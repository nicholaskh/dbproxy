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
	"testing"

	"github.com/stretchr/testify/assert"
)

func Test_calcParams(t *testing.T) {
	sql := "update micf_order_0 set order_status=4, update_time=1541831505" +
		"where\n" +
		"order_id in ('1321989216361392') and\n" +
		"project_id = 371 and\n" +
		"order_status = 2"
	paramCount, offsets, err := calcParams(sql)
	t.Log(paramCount)
	t.Log(offsets)
	t.Log(err)
	if err != nil {
		t.Logf("test calcParams failed, %v\n", err)
	}

	sql = "select * from t1 where id = ? and col = ?"
	paramCount, offsets, err = calcParams(sql)
	t.Log(paramCount)
	t.Log(offsets)
	t.Log(err)
	if err != nil || paramCount != 2 {
		t.Logf("test calcParams failed, %v\n", err)
	}
}

func Test_GetRewriteSQL(t *testing.T) {
	stmt := Stmt{
		id:         uint32(1000),
		sql:        "select * from users where id in (?,?,?,?)",
		args:       []interface{}{10, 11, 12, 13},
		paramCount: 4,
		offsets:    []int{33, 35, 37, 39},
	}

	sql, err := stmt.GetRewriteSQL()
	assert.Nil(t, err)
	assert.Equal(t, "select * from users where id in (10,11,12,13)", sql)

	stmt = Stmt{
		id:         uint32(1000),
		sql:        "select * from users where id in (?,?,?) and name=?",
		args:       []interface{}{10, 11, 12, []byte("zkh")},
		paramCount: 4,
		offsets:    []int{33, 35, 37, 49},
	}

	sql, err = stmt.GetRewriteSQL()
	assert.Nil(t, err)
	assert.Equal(t, "select * from users where id in (10,11,12) and name='zkh'", sql)

	stmt = Stmt{
		id:         uint32(1000),
		sql:        "select * from users where id in (?,?,?) and name in (?,?,?) and c3=100",
		args:       []interface{}{10, 11, 12, []byte("zkh"), []byte("zcc"), []byte("xbd")},
		paramCount: 6,
		offsets:    []int{33, 35, 37, 53, 55, 57},
	}

	sql, err = stmt.GetRewriteSQL()
	assert.Nil(t, err)
	assert.Equal(t, "select * from users where id in (10,11,12) and name in ('zkh','zcc','xbd') and c3=100", sql)
}
