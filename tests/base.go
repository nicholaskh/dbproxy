package tests

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
	"github.com/stretchr/testify/suite"
)

const (
	USERNAME = "user1"
	PASSWORD = "pwd1"
	NETWORK  = "tcp"
	SERVER   = "127.0.0.1"
	PORT     = 13306
	DATABASE = "test_db"
)

type BaseSuite struct {
	suite.Suite

	db *sql.DB
}

func (suite *BaseSuite) SetupSuite() {
	dsn := fmt.Sprintf("%s:%s@%s(%s:%d)/%s", USERNAME, PASSWORD, NETWORK, SERVER, PORT, DATABASE)
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		panic(err)
	}
	suite.db = db
	return
}
