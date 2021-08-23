#  mysqlproxy 自动化测试

## 项目说明
项目基于testify测试框架，集成toml配置读取，结合test自带的Parallel并行测试。

## 使用
- 新建测试项目

`cp project.go 项目名称_test.go` 
并将Project改为项目名称
- 新建测试sql

新增项目里的`xxSqlParams`方法里的map即可

## 运行
`go test -v ./...`

## 注意事项
- 如果不新增sql可以直接运行本项目进行现有的sql测试，运行前启动需要测试的gaea。
- 如果新增sql时需要查询对应的项目测试文件里有没有相同的sql

