# dbproxy

## 背景
> 由于Mysql为上一代数据库产品，年代久远，本身在功能上较现阶段的互联网应用场景有一定的落差，因此生产环境使用Mysql数据库时，无论在性能、运维、功能等方面，都需要做一定的扩展。

通常我们使用Mysql时会遇到一下几类问题：
* 无集群化的解决方案，通常需要业务方自己实现横向sharding策略。
* 无在线扩容方案，需要在线扩容时，往往需要业务做较大变动，以支持数据的一致性。
* 网络模型限制了连接数，连接数一般在千级别。
* 不支持跨机房部署。
* 不支持Paxos、Raft、Dynamo等一致性协议。

基于以上问题，我们需要通过一套旁路系统解决此类问题。

## 功能列表
- 多集群
- 多租户
- SQL透明转发
- 慢SQL指纹
- 错误SQL指纹
- 注解路由
- 慢日志
- 读写分离，从库负载均衡
- 自定义SQL拦截与过滤
- 连接池
- 配置热加载
- IP/IP段白名单
- 全局序列号
- SQL指纹缓存
- 跨机房双活支持

## 产品优势
- 实现Mysql集群模式，通过分片功能实现横向扩容，解决单机IO瓶颈。
- Go语言开发，Proxy性能较直连Mysql仅有10%的损失。
- 完善的监控体系，实现问题的发现、报警、追踪、排查、解除一站式服务。
- 完善的运维体系，提供在线Web界面，提高运维效率。
- 双活机房部署支持，极高的可用性，故障时，通过配置热加载，实现秒级的主从机房切换。
- 基于小米Gaea开发，有社区基础。

## Roadmap

- [x] 支持执行计划缓存
- [ ] 支持事务追踪
- [ ] 支持全局索引
- [ ] 支持分布式事务
- [ ] 支持平滑的扩容、缩容

## 沟通交流
### 服务群
> 对已接入dbproxy的业务提供在线技术支持服务
