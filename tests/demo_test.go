package tests

import (
	"database/sql"
	"fmt"
	"testing"

	"github.com/stretchr/testify/suite"
)

func TestDemo(t *testing.T) {
	ts := &AdminSysSuite{}
	suite.Run(t, ts)
}

type testObj struct {
	ID   int            `db:"id"`
	Name sql.NullString `db:"name"`
}

func (suite *AdminSysSuite) Test1() {
	row := suite.db.QueryRow("select * from test where id=?", 1)
	var obj testObj
	err := row.Scan(&obj.ID, &obj.Name)
	suite.Nil(err)
	suite.Equal(1, obj.ID)
	fmt.Println(obj.Name.Valid)
	suite.True(obj.Name.Valid)
	suite.Equal("1121212", obj.Name.String)
}

type AdminSysSuite struct {
	BaseSuite
}
