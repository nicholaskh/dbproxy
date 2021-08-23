-- MySQL dump 10.13  Distrib 5.6.50, for osx10.14 (x86_64)
--
-- Host: 127.0.0.1    Database: test_db
-- ------------------------------------------------------
-- Server version	5.6.50

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test`
--

LOCK TABLES `test` WRITE;
/*!40000 ALTER TABLE `test` DISABLE KEYS */;
INSERT INTO `test` VALUES (1,'1121212');
/*!40000 ALTER TABLE `test` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_relate`
--

DROP TABLE IF EXISTS `account_relate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_relate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `emplid` varchar(32) NOT NULL DEFAULT '' COMMENT '工号',
  `admin_id` varchar(32) NOT NULL DEFAULT '' COMMENT 'admin_id',
  `admin_name` varchar(32) NOT NULL DEFAULT '' COMMENT '用户名',
  `real_name` varchar(32) NOT NULL DEFAULT '' COMMENT '真实名',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `emplid` (`emplid`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COMMENT='工号与adminId关系表-彭伟';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_relate`
--

LOCK TABLES `account_relate` WRITE;
/*!40000 ALTER TABLE `account_relate` DISABLE KEYS */;
INSERT INTO `account_relate` VALUES (1,'217536','12737','217536','彭伟','2020-11-13 07:15:40'),(2,'182040','12069','shihaobo','师浩博','2020-11-13 08:16:49'),(3,'182782','12094','liyun12','李蕴','2020-11-13 08:18:25'),(4,'168761','11868','wangliyang1','王立阳','2020-11-13 08:30:54'),(5,'147242','11378','liangxiaodong1','梁小栋','2020-11-13 08:38:25'),(160,'090636134','12603','090636','宋世雄','2021-02-07 06:48:14');
/*!40000 ALTER TABLE `account_relate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '组id',
  `emplid` varchar(32) NOT NULL DEFAULT '' COMMENT '管理员工号',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '管理员姓名',
  `app_ids` varchar(128) NOT NULL DEFAULT '' COMMENT '拥有的应用(超管默认为空，拥有全部)',
  `app_name` varchar(128) NOT NULL DEFAULT '' COMMENT '应用名',
  `grade` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '管理员等级 1:超管 2:普通',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '用户类型 0:默认 1:正常 2:临时',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1:正常 2:冻结',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=316 DEFAULT CHARSET=utf8mb4 COMMENT='权限管理后台管理员账户信息-彭伟';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,2,'159775','白龙','2','测试',2,1,1,'2020-11-13 15:34:23'),(3,1,'217536','彭伟','','',1,1,1,'2020-11-13 15:34:23'),(5,1,'148792','娜仁格日乐','','',1,1,1,'2020-11-13 15:34:23'),(7,1,'149763','韩冬辉','','',1,1,1,'2020-11-13 15:34:23'),(8,1,'147242','梁小栋','','',1,1,1,'2020-11-13 15:34:23');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application`
--

DROP TABLE IF EXISTS `application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `application` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_code` varchar(32) NOT NULL DEFAULT '' COMMENT '流程单编号',
  `app_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '应用id',
  `app_name` varchar(128) NOT NULL DEFAULT '' COMMENT '应用名',
  `emplid` varchar(32) NOT NULL DEFAULT '' COMMENT '申请者员工工号',
  `deptid` varchar(32) NOT NULL DEFAULT '' COMMENT '申请人部门id',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '申请者姓名',
  `email` varchar(64) NOT NULL DEFAULT '' COMMENT '邮箱',
  `dept_name` varchar(128) NOT NULL DEFAULT '' COMMENT '部门名',
  `applied_ids` varchar(128) NOT NULL DEFAULT '' COMMENT '被申请的id',
  `applied_names` varchar(512) NOT NULL DEFAULT '' COMMENT '被申请用户/部门名',
  `role_ids` varchar(128) NOT NULL DEFAULT '' COMMENT '角色集',
  `role_names` varchar(128) NOT NULL DEFAULT '' COMMENT '角色名集合',
  `data_tag_ids` varchar(64) NOT NULL DEFAULT '' COMMENT '数据标签id',
  `func_perm` varchar(5210) NOT NULL DEFAULT '' COMMENT '功能权限相关集合',
  `tag_perm` varchar(5210) NOT NULL DEFAULT '' COMMENT '数据权限',
  `apply_reason` varchar(128) NOT NULL DEFAULT '' COMMENT '申请理由',
  `apply_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '申请类型 1:正式/虚拟用户 2:部门',
  `apply_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '申请状态 1:待提审 2:审批中 3:撤回 4:通过 5:驳回',
  `staff_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '员工类型：0默认1:正式2:临时',
  `add_callback` varchar(64) NOT NULL DEFAULT '' COMMENT '流程平台回调',
  `appr_callback` varchar(648) NOT NULL DEFAULT '' COMMENT '审批回调',
  `apply_time` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' COMMENT '申请时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `emplid` (`emplid`),
  KEY `create_time` (`create_time`),
  KEY `apply_status` (`apply_status`)
) ENGINE=InnoDB AUTO_INCREMENT=764 DEFAULT CHARSET=utf8mb4 COMMENT='权限申请表-彭伟';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application`
--

LOCK TABLES `application` WRITE;
/*!40000 ALTER TABLE `application` DISABLE KEYS */;
INSERT INTO `application` VALUES (1,'',2,'','006991','D1011884','马远远','','','0','平台研发','1','用户模块','','','','',1,1,1,'','','0000-01-01 00:00:00','2020-10-30 17:50:27'),(2,'',2,'','006991','D1011884','马远远','','','1,2','','1','','','','','',1,1,1,'','','0000-01-01 00:00:00','2020-10-30 17:51:40'),(3,'',2,'','006991','D1011884','马远远','','','D1017550','','1','','','','','',2,1,1,'','','0000-01-01 00:00:00','2020-10-30 17:53:20'),(4,'',2,'','006991','D1011884','马远远','','','D1011222','','1','','','','','',2,1,1,'','','0000-01-01 00:00:00','2020-10-30 18:02:27'),(5,'',3,'','006991','D1011884','马远远','','','D1017550','','2','','','','','',2,1,1,'','','0000-01-01 00:00:00','2020-10-30 18:17:22'),(754,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','D1011883','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,1,0,'','','0000-01-01 00:00:00','2021-02-07 14:48:14'),(755,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','088384','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,5,0,'{\"stat\":1,\"msg\":\"ok\",\"data\":\"QX2405410970\"}','','0000-01-01 00:00:00','2021-02-07 14:48:14'),(756,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','D1011883','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,1,0,'','','0000-01-01 00:00:00','2021-02-07 14:49:00'),(757,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','088384','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,5,0,'{\"stat\":1,\"msg\":\"ok\",\"data\":\"QX2405410970\"}','','0000-01-01 00:00:00','2021-02-07 14:49:00'),(758,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','D1011883','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,1,0,'','','0000-01-01 00:00:00','2021-02-07 14:49:48'),(759,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','088384','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,5,0,'{\"stat\":1,\"msg\":\"ok\",\"data\":\"QX2405410970\"}','','0000-01-01 00:00:00','2021-02-07 14:49:48'),(760,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','D1011883','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,1,0,'','','0000-01-01 00:00:00','2021-02-07 14:50:10'),(761,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','088384','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,5,0,'{\"stat\":1,\"msg\":\"ok\",\"data\":\"QX2405410970\"}','','0000-01-01 00:00:00','2021-02-07 14:50:10'),(762,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','D1011883','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,1,0,'','','0000-01-01 00:00:00','2021-02-07 14:56:19'),(763,'',2,'权限管理平台','182040','D1011883','测试','','集团前台-互联网服务事业部-网校事业部-互联网研发部-平台研发部-前端组','088384','测试','4','测试','','[{\"id\":4,\"resource_ids\":\"33\",\"name\":\"测试\",\"des\":\"\",\"type\":1,\"vaild_time_ident\":1,\"status\":1,\"vaild_time\":\"0000-01-01 00:00:00\",\"create_time\":\"2020-11-04 17:51:23\",\"status_name\":\"正常\",\"type_name\":\"非敏感角色\",\"surplus_time\":\"永久\",\"resource_name\":\"权限拥有者管理\"}]','[{\"tagType\":{\"key\":16,\"label\":\"33\"},\"tagValues\":[{\"key\":9,\"label\":\"22\"}],\"id\":1604483522000,\"tag_type\":\"33\",\"tag_values\":\"22\"}]','',2,5,0,'{\"stat\":1,\"msg\":\"ok\",\"data\":\"QX2405410970\"}','','0000-01-01 00:00:00','2021-02-07 14:56:19');
/*!40000 ALTER TABLE `application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `topic_id` int(11) unsigned NOT NULL COMMENT '话题id',
  `comment_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论id',
  `parent_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上级评论id',
  `reply_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上级回复id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `real_user_id` varchar(20) NOT NULL DEFAULT '0' COMMENT '真实用户id',
  `user_type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '用户类型',
  `nickname` varchar(20) NOT NULL COMMENT '用户昵称',
  `reply_uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '回复用户id',
  `content` varchar(255) NOT NULL COMMENT '评论内容',
  `voice_url` varchar(255) NOT NULL DEFAULT '' COMMENT '音频链接',
  `voice_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '音频时长',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '评论状态:1待审核;2审核中;3审核驳回;4审核通过;5运营隐藏;6用户删除',
  `type` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '评论类型:1普通评论;2语音评论;3朗读者评论',
  `source` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '评论来源:1普通学生;2运营前台;3运营后台;4灌水后台',
  `reply_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '回复数',
  `like_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '点赞数',
  `show_index_ids` varchar(25) NOT NULL DEFAULT '' COMMENT '首页回复展示id集合',
  `pinned_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '加精时间',
  `teacher_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '老师ID',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_comment_id` (`comment_id`),
  KEY `idx_topic_id_comment_id` (`topic_id`,`comment_id`),
  KEY `idx_topic_id_like_num_create_time` (`topic_id`,`like_num`,`create_time`),
  KEY `idx_parent_id_create_time` (`parent_id`,`create_time`),
  KEY `idx_user_id` (`user_id`) USING BTREE COMMENT '按用户id条件索引',
  KEY `idx_topic_id_teacher_id` (`topic_id`,`teacher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10449 DEFAULT CHARSET=utf8mb4 COMMENT='评论数据表-李兴部';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,364,2,0,0,11282,'11282',2,'李兴部测试',0,'评论2','',0,4,1,0,10,0,'3411:2901',0,0,1587564229,1595834030),(2,364,3,2,2,11282,'11282',2,'李兴部测试',0,'评论2的回复1','',0,4,1,0,0,0,'',0,0,1587564782,1587564782),(3,364,8,2,2,11282,'11282',2,'李兴部测试',11282,'评论2的回复1-回复2','',0,4,1,0,0,0,'',0,0,1587568796,1587568796),(4,364,9,2,2,11282,'11282',1,'李兴部测试',11282,'评论2的回复1-回复3','',0,4,1,0,0,0,'',0,0,1587569494,1587569494),(5,364,10,2,2,11282,'11282',1,'李兴部测试',11282,'评论2的回复1-回复4','',0,4,1,0,0,1,'',0,0,1587569609,1587569609),(10444,364,3433,0,0,11282,'11282',2,'李兴部测试',0,'评论2','',0,4,1,0,10,0,'3411:2901',0,0,1587564229,1595834030);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_activity_user`
--

DROP TABLE IF EXISTS `comment_activity_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment_activity_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `topic_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '话题ID',
  `subject_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '主题ID',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `comment_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论ID',
  `data` varchar(1000) NOT NULL DEFAULT '' COMMENT '用户数据',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=664 DEFAULT CHARSET=utf8mb4 COMMENT='评论运营活动用户数据表-孙德彪';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_activity_user`
--

LOCK TABLES `comment_activity_user` WRITE;
/*!40000 ALTER TABLE `comment_activity_user` DISABLE KEYS */;
INSERT INTO `comment_activity_user` VALUES (1,168,1,2433351,0,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604480840),(2,168,1,2433351,9511,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604480969),(3,168,1,2433351,9530,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604484609),(4,168,1,2433351,9531,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604485659),(5,168,1,2433351,9532,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604485659),(659,168,1,2433351,9511,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604480969),(660,168,1,2433351,9511,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604480969),(661,168,1,2433351,9511,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604480969),(662,168,1,2433351,9511,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604480969),(663,168,1,2433351,9511,'{\"type\":1,\"title\":\"你喜欢面条还是米饭\",\"result\":{\"point\":2,\"pointName\":\"米饭\"}}',1604480969);
/*!40000 ALTER TABLE `comment_activity_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_record`
--

DROP TABLE IF EXISTS `comment_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `item_id` varchar(100) NOT NULL DEFAULT '0' COMMENT '内容id',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `creator_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'id',
  `creator_name` varchar(150) NOT NULL DEFAULT '' COMMENT '名称',
  `online_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '内容上线时间',
  `online_status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '上线状态:2已上线;4待上线',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '状态:1未写入;2待审核;3已完成',
  `last_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作人工号',
  `last_name` varchar(100) NOT NULL DEFAULT '' COMMENT '操作人姓名',
  PRIMARY KEY (`id`),
  KEY `idx_item_id` (`item_id`) USING BTREE,
  KEY `idx_online_time` (`online_time`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_online_status` (`online_status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1325 DEFAULT CHARSET=utf8mb4 COMMENT='评论运营记录表-袁也';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_record`
--

LOCK TABLES `comment_record` WRITE;
/*!40000 ALTER TABLE `comment_record` DISABLE KEYS */;
INSERT INTO `comment_record` VALUES (1314,'102007212016548078','测试灌水后台2',10000256,'邱学康',1597647600,2,3,10506,'赵亚荣'),(1315,'102006171728505067','测试灌水后台3',10000256,'邱学康',1597746600,2,3,11040,'邱学康'),(1316,'102004080845208888','测试灌水后台4',10000256,'邱学康',1597893916,2,3,11040,'邱学康'),(1317,'102004122146263145','测试灌水后台5',10000256,'邱学康',1597736459,2,3,11040,'邱学康'),(1318,'131612510551675946','测试{{123}}   ？让老师看看哪位同学最快抢到沙发',10004864,'',1612510452,2,1,0,''),(1319,'102102051535541329','UGC测试视频500',10004814,'牛牛号',1612509605,2,1,0,''),(1320,'102006291716517514','测试灌水后台1',10004814,'邱学康',1597543200,2,1,0,''),(1321,'102006291716517514','测试灌水后台1',10004814,'邱学康',1597543200,2,1,0,''),(1322,'102006291716517514','测试灌水后台1',10004814,'邱学康',1597543200,2,1,0,''),(1323,'102006291716517514','测试灌水后台1',10004814,'邱学康',1597543200,2,1,0,''),(1324,'102006291716517514','测试灌水后台1',10004814,'邱学康',1597543200,2,1,0,'');
/*!40000 ALTER TABLE `comment_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_tmp`
--

DROP TABLE IF EXISTS `comment_tmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment_tmp` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `topic_id` int(11) unsigned NOT NULL COMMENT '话题id',
  `parent_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上级评论id',
  `reply_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '上级回复id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `real_user_id` varchar(20) NOT NULL DEFAULT '0' COMMENT '真实用户id',
  `user_type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '用户类型',
  `nickname` varchar(20) NOT NULL COMMENT '用户昵称',
  `reply_uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '回复用户id',
  `content` varchar(255) NOT NULL COMMENT '评论内容',
  `voice_url` varchar(255) NOT NULL DEFAULT '' COMMENT '音频链接',
  `voice_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '音频时长',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '评论状态:1待审核;2审核中;3审核驳回;4审核通过;5运营隐藏;6用户删除',
  `type` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '评论类型:1普通评论;2语音评论;3朗读者评论',
  `source` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '评论来源:1普通学生;2运营前台;3运营后台;4灌水后台',
  `reply_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '回复数',
  `like_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '点赞数',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_topic_id` (`topic_id`) USING BTREE COMMENT '按话题id条件查询',
  KEY `idx_parent_id` (`parent_id`) USING BTREE COMMENT '按上级评论id查询',
  KEY `idx_create_time` (`create_time`) USING BTREE COMMENT '按创建时间索引',
  KEY `idx_user_id` (`user_id`) USING BTREE COMMENT '按用户id条件索引'
) ENGINE=InnoDB AUTO_INCREMENT=16262 DEFAULT CHARSET=utf8mb4 COMMENT='评论待审数据表-马远远';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_tmp`
--

LOCK TABLES `comment_tmp` WRITE;
/*!40000 ALTER TABLE `comment_tmp` DISABLE KEYS */;
INSERT INTO `comment_tmp` VALUES (16180,1678,16087,0,10005214,'236155',5,'测试大大哟',0,'健健康康','',0,2,1,5,0,0,1612432924,1612432924),(16183,1360,0,0,2100050073,'2100050073',1,'学员q99raT',0,'','https://testmv.xesimg.com/app/readers/2021/02/04/2100050073_1612434125611_reader_userVoice_2100050073_1612434126.mp3',19501,2,2,1,0,1,1612434133,1612434133),(16184,1333,0,0,2100050071,'2100050071',1,'学员RUpABi',0,'','https://testmv.xesimg.com/app/readers/2021/02/04/2100050071_1612434343422_reader_userVoice_2100050071_1612434343.mp3',15001,2,2,1,0,1,1612434348,1612434348),(16185,1334,0,0,2100050073,'2100050073',1,'学员q99raT',0,'','https://testmv.xesimg.com/app/readers/2021/02/04/2100050073_1612434819759_reader_userVoice_2100050073_1612434820.mp3',15601,2,2,1,0,1,1612434824,1612434824),(16186,1333,0,0,2100050073,'2100050073',1,'哈哈2',0,'哈哈哈哈家','https://testmv.xesimg.com/app/readers/2021/02/04/2100050073_1612436999726_reader_userVoice_2100050073_1612437000.mp3',17401,2,2,1,0,1,1612437008,1612437008),(16187,1378,16171,0,10004802,'182782',3,'李蕴',0,'常用的信息可以在这里保存，便于发送。我的电话是__，常联系。__省__市__街道__小区__单元__室__省__市__街道__小区__单元__室__省__市__街道__小区__单元__室__省__市__街道__小区__单元__室__省__市__街道__小区__单元__室__省__','',0,2,1,5,0,0,1612449992,1612449992),(16251,867,0,0,2400089,'2400089',1,'学员CUDG1F',0,'啦啦啦啦啦','',0,2,1,1,0,0,1612509218,1612509218),(16252,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659),(16253,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659),(16254,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659),(16255,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659),(16256,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659),(16257,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659),(16258,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659),(16259,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659),(16260,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659),(16261,142,0,0,58364,'58364',1,'测试',0,'11','',0,6,1,0,0,0,1587616659,1587616659);
/*!40000 ALTER TABLE `comment_tmp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_trash`
--

DROP TABLE IF EXISTS `comment_trash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment_trash` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `topic_id` int(11) unsigned NOT NULL COMMENT '话题id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '评论信息',
  `wdfilter` varchar(1000) NOT NULL DEFAULT '' COMMENT '敏感词检测返回信息',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_topic_id` (`topic_id`) USING BTREE COMMENT '按话题id条件查询',
  KEY `idx_user_id` (`user_id`) USING BTREE COMMENT '按用户id条件查询'
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8mb4 COMMENT='触发敏感词发布失败记录-马远远';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_trash`
--

LOCK TABLES `comment_trash` WRITE;
/*!40000 ALTER TABLE `comment_trash` DISABLE KEYS */;
INSERT INTO `comment_trash` VALUES (1,1,1,'共产党18禁止','{\"key\":[{\"num\":1,\"word\":\"18\\u7981\"},{\"num\":1,\"word\":\"\\u5171\\u4ea7\\u515a\"}],\"total\":2}',1591956128),(2,1,1,'台独','{\"conclusion\":\"\\u98ce\\u9669\",\"conclusion_type\":1,\"hits\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"\\u53f0\\u72ec\"}],\"lib_name\":\"\\u653f\\u6cbb\"}]}',1592379661),(3,510,58372,'傻逼','{\"conclusion\":\"\\u98ce\\u9669\",\"conclusion_type\":1,\"hits\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"\\u50bb\\u903c\"}],\"lib_name\":\"\\u8fb1\\u9a82\"}]}',1592381355),(4,510,58372,'台独','{\"conclusion\":\"\\u98ce\\u9669\",\"conclusion_type\":1,\"hits\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"\\u53f0\\u72ec\"}],\"lib_name\":\"\\u653f\\u6cbb\"}]}',1592381363),(5,510,58372,'习近平','{\"conclusion\":\"\\u98ce\\u9669\",\"conclusion_type\":1,\"hits\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"\\u4e60\\u8fd1\"}],\"lib_name\":\"\\u653f\\u6cbb\"}]}',1592381372),(158,31,59530,'测试','{\"conclusion\":\"风险\",\"conclusion_type\":1,\"hits]\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"习近\"}],\"lib_name\":\"政治\"}]}',1593602495),(159,31,59530,'测试','{\"conclusion\":\"风险\",\"conclusion_type\":1,\"hits]\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"习近\"}],\"lib_name\":\"政治\"}]}',1593602495),(160,31,59530,'测试','{\"conclusion\":\"风险\",\"conclusion_type\":1,\"hits]\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"习近\"}],\"lib_name\":\"政治\"}]}',1593602495),(161,31,59530,'测试','{\"conclusion\":\"风险\",\"conclusion_type\":1,\"hits]\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"习近\"}],\"lib_name\":\"政治\"}]}',1593602495),(162,31,59530,'测试','{\"conclusion\":\"风险\",\"conclusion_type\":1,\"hits]\":[{\"detection_result\":[{\"count\":1,\"keyword\":\"习近\"}],\"lib_name\":\"政治\"}]}',1593602495);
/*!40000 ALTER TABLE `comment_trash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_tag`
--

DROP TABLE IF EXISTS `data_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `app_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '应用id',
  `data_tag_type_id` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '数据标签类型',
  `data_tag_id_info` varchar(128) NOT NULL DEFAULT '' COMMENT '标签id信息',
  `data_tag_name` varchar(128) NOT NULL DEFAULT '' COMMENT '标签名称',
  `data_tag_val` varchar(255) NOT NULL DEFAULT '' COMMENT '标签值',
  `data_tag_des` varchar(255) NOT NULL DEFAULT '' COMMENT '标签描述',
  `creater_id` varchar(20) NOT NULL DEFAULT '0' COMMENT '创建人',
  `modify_time` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态: 1:正常 2:冻结 3:删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COMMENT='数据标签表-梁小栋';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_tag`
--

LOCK TABLES `data_tag` WRITE;
/*!40000 ALTER TABLE `data_tag` DISABLE KEYS */;
INSERT INTO `data_tag` VALUES (1,2,1,'','标签1','1','','182782','0000-01-01 00:00:00','2020-11-12 17:10:37',1),(2,2,1,'','标签2','2','','182782','0000-01-01 00:00:00','2020-11-12 17:10:45',1),(3,2,1,'','标签3','3','','182782','0000-01-01 00:00:00','2020-11-12 17:10:50',1),(4,5,24,'','学科','{\"type\":\"subject\",\"value\":\"2\"}','','168761','2020-11-13 11:21:29','2020-11-13 11:07:52',1),(5,5,24,'','年级','{\"type\":\"grade\",\"value\":\"4\"}','','168761','2020-11-13 11:21:34','2020-11-13 11:08:16',1);
/*!40000 ALTER TABLE `data_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_tag_staffs_relate`
--

DROP TABLE IF EXISTS `data_tag_staffs_relate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_tag_staffs_relate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '应用id',
  `data_tag_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '数据标签id',
  `emplid` varchar(20) NOT NULL DEFAULT '' COMMENT '用户id',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1:未删除 2:删除',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '用户类型 0:默认 1:正常 2:临时',
  `creater_id` varchar(20) NOT NULL DEFAULT '0' COMMENT '创建人',
  `modify_time` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2343 DEFAULT CHARSET=utf8mb4 COMMENT='数据标签与员工关系表-梁小栋';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_tag_staffs_relate`
--

LOCK TABLES `data_tag_staffs_relate` WRITE;
/*!40000 ALTER TABLE `data_tag_staffs_relate` DISABLE KEYS */;
INSERT INTO `data_tag_staffs_relate` VALUES (1,2,2,'182782',1,1,'','2021-01-18 14:26:35','2020-11-12 17:15:14'),(2,2,1,'082573',1,1,'','2021-01-18 14:26:35','2020-11-12 17:18:51'),(3,2,1,'087516',1,1,'','2021-01-18 14:26:35','2020-11-12 17:18:51'),(4,2,2,'082573',1,1,'','2021-01-18 14:26:35','2020-11-12 17:19:18'),(5,2,2,'087516',1,1,'','2021-01-18 14:26:35','2020-11-12 17:19:18'),(2338,2,2,'182782',1,0,'065607','2021-01-18 14:26:35','2021-01-05 10:42:03'),(2339,2,2,'182782',1,0,'065607','2021-01-18 14:26:35','2021-01-05 10:42:03'),(2340,2,2,'182782',1,0,'065607','2021-01-18 14:26:35','2021-01-05 10:42:03'),(2341,2,2,'182782',1,0,'065607','2021-01-18 14:26:35','2021-01-05 10:42:03'),(2342,2,2,'182782',1,0,'065607','2021-01-18 14:26:35','2021-01-05 10:42:03');
/*!40000 ALTER TABLE `data_tag_staffs_relate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_tag_type`
--

DROP TABLE IF EXISTS `data_tag_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_tag_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `app_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '应用id',
  `data_tag_type_name` varchar(128) NOT NULL DEFAULT '' COMMENT '数据标签类型名称',
  `creater_id` varchar(20) NOT NULL DEFAULT '0' COMMENT '创建人',
  `modify_time` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态: 1:正常 2:冻结 3:删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COMMENT='数据标签类型表-梁小栋';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_tag_type`
--

LOCK TABLES `data_tag_type` WRITE;
/*!40000 ALTER TABLE `data_tag_type` DISABLE KEYS */;
INSERT INTO `data_tag_type` VALUES (1,2,'LY数据1','182782','0000-01-01 00:00:00','2020-11-12 17:09:42',1),(2,2,'LY数据2','182782','0000-01-01 00:00:00','2020-11-12 17:11:01',1),(3,2,'LY数据3','182782','0000-01-01 00:00:00','2020-11-12 17:11:05',1),(4,2,'LY数据4','182782','0000-01-01 00:00:00','2020-11-12 17:11:09',1),(5,2,'LY数据5','182782','0000-01-01 00:00:00','2020-11-12 17:11:14',1);
/*!40000 ALTER TABLE `data_tag_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_ehr`
--

DROP TABLE IF EXISTS `department_ehr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department_ehr` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `deptid` varchar(10) NOT NULL DEFAULT '' COMMENT '部门ID',
  `manager_id` varchar(10) NOT NULL DEFAULT '' COMMENT '部门领导工号',
  `descr` varchar(100) NOT NULL DEFAULT '' COMMENT '部门描述',
  `descrshort` varchar(15) NOT NULL DEFAULT '' COMMENT '部门名称',
  `eff_status` varchar(1) NOT NULL DEFAULT '' COMMENT '部门是否生效，A：有效；I：无效',
  `parent_node_name` varchar(10) NOT NULL DEFAULT '' COMMENT '父节点ID，如：D1006677',
  `parent_dept_ids` varchar(100) NOT NULL DEFAULT '' COMMENT '所有上级部门IDs，用竖线|分隔',
  `c_location_descr` varchar(10) NOT NULL DEFAULT '' COMMENT '地点描述，如：济南',
  `tree_level_num` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '节点级别',
  `dept_syb` varchar(10) NOT NULL DEFAULT '' COMMENT '事业部部门ID',
  `dept_syb_descr` varchar(40) NOT NULL DEFAULT '' COMMENT '部门事业部描述',
  PRIMARY KEY (`id`),
  KEY `deptid_index` (`deptid`)
) ENGINE=InnoDB AUTO_INCREMENT=7649 DEFAULT CHARSET=utf8mb4 COMMENT='EHR部门表-韩冬辉';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_ehr`
--

LOCK TABLES `department_ehr` WRITE;
/*!40000 ALTER TABLE `department_ehr` DISABLE KEYS */;
INSERT INTO `department_ehr` VALUES (7644,'D1002316','131300','集团前台业务三部-互联网班课业务-网校事业部-市场营销部-智慧营销部','智慧营销部','A','D1006603','D1006603|D1001112|D1011586|D1023474|D1000001','北京',6,'D1001112','集团前台业务三部-互联网班课业务-网校事业部'),(7645,'D1002320','157644','集团前台业务三部-互联网班课业务-网校事业部-市场营销部-品牌市场部','品牌市场部','A','D1006603','D1006603|D1001112|D1011586|D1023474|D1000001','北京',6,'D1001112','集团前台业务三部-互联网班课业务-网校事业部'),(7646,'D1004214','002327','集团前台业务三部-互联网班课业务-网校事业部-小高学部-英语产品部','英语产品部','A','D1006599','D1006599|D1001112|D1011586|D1023474|D1000001','北京',6,'D1001112','集团前台业务三部-互联网班课业务-网校事业部'),(7647,'D1004996','092113','集团前台业务三部-互联网班课业务-网校事业部-幼小学部-学习服务部-济南系统班基地-幼小英语-幼小英语1','幼小英语1','A','D1006683','D1006683|D1024104|D1023756|D1023753|D1001112|D1011586|D1023474|D1000001','济南',9,'D1001112','集团前台业务三部-互联网班课业务-网校事业部'),(7648,'D1004998','095474','集团前台业务三部-互联网班课业务-网校事业部-幼小学部-学习服务部-济南系统班基地-幼小数学','幼小数学','A','D1024104','D1024104|D1023756|D1023753|D1001112|D1011586|D1023474|D1000001','济南',8,'D1001112','集团前台业务三部-互联网班课业务-网校事业部');
/*!40000 ALTER TABLE `department_ehr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `finance_sea_data_sync`
--

DROP TABLE IF EXISTS `finance_sea_data_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `finance_sea_data_sync` (
  `id` bigint(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `stu_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `real_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '课程实付总金额',
  `total_plans` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '总场次数',
  `course_periods` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '当期确认课时',
  `course_period` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '当期场次数',
  `goods_no` varchar(20) NOT NULL DEFAULT '' COMMENT '货品唯一表示',
  `course_schedule_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上课id',
  `refund_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '退费金额',
  `course_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '课程原价',
  `promotion_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '促销价格',
  `coupon_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券价格',
  `gongbenfei` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '工本费',
  `course_type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '课程类型',
  `order_num` varchar(30) NOT NULL DEFAULT '' COMMENT '订单号',
  `product_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `product_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `grade_id` int(10) NOT NULL DEFAULT '0' COMMENT '年级id',
  `subject_id` int(10) NOT NULL DEFAULT '0' COMMENT '学科id',
  `term_id` int(10) NOT NULL DEFAULT '0' COMMENT '学期id',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0课消1退费2购课',
  `is_full_refund` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '是否全部退费',
  `course_time` datetime NOT NULL DEFAULT '2020-01-01 00:00:00' COMMENT '上课时间',
  `confirm_day` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '确认日期',
  `confirm_time` datetime NOT NULL DEFAULT '2020-01-01 00:00:00' COMMENT '确认日期',
  `pay_time` datetime NOT NULL DEFAULT '2020-01-01 00:00:00' COMMENT '支付时间',
  `refund_time` datetime NOT NULL DEFAULT '2020-01-01 00:00:00' COMMENT '退费日期',
  `create_time` datetime NOT NULL DEFAULT '2020-01-01 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_id` (`goods_no`,`course_schedule_id`,`type`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE,
  KEY `idx_refund_time` (`refund_time`) USING BTREE,
  KEY `idx_confirm_day` (`confirm_day`) USING BTREE,
  KEY `idx_stu_id` (`stu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21023727 DEFAULT CHARSET=utf8mb4 COMMENT='大海同步确认收入表-程帅';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `finance_sea_data_sync`
--

LOCK TABLES `finance_sea_data_sync` WRITE;
/*!40000 ALTER TABLE `finance_sea_data_sync` DISABLE KEYS */;
INSERT INTO `finance_sea_data_sync` VALUES (1,1,1,1,0,1,'1',1,1,1,1,1,1,1,'11',1,'1',1,1,1,0,0,'0000-00-00 00:00:00',0,'0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(21023722,188998,572000,22,0,2,'300P013586204D0123B',0,0,726000,0,0,0,3,'20200401188998115349',5876,'新标准课春高二数学22课时',12,2,1,0,0,'0000-00-00 00:00:00',20180203,'2020-04-01 11:53:49','2020-04-01 11:56:11','0000-00-00 00:00:00','2020-09-21 16:47:21');
/*!40000 ALTER TABLE `finance_sea_data_sync` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledge_nebula_class_care_stu`
--

DROP TABLE IF EXISTS `knowledge_nebula_class_care_stu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledge_nebula_class_care_stu` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `teacher_id` int(11) NOT NULL DEFAULT '0' COMMENT '老师id',
  `class_id` int(11) NOT NULL DEFAULT '0' COMMENT '班级id',
  `stu_id` int(11) NOT NULL DEFAULT '0' COMMENT '学生id',
  `care_status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '关注类型：0 默认值，非关注，1 关注学生',
  `updated_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '更新时间',
  `created_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx-stu_id` (`stu_id`),
  KEY `idx-class_id` (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COMMENT='知识星云学生关注表-朱培杰';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledge_nebula_class_care_stu`
--

LOCK TABLES `knowledge_nebula_class_care_stu` WRITE;
/*!40000 ALTER TABLE `knowledge_nebula_class_care_stu` DISABLE KEYS */;
INSERT INTO `knowledge_nebula_class_care_stu` VALUES (1,2377,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(2,2377,42633,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(3,2377,42633,59062,1,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(4,2377,42633,58364,1,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(5,2377,42633,58371,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(6,2377,42633,59105,0,'2021-01-06 15:49:19','0001-01-01 00:00:00'),(7,3897,42633,59104,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(8,2377,42633,59067,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(9,2377,80919,59963,0,'2021-01-20 15:20:40','0001-01-01 00:00:00'),(10,5814,94775,59979,1,'2021-01-06 16:46:11','0001-01-01 00:00:00'),(11,2377,42633,58373,1,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(12,5814,80919,59977,0,'2021-01-20 15:20:38','0001-01-01 00:00:00'),(13,5814,80919,59962,1,'2021-01-12 16:22:40','0001-01-01 00:00:00'),(14,5814,80919,1,1,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(15,5814,95470,59961,1,'2021-01-15 13:34:13','0001-01-01 00:00:00'),(16,5814,95471,2100050009,1,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(17,5814,95470,2100050009,1,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(18,5814,95499,59062,1,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(19,5814,95499,599,1,'0001-01-01 00:00:00','0001-01-01 00:00:00');
/*!40000 ALTER TABLE `knowledge_nebula_class_care_stu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledge_nebula_send_matrix_detail`
--

DROP TABLE IF EXISTS `knowledge_nebula_send_matrix_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledge_nebula_send_matrix_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `task_id` int(11) NOT NULL DEFAULT '0' COMMENT '任务id',
  `plan_id` int(11) NOT NULL DEFAULT '0' COMMENT '讲次id',
  `class_id` int(11) NOT NULL DEFAULT '0' COMMENT '班级id',
  `stu_id` int(11) NOT NULL DEFAULT '0' COMMENT '发送消息关联学生id',
  `receiver_id` varchar(50) NOT NULL DEFAULT '' COMMENT '接收人id',
  `receiver_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1：学生，2：爸爸，3：妈妈，4-8：家长1-5',
  `send_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '消息类型，1 表扬，2 督促',
  `send_url` text NOT NULL COMMENT '发送的链接地址',
  `send_words` text NOT NULL COMMENT '发送的话术',
  `send_status` tinyint(2) NOT NULL DEFAULT '0' COMMENT '发送状态：0，默认值，1：发送中，2：发送成功，3：发送失败，4：忽略失败，5：已重发',
  `fail_result` text NOT NULL COMMENT '发送失败的原因，来自于矩阵',
  `updated_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `created_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx-task_id` (`task_id`),
  KEY `idx-stu_id` (`stu_id`),
  KEY `idx-class_id` (`class_id`),
  KEY `idx-receiver_id` (`receiver_id`),
  KEY `idx-plan_id-class_id-send_status` (`plan_id`,`class_id`,`send_status`)
) ENGINE=InnoDB AUTO_INCREMENT=1065 DEFAULT CHARSET=utf8mb4 COMMENT='知识星云发送明细表-朱培杰';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledge_nebula_send_matrix_detail`
--

LOCK TABLES `knowledge_nebula_send_matrix_detail` WRITE;
/*!40000 ALTER TABLE `knowledge_nebula_send_matrix_detail` DISABLE KEYS */;
INSERT INTO `knowledge_nebula_send_matrix_detail` VALUES (1,31,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'','测试一下哦林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-30 01:05:09'),(2,31,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'','测试一下哦林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-30 01:05:42'),(3,33,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'xb-POtqtZ7Wl6di7XuMZPpi0ybLlBGtiLjNTCab-E4U','测试一下111111林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-30 11:10:14'),(4,33,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'xb-POtqtZ7Wl6di7XuMZPpi0ybLlBGtiLjNTCab-E4U','测试一下111111林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-30 11:36:11'),(5,33,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'xb-POtqtZ7Wl6di7XuMZPpi0ybLlBGtiLjNTCab-E4U','测试一下111111林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-30 11:37:27'),(1060,31,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'https://app.xueersi.com/nebula-h5/knowledge?stu_report_id=xb-POtqtZ7Wl6di7XuMZPi-S6sBpEnXdZCtrWTgaptA','测试一下哦林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-31 10:49:39'),(1061,31,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'https://app.xueersi.com/nebula-h5/knowledge?stu_report_id=xb-POtqtZ7Wl6di7XuMZPi-S6sBpEnXdZCtrWTgaptA','测试一下哦林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-31 10:49:39'),(1062,31,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'https://app.xueersi.com/nebula-h5/knowledge?stu_report_id=xb-POtqtZ7Wl6di7XuMZPi-S6sBpEnXdZCtrWTgaptA','测试一下哦林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-31 10:49:39'),(1063,31,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'https://app.xueersi.com/nebula-h5/knowledge?stu_report_id=xb-POtqtZ7Wl6di7XuMZPi-S6sBpEnXdZCtrWTgaptA','测试一下哦林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-31 10:49:39'),(1064,31,673178,42633,58364,'wxid_f1feogigh8hc21',1,1,'https://app.xueersi.com/nebula-h5/knowledge?stu_report_id=xb-POtqtZ7Wl6di7XuMZPi-S6sBpEnXdZCtrWTgaptA','测试一下哦林依依同学，这里是讲次19935-outline_catalog100',4,'','2021-01-01 15:25:20','2020-12-31 10:49:39');
/*!40000 ALTER TABLE `knowledge_nebula_send_matrix_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledge_nebula_send_matrix_task`
--

DROP TABLE IF EXISTS `knowledge_nebula_send_matrix_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledge_nebula_send_matrix_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增task ID',
  `plan_id` int(11) NOT NULL DEFAULT '0' COMMENT '讲次id',
  `class_id` int(11) NOT NULL DEFAULT '0' COMMENT '班级id',
  `send_text` text NOT NULL COMMENT '发送文本设定内容',
  `send_link_ids` text NOT NULL COMMENT '发送关联id，task_type=0：发给学生的ids，task_type=1：对应的失败detail数据id',
  `receiver_type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '接收人类型：1 学生自己，2 学生所有家长，3 学生+所有家长',
  `send_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '发送消息类型，1表扬，2督促',
  `task_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '任务类型，0 默认，1 重发',
  `task_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '任务状态：0 初始化，1发送中，2处理完成',
  `creator_id` int(11) NOT NULL DEFAULT '0' COMMENT '发送人id',
  `updated_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '更新时间',
  `created_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx-class_id` (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=411 DEFAULT CHARSET=utf8mb4 COMMENT='知识星云发送任务-朱培杰';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledge_nebula_send_matrix_task`
--

LOCK TABLES `knowledge_nebula_send_matrix_task` WRITE;
/*!40000 ALTER TABLE `knowledge_nebula_send_matrix_task` DISABLE KEYS */;
INSERT INTO `knowledge_nebula_send_matrix_task` VALUES (1,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(2,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(3,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(4,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(5,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'2020-12-24 19:38:26','2020-12-24 19:38:26'),(406,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(407,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(408,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(409,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00'),(410,673079,42633,'\"test 1111\"','59062',1,1,0,0,0,'0001-01-01 00:00:00','0001-01-01 00:00:00');
/*!40000 ALTER TABLE `knowledge_nebula_send_matrix_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledge_nebula_teacher_talk_words`
--

DROP TABLE IF EXISTS `knowledge_nebula_teacher_talk_words`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledge_nebula_teacher_talk_words` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `teacher_id` int(11) NOT NULL DEFAULT '0' COMMENT '老师id',
  `talk_words` varchar(255) NOT NULL DEFAULT '0' COMMENT '话术',
  `talk_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '话术类型，默认值：0 ，1：表扬默认话术，2：督促默认话术',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除话术：0 默认值，1 删除',
  `updated_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '更新时间',
  `created_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx-class_id_talk_type` (`talk_type`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COMMENT='知识星云班级默认话术表-朱培杰';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledge_nebula_teacher_talk_words`
--

LOCK TABLES `knowledge_nebula_teacher_talk_words` WRITE;
/*!40000 ALTER TABLE `knowledge_nebula_teacher_talk_words` DISABLE KEYS */;
INSERT INTO `knowledge_nebula_teacher_talk_words` VALUES (1,2377,'{lecture}额额额额额额{studentName}',1,0,'2020-12-24 20:08:22','2020-12-24 20:08:22'),(2,2377,'哈哈哈哈{studentName}哈哈哈sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssj',2,0,'2021-01-01 14:57:35','2021-01-01 14:57:35'),(3,5814,'亲爱滴{studentName}，您孩子参与的{lecture}课程，根据他的课堂表现，给他制定了个性化的练习，请查收~',2,0,'2021-01-06 15:55:27','2021-01-06 15:55:27'),(4,5814,'{studentName}你好，{lecture}的个性化练习，你做的非常棒。老师为你点赞！\n再接再厉，争取再上一层楼！',1,0,'2021-01-08 17:13:16','2021-01-08 17:13:16'),(5,0,'{studentName}你好，老师为你准备的{lecture}的个性化练习，你还没有做哦。快去练习提升吧~{studentName}{lecture}',2,0,'2021-01-15 13:40:28','2021-01-15 13:40:28'),(76,2377,'{lecture}额额额额额额{studentName}',1,0,'2020-12-24 20:08:22','2020-12-24 20:08:22'),(77,2377,'{lecture}额额额额额额{studentName}',1,0,'2020-12-24 20:08:22','2020-12-24 20:08:22'),(78,2377,'{lecture}额额额额额额{studentName}',1,0,'2020-12-24 20:08:22','2020-12-24 20:08:22'),(79,2377,'{lecture}额额额额额额{studentName}',1,0,'2020-12-24 20:08:22','2020-12-24 20:08:22'),(80,2377,'{lecture}额额额额额额{studentName}',1,0,'2020-12-24 20:08:22','2020-12-24 20:08:22');
/*!40000 ALTER TABLE `knowledge_nebula_teacher_talk_words` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knowledge_nebula_teacher_talk_words_log`
--

DROP TABLE IF EXISTS `knowledge_nebula_teacher_talk_words_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledge_nebula_teacher_talk_words_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `teacher_id` int(11) NOT NULL DEFAULT '0' COMMENT '老师id',
  `talk_words` varchar(255) NOT NULL DEFAULT '0' COMMENT '当次修改话术，每修改一次，本表多一条数据',
  `operate` tinyint(1) NOT NULL DEFAULT '0' COMMENT '操作 0默认，1 add, 2 delete',
  `talk_type` tinyint(1) NOT NULL COMMENT '1表扬默认话术；2 督促默认话术',
  `created_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1318 DEFAULT CHARSET=utf8mb4 COMMENT='知识星云班级默认话术修改记录-朱培杰';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knowledge_nebula_teacher_talk_words_log`
--

LOCK TABLES `knowledge_nebula_teacher_talk_words_log` WRITE;
/*!40000 ALTER TABLE `knowledge_nebula_teacher_talk_words_log` DISABLE KEYS */;
INSERT INTO `knowledge_nebula_teacher_talk_words_log` VALUES (1,2377,'\"老实说，这是个测试\"',1,1,'0001-01-01 00:00:00'),(2,2377,'\"老实说，这是个测试\"',1,1,'2020-12-24 20:08:22'),(3,2377,'{lecture}撒大声地撒',1,2,'2020-12-25 18:36:31'),(4,2377,'{lecture}撒大声地撒1111',1,2,'2020-12-25 19:19:56'),(5,2377,'{lecture}撒大声地撒1111<br><br><br>{lecture}',1,2,'2020-12-26 16:17:29'),(1313,2377,'{lecture}撒大声地撒',1,2,'2020-12-25 18:36:31'),(1314,2377,'{lecture}撒大声地撒',1,2,'2020-12-25 18:36:31'),(1315,2377,'{lecture}撒大声地撒',1,2,'2020-12-25 18:36:31'),(1316,2377,'{lecture}撒大声地撒',1,2,'2020-12-25 18:36:31'),(1317,2377,'{lecture}撒大声地撒',1,2,'2020-12-25 18:36:31');
/*!40000 ALTER TABLE `knowledge_nebula_teacher_talk_words_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `like`
--

DROP TABLE IF EXISTS `like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `like` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `topic_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '内容资源id',
  `comment_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论id',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '状态:0取消点赞;1点赞',
  `like_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '点赞时间',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`) USING BTREE COMMENT '按用户id条件查询',
  KEY `idx_topic_id` (`topic_id`),
  KEY `idx_t_c_l` (`topic_id`,`comment_id`,`like_time`),
  KEY `idx_comment_id` (`comment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2262 DEFAULT CHARSET=utf8mb4 COMMENT='点赞记录表-李兴部';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `like`
--

LOCK TABLES `like` WRITE;
/*!40000 ALTER TABLE `like` DISABLE KEYS */;
INSERT INTO `like` VALUES (1,11212,1,1,0,1584593496,1584593496,1587602627),(2,11282,1,1,0,1585206721,1584965893,1587602627),(3,11282,1,17,0,1585294756,1584966028,1587602627),(4,11282,1,9,0,1585051111,1585011101,1587602627),(5,11282,1,6,0,1585206950,1585011103,1587602627),(2257,11212,1,1,0,1584593496,1584593496,1587602627),(2258,11212,1,1,0,1584593496,1584593496,1587602627),(2259,11212,1,1,0,1584593496,1584593496,1587602627),(2260,11212,1,1,0,1584593496,1584593496,1587602627),(2261,11212,1,1,0,1584593496,1584593496,1587602627);
/*!40000 ALTER TABLE `like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meme_comment_face`
--

DROP TABLE IF EXISTS `meme_comment_face`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meme_comment_face` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `topic_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '话题ID',
  `comment_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论ID',
  `face_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '表情ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态,0:下线;1:上线',
  PRIMARY KEY (`id`),
  KEY `idx_topic_id_comment_id` (`topic_id`,`comment_id`),
  KEY `idx_face_id` (`face_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1407 DEFAULT CHARSET=utf8mb4 COMMENT='评论与表情关系表-孙德彪';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meme_comment_face`
--

LOCK TABLES `meme_comment_face` WRITE;
/*!40000 ALTER TABLE `meme_comment_face` DISABLE KEYS */;
INSERT INTO `meme_comment_face` VALUES (1,168,6947,1,1),(2,46,9997,29,1),(3,44,9998,28,1),(4,44,9999,28,1),(5,44,10000,26,1),(1402,44,9998,28,1),(1403,44,9998,28,1),(1404,44,9998,28,1),(1405,44,9998,28,1),(1406,44,9998,28,1);
/*!40000 ALTER TABLE `meme_comment_face` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meme_user`
--

DROP TABLE IF EXISTS `meme_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meme_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `meme_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '表情包ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态,0:已删除;1:已添加;2:表情包已下线',
  `add_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id_meme_id` (`user_id`,`meme_id`),
  KEY `idx_meme_id` (`meme_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3183 DEFAULT CHARSET=utf8mb4 COMMENT='用户与表情包关系表-孙德彪';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meme_user`
--

LOCK TABLES `meme_user` WRITE;
/*!40000 ALTER TABLE `meme_user` DISABLE KEYS */;
INSERT INTO `meme_user` VALUES (2,59530,15,2,1608299665,1608299188,1609326758),(3,59530,16,2,1608299671,1608299191,1609326758),(4,59530,18,1,1610683051,1608299196,1610683051),(5,59530,20,2,1609147144,1608299199,1609326758),(3178,59144,13,2,1608299665,1608299188,1609326758);
/*!40000 ALTER TABLE `meme_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operator`
--

DROP TABLE IF EXISTS `operator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operator` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `comment_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论id',
  `topic_id` int(11) unsigned NOT NULL COMMENT '话题id',
  `operator_uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `operator_msg` varchar(255) NOT NULL DEFAULT '' COMMENT '备注信息',
  `operator_type` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '操作类型:1谛听人工审核通过,2谛听人工审核拒绝,3谛听敏感词检测拒绝,5评论白名单机制默认审核通过,6灌水后台评论默认审核通过,7知音楼回复评论默认通过,8评论审核后台审核通过,9评论审核后台审核拒绝',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_topic_id` (`topic_id`) USING BTREE COMMENT '按话题id条件查询',
  KEY `idx_user_id` (`operator_uid`) USING BTREE COMMENT '按用户id条件查询',
  KEY `idx_comment_id` (`comment_id`) USING BTREE COMMENT '按评论id条件查询'
) ENGINE=InnoDB AUTO_INCREMENT=10536 DEFAULT CHARSET=utf8mb4 COMMENT='评论操作记录表-马远远';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operator`
--

LOCK TABLES `operator` WRITE;
/*!40000 ALTER TABLE `operator` DISABLE KEYS */;
INSERT INTO `operator` VALUES (1,2,364,0,'审核通过',4,1587564467),(2,3,364,0,'审核通过',4,1587565042),(3,8,364,0,'审核通过',4,1587568981),(4,9,364,0,'审核通过',4,1587569512),(5,10,364,0,'审核通过',4,1587569619),(10531,2,364,0,'审核通过',4,1587564467),(10532,2,364,0,'审核通过',4,1587564467),(10533,2,364,0,'审核通过',4,1587564467),(10534,2,364,0,'审核通过',4,1587564467),(10535,2,364,0,'审核通过',4,1587564467);
/*!40000 ALTER TABLE `operator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reciter_comment`
--

DROP TABLE IF EXISTS `reciter_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reciter_comment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `topic_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '话题id',
  `resource_id` varchar(100) NOT NULL DEFAULT '' COMMENT '资源id',
  `comment_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `score` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '朗读者评分',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_topic_id` (`topic_id`,`comment_id`) USING BTREE COMMENT '话题评论联合唯一索引',
  KEY `idx_user_id` (`user_id`) USING BTREE COMMENT '用户id索引'
) ENGINE=InnoDB AUTO_INCREMENT=316 DEFAULT CHARSET=utf8mb4 COMMENT='朗读者评论关联表-李兴部';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reciter_comment`
--

LOCK TABLES `reciter_comment` WRITE;
/*!40000 ALTER TABLE `reciter_comment` DISABLE KEYS */;
INSERT INTO `reciter_comment` VALUES (1,1270,'cms_lxb_reciter_test',11155,58371,80),(2,1270,'cms_lxb_reciter_test',11168,58371,40),(3,1288,'131606821299721303',11656,58375,3),(4,1288,'131606821299721303',11657,58375,3),(5,1288,'131606821299721303',11658,58375,3),(311,1134,'cms_lxb_reciter_test',13423,58371,80);
/*!40000 ALTER TABLE `reciter_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '投诉用户id',
  `type` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '投诉类型',
  `content` varchar(255) NOT NULL COMMENT '投诉内容',
  `appeal_uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '被投诉用户id',
  `appeal_uname` varchar(20) NOT NULL COMMENT '被投诉用户昵称',
  `topic_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '被投诉话题id',
  `resource_id` varchar(100) NOT NULL COMMENT '被投诉内容资源id',
  `comment_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '被投诉评论id',
  `level2_text` varchar(255) NOT NULL COMMENT '被投诉评论内容',
  `level1_text` varchar(255) NOT NULL COMMENT '被投诉上级评论内容',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '投诉时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`) USING BTREE COMMENT '按用户id条件查询',
  KEY `idx_appeal_uid` (`appeal_uid`) USING BTREE COMMENT '按被投诉用户条件查询',
  KEY `idx_type` (`type`) USING BTREE COMMENT '按投诉类型查询'
) ENGINE=InnoDB AUTO_INCREMENT=495 DEFAULT CHARSET=utf8mb4 COMMENT='投诉记录表-李兴部';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report`
--

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
INSERT INTO `report` VALUES (1,0,1,'topic为1,comment为1，投诉其他类型',11212,'11212',1,'cms_lxb_11281',2,'11212创建的第1条评论','',1584593843),(2,0,1,'topic为1,comment为1，投诉其他类型',11232,'11232',1,'cms_lxb_11281',14,'11212创建的第1条评论---11232回复----11232回复','11212创建的第1条评论',1584593887),(3,11282,4,'政治、色情等敏感信息',11212,'11212',1,'cms_lxb_11281',2,'11212创建的第1条评论','',1584972760),(4,11282,4,'政治、色情等敏感信息',11212,'11212',1,'cms_lxb_11281',2,'11212创建的第1条评论','',1584975341),(5,11282,5,'引战、虚假造谣',11212,'11212',1,'cms_lxb_11281',2,'11212创建的第1条评论','',1584975535),(490,11282,4,'引战、虚假造谣',11212,'11212',1,'cms_lxb_11281',2,'11212创建的第1条评论','',1584975535),(491,11282,4,'引战、虚假造谣',11212,'11212',1,'cms_lxb_11281',2,'11212创建的第1条评论','',1584975535),(492,11282,4,'引战、虚假造谣',11212,'11212',1,'cms_lxb_11281',2,'11212创建的第1条评论','',1584975535),(493,11282,4,'引战、虚假造谣',11212,'11212',1,'cms_lxb_11281',2,'11212创建的第1条评论','',1584975535),(494,11282,4,'引战、虚假造谣',11212,'11212',1,'cms_lxb_11281',2,'11212创建的第1条评论','',1584975535);
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `app_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '应用id',
  `resource_ids` varchar(6144) NOT NULL DEFAULT '' COMMENT '资源id集合',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '角色名',
  `des` varchar(128) NOT NULL DEFAULT '' COMMENT '角色描述',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '角色类型 1:非敏感 2:敏感',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '角色状态 1:正常 2:冻结',
  `appr_tal_num` varchar(64) NOT NULL DEFAULT '' COMMENT '审批人工号id',
  `appr_name` varchar(64) NOT NULL DEFAULT '' COMMENT '干系人姓名',
  `vaild_time_ident` tinyint(1) NOT NULL DEFAULT '1' COMMENT '创建后有效期 1:永久 2:30天 3:60天 4:90天 5:180天',
  `vaild_time` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' COMMENT '创建后有效期',
  `modify_time` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `app_id` (`app_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='角色表-彭伟';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,2,'31,37,38,17,66,246,243','标签管理','',2,1,'159775','白龙',1,'2020-11-02 17:31:45','2020-12-18 14:19:44','2020-11-02 17:31:45'),(2,2,'16,17','权限管理-角色','',1,2,'217536','彭伟',1,'2020-11-02 20:44:57','2020-12-11 11:23:22','2020-11-02 20:44:57'),(3,2,'18,22,13','测试员工','测试员工的角色权限',2,2,'217536','彭伟',2,'2020-12-04 16:17:34','2020-12-11 11:23:23','2020-11-04 16:17:34'),(4,2,'33','张红','',1,2,'217536','彭伟',1,'2020-11-04 17:51:23','2020-11-28 21:08:54','2020-11-04 17:51:23'),(5,2,'22','测试员工2','测试员工角色22',1,2,'037409','',4,'2021-02-02 19:11:55','2020-11-26 22:19:59','2020-11-04 19:11:55');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_ehr`
--

DROP TABLE IF EXISTS `staff_ehr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_ehr` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `emplid` varchar(20) NOT NULL DEFAULT '' COMMENT '工号',
  `name` varchar(30) NOT NULL DEFAULT '' COMMENT '姓名',
  `t_sex` char(1) NOT NULL DEFAULT '' COMMENT '性别',
  `phone` varchar(15) NOT NULL DEFAULT '' COMMENT '电话',
  `email_addr` varchar(30) NOT NULL DEFAULT '' COMMENT '邮箱',
  `deptid` varchar(10) NOT NULL DEFAULT '' COMMENT '部门id',
  `t_dept_descr` varchar(50) NOT NULL DEFAULT '' COMMENT '部门描述',
  `dept_syb` varchar(15) NOT NULL DEFAULT '' COMMENT '所属事业部',
  `dept_syb_descr` varchar(50) NOT NULL DEFAULT '' COMMENT '所属事业部描述',
  `c_rusi_dt` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' COMMENT '入司日期',
  `termination_dt` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' COMMENT '离职日期',
  `empl_rcd` tinyint(1) NOT NULL DEFAULT '0' COMMENT '岗位序号 0主岗 1副岗 2副岗',
  `hr_status` char(1) NOT NULL DEFAULT '' COMMENT '在职状态，A在职，I离职',
  `jobcode` varchar(10) NOT NULL DEFAULT '' COMMENT '职务编码',
  `c_jobcode_descr1` varchar(50) NOT NULL DEFAULT '' COMMENT '职务描述',
  `t_jobcode_descr` varchar(50) NOT NULL DEFAULT '' COMMENT '职务别名',
  `modify_time` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`emplid`,`empl_rcd`) USING BTREE,
  KEY `update_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=6819421 DEFAULT CHARSET=utf8mb4 COMMENT='EHR员工信息表-彭伟';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_ehr`
--

LOCK TABLES `staff_ehr` WRITE;
/*!40000 ALTER TABLE `staff_ehr` DISABLE KEYS */;
INSERT INTO `staff_ehr` VALUES (6819416,'012121','魏倩','女','','','D1020965','集团总部-位晨-行政部-运营区域管理中心-网校行政部-网校行政北京区域','D1000002','集团总部','2018-03-05 00:00:00','1970-01-01 00:00:00',0,'A','J02560','行政专员III','高级行政专员','2020-04-22 14:36:01','0000-00-00 00:00:00'),(6819417,'012122','贾世增','男','','','D1011257','集团前台-互联网服务事业部-网校事业部-学科项目部-高中产品部-理科教研部','D1001112','集团前台-互联网服务事业部-网校事业部','2010-10-11 00:00:00','1970-01-01 00:00:00',0,'A','J01531','产品教研专家III-高中理综','教研专家','2020-05-21 15:37:59','0000-00-00 00:00:00'),(6819418,'001212','贾世增','男','','','D1011222','集团前台-互联网服务事业部-网校事业部-学科项目部-师资管理部','D1001112','集团前台-互联网服务事业部-网校事业部','2016-07-01 00:00:00','1970-01-01 00:00:00',3,'A','J03076','教师-综合','主讲教师','2020-05-21 15:38:00','0000-00-00 00:00:00'),(6819419,'031212','段路中','男','','','D1021698','集团前台-互联网服务事业部-网校事业部-互联网研发部-效能研发部-后端组','D1001112','集团前台-互联网服务事业部-网校事业部','2016-04-05 00:00:00','1970-01-01 00:00:00',0,'A','J00127','PHP/Java副专家','高级PHP/Java工程师','2020-05-21 15:38:04','0000-00-00 00:00:00'),(6819420,'042322','于晗','女','','','D1017554','集团前台-互联网服务事业部-网校事业部-学科项目部-初中产品部-内控部','D1001112','集团前台-互联网服务事业部-网校事业部','2016-04-25 00:00:00','1970-01-01 00:00:00',0,'A','J02383','项目管理专员III','项目管理专员III','2020-05-21 15:38:05','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `staff_ehr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_role_relate`
--

DROP TABLE IF EXISTS `staff_role_relate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_role_relate` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `emplid` varchar(32) NOT NULL DEFAULT '' COMMENT '员工工号',
  `app_id` int(11) NOT NULL DEFAULT '0' COMMENT '应用id',
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '员工所属角色的状态 1:正常 2:失效(删除)',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '员工的类型 0:默认 1:正式 2:临时',
  `modify_time` datetime NOT NULL DEFAULT '0000-01-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `emplid` (`emplid`,`app_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=478 DEFAULT CHARSET=utf8mb4 COMMENT='员工和角色的关系-彭伟';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_role_relate`
--

LOCK TABLES `staff_role_relate` WRITE;
/*!40000 ALTER TABLE `staff_role_relate` DISABLE KEYS */;
INSERT INTO `staff_role_relate` VALUES (1,'1',2,1,1,1,'2021-01-20 12:30:38','2020-11-02 17:32:42'),(2,'005753',2,2,2,1,'2021-01-14 15:51:08','2020-11-02 20:50:41'),(3,'082548',2,1,2,1,'2021-01-14 15:51:08','2020-11-04 15:51:26'),(4,'082548',2,1,2,1,'2021-01-14 15:51:08','2020-11-04 16:22:07'),(5,'088384',2,4,2,1,'2021-01-14 15:51:08','2020-11-04 17:52:03'),(473,'005753',2,2,1,1,'0000-01-01 00:00:00','2021-02-07 14:48:14'),(474,'005753',2,2,1,1,'0000-01-01 00:00:00','2021-02-07 14:49:00'),(475,'005753',2,2,1,1,'0000-01-01 00:00:00','2021-02-07 14:49:48'),(476,'005753',2,2,1,1,'0000-01-01 00:00:00','2021-02-07 14:50:10'),(477,'005753',2,2,1,1,'0000-01-01 00:00:00','2021-02-07 14:56:19');
/*!40000 ALTER TABLE `staff_role_relate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `resource_id` varchar(100) NOT NULL COMMENT '内容资源id',
  `first_cid` varchar(190) NOT NULL COMMENT '一级分类id',
  `second_cid` varchar(190) NOT NULL COMMENT '二级分类id',
  `title` varchar(100) NOT NULL COMMENT '内容标题',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '状态，0关闭评论;1开放评论',
  `subject_ids` varchar(190) NOT NULL COMMENT '适用学科ids，英文逗号分隔',
  `grade_ids` varchar(190) NOT NULL COMMENT '适用年级ids，英文逗号分隔',
  `teacher_ids` varchar(190) NOT NULL COMMENT '主讲老师ids',
  `finish_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '存活时间',
  `creator_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'id',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `comment_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论总数',
  `total_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论总数(已审核+隐藏)',
  `update_uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新用户id',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_resource_id` (`resource_id`) USING BTREE COMMENT '内容资源条件检索',
  KEY `idx_creator_id` (`creator_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1848 DEFAULT CHARSET=utf8mb4 COMMENT='话题资源管理表-李兴部';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
INSERT INTO `topic` VALUES (1,'cms_lxb_11281','1','','cms业务同步更新',1,'','','',0,10000000,1584527628,8,8,0,1594626514),(1843,'102003170028268973','1','9999,152','测试视频评论组件',1,'','3','',0,7,1585320704,45,0,0,1597331820),(1844,'102003170028268973','1','9999,152','测试视频评论组件',1,'','3','',0,7,1585320704,45,0,0,1597331820),(1845,'102003170028268973','1','9999,152','测试视频评论组件',1,'','3','',0,7,1585320704,45,0,0,1597331820),(1846,'102003170028268973','1','9999,152','测试视频评论组件',1,'','3','',0,7,1585320704,45,0,0,1597331820),(1847,'102003170028268973','1','9999,152','测试视频评论组件',1,'','3','',0,7,1585320704,45,0,0,1597331820);
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_paper`
--

DROP TABLE IF EXISTS `user_paper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_paper` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增Id',
  `stu_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '学生Id',
  `source_type` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '试卷来源:1->辅导侧生成;2->教材章节侧生成',
  `answer_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '试卷作答状态:1->未作答;2->已作答',
  `request_knowledge_ids` varchar(512) NOT NULL DEFAULT '' COMMENT '请求的知识点ids',
  `plan_id` int(11) NOT NULL COMMENT '讲次id',
  `class_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '班级id',
  `answer_time` varchar(15) NOT NULL DEFAULT '' COMMENT '作答总用时(毫秒)',
  `correct_count` int(11) NOT NULL DEFAULT '0' COMMENT '答对数',
  `create_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
  `modify_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '编辑时间',
  `recommend_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '内容云-推荐id',
  `transformation` text COMMENT '变化',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_stu_id` (`stu_id`) USING BTREE,
  KEY `idx_modify_time` (`modify_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1364 DEFAULT CHARSET=utf8mb4 COMMENT='用户试卷表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_paper`
--

LOCK TABLES `user_paper` WRITE;
/*!40000 ALTER TABLE `user_paper` DISABLE KEYS */;
INSERT INTO `user_paper` VALUES (1345,59961,1,2,'[\"22349acf66004e289c2475c272f48c06\"]',1121041,94877,'161',5,'2021-02-05 15:32:26','2021-02-05 15:35:08','155b4179792d4df7963645160bedff52','[{\"stuId\":\"59961\",\"knowleageId\":\"22349acf66004e289c2475c272f48c06\",\"knowleageName\":\"\\u70b9\\u5728\\u4e00\\u6b21\\u51fd\\u6570\\u56fe\\u8c61\\u4e0a\",\"recommendId\":\"155b4179792d4df7963645160bedff52\",\"score\":0.73035973,\"label\":3,\"threshold\":[\"0.30000000\",\"0.73000000\"],\"isHighFrequency\":0,\"isThisExercise\":1,\"preMastery\":0.5800993,\"thisMastery\":0.73035973,\"preLabel\":2}]'),(1354,59899,1,2,'[\"9adec8b535b544b582ee149ea7203045\"]',1125567,95470,'158',5,'2021-02-05 15:35:11','2021-02-05 15:37:51','e01778655d7f4641b773fb270f878bb8','[{\"stuId\":\"59899\",\"knowleageId\":\"9adec8b535b544b582ee149ea7203045\",\"knowleageName\":\"\\u529f\\u7387\\u7684\\u7b80\\u5355\\u8ba1\\u7b97\",\"recommendId\":\"e01778655d7f4641b773fb270f878bb8\",\"score\":0.8398199,\"label\":3,\"threshold\":[\"0.31000000\",\"0.68500000\"],\"isHighFrequency\":1,\"isThisExercise\":0,\"preMastery\":0.60458386,\"thisMastery\":0.8398199,\"preLabel\":2}]'),(1355,59961,1,2,'[\"22349acf66004e289c2475c272f48c06\"]',1121041,94877,'189',5,'2021-02-05 15:35:22','2021-02-05 15:38:31','6fe2a6532e3448f38820c3842a973a39','[{\"stuId\":\"59961\",\"knowleageId\":\"22349acf66004e289c2475c272f48c06\",\"knowleageName\":\"\\u70b9\\u5728\\u4e00\\u6b21\\u51fd\\u6570\\u56fe\\u8c61\\u4e0a\",\"recommendId\":\"6fe2a6532e3448f38820c3842a973a39\",\"score\":0.9426665,\"label\":3,\"threshold\":[\"0.30000000\",\"0.73000000\"],\"isHighFrequency\":0,\"isThisExercise\":1,\"preMastery\":0.73035973,\"thisMastery\":0.9426665,\"preLabel\":3}]'),(1356,59961,1,2,'[\"22349acf66004e289c2475c272f48c06\"]',1121041,94877,'33',5,'2021-02-05 15:41:44','2021-02-05 15:42:18','3a969bab9bc1407fa8a3c5b4d85a5a95','[{\"stuId\":\"59961\",\"knowleageId\":\"22349acf66004e289c2475c272f48c06\",\"knowleageName\":\"\\u70b9\\u5728\\u4e00\\u6b21\\u51fd\\u6570\\u56fe\\u8c61\\u4e0a\",\"recommendId\":\"3a969bab9bc1407fa8a3c5b4d85a5a95\",\"score\":0.9426665,\"label\":3,\"threshold\":[\"0.30000000\",\"0.73000000\"],\"isHighFrequency\":0,\"isThisExercise\":0,\"preMastery\":0.9426665,\"thisMastery\":0.9426665,\"preLabel\":3}]'),(1357,59961,1,2,'[\"22349acf66004e289c2475c272f48c06\"]',1121041,94877,'46',5,'2021-02-05 15:42:30','2021-02-05 15:43:16','b6341b297ba14d0081ca0790f05771ba','[{\"stuId\":\"59961\",\"knowleageId\":\"22349acf66004e289c2475c272f48c06\",\"knowleageName\":\"\\u70b9\\u5728\\u4e00\\u6b21\\u51fd\\u6570\\u56fe\\u8c61\\u4e0a\",\"recommendId\":\"b6341b297ba14d0081ca0790f05771ba\",\"score\":1,\"label\":3,\"threshold\":[\"0.30000000\",\"0.73000000\"],\"isHighFrequency\":0,\"isThisExercise\":1,\"preMastery\":0.9426665,\"thisMastery\":1,\"preLabel\":3}]'),(1358,59899,1,2,'[\"e0ba89e140384f9a9e860289acc2d3bf\",\"bc69f767cfc8424fae2e2c057e661b88\",\"9adec8b535b544b582ee149ea7203045\",\"85803eff855947c2a7bf5c02363f082c\",\"4ef124daa11b4ec8bdb70d50e3232ad5\"]',1125567,95470,'280',5,'2021-02-05 15:42:38','2021-02-05 15:47:19','475af8472d884b4980eb3ba74a2bed20','[{\"stuId\":\"59899\",\"knowleageId\":\"4ef124daa11b4ec8bdb70d50e3232ad5\",\"knowleageName\":\"\\u91cd\\u529b\\u7684\\u4f30\\u6d4b\",\"recommendId\":\"475af8472d884b4980eb3ba74a2bed20\",\"score\":0.7154263,\"label\":3,\"threshold\":[\"0.37000000\",\"0.66000000\"],\"isHighFrequency\":0,\"isThisExercise\":0,\"preMastery\":0.7154263,\"thisMastery\":0.7154263,\"preLabel\":3},{\"stuId\":\"59899\",\"knowleageId\":\"85803eff855947c2a7bf5c02363f082c\",\"knowleageName\":\"\\u529f\\u7684\\u7b80\\u5355\\u8ba1\\u7b97\",\"recommendId\":\"475af8472d884b4980eb3ba74a2bed20\",\"score\":0.92891985,\"label\":3,\"threshold\":[\"0.34000000\",\"0.66000000\"],\"isHighFrequency\":1,\"isThisExercise\":1,\"preMastery\":0.66976583,\"thisMastery\":0.92891985,\"preLabel\":3},{\"stuId\":\"59899\",\"knowleageId\":\"9adec8b535b544b582ee149ea7203045\",\"knowleageName\":\"\\u529f\\u7387\\u7684\\u7b80\\u5355\\u8ba1\\u7b97\",\"recommendId\":\"475af8472d884b4980eb3ba74a2bed20\",\"score\":0.8398199,\"label\":3,\"threshold\":[\"0.31000000\",\"0.68500000\"],\"isHighFrequency\":1,\"isThisExercise\":0,\"preMastery\":0.8398199,\"thisMastery\":0.8398199,\"preLabel\":3},{\"stuId\":\"59899\",\"knowleageId\":\"bc69f767cfc8424fae2e2c057e661b88\",\"knowleageName\":\"\\u957f\\u5ea6\\u7684\\u4f30\\u6d4b\",\"recommendId\":\"475af8472d884b4980eb3ba74a2bed20\",\"score\":0.70989776,\"label\":3,\"threshold\":[\"0.42000000\",\"0.67500000\"],\"isHighFrequency\":1,\"isThisExercise\":0,\"preMastery\":0.70989776,\"thisMastery\":0.70989776,\"preLabel\":3},{\"stuId\":\"59899\",\"knowleageId\":\"e0ba89e140384f9a9e860289acc2d3bf\",\"knowleageName\":\"\\u529f\\u7387\\u7684\\u4f30\\u8ba1\",\"recommendId\":\"475af8472d884b4980eb3ba74a2bed20\",\"score\":0.9912786,\"label\":3,\"threshold\":[\"0.30000000\",\"0.70000000\"],\"isHighFrequency\":0,\"isThisExercise\":0,\"preMastery\":0.9912786,\"thisMastery\":0.9912786,\"preLabel\":3}]'),(1359,12345,1,1,'[\"0fd03aea6e3b443282b2ff4bb264013f\", \"6oo7ryi0e79zkqai08wbmeohxn6c03b4\"]',2,1,'',0,'2020-12-25 14:47:43','1970-01-01 00:00:00','ee977d69700e43b083d7fc8f5e4dd471',NULL),(1360,12345,1,1,'[\"0fd03aea6e3b443282b2ff4bb264013f\", \"6oo7ryi0e79zkqai08wbmeohxn6c03b4\"]',2,1,'',0,'2020-12-25 14:47:43','1970-01-01 00:00:00','ee977d69700e43b083d7fc8f5e4dd471',NULL),(1361,12345,1,1,'[\"0fd03aea6e3b443282b2ff4bb264013f\", \"6oo7ryi0e79zkqai08wbmeohxn6c03b4\"]',2,1,'',0,'2020-12-25 14:47:43','1970-01-01 00:00:00','ee977d69700e43b083d7fc8f5e4dd471',NULL),(1362,12345,1,1,'[\"0fd03aea6e3b443282b2ff4bb264013f\", \"6oo7ryi0e79zkqai08wbmeohxn6c03b4\"]',2,1,'',0,'2020-12-25 14:47:43','1970-01-01 00:00:00','ee977d69700e43b083d7fc8f5e4dd471',NULL),(1363,12345,1,1,'[\"0fd03aea6e3b443282b2ff4bb264013f\", \"6oo7ryi0e79zkqai08wbmeohxn6c03b4\"]',2,1,'',0,'2020-12-25 14:47:43','1970-01-01 00:00:00','ee977d69700e43b083d7fc8f5e4dd471',NULL);
/*!40000 ALTER TABLE `user_paper` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_ques_result`
--

DROP TABLE IF EXISTS `user_ques_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_ques_result` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `stu_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '网校用户Id',
  `paper_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '试卷id',
  `plan_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '讲次id',
  `knowledge_id` varchar(100) NOT NULL DEFAULT '' COMMENT '内容云-应用树-知识点id',
  `nry_ques_id` varchar(32) NOT NULL DEFAULT '' COMMENT '内容云-试题id',
  `wx_ques_id` int(11) NOT NULL DEFAULT '0' COMMENT '网校-试题id',
  `ques_order` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '试题展示序号',
  `ques_type` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '试题类型:1->填空;2->选择 ',
  `user_answer` varchar(256) NOT NULL DEFAULT '' COMMENT '用户答案',
  `answer_status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '1.未曝光 2.错误 3.正确 4.跳过',
  `create_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
  `modify_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '编辑时间',
  `answer_time` varchar(15) NOT NULL DEFAULT '' COMMENT '作答总用时(毫秒)',
  `recommend_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '内容云-推荐id',
  `knowledge_name` varchar(64) NOT NULL DEFAULT '' COMMENT '知识点名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_stu_id` (`stu_id`) USING BTREE,
  KEY `idx_paper` (`paper_id`) USING BTREE,
  KEY `idx_modify_time` (`modify_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1965 DEFAULT CHARSET=utf8mb4 COMMENT='用户答题结果表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_ques_result`
--

LOCK TABLES `user_ques_result` WRITE;
/*!40000 ALTER TABLE `user_ques_result` DISABLE KEYS */;
INSERT INTO `user_ques_result` VALUES (1915,59920,1255,1125567,'e0ba89e140384f9a9e860289acc2d3bf','4ab8f9cb86984fc9a0df59826ee1c751',3445248,0,2,'',1,'2021-02-02 18:47:51','2021-02-02 18:48:08','','0542c7cef14c499a95e2ff0de675d275','功率的估计'),(1916,59920,1255,1125567,'e0ba89e140384f9a9e860289acc2d3bf','10d5bd5ef1864cd5afb3ea265aae0aaa',3443718,0,2,'',1,'2021-02-02 18:47:51','2021-02-02 18:48:08','','0542c7cef14c499a95e2ff0de675d275','功率的估计'),(1917,59920,1255,1125567,'e0ba89e140384f9a9e860289acc2d3bf','28a2a01cd7f94aafb2994c128be49a10',3445247,0,2,'',1,'2021-02-02 18:47:51','2021-02-02 18:48:08','','0542c7cef14c499a95e2ff0de675d275','功率的估计'),(1918,59920,1255,1125567,'e0ba89e140384f9a9e860289acc2d3bf','8cda84fb024e4ae9bfd4af54d1d2e4d8',3445245,0,2,'',1,'2021-02-02 18:47:51','2021-02-02 18:48:08','','0542c7cef14c499a95e2ff0de675d275','功率的估计'),(1919,59920,1255,1125567,'e0ba89e140384f9a9e860289acc2d3bf','7ddc8fa72e564d528678cd586bc453f8',3445250,0,2,'',1,'2021-02-02 18:47:51','2021-02-02 18:48:08','','0542c7cef14c499a95e2ff0de675d275','功率的估计'),(1960,2422275,48,673080,'64a9ce24fb574a6dbd7fe3522e49ff41','bfeb18002ee14db69ccd769c62b3f5cd',3441952,0,2,'',1,'2020-12-29 18:32:20','1970-01-01 00:00:00','','beae8331975649779970a43b4496b700','分数'),(1961,2422275,48,673080,'64a9ce24fb574a6dbd7fe3522e49ff41','bfeb18002ee14db69ccd769c62b3f5cd',3441952,0,2,'',1,'2020-12-29 18:32:20','1970-01-01 00:00:00','','beae8331975649779970a43b4496b700','分数'),(1962,2422275,48,673080,'64a9ce24fb574a6dbd7fe3522e49ff41','bfeb18002ee14db69ccd769c62b3f5cd',3441952,0,2,'',1,'2020-12-29 18:32:20','1970-01-01 00:00:00','','beae8331975649779970a43b4496b700','分数'),(1963,2422275,48,673080,'64a9ce24fb574a6dbd7fe3522e49ff41','bfeb18002ee14db69ccd769c62b3f5cd',3441952,0,2,'',1,'2020-12-29 18:32:20','1970-01-01 00:00:00','','beae8331975649779970a43b4496b700','分数'),(1964,2422275,48,673080,'64a9ce24fb574a6dbd7fe3522e49ff41','bfeb18002ee14db69ccd769c62b3f5cd',3441952,0,2,'',1,'2020-12-29 18:32:20','1970-01-01 00:00:00','','beae8331975649779970a43b4496b700','分数');
/*!40000 ALTER TABLE `user_ques_result` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-02-07 15:03:08
