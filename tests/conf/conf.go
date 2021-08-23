package conf

import (
	"github.com/BurntSushi/toml"
	"log"
)

var Conf = &Config{}

func init() {
	//flag.Parse()
	if _, err := toml.DecodeFile("../conf/conf.toml", Conf); err != nil {
		log.Fatalln(err)
	}
}

type Config struct {
	DriverName string `toml:"driver_name"`
	Gaea       Gaea   `toml:"gaea"`
	Mysql      Mysql  `toml:"mysql"`
}

type Gaea struct {
	Username string `toml:"username"`
	Password string `toml:"password"`
	Network  string `toml:"network"`
	Server   string `toml:"server"`
	Port     int    `toml:"port"`
	Database string `toml:"database"`
}

type Mysql struct {
	User     string `toml:"user"`
	Password string `toml:"password"`
	Network  string `toml:"network"`
	Server   string `toml:"server"`
	Port     int    `toml:"port"`
	Database string `toml:"database"`
}
