# Dbproxy Change Log
All notable changes to this project are documented in this file.

## [Unreleased]
- 兼容mysql 8.0客户端
- graceful shutdown
- 去掉xorm依赖

## [0.1.5] - 2021-03-16
+ New Features
    - 【双活】支持跨机房复制延迟时通过API切流
+ Bugfix
    - 跨机房延迟监控的心跳包，每个db使用一个ticker，避免ticker争用
+ 优化
    - 跨机房延迟监控心跳包，db维度的连接池改成MySQL实例维度的连接池

## [0.1.3] - 2021-02-20
+ Bugfix
    - 主机房里不走同一客户端连接写入200ms后读主机房逻辑
+ New Features
    - Support JSON format log

## [0.1.2] - 2021-02-08
+ tests
    * 60+ integration tests
+ SQL兼容
    * write plain column name in builtinCountFunc
+ 监控
    * 支持JSON格式的日志
    * 跨机房主从复制延迟监控

## [0.1.1] - 2021-01-28
+ New Features
    * 支持SAVEPOINT，ROLLBACK TO语法
    * 修复mysql客户端auto-rehash功能, 不需要使用mysql -A参数
+ Deployment
    * 增加部署规范
    * systemd config template
+ 性能优化
    * 同一Session里的SQL fingerprint多次解析使用缓存
    * 解决时间轮map的gc延迟问题: 使用Session Sequence池，重复使用map的bucket [#20135](https://github.com/golang/go/issues/20135) 

## [0.1.0] - 2021-01-13
+ New Features
    - 【双活】支持双活部署
    - 【双活】支持通过配置热加载的方式实现双活Failover
    - 【双活】同一个Session，写入200ms内，直接读取主机房Slave
    - 【双活】双活Failover后，通过接口实现恢复原集群配置
    - 【高可用】单replica内的MySQL主从切换接口
+ 性能优化
    - SQL Parser里的ValueExpr使用对象池
    - GetRewriteSQL函数里使用strings.Builder优化内存使用
+ 监控
    - QPS、Latency监控使用SQL指纹
    - 只有在non-interactive模式下才进prometheus监控
+ SQL兼容
    - LIMIT 'xxx', 'xxx', 支持offset和limit count SQL形式，兼容Fend框架
    - SELECT语句里的aggregation function保留大小写
    - SELECT语句里的aggregation function保留大小写
    - COUNT(*)不解析成COUNT(1)
    - COUNT(*)不解析成COUNT(1)
    - 支持SQL: SELECT COUNT(*)
    - 支持SQL: set character_set_connection=binary
