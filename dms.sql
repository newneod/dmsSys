/*
 Navicat Premium Data Transfer

 Source Server         : 121.40.133.157
 Source Server Type    : MySQL
 Source Server Version : 50615
 Source Host           : 121.40.133.157:3306
 Source Schema         : dms

 Target Server Type    : MySQL
 Target Server Version : 50615
 File Encoding         : 65001

 Date: 30/05/2018 15:03:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for api_auth_manage
-- ----------------------------
DROP TABLE IF EXISTS `api_auth_manage`;
CREATE TABLE `api_auth_manage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `api_auth_type` int(11) DEFAULT NULL COMMENT '0:none,1:sap,2:token,2:rsa',
  `api_auth_uname` varchar(20) DEFAULT NULL COMMENT '用户名    ',
  `api_auth_pwd` varchar(20) DEFAULT NULL COMMENT '密码',
  `api_auth_sap_sysnr` char(10) DEFAULT NULL COMMENT 'api 系统编号 实例编号',
  `api_auth_sap_client` char(10) DEFAULT NULL COMMENT '分配的 sap client 编号',
  `api_auth_time` int(11) DEFAULT '0' COMMENT 'token 有效期 单位s ,0为永久有效',
  `api_auth_rsa` text COMMENT '分配私钥私钥',
  `createtime` int(11) DEFAULT NULL,
  `updatetime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for api_list
-- ----------------------------
DROP TABLE IF EXISTS `api_list`;
CREATE TABLE `api_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) DEFAULT NULL COMMENT '对应模块id',
  `api_name` varchar(255) DEFAULT NULL COMMENT '接口名',
  `api_type` tinyint(2) DEFAULT NULL COMMENT 'API类型, 1:外部调用,2:获取token',
  `api_status` int(1) DEFAULT '1' COMMENT '状态 0:不可用,1:可用',
  `api_alias` char(20) DEFAULT NULL COMMENT 'api_别名,内部接口调用使用',
  `api_method` tinyint(2) DEFAULT NULL COMMENT '1:POST,2:GET,3:DELETE,4:PUT,5:HEAD',
  `createimte` int(11) DEFAULT NULL,
  `updatetime` int(11) DEFAULT NULL,
  `operator_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for api_module_config
-- ----------------------------
DROP TABLE IF EXISTS `api_module_config`;
CREATE TABLE `api_module_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_type` int(11) DEFAULT NULL COMMENT 'api mouble 类型,1:360,2:sap',
  `module_status` int(1) DEFAULT NULL COMMENT '模块状态: 0不可用,1:可用',
  `module_name` varchar(255) DEFAULT NULL,
  `module_host` varchar(255) DEFAULT NULL COMMENT '接口host, sap 为接口ip或域名，http 为baseurl',
  `module_auth_id` int(11) DEFAULT NULL COMMENT '接口验证方式id',
  `module_sap_lang` varchar(10) DEFAULT 'EN' COMMENT 'sap 语言 ',
  `createtime` int(11) DEFAULT NULL,
  `updatetime` int(11) DEFAULT NULL,
  `operator_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for api_param
-- ----------------------------
DROP TABLE IF EXISTS `api_param`;
CREATE TABLE `api_param` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `api_id` int(11) DEFAULT NULL COMMENT '对应的api id',
  `api_param_type` int(1) DEFAULT NULL COMMENT '参数结构类型 (sap 专用) 0:none,1:import,2:export,3:changing',
  `api_param_val_type` int(11) DEFAULT NULL COMMENT '1:table (json 数组) ,2:structure (json 对象),3:string,4:int',
  `api_param_name` char(20) DEFAULT NULL COMMENT '参数名 api_param_val_type 为1,2 时可以为空',
  `api_param_status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '0不可用，1可用',
  `creaetime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for api_record
-- ----------------------------
DROP TABLE IF EXISTS `api_record`;
CREATE TABLE `api_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `api_id` int(11) DEFAULT NULL COMMENT '接口id',
  `record_api_name` varchar(100) DEFAULT NULL COMMENT '接口名',
  `record_api_host` varchar(255) DEFAULT NULL,
  `record_api_param` text,
  `record_api_result` text,
  `record_api_auth` char(10) DEFAULT NULL,
  `record_api_status` tinyint(2) DEFAULT NULL COMMENT '状态  1，正在执行; 2，执行成功; 3,执行失败;',
  `record_origin` char(20) DEFAULT NULL COMMENT '记录来源',
  `createtime` int(11) DEFAULT NULL,
  `updatetime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for api_result_param
-- ----------------------------
DROP TABLE IF EXISTS `api_result_param`;
CREATE TABLE `api_result_param` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `api_id` int(11) DEFAULT NULL,
  `api_result_valtype` int(10) DEFAULT NULL COMMENT '1:table (json 数组) ,2:structure (json 对象),3:string,4:int',
  `api_result_name` varchar(20) DEFAULT NULL,
  `api_result_status` tinyint(2) DEFAULT '1' COMMENT '1,启用 2:废弃',
  `createtime` int(11) DEFAULT NULL,
  `updatetime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for as_auto_audit
-- ----------------------------
DROP TABLE IF EXISTS `as_auto_audit`;
CREATE TABLE `as_auto_audit` (
  `auto_audit_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `auto_audit_name` varchar(20) NOT NULL COMMENT '规则名称',
  `auto_audit_type` tinyint(1) NOT NULL COMMENT '规则类型 1-金额判断 ,2=索赔类型',
  `auto_audit_amount` decimal(8,5) NOT NULL COMMENT '金额',
  `claim_type` tinyint(1) NOT NULL COMMENT '索赔类型：1=首保，2=三包',
  `warranty_services_id` int(10) unsigned NOT NULL COMMENT '三包配置ID',
  `auto_audit_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`auto_audit_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='自动审核规则';

-- ----------------------------
-- Table structure for as_claim
-- ----------------------------
DROP TABLE IF EXISTS `as_claim`;
CREATE TABLE `as_claim` (
  `claim_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '索赔单id',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `claim_code` char(12) NOT NULL COMMENT '索赔单编号',
  `repair_code` char(12) NOT NULL COMMENT '维修单编号',
  `claim_type` tinyint(1) unsigned NOT NULL COMMENT '索赔类型：1=首保，2=三包',
  `claim_need_translate` tinyint(1) unsigned NOT NULL COMMENT '是否需要旧件回运',
  `claim_amount` decimal(8,5) unsigned NOT NULL COMMENT '金额',
  `claim_remark` varchar(128) DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`claim_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='索赔单';

-- ----------------------------
-- Table structure for as_claim_detail
-- ----------------------------
DROP TABLE IF EXISTS `as_claim_detail`;
CREATE TABLE `as_claim_detail` (
  `claim_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `claim_id` int(10) unsigned NOT NULL COMMENT '索赔单ID',
  `repair_code` char(12) NOT NULL COMMENT '维修单编号',
  `repair_detail_id` int(10) unsigned NOT NULL COMMENT '维修明细单id',
  `claim_detail_type` tinyint(1) unsigned NOT NULL COMMENT '接单类型：1=维修项目，2=物料',
  `claim_detail_code` char(10) NOT NULL COMMENT '编号（维修项目 | 物料编号）',
  `claim_detail_name` varchar(20) NOT NULL COMMENT '名称（维修项目 | 物料编号）',
  `claim_detail_amount` decimal(8,5) unsigned NOT NULL COMMENT '所需数量/工时（维修项目 | 物料编号）',
  `claim_detail_price` decimal(8,5) unsigned NOT NULL COMMENT '所需单价（维修项目 | 物料编号）',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`claim_detail_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='索赔单明细';

-- ----------------------------
-- Table structure for as_dispatching
-- ----------------------------
DROP TABLE IF EXISTS `as_dispatching`;
CREATE TABLE `as_dispatching` (
  `dispatching_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '派工单ID',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `dispatching_code` char(12) NOT NULL COMMENT '派工单编号',
  `repair_code` char(12) NOT NULL COMMENT '维修单编号',
  `user_code` char(10) NOT NULL COMMENT '责任技师',
  `dispatching_expect_begin_time` int(10) unsigned NOT NULL COMMENT '期望开工时间',
  `dispatching_expect_end_time` int(10) unsigned NOT NULL COMMENT '期望完工时间',
  `dispatching_actual_begin_time` int(10) unsigned NOT NULL COMMENT '实际开工时间',
  `dispatching_actual_end_time` int(10) unsigned NOT NULL COMMENT '实际完工时间',
  `dispatching_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`dispatching_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='派工单';

-- ----------------------------
-- Table structure for as_dispatching_detail
-- ----------------------------
DROP TABLE IF EXISTS `as_dispatching_detail`;
CREATE TABLE `as_dispatching_detail` (
  `dispatching_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '派工单明细ID',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `dispatching_id` int(10) unsigned NOT NULL COMMENT '派工单ID',
  `repair_code` char(12) NOT NULL COMMENT '维修单编号',
  `repair_detail_id` int(10) unsigned NOT NULL COMMENT '维修单明细id',
  `repair_type_id` int(10) unsigned NOT NULL COMMENT '维修类型id',
  `user_code` char(10) NOT NULL COMMENT '责任技师',
  `dispatching_detail_work_type` tinyint(10) unsigned NOT NULL COMMENT '工单类型:1=保险,2=客户付费,3=索赔,4=内部修理，5=其他',
  `dispatching_detail_type` tinyint(1) unsigned NOT NULL COMMENT '接单类型：1=维修项目，2=物料',
  `dispatching_detail_code` char(10) NOT NULL COMMENT '编号（维修项目 | 物料编号）待确定',
  `dispatching_detail_name` varchar(20) NOT NULL COMMENT '名称（维修项目 | 物料编号）',
  `dispatching_detail_amount` decimal(8,5) NOT NULL DEFAULT '0.00000' COMMENT '所需数量/工时（维修项目 | 物料编号）',
  `dispatching_detail_price` decimal(8,5) NOT NULL DEFAULT '0.00000' COMMENT '所需单价（维修项目 | 物料编号）',
  `dispatching_detail_expect_begin_time` int(10) unsigned NOT NULL COMMENT '期望开工时间',
  `dispatching_detail_expect_end_time` int(10) unsigned NOT NULL COMMENT '期望完工时间',
  `dispatching_detail_actual_begin_time` int(10) unsigned NOT NULL COMMENT '实际开工时间',
  `dispatching_detail_actual_end_time` int(10) unsigned NOT NULL COMMENT '实际完工时间',
  `create_user` char(10) NOT NULL DEFAULT '' COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `modify_user` char(10) NOT NULL DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`dispatching_detail_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='派工单明细';

-- ----------------------------
-- Table structure for as_maintenance_item
-- ----------------------------
DROP TABLE IF EXISTS `as_maintenance_item`;
CREATE TABLE `as_maintenance_item` (
  `maintenance_item_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '维修项目ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `maintenance_item_code` char(8) NOT NULL DEFAULT '' COMMENT '维修项目编号',
  `maintenance_item_ref_id` int(11) unsigned NOT NULL COMMENT '关联维修项目ID',
  `maintenance_item_name` varchar(64) NOT NULL DEFAULT '' COMMENT '项目名称',
  `maintenance_item_hour` decimal(8,5) unsigned NOT NULL COMMENT '项目标准工时',
  `maintenance_item_price` decimal(8,5) unsigned NOT NULL COMMENT '项目工时单价',
  `maintenance_item_custom_price` decimal(8,5) unsigned NOT NULL COMMENT '项目自定义工时单价',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(11) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`maintenance_item_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='维修项目';

-- ----------------------------
-- Table structure for as_repair
-- ----------------------------
DROP TABLE IF EXISTS `as_repair`;
CREATE TABLE `as_repair` (
  `repair_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `repair_code` char(12) NOT NULL COMMENT '维修单编号',
  `repair_plate_number` varchar(8) NOT NULL COMMENT '车牌号',
  `repair_plate_vin` char(17) NOT NULL COMMENT '车架号',
  `repair_repair_mileage` int(10) unsigned NOT NULL COMMENT '最近公里数',
  `repair_expect_begin_time` int(10) unsigned NOT NULL COMMENT '期望开工时间',
  `repair_expect_end_time` int(10) unsigned NOT NULL COMMENT '期望完工时间',
  `repair_actual_begin_time` int(10) unsigned NOT NULL COMMENT '实际开工时间',
  `repair_actual_end_time` int(10) unsigned NOT NULL COMMENT '实际完工时间',
  `repair_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`repair_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='维修单';

-- ----------------------------
-- Table structure for as_repair_detail
-- ----------------------------
DROP TABLE IF EXISTS `as_repair_detail`;
CREATE TABLE `as_repair_detail` (
  `repair_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `repair_order_id` int(10) unsigned NOT NULL COMMENT '对应的维修单id',
  `dispatch_detail_work_type` tinyint(10) unsigned NOT NULL COMMENT '工单类型:1=保险,2=客户付费,3=索赔,4=内部修理，5=其他',
  `repair_detail_type` tinyint(1) unsigned NOT NULL COMMENT '接单类型：1=维修项目，2=物料',
  `repair_detail_code` char(10) NOT NULL COMMENT '编号（维修项目 | 物料编号）待定',
  `repair_detail_name` varchar(64) NOT NULL DEFAULT '' COMMENT '名称（维修项目 | 物料编号）待定',
  `repair_detail_amount` decimal(8,5) NOT NULL DEFAULT '0.00000' COMMENT '所需数量/工时（维修项目 | 物料编号）',
  `repair_detail_price` decimal(8,5) NOT NULL DEFAULT '0.00000' COMMENT '所需单价（维修项目 | 物料编号）',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`repair_detail_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='维修单明细';

-- ----------------------------
-- Table structure for as_repair_type
-- ----------------------------
DROP TABLE IF EXISTS `as_repair_type`;
CREATE TABLE `as_repair_type` (
  `repair_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '维修类型ID',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `repair_type_name` varchar(20) NOT NULL COMMENT '维修类型名称',
  `repair_type_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态：1=正常 2=禁用',
  `repair_type_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户 编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`repair_type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='维修类型';

-- ----------------------------
-- Table structure for as_reservation
-- ----------------------------
DROP TABLE IF EXISTS `as_reservation`;
CREATE TABLE `as_reservation` (
  `reservation_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '预约单ID',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `reservation_type_id` int(11) unsigned NOT NULL COMMENT '预约方式ID',
  `vin` varchar(20) NOT NULL COMMENT '车架号',
  `reservation_plate_number` varchar(8) NOT NULL COMMENT '车牌号',
  `reservation_arrivedate` int(10) unsigned NOT NULL COMMENT '到店日期',
  `reservation_arrivetime` char(11) NOT NULL DEFAULT '' COMMENT '到店时间',
  `reservation_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '到店状态 0=未到店，1=已转修(已到店，维修中)，2=已竣工， 3=已作废',
  `reservation_mileage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '送修里程',
  `reservation_maintain_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '送修时间（进厂时间、开单日期，转修时间）',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`reservation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='预约单';

-- ----------------------------
-- Table structure for as_reservation_period
-- ----------------------------
DROP TABLE IF EXISTS `as_reservation_period`;
CREATE TABLE `as_reservation_period` (
  `reservation_period_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `company_code` char(5) NOT NULL DEFAULT '' COMMENT '帐套',
  `customer_code` char(8) NOT NULL DEFAULT '' COMMENT '客户编号',
  `reservation_period_start_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '开始时间段',
  `reservation_period_end_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '结束时间',
  `reservation_period_weekday_number` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '周内工位',
  `reservation_period_weekend_number` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '周末工位',
  `reservation_period_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '显示状态：1=正常，2=禁用',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`reservation_period_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='预约工位配置表';

-- ----------------------------
-- Table structure for as_reservation_type
-- ----------------------------
DROP TABLE IF EXISTS `as_reservation_type`;
CREATE TABLE `as_reservation_type` (
  `reservation_type_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '类型ID',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `reservation_type_name` varchar(32) NOT NULL COMMENT '预约类型名称',
  `reservation_type_status` tinyint(1) unsigned NOT NULL COMMENT '状态：1=正常 2=禁用',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`reservation_type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='预约类型表';

-- ----------------------------
-- Table structure for as_technical_report
-- ----------------------------
DROP TABLE IF EXISTS `as_technical_report`;
CREATE TABLE `as_technical_report` (
  `technical_report_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '技术报告ID',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `claim_id` int(10) unsigned NOT NULL COMMENT '索赔单id',
  `claim_detail_id` int(10) unsigned NOT NULL COMMENT '索赔单明细id',
  `technical_report_user_code` char(10) NOT NULL COMMENT '技术报告用户编号',
  `technical_report_desc` text NOT NULL COMMENT '工单描述',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`technical_report_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='技术报告';

-- ----------------------------
-- Table structure for as_warranty_services
-- ----------------------------
DROP TABLE IF EXISTS `as_warranty_services`;
CREATE TABLE `as_warranty_services` (
  `warranty_services_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_code` char(5) NOT NULL COMMENT '帐套',
  `warranty_services_name` varchar(20) NOT NULL COMMENT '规则名称',
  `warranty_services_rule` varchar(256) NOT NULL COMMENT '规则细则',
  `meterial_code` varchar(30) NOT NULL COMMENT '物料编号',
  `warranty_services_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`warranty_services_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='三包规则(废弃)';

-- ----------------------------
-- Table structure for base_batch_mgr
-- ----------------------------
DROP TABLE IF EXISTS `base_batch_mgr`;
CREATE TABLE `base_batch_mgr` (
  `batch_mgr_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '批次ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `batch_mgr_code` varchar(30) NOT NULL COMMENT '批次编号',
  `batch_mgr_prod_time` int(10) unsigned NOT NULL COMMENT '生产日期',
  `batch_mgr_expir_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '过期日期',
  `batch_mgr_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废 4-过期',
  `batch_mgr_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`batch_mgr_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='批次管理表';

-- ----------------------------
-- Records of base_batch_mgr
-- ----------------------------
BEGIN;
INSERT INTO `base_batch_mgr` VALUES (1, 'tiger', '33', 0, 1526525493, 1, '', '', 0, '', 0);
INSERT INTO `base_batch_mgr` VALUES (2, 'tiger', '22', 0, 1526525493, 1, '', '', 0, '', 0);
INSERT INTO `base_batch_mgr` VALUES (3, 'tiger', '11112', 2017, 2019, 1, 'xiaocai', 'tiger', 1526609820, 'tiger', 1526609887);
COMMIT;

-- ----------------------------
-- Table structure for base_cargo_space
-- ----------------------------
DROP TABLE IF EXISTS `base_cargo_space`;
CREATE TABLE `base_cargo_space` (
  `cargo_space_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '货位ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `warehouse_code` char(10) NOT NULL COMMENT '仓库编号',
  `warehouse_space_code` char(20) NOT NULL COMMENT '仓位编号',
  `cargo_space_code` char(20) NOT NULL COMMENT '货位编号',
  `cargo_space_name` varchar(45) NOT NULL COMMENT '货位名称',
  `cargo_space_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
  `cargo_space_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `cargo_space_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`cargo_space_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='货位表';

-- ----------------------------
-- Records of base_cargo_space
-- ----------------------------
BEGIN;
INSERT INTO `base_cargo_space` VALUES (1, 'lijix', '1234567890', 'ckceshi001', 'huowei001', 'dsd', 'asasd', 1, '货位弃用', 'lijinxing', 1527477587, 'lijinxing', 1527492407);
COMMIT;

-- ----------------------------
-- Table structure for base_color
-- ----------------------------
DROP TABLE IF EXISTS `base_color`;
CREATE TABLE `base_color` (
  `color_id` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT COMMENT '颜色ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `color_name` varchar(30) NOT NULL COMMENT '颜色名称',
  `color_hex` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '颜色hex值,RGB大端存储',
  `color_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `color_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`color_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='颜色表';

-- ----------------------------
-- Records of base_color
-- ----------------------------
BEGIN;
INSERT INTO `base_color` VALUES (0000000001, 'tiger', '红色', 129, 3, 'sdswes', 'tiger', 1526611178, 'tiger', 1526611385);
INSERT INTO `base_color` VALUES (0000000002, 'tiger', '红色', 128, 1, '', 'tiger', 1526611353, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for base_fund_usage
-- ----------------------------
DROP TABLE IF EXISTS `base_fund_usage`;
CREATE TABLE `base_fund_usage` (
  `fund_usage_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '资金用途ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `fund_usage_name` varchar(45) NOT NULL COMMENT '资金用途名称',
  `fund_usage_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '业务类型 0-通用（经销商） 1-整车 2-备件 3-保证金（销售公司）',
  `fund_usage_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '资金用途状态 1-启用,2-停用,3-废弃',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号(初始值使用创建人)',
  `modify_time` int(11) unsigned NOT NULL COMMENT '修改时间 (初始值使用创建时间)',
  PRIMARY KEY (`fund_usage_id`),
  KEY `idx_company_code` (`company_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='资金用途表';

-- ----------------------------
-- Records of base_fund_usage
-- ----------------------------
BEGIN;
INSERT INTO `base_fund_usage` VALUES (1, '4s001', '整车款', 0, 1, '4s001caiwu', 1527126166, '4s001caiwu', 1527126166);
INSERT INTO `base_fund_usage` VALUES (2, '4s001', '维修款', 0, 1, '4s001caiwu', 1527126174, '4s001caiwu', 1527126174);
INSERT INTO `base_fund_usage` VALUES (3, '4s001', '保养款', 0, 1, '4s001caiwu', 1527126180, '4s001caiwu', 1527126180);
INSERT INTO `base_fund_usage` VALUES (4, '4s001', '保险费', 0, 1, '4s001caiwu', 1527126195, '4s001caiwu', 1527490626);
INSERT INTO `base_fund_usage` VALUES (5, 'gs001', '整车款', 1, 1, '4s001caiwu', 1527128230, '4s001caiwu', 1527128230);
INSERT INTO `base_fund_usage` VALUES (6, 'gs001', '备件款', 2, 1, '4s001caiwu', 1527128230, '4s001caiwu', 1527128230);
INSERT INTO `base_fund_usage` VALUES (7, 'gs001', '保证金', 3, 1, '4s001caiwu', 1527128230, '4s001caiwu', 1527128230);
INSERT INTO `base_fund_usage` VALUES (9, '4s001', '保险费', 0, 3, '4s001caiwu', 1527144801, '4s001caiwu', 1527490608);
INSERT INTO `base_fund_usage` VALUES (10, 'sy001', '整车采购', 1, 1, '', 0, '', 0);
INSERT INTO `base_fund_usage` VALUES (11, '4s001', '咨询费', 0, 1, '4s001caiwu', 1527489955, '4s001caiwu', 1527489955);
COMMIT;

-- ----------------------------
-- Table structure for base_inventory
-- ----------------------------
DROP TABLE IF EXISTS `base_inventory`;
CREATE TABLE `base_inventory` (
  `inventory_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '库存ID',
  `company_code` char(5) NOT NULL DEFAULT '' COMMENT '账套',
  `meterial_code` varchar(30) NOT NULL DEFAULT '' COMMENT '物料编号',
  `warehouse_code` char(10) NOT NULL DEFAULT '' COMMENT '仓库编号',
  `warehouse_space_code` char(20) NOT NULL DEFAULT '' COMMENT '仓位编号',
  `cargo_space_code` char(20) NOT NULL DEFAULT '' COMMENT '货位编号',
  `meterial_trace_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否批次管理 0-无 1-批次号管理 2-序列号管理',
  `batch_mgr_code` char(10) NOT NULL DEFAULT '' COMMENT '批次编号',
  `seq_code` varchar(20) NOT NULL DEFAULT '' COMMENT '序列编号',
  `inventory_real_quantity` decimal(13,5) NOT NULL DEFAULT '0.00000' COMMENT '现有量',
  `inventory_ordered_quantity` decimal(13,5) NOT NULL DEFAULT '0.00000' COMMENT '已订购',
  `inventory_reserved_quantity` decimal(13,5) NOT NULL DEFAULT '0.00000' COMMENT '预留',
  `inventory_on_order_quantity` decimal(13,5) NOT NULL DEFAULT '0.00000' COMMENT '待发',
  `inventory_on_road_quantity` decimal(13,5) NOT NULL DEFAULT '0.00000' COMMENT '在途',
  `inventory_real_available_quantity` decimal(13,5) NOT NULL DEFAULT '0.00000' COMMENT '实际可用',
  `inventory_reserved_available_quantity` decimal(13,5) NOT NULL DEFAULT '0.00000' COMMENT '备货可用',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`inventory_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='库存现有量表';

-- ----------------------------
-- Records of base_inventory
-- ----------------------------
BEGIN;
INSERT INTO `base_inventory` VALUES (1, 'tiger', 'a', '', '', '', 0, '', 'a', 1.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.00000, '', 0, 'tiger', 1527220836);
INSERT INTO `base_inventory` VALUES (4, 'tiger', 'b', '', '', '', 0, '', 'b', 1.00000, 1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.00000, '', 0, 'tiger', 1527220836);
INSERT INTO `base_inventory` VALUES (6, 'sy', 'mc001', 'wc001', 'wpc001', 'csc001', 1, 'pc001', '', 100.00000, 0.00000, 0.00000, 0.00000, 0.00000, 100.00000, 0.00000, '', 0, '', 0);
INSERT INTO `base_inventory` VALUES (7, 'sy', 'mc001', 'wc001', 'wpc001', 'csc001', 1, 'pc002', '', 100.00000, 0.00000, 0.00000, 0.00000, 0.00000, 100.00000, 0.00000, '', 0, '', 0);
INSERT INTO `base_inventory` VALUES (8, 'sy', 'mc001', 'wc001', 'wpc001', 'csc001', 1, 'pc003', '', 100.00000, 0.00000, 0.00000, 0.00000, 0.00000, 100.00000, 0.00000, '', 0, '', 0);
INSERT INTO `base_inventory` VALUES (9, 'sy', 'mc010', 'wc010', 'wpc010', 'csc010', 2, '', 'sc001', 1.00000, 0.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.00000, '', 0, '', 0);
INSERT INTO `base_inventory` VALUES (10, 'sy', 'mc010', 'wc010', 'wpc010', 'csc010', 2, '', 'sc002', 1.00000, 0.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.00000, '', 0, '', 0);
INSERT INTO `base_inventory` VALUES (11, 'sy', 'mc010', 'wc010', 'wpc010', 'csc010', 2, '', 'sc003', 1.00000, 0.00000, 0.00000, 0.00000, 0.00000, 1.00000, 0.00000, '', 0, '', 0);
INSERT INTO `base_inventory` VALUES (12, 'tiger', 'WL003', 'wc002', 'wpc001', 'csc001', 1, 'pc001', '', 30.00000, 0.00000, 0.00000, 20.00000, 0.00000, 10.00000, 0.00000, 'bkh', 1527323337, '', 0);
INSERT INTO `base_inventory` VALUES (13, 'tiger', 'WL004', 'wc002', 'wpc001', 'csc002', 1, 'pc001', '', 10.00000, 0.00000, 0.00000, 10.00000, 0.00000, 0.00000, 0.00000, 'bkh', 1527323345, '', 0);
INSERT INTO `base_inventory` VALUES (37, 'lijix', '1111', '', '', '', 0, '1', '', 6.00000, 0.00000, 0.00000, 0.00000, 0.00000, 6.00000, 0.00000, 'ljx', 1527325609, 'ljx', 1527326985);
INSERT INTO `base_inventory` VALUES (40, 'sy001', 'WL0003', '', '', '', 0, '', '', 0.00000, 30.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, '', 0, '', 0);
INSERT INTO `base_inventory` VALUES (41, 'sy001', 'WL0001', 'wc001', 'wsc001', 'csc001', 2, '', 'sc001', 1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.00000, 'sy', 1555555555, '', 0);
INSERT INTO `base_inventory` VALUES (42, 'sy001', 'WL0001', 'wc001', 'wsc001', 'csc001', 2, '', 'sc002', 1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.00000, 'sy', 1424242444, '', 0);
INSERT INTO `base_inventory` VALUES (43, 'sy001', 'WL0002', 'wc001', 'wsc001', 'csc002', 2, '', 'sc010', 1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.00000, 'sy', 1424242424, '', 0);
INSERT INTO `base_inventory` VALUES (44, 'sy001', 'WL0002', 'wc001', 'wsc001', 'csc002', 2, '', 'sc011', 1.00000, 0.00000, 0.00000, 1.00000, 0.00000, 0.00000, 0.00000, 'sy', 1424242424, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for base_inventory_safe_limit
-- ----------------------------
DROP TABLE IF EXISTS `base_inventory_safe_limit`;
CREATE TABLE `base_inventory_safe_limit` (
  `inventory_id` int(10) unsigned NOT NULL COMMENT '库存ID',
  `company_code` char(5) NOT NULL DEFAULT '' COMMENT '账套',
  `material_code` varchar(30) NOT NULL DEFAULT '' COMMENT '物料编号',
  `inventory_max_quantity` decimal(13,5) unsigned NOT NULL COMMENT '库存上限',
  `inventory_min_quantity` decimal(13,5) unsigned NOT NULL COMMENT '库存下限',
  `inventory_check_start` int(10) unsigned NOT NULL COMMENT '检查起始时间',
  `inventory_check_end` int(10) unsigned NOT NULL COMMENT '检查结束时间',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`inventory_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='库存安全阀值表';

-- ----------------------------
-- Records of base_inventory_safe_limit
-- ----------------------------
BEGIN;
INSERT INTO `base_inventory_safe_limit` VALUES (1, '1', 'a', 20.00000, 10.00000, 1520000000, 1530000000, 'nzw', 1525000000, '', 0);
INSERT INTO `base_inventory_safe_limit` VALUES (2, '1', 'b', 1.00000, 4.00000, 1520000000, 1530000000, 'nzw', 1525000000, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for base_material_category
-- ----------------------------
DROP TABLE IF EXISTS `base_material_category`;
CREATE TABLE `base_material_category` (
  `material_category_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '物料分类ID',
  `company_code` char(5) NOT NULL DEFAULT '' COMMENT '账套',
  `material_category_pid` int(11) unsigned NOT NULL COMMENT '分类父ID',
  `material_category_name` varchar(45) NOT NULL DEFAULT '' COMMENT '分类名称',
  `material_category_mark` varchar(64) NOT NULL DEFAULT '' COMMENT '分类说明',
  `material_category_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `material_category_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`material_category_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='物料分类表';

-- ----------------------------
-- Records of base_material_category
-- ----------------------------
BEGIN;
INSERT INTO `base_material_category` VALUES (1, 'lijix', 0, '测试', '这是来测试', '测试作废', 1, 'lijinxing', 1527498448, 'lijinxing', 1527500053);
INSERT INTO `base_material_category` VALUES (2, 'lijix', 1, '测试11', '这是来测试1', '测试作废', 1, 'lijinxing', 1527498633, 'lijinxing', 1527500050);
INSERT INTO `base_material_category` VALUES (3, 'lijix', 2, '测试112', '这是来测试1', '测试作废', 1, 'lijinxing', 1527498647, 'lijinxing', 1527499937);
COMMIT;

-- ----------------------------
-- Table structure for base_material_price
-- ----------------------------
DROP TABLE IF EXISTS `base_material_price`;
CREATE TABLE `base_material_price` (
  `material_price_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '物料价格ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `supplier_code` char(10) NOT NULL COMMENT '供应商编号',
  `material_code` varchar(40) NOT NULL COMMENT '物料编号',
  `material_price_purchase` decimal(8,5) NOT NULL COMMENT '采购价格',
  `material_price_market` decimal(8,5) NOT NULL COMMENT '市场价格',
  `material_price_sale` decimal(8,5) NOT NULL COMMENT '当前销售价格',
  `material_price_status` tinyint(1) unsigned NOT NULL COMMENT '状态 0-停用 1-启用 2-作废',
  `material_price_start_time` int(10) unsigned NOT NULL COMMENT '有效期开始时间',
  `material_price_end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '有效期结束时间  0 表示永久有效',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`material_price_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物料价格表';

-- ----------------------------
-- Table structure for base_meterial
-- ----------------------------
DROP TABLE IF EXISTS `base_meterial`;
CREATE TABLE `base_meterial` (
  `meterial_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '物料ID',
  `meterial_code` varchar(40) NOT NULL COMMENT '物料编号',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `meterial_prod_code` varchar(45) NOT NULL COMMENT '生产物料编号 SAP编号',
  `meterial_name` varchar(45) NOT NULL COMMENT '名称',
  `meterial_weight` decimal(8,5) unsigned NOT NULL DEFAULT '0.00000' COMMENT '重量',
  `meterial_volume` decimal(8,5) unsigned NOT NULL DEFAULT '0.00000' COMMENT '体积',
  `color_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '物料颜色ID',
  `color_name` varchar(30) NOT NULL DEFAULT '' COMMENT '颜色名称',
  `meterial_series` varchar(45) NOT NULL DEFAULT '' COMMENT '车系',
  `meterial_model` varchar(45) NOT NULL DEFAULT '' COMMENT '车型',
  `meterial_figure_code` varchar(30) NOT NULL DEFAULT '' COMMENT '图号',
  `meterial_status` tinyint(1) unsigned zerofill NOT NULL DEFAULT '0' COMMENT '状态(枚举) 0-正常 1-停产',
  `meterial_category_id` int(11) unsigned NOT NULL COMMENT '物料分类',
  `meterial_purchase_warehouse` char(10) NOT NULL COMMENT '默认采购仓库',
  `meterial_sell_warehouse_code` char(10) NOT NULL COMMENT '默认销售仓库',
  `meterial_inventory_warehouse_code` char(10) NOT NULL COMMENT '默认库存仓库',
  `meterial_unit_id` int(10) unsigned NOT NULL COMMENT '计量单位',
  `meterial_unit_name` varchar(45) NOT NULL DEFAULT '' COMMENT '单位名称',
  `meterial_purchasing_cycle` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '采购周期天',
  `meterial_production_cycle` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '生产周期天',
  `meterial_trace_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0 - 无， 1- 批次管理， 2- 序列管理',
  `meterial_is_vehicle` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否为整车  0- 否  1-是',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`meterial_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='物料表';

-- ----------------------------
-- Records of base_meterial
-- ----------------------------
BEGIN;
INSERT INTO `base_meterial` VALUES (1, '222222222', '', '', '', 0.00000, 0.00000, 0, '', '', '', '', 0, 0, '', '', '', 0, '', 0, 0, 0, 0, '', 0, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for base_meterial_record
-- ----------------------------
DROP TABLE IF EXISTS `base_meterial_record`;
CREATE TABLE `base_meterial_record` (
  `meterial_record_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '物料交易记录ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `meterial_code` varchar(30) NOT NULL COMMENT '物料编号',
  `batch_mgr_code` varchar(20) NOT NULL DEFAULT '' COMMENT '批次编号',
  `seq_code` varchar(20) NOT NULL DEFAULT '' COMMENT '序列编号',
  `seq_type_id` tinyint(1) unsigned NOT NULL COMMENT '来源单据类型',
  `meterial_record_src_code` char(12) NOT NULL DEFAULT '' COMMENT '来源单据编号',
  `meterial_record_status` tinyint(1) unsigned NOT NULL COMMENT '销售单据状态 1-已订购 2-预留 3-待发 4-在途 5-已出货',
  `meterial_record_io_time` int(10) unsigned NOT NULL COMMENT '实际出入库日期',
  `meterial_record_finance_time` int(10) unsigned NOT NULL COMMENT '财务开票日期',
  `meterial_record_line_id` bigint(20) unsigned NOT NULL COMMENT '来源单据行号',
  `meterial_record_quantity` decimal(8,5) NOT NULL COMMENT '出入库数量',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`meterial_record_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='物料交易记录';

-- ----------------------------
-- Records of base_meterial_record
-- ----------------------------
BEGIN;
INSERT INTO `base_meterial_record` VALUES (59, 'tiger', 'a', '', 'a', 0, '', 4, 0, 0, 0, 1.00000, 'tiger', 1527220835, '', 0);
INSERT INTO `base_meterial_record` VALUES (60, 'tiger', 'b', '', 'b', 0, '', 4, 0, 0, 0, 1.00000, 'tiger', 1527220835, '', 0);
INSERT INTO `base_meterial_record` VALUES (65, 'lijix', '1111', '1', '', 6, 'CR18050073', 5, 1527325609, 0, 0, 1.00000, 'ljx', 1527325609, '', 0);
INSERT INTO `base_meterial_record` VALUES (66, 'lijix', '1111', '1', '', 6, 'CR18050073', 5, 1527325609, 0, 0, 1.00000, 'ljx', 1527325609, '', 0);
INSERT INTO `base_meterial_record` VALUES (67, 'sy001', 'WL0001', '', '', 3, 'XS18050027', 1, 0, 0, 0, 11.00000, 'sy', 1527326693, '', 0);
INSERT INTO `base_meterial_record` VALUES (68, 'sy001', 'WL0002', '', '', 3, 'XS18050027', 1, 0, 0, 0, 12.00000, 'sy', 1527326693, '', 0);
INSERT INTO `base_meterial_record` VALUES (69, 'sy001', 'WL0003', '', '', 3, 'XS18050027', 1, 0, 0, 0, 10.00000, 'sy', 1527326693, '', 0);
INSERT INTO `base_meterial_record` VALUES (70, 'lijix', '1111', '1', '', 6, 'CR18050080', 5, 1527326883, 0, 0, 1.00000, 'ljx', 1527326883, '', 0);
INSERT INTO `base_meterial_record` VALUES (71, 'lijix', '1111', '1', '', 6, 'CR18050080', 5, 1527326883, 0, 0, 1.00000, 'ljx', 1527326883, '', 0);
INSERT INTO `base_meterial_record` VALUES (72, 'lijix', '1111', '1', '', 6, 'CR18050082', 5, 1527326985, 0, 0, 1.00000, 'ljx', 1527326985, '', 0);
INSERT INTO `base_meterial_record` VALUES (73, 'lijix', '1111', '1', '', 6, 'CR18050082', 5, 1527326985, 0, 0, 1.00000, 'ljx', 1527326985, '', 0);
INSERT INTO `base_meterial_record` VALUES (75, 'sy001', 'WL0002', '', '', 3, 'XS18050028', 1, 0, 0, 0, 6.00000, 'sy', 1527327584, '', 0);
INSERT INTO `base_meterial_record` VALUES (76, 'sy001', 'WL0003', '', '', 3, 'XS18050028', 1, 0, 0, 0, 10.00000, 'sy', 1527327584, '', 0);
INSERT INTO `base_meterial_record` VALUES (135, 'tiger', 'WL003', 'pc001', '', 0, 'BH18050039', 2, 0, 0, 0, 10.00000, 'tiger', 15555555, '', 0);
INSERT INTO `base_meterial_record` VALUES (138, 'tiger', 'WL003', 'pc001', '', 0, 'CH18050039', 3, 0, 0, 0, 20.00000, 'tiger', 1527476988, '', 0);
INSERT INTO `base_meterial_record` VALUES (139, 'tiger', 'WL003', 'pc001', '', 0, 'CH18050039', 5, 0, 0, 0, 20.00000, 'tiger', 1527476988, '', 0);
INSERT INTO `base_meterial_record` VALUES (140, 'tiger', 'WL004', 'pc001', '', 0, 'CH18050039', 3, 0, 0, 0, 10.00000, 'tiger', 1527476988, '', 0);
INSERT INTO `base_meterial_record` VALUES (141, 'tiger', 'WL004', 'pc001', '', 0, 'CH18050039', 5, 0, 0, 0, 10.00000, 'tiger', 1527476988, '', 0);
INSERT INTO `base_meterial_record` VALUES (142, 'sy001', 'WL0001', '', 'sc001', 7, 'BH18050005', 2, 0, 0, 0, 1.00000, 'sy', 1527477735, '', 0);
INSERT INTO `base_meterial_record` VALUES (143, 'sy001', 'WL0001', '', '', 3, 'XS18050028', 1, 0, 0, 0, 4.00000, 'sy', 1527327584, '', 0);
INSERT INTO `base_meterial_record` VALUES (144, 'sy001', 'WL0001', '', 'sc001', 7, 'BH18050005', 2, 0, 0, 0, 1.00000, 'sy', 1527477992, '', 0);
INSERT INTO `base_meterial_record` VALUES (145, 'sy001', 'WL0001', '', 'sc001', 7, 'BH18050005', 2, 0, 0, 0, 1.00000, 'sy', 1527478018, '', 0);
INSERT INTO `base_meterial_record` VALUES (146, 'sy001', 'WL0001', '', 'sc001', 7, 'BH18050005', 2, 0, 0, 0, 1.00000, 'sy', 1527478037, '', 0);
INSERT INTO `base_meterial_record` VALUES (147, 'sy001', 'WL0001', '', 'sc002', 7, 'BH18050005', 2, 0, 0, 0, 1.00000, 'sy', 1527478037, '', 0);
INSERT INTO `base_meterial_record` VALUES (148, 'sy001', 'WL0001', '', 'sc003', 7, 'BH18050005', 2, 0, 0, 0, 1.00000, 'sy', 1527478037, '', 0);
INSERT INTO `base_meterial_record` VALUES (149, 'sy001', 'WL0002', '', 'sc010', 7, 'BH18050005', 2, 0, 0, 0, 1.00000, 'sy', 1527478038, '', 0);
INSERT INTO `base_meterial_record` VALUES (150, 'sy001', 'WL0002', '', 'sc011', 7, 'BH18050005', 2, 0, 0, 0, 1.00000, 'sy', 1527478038, '', 0);
INSERT INTO `base_meterial_record` VALUES (151, 'sy001', 'WL0001', '', 'sc001', 7, 'BH18050006', 2, 0, 0, 0, 1.00000, 'sy', 1527479550, '', 0);
INSERT INTO `base_meterial_record` VALUES (152, 'sy001', 'WL0001', '', 'sc002', 7, 'BH18050006', 2, 0, 0, 0, 1.00000, 'sy', 1527479550, '', 0);
INSERT INTO `base_meterial_record` VALUES (153, 'sy001', 'WL0001', '', 'sc003', 7, 'BH18050006', 2, 0, 0, 0, 1.00000, 'sy', 1527479550, '', 0);
INSERT INTO `base_meterial_record` VALUES (154, 'sy001', 'WL0002', '', 'sc010', 7, 'BH18050006', 2, 0, 0, 0, 1.00000, 'sy', 1527479551, '', 0);
INSERT INTO `base_meterial_record` VALUES (155, 'sy001', 'WL0002', '', 'sc011', 7, 'BH18050006', 2, 0, 0, 0, 1.00000, 'sy', 1527479551, '', 0);
INSERT INTO `base_meterial_record` VALUES (160, 'sy001', 'WL0001', '', 'sc001', 0, 'CH18050040', 3, 0, 0, 0, 1.00000, 'tiger', 1527561282, '', 0);
INSERT INTO `base_meterial_record` VALUES (161, 'sy001', 'WL0001', '', 'sc001', 0, 'CH18050040', 5, 0, 0, 0, 1.00000, 'tiger', 1527561282, '', 0);
INSERT INTO `base_meterial_record` VALUES (162, 'sy001', 'WL0001', '', 'sc002', 0, 'CH18050040', 3, 0, 0, 0, 1.00000, 'tiger', 1527561282, '', 0);
INSERT INTO `base_meterial_record` VALUES (163, 'sy001', 'WL0001', '', 'sc002', 0, 'CH18050040', 5, 0, 0, 0, 1.00000, 'tiger', 1527561282, '', 0);
INSERT INTO `base_meterial_record` VALUES (164, 'sy001', 'WL0002', '', 'sc010', 0, 'CH18050040', 3, 0, 0, 0, 1.00000, 'tiger', 1527561283, '', 0);
INSERT INTO `base_meterial_record` VALUES (165, 'sy001', 'WL0002', '', 'sc010', 0, 'CH18050040', 5, 0, 0, 0, 1.00000, 'tiger', 1527561283, '', 0);
INSERT INTO `base_meterial_record` VALUES (166, 'sy001', 'WL0002', '', 'sc011', 0, 'CH18050040', 3, 0, 0, 0, 1.00000, 'tiger', 1527561283, '', 0);
INSERT INTO `base_meterial_record` VALUES (167, 'sy001', 'WL0002', '', 'sc011', 0, 'CH18050040', 5, 0, 0, 0, 1.00000, 'tiger', 1527561283, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for base_purchase_calendar
-- ----------------------------
DROP TABLE IF EXISTS `base_purchase_calendar`;
CREATE TABLE `base_purchase_calendar` (
  `purchase_calendar_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '采购日历ID',
  `company_code` char(5) NOT NULL DEFAULT '' COMMENT '账套',
  `purchase_calendar_year` int(4) unsigned NOT NULL COMMENT '年份',
  `purchase_calendar_month` tinyint(1) unsigned NOT NULL COMMENT '月份',
  `purchase_calendar_start_day` tinyint(1) unsigned NOT NULL COMMENT '起始_日',
  `purchase_calendar_stop_day` tinyint(1) unsigned NOT NULL COMMENT '终止_日',
  `sell_region_id` int(10) unsigned NOT NULL COMMENT '销售区域ID',
  `purchase_calendar_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `purchase_calendar_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`purchase_calendar_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='采购日历表';

-- ----------------------------
-- Records of base_purchase_calendar
-- ----------------------------
BEGIN;
INSERT INTO `base_purchase_calendar` VALUES (1, 'tiger', 2017, 6, 13, 17, 4, 3, 'sssss', 'tiger', 1526610855, 'tiger', 1526610923);
INSERT INTO `base_purchase_calendar` VALUES (2, 'tiger', 2017, 6, 13, 17, 4, 1, '', 'tiger', 1526610893, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for base_record_gen_id
-- ----------------------------
DROP TABLE IF EXISTS `base_record_gen_id`;
CREATE TABLE `base_record_gen_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '行号全局ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物料交易单据行号生成器';

-- ----------------------------
-- Table structure for base_sell_region
-- ----------------------------
DROP TABLE IF EXISTS `base_sell_region`;
CREATE TABLE `base_sell_region` (
  `sell_region_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '销售区域ID',
  `sell_region_name` varchar(45) NOT NULL COMMENT '销售区域名称',
  `sell_region_pid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '销售区域父ID',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(11) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`sell_region_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售区域';

-- ----------------------------
-- Table structure for base_sequence_code
-- ----------------------------
DROP TABLE IF EXISTS `base_sequence_code`;
CREATE TABLE `base_sequence_code` (
  `sequence_code_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '序列号ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `sequence_code` varchar(30) NOT NULL COMMENT '序列编号',
  `sequence_code_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `sequence_code_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `create_user` varchar(10) NOT NULL COMMENT '创建用户ID',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`sequence_code_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='序列号管理表';

-- ----------------------------
-- Records of base_sequence_code
-- ----------------------------
BEGIN;
INSERT INTO `base_sequence_code` VALUES (1, 'tiger', '1122333', 3, 'dfss', 'tiger', 1526611601, 'tiger', 1526611627);
INSERT INTO `base_sequence_code` VALUES (2, 'tiger', '1122333', 1, '', 'tiger', 1526611619, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for base_settlement
-- ----------------------------
DROP TABLE IF EXISTS `base_settlement`;
CREATE TABLE `base_settlement` (
  `settlement_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `settlement_name` varchar(20) NOT NULL COMMENT '资金结算方式名称',
  `settlement_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '资金结算方式状态 1-启用,2-停用,3-废弃',
  `create_user` char(10) NOT NULL COMMENT '操作人编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改人编号',
  `modify_time` int(11) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`settlement_id`),
  KEY `idx_company_code` (`company_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='资金结算方式';

-- ----------------------------
-- Records of base_settlement
-- ----------------------------
BEGIN;
INSERT INTO `base_settlement` VALUES (1, '4s001', '微信支付', 3, '4s001caiwu', 1527142240, '4s001caiwu', 1527142704);
INSERT INTO `base_settlement` VALUES (2, '4s001', '现金', 1, '4s001caiwu', 1527142258, '4s001caiwu', 1527144205);
INSERT INTO `base_settlement` VALUES (3, '4s001', '支付宝', 1, '4s001caiwu', 1527142262, '4s001caiwu', 1527142262);
INSERT INTO `base_settlement` VALUES (4, '4s001', '银行转账', 1, '4s001caiwu', 1527142270, '4s001caiwu', 1527142270);
INSERT INTO `base_settlement` VALUES (9, '4s001', '微信支付', 1, '4s001caiwu', 1527143987, '4s001caiwu', 1527143987);
INSERT INTO `base_settlement` VALUES (10, 'gs001', '三方承兑', 1, 'gs001caiwu', 1527143987, 'gs001caiwu', 1527143987);
INSERT INTO `base_settlement` VALUES (11, 'gs001', '银行转账', 1, 'gs001caiwu', 1527142240, 'gs001caiwu', 1527142240);
COMMIT;

-- ----------------------------
-- Table structure for base_tax_group
-- ----------------------------
DROP TABLE IF EXISTS `base_tax_group`;
CREATE TABLE `base_tax_group` (
  `tax_group_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '税组ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `tax_group_name` varchar(45) NOT NULL COMMENT '税组名称',
  `tax_group_value` decimal(8,5) unsigned NOT NULL COMMENT '税率',
  `tax_group_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '说明',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(11) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`tax_group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售税组';

-- ----------------------------
-- Table structure for base_unit
-- ----------------------------
DROP TABLE IF EXISTS `base_unit`;
CREATE TABLE `base_unit` (
  `unit_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '单位ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `unit_name` varchar(45) NOT NULL COMMENT '计量单位名称',
  `unit_precision` smallint(1) unsigned NOT NULL COMMENT '小数位数',
  `unit_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `unit_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`unit_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='物料计量单位表';

-- ----------------------------
-- Records of base_unit
-- ----------------------------
BEGIN;
INSERT INTO `base_unit` VALUES (1, 'tiger', '深度尺', 12, 1, '', 'tiger', 1527564831, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for base_vehicle_type
-- ----------------------------
DROP TABLE IF EXISTS `base_vehicle_type`;
CREATE TABLE `base_vehicle_type` (
  `vehicle_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `vehicle_type_code` varchar(20) NOT NULL COMMENT '车型编码',
  `vehicle_type_name` varchar(45) NOT NULL COMMENT '名称',
  `vehicle_type_pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父级id',
  `vehicle_type_level` tinyint(1) unsigned NOT NULL COMMENT '类型： 1-车系 2-车型 3-车款',
  `create_user` char(10) NOT NULL COMMENT '创建人编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改人编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`vehicle_type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='车型表';

-- ----------------------------
-- Table structure for base_warehouse
-- ----------------------------
DROP TABLE IF EXISTS `base_warehouse`;
CREATE TABLE `base_warehouse` (
  `warehouse_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '仓库ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `warehouse_code` char(10) NOT NULL COMMENT '仓库编号',
  `warehouse_name` varchar(45) NOT NULL COMMENT '仓库名称',
  `warehouse_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '描述',
  `warehouse_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0默认，1-内采库,2-外采库（1、2为4s店专用） 3-整车正常库 4-备件正常库 5-整车问题库 6-备件问题库（3、4、5、6为销售公司专用）''',
  `warehouse_is_space_mgr` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否支持仓位管理 0-不支持, 1-支持',
  `warehouse_space_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `warehouse_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`warehouse_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='仓库表';

-- ----------------------------
-- Records of base_warehouse
-- ----------------------------
BEGIN;
INSERT INTO `base_warehouse` VALUES (1, 'lijix', '1234567890', '1212', '仓库描述111', 1, 0, 1, '仓库作废', 'lijinxing', 1526886702, 'lijinxing', 1527490633);
INSERT INTO `base_warehouse` VALUES (2, 'lijix', 'ceshi001', '测试1', '这是来测试的', 0, 0, 3, '测试作废', 'lijinxing', 1527476610, 'lijinxing', 1527478374);
INSERT INTO `base_warehouse` VALUES (3, 'lijix', 'ceshi002', '1212', '仓库描述', 0, 1, 1, '', 'lijinxing', 1527476657, 'lijinxing', 1527489598);
COMMIT;

-- ----------------------------
-- Table structure for base_warehouse_space
-- ----------------------------
DROP TABLE IF EXISTS `base_warehouse_space`;
CREATE TABLE `base_warehouse_space` (
  `warehouse_space_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '仓位ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `warehouse_space_code` char(20) NOT NULL COMMENT '仓位编号',
  `warehouse_code` char(10) NOT NULL COMMENT '仓库编号',
  `warehouse_space_name` varchar(45) NOT NULL COMMENT '仓位名称',
  `warehouse_space_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
  `warehouse_space_is_space_mgr` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否货位管理 0-否, 1-是',
  `warehouse_space_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `warehouse_space_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`warehouse_space_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='仓位表';

-- ----------------------------
-- Records of base_warehouse_space
-- ----------------------------
BEGIN;
INSERT INTO `base_warehouse_space` VALUES (1, 'lijix', 'ckceshi001', '1234567890', '初三大四', '多岁的', 0, 1, '仓位弃用', 'lijinxing', 1527477300, 'lijinxing', 1527491353);
COMMIT;

-- ----------------------------
-- Table structure for comm_address
-- ----------------------------
DROP TABLE IF EXISTS `comm_address`;
CREATE TABLE `comm_address` (
  `address_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `address_type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '地址类型 0-普通, 1-收货',
  `address_zip_code` char(7) NOT NULL DEFAULT '' COMMENT '邮政编号',
  `province_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '市Id',
  `district_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '区id',
  `address_detail` varchar(128) NOT NULL DEFAULT '' COMMENT '详细地址记录',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(11) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`address_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='客户地址';

-- ----------------------------
-- Records of comm_address
-- ----------------------------
BEGIN;
INSERT INTO `comm_address` VALUES (1, '12345', 0, '1111111', 4, 5, 6, 'ewqewqewqewqewqewq', '12345', 1526020723, '12345', 1526023100);
INSERT INTO `comm_address` VALUES (2, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526020764, '', 0);
INSERT INTO `comm_address` VALUES (3, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526020909, '', 0);
INSERT INTO `comm_address` VALUES (4, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526020946, '', 0);
INSERT INTO `comm_address` VALUES (5, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526021073, '', 0);
INSERT INTO `comm_address` VALUES (6, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526021096, '', 0);
INSERT INTO `comm_address` VALUES (7, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526021612, '', 0);
INSERT INTO `comm_address` VALUES (8, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526021642, '', 0);
INSERT INTO `comm_address` VALUES (9, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526021710, '', 0);
INSERT INTO `comm_address` VALUES (10, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526022122, '', 0);
INSERT INTO `comm_address` VALUES (11, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526022147, '', 0);
INSERT INTO `comm_address` VALUES (12, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526022159, '', 0);
INSERT INTO `comm_address` VALUES (13, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526022182, '', 0);
INSERT INTO `comm_address` VALUES (14, '12345', 1, '321qq', 1, 2, 3, 'ewqewqw', '12345', 1526022438, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for comm_address_area
-- ----------------------------
DROP TABLE IF EXISTS `comm_address_area`;
CREATE TABLE `comm_address_area` (
  `id` varchar(20) NOT NULL,
  `upid` varchar(20) NOT NULL,
  `levels` int(6) NOT NULL,
  `orders` int(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `upid` (`upid`) USING BTREE,
  KEY `levels` (`levels`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='全国区域表(系统维护)';

-- ----------------------------
-- Records of comm_address_area
-- ----------------------------
BEGIN;
INSERT INTO `comm_address_area` VALUES ('110000000000', '0', 1, 0, '北京市');
INSERT INTO `comm_address_area` VALUES ('110101000000', '110000000000', 2, 0, '东城区');
INSERT INTO `comm_address_area` VALUES ('110102000000', '110000000000', 2, 0, '西城区');
INSERT INTO `comm_address_area` VALUES ('110105000000', '110000000000', 2, 0, '朝阳区');
INSERT INTO `comm_address_area` VALUES ('110106000000', '110000000000', 2, 0, '丰台区');
INSERT INTO `comm_address_area` VALUES ('110109000000', '110000000000', 2, 0, '门头沟区');
INSERT INTO `comm_address_area` VALUES ('110107000000', '110000000000', 2, 0, '石景山区');
INSERT INTO `comm_address_area` VALUES ('110108000000', '110000000000', 2, 0, '海淀区');
INSERT INTO `comm_address_area` VALUES ('110111000000', '110000000000', 2, 0, '房山区');
INSERT INTO `comm_address_area` VALUES ('110112000000', '110000000000', 2, 0, '通州区');
INSERT INTO `comm_address_area` VALUES ('110113000000', '110000000000', 2, 0, '顺义区');
INSERT INTO `comm_address_area` VALUES ('110114000000', '110000000000', 2, 0, '昌平区');
INSERT INTO `comm_address_area` VALUES ('110115000000', '110000000000', 2, 0, '大兴区');
INSERT INTO `comm_address_area` VALUES ('110116000000', '110000000000', 2, 0, '怀柔区');
INSERT INTO `comm_address_area` VALUES ('110117000000', '110000000000', 2, 0, '平谷区');
INSERT INTO `comm_address_area` VALUES ('110228000000', '110000000000', 2, 0, '密云县');
INSERT INTO `comm_address_area` VALUES ('110229000000', '110000000000', 2, 0, '延庆县');
INSERT INTO `comm_address_area` VALUES ('340000000000', '0', 1, 0, '安徽省');
INSERT INTO `comm_address_area` VALUES ('340100000000', '340000000000', 2, 0, '合肥市');
INSERT INTO `comm_address_area` VALUES ('340102000000', '340100000000', 3, 0, '瑶海区');
INSERT INTO `comm_address_area` VALUES ('340103000000', '340100000000', 3, 0, '庐阳区');
INSERT INTO `comm_address_area` VALUES ('340104000000', '340100000000', 3, 0, '蜀山区');
INSERT INTO `comm_address_area` VALUES ('340111000000', '340100000000', 3, 0, '包河区');
INSERT INTO `comm_address_area` VALUES ('340121000000', '340100000000', 3, 0, '长丰县');
INSERT INTO `comm_address_area` VALUES ('340122000000', '340100000000', 3, 0, '肥东县');
INSERT INTO `comm_address_area` VALUES ('340123000000', '340100000000', 3, 0, '肥西县');
INSERT INTO `comm_address_area` VALUES ('340124000000', '340100000000', 3, 0, '庐江县');
INSERT INTO `comm_address_area` VALUES ('340181000000', '340100000000', 3, 0, '巢湖市');
INSERT INTO `comm_address_area` VALUES ('340200000000', '340000000000', 2, 0, '芜湖市');
INSERT INTO `comm_address_area` VALUES ('340202000000', '340200000000', 3, 0, '镜湖区');
INSERT INTO `comm_address_area` VALUES ('340203000000', '340200000000', 3, 0, '弋江区');
INSERT INTO `comm_address_area` VALUES ('340207000000', '340200000000', 3, 0, '鸠江区');
INSERT INTO `comm_address_area` VALUES ('340208000000', '340200000000', 3, 0, '三山区');
INSERT INTO `comm_address_area` VALUES ('340221000000', '340200000000', 3, 0, '芜湖县');
INSERT INTO `comm_address_area` VALUES ('340222000000', '340200000000', 3, 0, '繁昌县');
INSERT INTO `comm_address_area` VALUES ('340223000000', '340200000000', 3, 0, '南陵县');
INSERT INTO `comm_address_area` VALUES ('340225000000', '340200000000', 3, 0, '无为县');
INSERT INTO `comm_address_area` VALUES ('340300000000', '340000000000', 2, 0, '蚌埠市');
INSERT INTO `comm_address_area` VALUES ('340302000000', '340300000000', 3, 0, '龙子湖区');
INSERT INTO `comm_address_area` VALUES ('340303000000', '340300000000', 3, 0, '蚌山区');
INSERT INTO `comm_address_area` VALUES ('340304000000', '340300000000', 3, 0, '禹会区');
INSERT INTO `comm_address_area` VALUES ('340311000000', '340300000000', 3, 0, '淮上区');
INSERT INTO `comm_address_area` VALUES ('340321000000', '340300000000', 3, 0, '怀远县');
INSERT INTO `comm_address_area` VALUES ('340322000000', '340300000000', 3, 0, '五河县');
INSERT INTO `comm_address_area` VALUES ('340323000000', '340300000000', 3, 0, '固镇县');
INSERT INTO `comm_address_area` VALUES ('340400000000', '340000000000', 2, 0, '淮南市');
INSERT INTO `comm_address_area` VALUES ('340402000000', '340400000000', 3, 0, '大通区');
INSERT INTO `comm_address_area` VALUES ('340403000000', '340400000000', 3, 0, '田家庵区');
INSERT INTO `comm_address_area` VALUES ('340404000000', '340400000000', 3, 0, '谢家集区');
INSERT INTO `comm_address_area` VALUES ('340405000000', '340400000000', 3, 0, '八公山区');
INSERT INTO `comm_address_area` VALUES ('340406000000', '340400000000', 3, 0, '潘集区');
INSERT INTO `comm_address_area` VALUES ('340421000000', '340400000000', 3, 0, '凤台县');
INSERT INTO `comm_address_area` VALUES ('340500000000', '340000000000', 2, 0, '马鞍山市');
INSERT INTO `comm_address_area` VALUES ('340502000000', '340500000000', 3, 0, '金家庄区');
INSERT INTO `comm_address_area` VALUES ('340503000000', '340500000000', 3, 0, '花山区');
INSERT INTO `comm_address_area` VALUES ('340504000000', '340500000000', 3, 0, '雨山区');
INSERT INTO `comm_address_area` VALUES ('340521000000', '340500000000', 3, 0, '当涂县');
INSERT INTO `comm_address_area` VALUES ('340522000000', '340500000000', 3, 0, '含山县');
INSERT INTO `comm_address_area` VALUES ('340523000000', '340500000000', 3, 0, '和县');
INSERT INTO `comm_address_area` VALUES ('340600000000', '340000000000', 2, 0, '淮北市');
INSERT INTO `comm_address_area` VALUES ('340602000000', '340600000000', 3, 0, '杜集区');
INSERT INTO `comm_address_area` VALUES ('340603000000', '340600000000', 3, 0, '相山区');
INSERT INTO `comm_address_area` VALUES ('340604000000', '340600000000', 3, 0, '烈山区');
INSERT INTO `comm_address_area` VALUES ('340621000000', '340600000000', 3, 0, '濉溪县');
INSERT INTO `comm_address_area` VALUES ('340700000000', '340000000000', 2, 0, '铜陵市');
INSERT INTO `comm_address_area` VALUES ('340702000000', '340700000000', 3, 0, '铜官山区');
INSERT INTO `comm_address_area` VALUES ('340703000000', '340700000000', 3, 0, '狮子山区');
INSERT INTO `comm_address_area` VALUES ('340711000000', '340700000000', 3, 0, '郊区');
INSERT INTO `comm_address_area` VALUES ('340721000000', '340700000000', 3, 0, '铜陵县');
INSERT INTO `comm_address_area` VALUES ('340800000000', '340000000000', 2, 0, '安庆市');
INSERT INTO `comm_address_area` VALUES ('340802000000', '340800000000', 3, 0, '迎江区');
INSERT INTO `comm_address_area` VALUES ('340803000000', '340800000000', 3, 0, '大观区');
INSERT INTO `comm_address_area` VALUES ('340811000000', '340800000000', 3, 0, '宜秀区');
INSERT INTO `comm_address_area` VALUES ('340822000000', '340800000000', 3, 0, '怀宁县');
INSERT INTO `comm_address_area` VALUES ('340823000000', '340800000000', 3, 0, '枞阳县');
INSERT INTO `comm_address_area` VALUES ('340824000000', '340800000000', 3, 0, '潜山县');
INSERT INTO `comm_address_area` VALUES ('340825000000', '340800000000', 3, 0, '太湖县');
INSERT INTO `comm_address_area` VALUES ('340826000000', '340800000000', 3, 0, '宿松县');
INSERT INTO `comm_address_area` VALUES ('340827000000', '340800000000', 3, 0, '望江县');
INSERT INTO `comm_address_area` VALUES ('340828000000', '340800000000', 3, 0, '岳西县');
INSERT INTO `comm_address_area` VALUES ('340881000000', '340800000000', 3, 0, '桐城市');
INSERT INTO `comm_address_area` VALUES ('341000000000', '340000000000', 2, 0, '黄山市');
INSERT INTO `comm_address_area` VALUES ('341002000000', '341000000000', 3, 0, '屯溪区');
INSERT INTO `comm_address_area` VALUES ('341003000000', '341000000000', 3, 0, '黄山区');
INSERT INTO `comm_address_area` VALUES ('341004000000', '341000000000', 3, 0, '徽州区');
INSERT INTO `comm_address_area` VALUES ('341021000000', '341000000000', 3, 0, '歙县');
INSERT INTO `comm_address_area` VALUES ('341022000000', '341000000000', 3, 0, '休宁县');
INSERT INTO `comm_address_area` VALUES ('341023000000', '341000000000', 3, 0, '黟县');
INSERT INTO `comm_address_area` VALUES ('341024000000', '341000000000', 3, 0, '祁门县');
INSERT INTO `comm_address_area` VALUES ('341100000000', '340000000000', 2, 0, '滁州市');
INSERT INTO `comm_address_area` VALUES ('341102000000', '341100000000', 3, 0, '琅琊区');
INSERT INTO `comm_address_area` VALUES ('341103000000', '341100000000', 3, 0, '南谯区');
INSERT INTO `comm_address_area` VALUES ('341122000000', '341100000000', 3, 0, '来安县');
INSERT INTO `comm_address_area` VALUES ('341124000000', '341100000000', 3, 0, '全椒县');
INSERT INTO `comm_address_area` VALUES ('341125000000', '341100000000', 3, 0, '定远县');
INSERT INTO `comm_address_area` VALUES ('341126000000', '341100000000', 3, 0, '凤阳县');
INSERT INTO `comm_address_area` VALUES ('341181000000', '341100000000', 3, 0, '天长市');
INSERT INTO `comm_address_area` VALUES ('341182000000', '341100000000', 3, 0, '明光市');
INSERT INTO `comm_address_area` VALUES ('341200000000', '340000000000', 2, 0, '阜阳市');
INSERT INTO `comm_address_area` VALUES ('341202000000', '341200000000', 3, 0, '颍州区');
INSERT INTO `comm_address_area` VALUES ('341203000000', '341200000000', 3, 0, '颍东区');
INSERT INTO `comm_address_area` VALUES ('341204000000', '341200000000', 3, 0, '颍泉区');
INSERT INTO `comm_address_area` VALUES ('341221000000', '341200000000', 3, 0, '临泉县');
INSERT INTO `comm_address_area` VALUES ('341222000000', '341200000000', 3, 0, '太和县');
INSERT INTO `comm_address_area` VALUES ('341225000000', '341200000000', 3, 0, '阜南县');
INSERT INTO `comm_address_area` VALUES ('341226000000', '341200000000', 3, 0, '颍上县');
INSERT INTO `comm_address_area` VALUES ('341282000000', '341200000000', 3, 0, '界首市');
INSERT INTO `comm_address_area` VALUES ('341300000000', '340000000000', 2, 0, '宿州市');
INSERT INTO `comm_address_area` VALUES ('341302000000', '341300000000', 3, 0, '埇桥区');
INSERT INTO `comm_address_area` VALUES ('341321000000', '341300000000', 3, 0, '砀山县');
INSERT INTO `comm_address_area` VALUES ('341322000000', '341300000000', 3, 0, '萧县');
INSERT INTO `comm_address_area` VALUES ('341323000000', '341300000000', 3, 0, '灵璧县');
INSERT INTO `comm_address_area` VALUES ('341324000000', '341300000000', 3, 0, '泗县');
INSERT INTO `comm_address_area` VALUES ('341500000000', '340000000000', 2, 0, '六安市');
INSERT INTO `comm_address_area` VALUES ('341502000000', '341500000000', 3, 0, '金安区');
INSERT INTO `comm_address_area` VALUES ('341503000000', '341500000000', 3, 0, '裕安区');
INSERT INTO `comm_address_area` VALUES ('341521000000', '341500000000', 3, 0, '寿县');
INSERT INTO `comm_address_area` VALUES ('341522000000', '341500000000', 3, 0, '霍邱县');
INSERT INTO `comm_address_area` VALUES ('341523000000', '341500000000', 3, 0, '舒城县');
INSERT INTO `comm_address_area` VALUES ('341524000000', '341500000000', 3, 0, '金寨县');
INSERT INTO `comm_address_area` VALUES ('341525000000', '341500000000', 3, 0, '霍山县');
INSERT INTO `comm_address_area` VALUES ('341600000000', '340000000000', 2, 0, '亳州市');
INSERT INTO `comm_address_area` VALUES ('341602000000', '341600000000', 3, 0, '谯城区');
INSERT INTO `comm_address_area` VALUES ('341621000000', '341600000000', 3, 0, '涡阳县');
INSERT INTO `comm_address_area` VALUES ('341622000000', '341600000000', 3, 0, '蒙城县');
INSERT INTO `comm_address_area` VALUES ('341623000000', '341600000000', 3, 0, '利辛县');
INSERT INTO `comm_address_area` VALUES ('341700000000', '340000000000', 2, 0, '池州市');
INSERT INTO `comm_address_area` VALUES ('341702000000', '341700000000', 3, 0, '贵池区');
INSERT INTO `comm_address_area` VALUES ('341721000000', '341700000000', 3, 0, '东至县');
INSERT INTO `comm_address_area` VALUES ('341722000000', '341700000000', 3, 0, '石台县');
INSERT INTO `comm_address_area` VALUES ('341723000000', '341700000000', 3, 0, '青阳县');
INSERT INTO `comm_address_area` VALUES ('341800000000', '340000000000', 2, 0, '宣城市');
INSERT INTO `comm_address_area` VALUES ('341802000000', '341800000000', 3, 0, '宣州区');
INSERT INTO `comm_address_area` VALUES ('341821000000', '341800000000', 3, 0, '郎溪县');
INSERT INTO `comm_address_area` VALUES ('341822000000', '341800000000', 3, 0, '广德县');
INSERT INTO `comm_address_area` VALUES ('341823000000', '341800000000', 3, 0, '泾县');
INSERT INTO `comm_address_area` VALUES ('341824000000', '341800000000', 3, 0, '绩溪县');
INSERT INTO `comm_address_area` VALUES ('341825000000', '341800000000', 3, 0, '旌德县');
INSERT INTO `comm_address_area` VALUES ('341881000000', '341800000000', 3, 0, '宁国市');
INSERT INTO `comm_address_area` VALUES ('350000000000', '0', 1, 1, '福建省');
INSERT INTO `comm_address_area` VALUES ('350100000000', '350000000000', 2, 0, '福州市');
INSERT INTO `comm_address_area` VALUES ('350102000000', '350100000000', 3, 0, '鼓楼区');
INSERT INTO `comm_address_area` VALUES ('350103000000', '350100000000', 3, 0, '台江区');
INSERT INTO `comm_address_area` VALUES ('350104000000', '350100000000', 3, 0, '仓山区');
INSERT INTO `comm_address_area` VALUES ('350105000000', '350100000000', 3, 0, '马尾区');
INSERT INTO `comm_address_area` VALUES ('350111000000', '350100000000', 3, 0, '晋安区');
INSERT INTO `comm_address_area` VALUES ('350121000000', '350100000000', 3, 0, '闽侯县');
INSERT INTO `comm_address_area` VALUES ('350128000000', '350100000000', 3, 0, '平潭县');
INSERT INTO `comm_address_area` VALUES ('350122000000', '350100000000', 3, 0, '连江县');
INSERT INTO `comm_address_area` VALUES ('350123000000', '350100000000', 3, 0, '罗源县');
INSERT INTO `comm_address_area` VALUES ('350124000000', '350100000000', 3, 0, '闽清县');
INSERT INTO `comm_address_area` VALUES ('350125000000', '350100000000', 3, 0, '永泰县');
INSERT INTO `comm_address_area` VALUES ('350181000000', '350100000000', 3, 0, '福清市');
INSERT INTO `comm_address_area` VALUES ('350182000000', '350100000000', 3, 0, '长乐市');
INSERT INTO `comm_address_area` VALUES ('350200000000', '350000000000', 2, 0, '厦门市');
INSERT INTO `comm_address_area` VALUES ('350203000000', '350200000000', 3, 0, '思明区');
INSERT INTO `comm_address_area` VALUES ('350205000000', '350200000000', 3, 0, '海沧区');
INSERT INTO `comm_address_area` VALUES ('350206000000', '350200000000', 3, 0, '湖里区');
INSERT INTO `comm_address_area` VALUES ('350211000000', '350200000000', 3, 0, '集美区');
INSERT INTO `comm_address_area` VALUES ('350212000000', '350200000000', 3, 0, '同安区');
INSERT INTO `comm_address_area` VALUES ('350213000000', '350200000000', 3, 0, '翔安区');
INSERT INTO `comm_address_area` VALUES ('350300000000', '350000000000', 2, 0, '莆田市');
INSERT INTO `comm_address_area` VALUES ('350302000000', '350300000000', 3, 0, '城厢区');
INSERT INTO `comm_address_area` VALUES ('350303000000', '350300000000', 3, 0, '涵江区');
INSERT INTO `comm_address_area` VALUES ('350304000000', '350300000000', 3, 0, '荔城区');
INSERT INTO `comm_address_area` VALUES ('350305000000', '350300000000', 3, 0, '秀屿区');
INSERT INTO `comm_address_area` VALUES ('350322000000', '350300000000', 3, 0, '仙游县');
INSERT INTO `comm_address_area` VALUES ('350400000000', '350000000000', 2, 0, '三明市');
INSERT INTO `comm_address_area` VALUES ('350402000000', '350400000000', 3, 0, '梅列区');
INSERT INTO `comm_address_area` VALUES ('350403000000', '350400000000', 3, 0, '三元区');
INSERT INTO `comm_address_area` VALUES ('350421000000', '350400000000', 3, 0, '明溪县');
INSERT INTO `comm_address_area` VALUES ('350423000000', '350400000000', 3, 0, '清流县');
INSERT INTO `comm_address_area` VALUES ('350424000000', '350400000000', 3, 0, '宁化县');
INSERT INTO `comm_address_area` VALUES ('350425000000', '350400000000', 3, 0, '大田县');
INSERT INTO `comm_address_area` VALUES ('350426000000', '350400000000', 3, 0, '尤溪县');
INSERT INTO `comm_address_area` VALUES ('350427000000', '350400000000', 3, 0, '沙县');
INSERT INTO `comm_address_area` VALUES ('350428000000', '350400000000', 3, 0, '将乐县');
INSERT INTO `comm_address_area` VALUES ('350429000000', '350400000000', 3, 0, '泰宁县');
INSERT INTO `comm_address_area` VALUES ('350430000000', '350400000000', 3, 0, '建宁县');
INSERT INTO `comm_address_area` VALUES ('350481000000', '350400000000', 3, 0, '永安市');
INSERT INTO `comm_address_area` VALUES ('350500000000', '350000000000', 2, 0, '泉州市');
INSERT INTO `comm_address_area` VALUES ('350502000000', '350500000000', 3, 0, '鲤城区');
INSERT INTO `comm_address_area` VALUES ('350503000000', '350500000000', 3, 0, '丰泽区');
INSERT INTO `comm_address_area` VALUES ('350504000000', '350500000000', 3, 0, '洛江区');
INSERT INTO `comm_address_area` VALUES ('350505000000', '350500000000', 3, 0, '泉港区');
INSERT INTO `comm_address_area` VALUES ('350521000000', '350500000000', 3, 0, '惠安县');
INSERT INTO `comm_address_area` VALUES ('350524000000', '350500000000', 3, 0, '安溪县');
INSERT INTO `comm_address_area` VALUES ('350525000000', '350500000000', 3, 0, '永春县');
INSERT INTO `comm_address_area` VALUES ('350526000000', '350500000000', 3, 0, '德化县');
INSERT INTO `comm_address_area` VALUES ('350527000000', '350500000000', 3, 0, '金门县');
INSERT INTO `comm_address_area` VALUES ('350581000000', '350500000000', 3, 0, '石狮市');
INSERT INTO `comm_address_area` VALUES ('350582000000', '350500000000', 3, 0, '晋江市');
INSERT INTO `comm_address_area` VALUES ('350583000000', '350500000000', 3, 0, '南安市');
INSERT INTO `comm_address_area` VALUES ('350600000000', '350000000000', 2, 0, '漳州市');
INSERT INTO `comm_address_area` VALUES ('350602000000', '350600000000', 3, 0, '芗城区');
INSERT INTO `comm_address_area` VALUES ('350603000000', '350600000000', 3, 0, '龙文区');
INSERT INTO `comm_address_area` VALUES ('350622000000', '350600000000', 3, 0, '云霄县');
INSERT INTO `comm_address_area` VALUES ('350623000000', '350600000000', 3, 0, '漳浦县');
INSERT INTO `comm_address_area` VALUES ('350624000000', '350600000000', 3, 0, '诏安县');
INSERT INTO `comm_address_area` VALUES ('350625000000', '350600000000', 3, 0, '长泰县');
INSERT INTO `comm_address_area` VALUES ('350626000000', '350600000000', 3, 0, '东山县');
INSERT INTO `comm_address_area` VALUES ('350627000000', '350600000000', 3, 0, '南靖县');
INSERT INTO `comm_address_area` VALUES ('350628000000', '350600000000', 3, 0, '平和县');
INSERT INTO `comm_address_area` VALUES ('350629000000', '350600000000', 3, 0, '华安县');
INSERT INTO `comm_address_area` VALUES ('350681000000', '350600000000', 3, 0, '龙海市');
INSERT INTO `comm_address_area` VALUES ('350700000000', '350000000000', 2, 0, '南平市');
INSERT INTO `comm_address_area` VALUES ('350702000000', '350700000000', 3, 0, '延平区');
INSERT INTO `comm_address_area` VALUES ('350721000000', '350700000000', 3, 0, '顺昌县');
INSERT INTO `comm_address_area` VALUES ('350722000000', '350700000000', 3, 0, '浦城县');
INSERT INTO `comm_address_area` VALUES ('350723000000', '350700000000', 3, 0, '光泽县');
INSERT INTO `comm_address_area` VALUES ('350724000000', '350700000000', 3, 0, '松溪县');
INSERT INTO `comm_address_area` VALUES ('350725000000', '350700000000', 3, 0, '政和县');
INSERT INTO `comm_address_area` VALUES ('350781000000', '350700000000', 3, 0, '邵武市');
INSERT INTO `comm_address_area` VALUES ('350782000000', '350700000000', 3, 0, '武夷山市');
INSERT INTO `comm_address_area` VALUES ('350783000000', '350700000000', 3, 0, '建瓯市');
INSERT INTO `comm_address_area` VALUES ('350784000000', '350700000000', 3, 0, '建阳市');
INSERT INTO `comm_address_area` VALUES ('350800000000', '350000000000', 2, 0, '龙岩市');
INSERT INTO `comm_address_area` VALUES ('350802000000', '350800000000', 3, 0, '新罗区');
INSERT INTO `comm_address_area` VALUES ('350821000000', '350800000000', 3, 0, '长汀县');
INSERT INTO `comm_address_area` VALUES ('350822000000', '350800000000', 3, 0, '永定县');
INSERT INTO `comm_address_area` VALUES ('350823000000', '350800000000', 3, 0, '上杭县');
INSERT INTO `comm_address_area` VALUES ('350824000000', '350800000000', 3, 0, '武平县');
INSERT INTO `comm_address_area` VALUES ('350825000000', '350800000000', 3, 0, '连城县');
INSERT INTO `comm_address_area` VALUES ('350881000000', '350800000000', 3, 0, '漳平市');
INSERT INTO `comm_address_area` VALUES ('350900000000', '350000000000', 2, 0, '宁德市');
INSERT INTO `comm_address_area` VALUES ('350902000000', '350900000000', 3, 0, '蕉城区');
INSERT INTO `comm_address_area` VALUES ('350921000000', '350900000000', 3, 0, '霞浦县');
INSERT INTO `comm_address_area` VALUES ('350922000000', '350900000000', 3, 0, '古田县');
INSERT INTO `comm_address_area` VALUES ('350923000000', '350900000000', 3, 0, '屏南县');
INSERT INTO `comm_address_area` VALUES ('350924000000', '350900000000', 3, 0, '寿宁县');
INSERT INTO `comm_address_area` VALUES ('350925000000', '350900000000', 3, 0, '周宁县');
INSERT INTO `comm_address_area` VALUES ('350926000000', '350900000000', 3, 0, '柘荣县');
INSERT INTO `comm_address_area` VALUES ('350981000000', '350900000000', 3, 0, '福安市');
INSERT INTO `comm_address_area` VALUES ('350982000000', '350900000000', 3, 0, '福鼎市');
INSERT INTO `comm_address_area` VALUES ('620000000000', '0', 1, 0, '甘肃省');
INSERT INTO `comm_address_area` VALUES ('620100000000', '620000000000', 2, 0, '兰州市');
INSERT INTO `comm_address_area` VALUES ('620102000000', '620100000000', 3, 0, '城关区');
INSERT INTO `comm_address_area` VALUES ('620103000000', '620100000000', 3, 0, '七里河区');
INSERT INTO `comm_address_area` VALUES ('620104000000', '620100000000', 3, 0, '西固区');
INSERT INTO `comm_address_area` VALUES ('620105000000', '620100000000', 3, 0, '安宁区');
INSERT INTO `comm_address_area` VALUES ('620111000000', '620100000000', 3, 0, '红古区');
INSERT INTO `comm_address_area` VALUES ('620121000000', '620100000000', 3, 0, '永登县');
INSERT INTO `comm_address_area` VALUES ('620122000000', '620100000000', 3, 0, '皋兰县');
INSERT INTO `comm_address_area` VALUES ('620123000000', '620100000000', 3, 0, '榆中县');
INSERT INTO `comm_address_area` VALUES ('620200000000', '620000000000', 2, 0, '嘉峪关市');
INSERT INTO `comm_address_area` VALUES ('620300000000', '620000000000', 2, 0, '金昌市');
INSERT INTO `comm_address_area` VALUES ('620302000000', '620300000000', 3, 0, '金川区');
INSERT INTO `comm_address_area` VALUES ('620321000000', '620300000000', 3, 0, '永昌县');
INSERT INTO `comm_address_area` VALUES ('620400000000', '620000000000', 2, 0, '白银市');
INSERT INTO `comm_address_area` VALUES ('620402000000', '620400000000', 3, 0, '白银区');
INSERT INTO `comm_address_area` VALUES ('620403000000', '620400000000', 3, 0, '平川区');
INSERT INTO `comm_address_area` VALUES ('620421000000', '620400000000', 3, 0, '靖远县');
INSERT INTO `comm_address_area` VALUES ('620422000000', '620400000000', 3, 0, '会宁县');
INSERT INTO `comm_address_area` VALUES ('620423000000', '620400000000', 3, 0, '景泰县');
INSERT INTO `comm_address_area` VALUES ('620500000000', '620000000000', 2, 0, '天水市');
INSERT INTO `comm_address_area` VALUES ('620502000000', '620500000000', 3, 0, '秦州区');
INSERT INTO `comm_address_area` VALUES ('620503000000', '620500000000', 3, 0, '麦积区');
INSERT INTO `comm_address_area` VALUES ('620521000000', '620500000000', 3, 0, '清水县');
INSERT INTO `comm_address_area` VALUES ('620522000000', '620500000000', 3, 0, '秦安县');
INSERT INTO `comm_address_area` VALUES ('620523000000', '620500000000', 3, 0, '甘谷县');
INSERT INTO `comm_address_area` VALUES ('620524000000', '620500000000', 3, 0, '武山县');
INSERT INTO `comm_address_area` VALUES ('620525000000', '620500000000', 3, 0, '张家川回族自治县');
INSERT INTO `comm_address_area` VALUES ('620600000000', '620000000000', 2, 0, '武威市');
INSERT INTO `comm_address_area` VALUES ('620602000000', '620600000000', 3, 0, '凉州区');
INSERT INTO `comm_address_area` VALUES ('620621000000', '620600000000', 3, 0, '民勤县');
INSERT INTO `comm_address_area` VALUES ('620622000000', '620600000000', 3, 0, '古浪县');
INSERT INTO `comm_address_area` VALUES ('620623000000', '620600000000', 3, 0, '天祝藏族自治县');
INSERT INTO `comm_address_area` VALUES ('620700000000', '620000000000', 2, 0, '张掖市');
INSERT INTO `comm_address_area` VALUES ('620702000000', '620700000000', 3, 0, '甘州区');
INSERT INTO `comm_address_area` VALUES ('620721000000', '620700000000', 3, 0, '肃南裕固族自治县');
INSERT INTO `comm_address_area` VALUES ('620722000000', '620700000000', 3, 0, '民乐县');
INSERT INTO `comm_address_area` VALUES ('620723000000', '620700000000', 3, 0, '临泽县');
INSERT INTO `comm_address_area` VALUES ('620724000000', '620700000000', 3, 0, '高台县');
INSERT INTO `comm_address_area` VALUES ('620725000000', '620700000000', 3, 0, '山丹县');
INSERT INTO `comm_address_area` VALUES ('620800000000', '620000000000', 2, 0, '平凉市');
INSERT INTO `comm_address_area` VALUES ('620802000000', '620800000000', 3, 0, '崆峒区');
INSERT INTO `comm_address_area` VALUES ('620821000000', '620800000000', 3, 0, '泾川县');
INSERT INTO `comm_address_area` VALUES ('620822000000', '620800000000', 3, 0, '灵台县');
INSERT INTO `comm_address_area` VALUES ('620823000000', '620800000000', 3, 0, '崇信县');
INSERT INTO `comm_address_area` VALUES ('620824000000', '620800000000', 3, 0, '华亭县');
INSERT INTO `comm_address_area` VALUES ('620825000000', '620800000000', 3, 0, '庄浪县');
INSERT INTO `comm_address_area` VALUES ('620826000000', '620800000000', 3, 0, '静宁县');
INSERT INTO `comm_address_area` VALUES ('620900000000', '620000000000', 2, 0, '酒泉市');
INSERT INTO `comm_address_area` VALUES ('620902000000', '620900000000', 3, 0, '肃州区');
INSERT INTO `comm_address_area` VALUES ('620921000000', '620900000000', 3, 0, '金塔县');
INSERT INTO `comm_address_area` VALUES ('620922000000', '620900000000', 3, 0, '瓜州县');
INSERT INTO `comm_address_area` VALUES ('620923000000', '620900000000', 3, 0, '肃北蒙古族自治县');
INSERT INTO `comm_address_area` VALUES ('620924000000', '620900000000', 3, 0, '阿克塞哈萨克族自治县');
INSERT INTO `comm_address_area` VALUES ('620981000000', '620900000000', 3, 0, '玉门市');
INSERT INTO `comm_address_area` VALUES ('620982000000', '620900000000', 3, 0, '敦煌市');
INSERT INTO `comm_address_area` VALUES ('621000000000', '620000000000', 2, 0, '庆阳市');
INSERT INTO `comm_address_area` VALUES ('621002000000', '621000000000', 3, 0, '西峰区');
INSERT INTO `comm_address_area` VALUES ('621021000000', '621000000000', 3, 0, '庆城县');
INSERT INTO `comm_address_area` VALUES ('621022000000', '621000000000', 3, 0, '环县');
INSERT INTO `comm_address_area` VALUES ('621023000000', '621000000000', 3, 0, '华池县');
INSERT INTO `comm_address_area` VALUES ('621024000000', '621000000000', 3, 0, '合水县');
INSERT INTO `comm_address_area` VALUES ('621025000000', '621000000000', 3, 0, '正宁县');
INSERT INTO `comm_address_area` VALUES ('621026000000', '621000000000', 3, 0, '宁县');
INSERT INTO `comm_address_area` VALUES ('621027000000', '621000000000', 3, 0, '镇原县');
INSERT INTO `comm_address_area` VALUES ('621100000000', '620000000000', 2, 0, '定西市');
INSERT INTO `comm_address_area` VALUES ('621102000000', '621100000000', 3, 0, '安定区');
INSERT INTO `comm_address_area` VALUES ('621121000000', '621100000000', 3, 0, '通渭县');
INSERT INTO `comm_address_area` VALUES ('621122000000', '621100000000', 3, 0, '陇西县');
INSERT INTO `comm_address_area` VALUES ('621123000000', '621100000000', 3, 0, '渭源县');
INSERT INTO `comm_address_area` VALUES ('621124000000', '621100000000', 3, 0, '临洮县');
INSERT INTO `comm_address_area` VALUES ('621125000000', '621100000000', 3, 0, '漳县');
INSERT INTO `comm_address_area` VALUES ('621126000000', '621100000000', 3, 0, '岷县');
INSERT INTO `comm_address_area` VALUES ('621200000000', '620000000000', 2, 0, '陇南市');
INSERT INTO `comm_address_area` VALUES ('621202000000', '621200000000', 3, 0, '武都区');
INSERT INTO `comm_address_area` VALUES ('621221000000', '621200000000', 3, 0, '成县');
INSERT INTO `comm_address_area` VALUES ('621222000000', '621200000000', 3, 0, '文县');
INSERT INTO `comm_address_area` VALUES ('621223000000', '621200000000', 3, 0, '宕昌县');
INSERT INTO `comm_address_area` VALUES ('621224000000', '621200000000', 3, 0, '康县');
INSERT INTO `comm_address_area` VALUES ('621225000000', '621200000000', 3, 0, '西和县');
INSERT INTO `comm_address_area` VALUES ('621226000000', '621200000000', 3, 0, '礼县');
INSERT INTO `comm_address_area` VALUES ('621227000000', '621200000000', 3, 0, '徽县');
INSERT INTO `comm_address_area` VALUES ('621228000000', '621200000000', 3, 0, '两当县');
INSERT INTO `comm_address_area` VALUES ('622900000000', '620000000000', 2, 0, '临夏回族自治州');
INSERT INTO `comm_address_area` VALUES ('622901000000', '622900000000', 3, 0, '临夏市');
INSERT INTO `comm_address_area` VALUES ('622921000000', '622900000000', 3, 0, '临夏县');
INSERT INTO `comm_address_area` VALUES ('622922000000', '622900000000', 3, 0, '康乐县');
INSERT INTO `comm_address_area` VALUES ('622923000000', '622900000000', 3, 0, '永靖县');
INSERT INTO `comm_address_area` VALUES ('622924000000', '622900000000', 3, 0, '广河县');
INSERT INTO `comm_address_area` VALUES ('622925000000', '622900000000', 3, 0, '和政县');
INSERT INTO `comm_address_area` VALUES ('622926000000', '622900000000', 3, 0, '东乡族自治县');
INSERT INTO `comm_address_area` VALUES ('622927000000', '622900000000', 3, 0, '积石山保安族东乡族撒拉族自治县');
INSERT INTO `comm_address_area` VALUES ('623000000000', '620000000000', 2, 0, '甘南藏族自治州');
INSERT INTO `comm_address_area` VALUES ('623001000000', '623000000000', 3, 0, '合作市');
INSERT INTO `comm_address_area` VALUES ('623021000000', '623000000000', 3, 0, '临潭县');
INSERT INTO `comm_address_area` VALUES ('623022000000', '623000000000', 3, 0, '卓尼县');
INSERT INTO `comm_address_area` VALUES ('623023000000', '623000000000', 3, 0, '舟曲县');
INSERT INTO `comm_address_area` VALUES ('623024000000', '623000000000', 3, 0, '迭部县');
INSERT INTO `comm_address_area` VALUES ('623025000000', '623000000000', 3, 0, '玛曲县');
INSERT INTO `comm_address_area` VALUES ('623026000000', '623000000000', 3, 0, '碌曲县');
INSERT INTO `comm_address_area` VALUES ('623027000000', '623000000000', 3, 0, '夏河县');
INSERT INTO `comm_address_area` VALUES ('440000000000', '0', 1, 0, '广东省');
INSERT INTO `comm_address_area` VALUES ('440100000000', '440000000000', 2, 0, '广州市');
INSERT INTO `comm_address_area` VALUES ('440103000000', '440100000000', 3, 0, '荔湾区');
INSERT INTO `comm_address_area` VALUES ('440104000000', '440100000000', 3, 0, '越秀区');
INSERT INTO `comm_address_area` VALUES ('440105000000', '440100000000', 3, 0, '海珠区');
INSERT INTO `comm_address_area` VALUES ('440106000000', '440100000000', 3, 0, '天河区');
INSERT INTO `comm_address_area` VALUES ('440111000000', '440100000000', 3, 0, '白云区');
INSERT INTO `comm_address_area` VALUES ('440112000000', '440100000000', 3, 0, '黄埔区');
INSERT INTO `comm_address_area` VALUES ('440113000000', '440100000000', 3, 0, '番禺区');
INSERT INTO `comm_address_area` VALUES ('440114000000', '440100000000', 3, 0, '花都区');
INSERT INTO `comm_address_area` VALUES ('440115000000', '440100000000', 3, 0, '南沙区');
INSERT INTO `comm_address_area` VALUES ('440116000000', '440100000000', 3, 0, '萝岗区');
INSERT INTO `comm_address_area` VALUES ('440183000000', '440100000000', 3, 0, '增城市');
INSERT INTO `comm_address_area` VALUES ('440184000000', '440100000000', 3, 0, '从化市');
INSERT INTO `comm_address_area` VALUES ('440200000000', '440000000000', 2, 0, '韶关市');
INSERT INTO `comm_address_area` VALUES ('440203000000', '440200000000', 3, 0, '武江区');
INSERT INTO `comm_address_area` VALUES ('440204000000', '440200000000', 3, 0, '浈江区');
INSERT INTO `comm_address_area` VALUES ('440205000000', '440200000000', 3, 0, '曲江区');
INSERT INTO `comm_address_area` VALUES ('440222000000', '440200000000', 3, 0, '始兴县');
INSERT INTO `comm_address_area` VALUES ('440224000000', '440200000000', 3, 0, '仁化县');
INSERT INTO `comm_address_area` VALUES ('440229000000', '440200000000', 3, 0, '翁源县');
INSERT INTO `comm_address_area` VALUES ('440232000000', '440200000000', 3, 0, '乳源瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('440233000000', '440200000000', 3, 0, '新丰县');
INSERT INTO `comm_address_area` VALUES ('440281000000', '440200000000', 3, 0, '乐昌市');
INSERT INTO `comm_address_area` VALUES ('440282000000', '440200000000', 3, 0, '南雄市');
INSERT INTO `comm_address_area` VALUES ('440300000000', '440000000000', 2, 0, '深圳市');
INSERT INTO `comm_address_area` VALUES ('440303000000', '440300000000', 3, 0, '罗湖区');
INSERT INTO `comm_address_area` VALUES ('440304000000', '440300000000', 3, 0, '福田区');
INSERT INTO `comm_address_area` VALUES ('440305000000', '440300000000', 3, 0, '南山区');
INSERT INTO `comm_address_area` VALUES ('440306000000', '440300000000', 3, 0, '宝安区');
INSERT INTO `comm_address_area` VALUES ('440307000000', '440300000000', 3, 0, '龙岗区');
INSERT INTO `comm_address_area` VALUES ('440308000000', '440300000000', 3, 0, '盐田区');
INSERT INTO `comm_address_area` VALUES ('440400000000', '440000000000', 2, 0, '珠海市');
INSERT INTO `comm_address_area` VALUES ('440402000000', '440400000000', 3, 0, '香洲区');
INSERT INTO `comm_address_area` VALUES ('440403000000', '440400000000', 3, 0, '斗门区');
INSERT INTO `comm_address_area` VALUES ('440404000000', '440400000000', 3, 0, '金湾区');
INSERT INTO `comm_address_area` VALUES ('440500000000', '440000000000', 2, 0, '汕头市');
INSERT INTO `comm_address_area` VALUES ('440507000000', '440500000000', 3, 0, '龙湖区');
INSERT INTO `comm_address_area` VALUES ('440511000000', '440500000000', 3, 0, '金平区');
INSERT INTO `comm_address_area` VALUES ('440512000000', '440500000000', 3, 0, '濠江区');
INSERT INTO `comm_address_area` VALUES ('440513000000', '440500000000', 3, 0, '潮阳区');
INSERT INTO `comm_address_area` VALUES ('440514000000', '440500000000', 3, 0, '潮南区');
INSERT INTO `comm_address_area` VALUES ('440515000000', '440500000000', 3, 0, '澄海区');
INSERT INTO `comm_address_area` VALUES ('440523000000', '440500000000', 3, 0, '南澳县');
INSERT INTO `comm_address_area` VALUES ('440600000000', '440000000000', 2, 0, '佛山市');
INSERT INTO `comm_address_area` VALUES ('440604000000', '440600000000', 3, 0, '禅城区');
INSERT INTO `comm_address_area` VALUES ('440605000000', '440600000000', 3, 0, '南海区');
INSERT INTO `comm_address_area` VALUES ('440606000000', '440600000000', 3, 0, '顺德区');
INSERT INTO `comm_address_area` VALUES ('440607000000', '440600000000', 3, 0, '三水区');
INSERT INTO `comm_address_area` VALUES ('440608000000', '440600000000', 3, 0, '高明区');
INSERT INTO `comm_address_area` VALUES ('440700000000', '440000000000', 2, 0, '江门市');
INSERT INTO `comm_address_area` VALUES ('440703000000', '440700000000', 3, 0, '蓬江区');
INSERT INTO `comm_address_area` VALUES ('440704000000', '440700000000', 3, 0, '江海区');
INSERT INTO `comm_address_area` VALUES ('440705000000', '440700000000', 3, 0, '新会区');
INSERT INTO `comm_address_area` VALUES ('440781000000', '440700000000', 3, 0, '台山市');
INSERT INTO `comm_address_area` VALUES ('440783000000', '440700000000', 3, 0, '开平市');
INSERT INTO `comm_address_area` VALUES ('440784000000', '440700000000', 3, 0, '鹤山市');
INSERT INTO `comm_address_area` VALUES ('440785000000', '440700000000', 3, 0, '恩平市');
INSERT INTO `comm_address_area` VALUES ('440800000000', '440000000000', 2, 0, '湛江市');
INSERT INTO `comm_address_area` VALUES ('440802000000', '440800000000', 3, 0, '赤坎区');
INSERT INTO `comm_address_area` VALUES ('440803000000', '440800000000', 3, 0, '霞山区');
INSERT INTO `comm_address_area` VALUES ('440804000000', '440800000000', 3, 0, '坡头区');
INSERT INTO `comm_address_area` VALUES ('440811000000', '440800000000', 3, 0, '麻章区');
INSERT INTO `comm_address_area` VALUES ('440823000000', '440800000000', 3, 0, '遂溪县');
INSERT INTO `comm_address_area` VALUES ('440825000000', '440800000000', 3, 0, '徐闻县');
INSERT INTO `comm_address_area` VALUES ('440881000000', '440800000000', 3, 0, '廉江市');
INSERT INTO `comm_address_area` VALUES ('440882000000', '440800000000', 3, 0, '雷州市');
INSERT INTO `comm_address_area` VALUES ('440883000000', '440800000000', 3, 0, '吴川市');
INSERT INTO `comm_address_area` VALUES ('440900000000', '440000000000', 2, 0, '茂名市');
INSERT INTO `comm_address_area` VALUES ('440902000000', '440900000000', 3, 0, '茂南区');
INSERT INTO `comm_address_area` VALUES ('440903000000', '440900000000', 3, 0, '茂港区');
INSERT INTO `comm_address_area` VALUES ('440923000000', '440900000000', 3, 0, '电白县');
INSERT INTO `comm_address_area` VALUES ('440981000000', '440900000000', 3, 0, '高州市');
INSERT INTO `comm_address_area` VALUES ('440982000000', '440900000000', 3, 0, '化州市');
INSERT INTO `comm_address_area` VALUES ('440983000000', '440900000000', 3, 0, '信宜市');
INSERT INTO `comm_address_area` VALUES ('441200000000', '440000000000', 2, 0, '肇庆市');
INSERT INTO `comm_address_area` VALUES ('441202000000', '441200000000', 3, 0, '端州区');
INSERT INTO `comm_address_area` VALUES ('441203000000', '441200000000', 3, 0, '鼎湖区');
INSERT INTO `comm_address_area` VALUES ('441223000000', '441200000000', 3, 0, '广宁县');
INSERT INTO `comm_address_area` VALUES ('441224000000', '441200000000', 3, 0, '怀集县');
INSERT INTO `comm_address_area` VALUES ('441225000000', '441200000000', 3, 0, '封开县');
INSERT INTO `comm_address_area` VALUES ('441226000000', '441200000000', 3, 0, '德庆县');
INSERT INTO `comm_address_area` VALUES ('441283000000', '441200000000', 3, 0, '高要市');
INSERT INTO `comm_address_area` VALUES ('441284000000', '441200000000', 3, 0, '四会市');
INSERT INTO `comm_address_area` VALUES ('441300000000', '440000000000', 2, 0, '惠州市');
INSERT INTO `comm_address_area` VALUES ('441302000000', '441300000000', 3, 0, '惠城区');
INSERT INTO `comm_address_area` VALUES ('441303000000', '441300000000', 3, 0, '惠阳区');
INSERT INTO `comm_address_area` VALUES ('441322000000', '441300000000', 3, 0, '博罗县');
INSERT INTO `comm_address_area` VALUES ('441323000000', '441300000000', 3, 0, '惠东县');
INSERT INTO `comm_address_area` VALUES ('441324000000', '441300000000', 3, 0, '龙门县');
INSERT INTO `comm_address_area` VALUES ('441400000000', '440000000000', 2, 0, '梅州市');
INSERT INTO `comm_address_area` VALUES ('441402000000', '441400000000', 3, 0, '梅江区');
INSERT INTO `comm_address_area` VALUES ('441421000000', '441400000000', 3, 0, '梅县');
INSERT INTO `comm_address_area` VALUES ('441422000000', '441400000000', 3, 0, '大埔县');
INSERT INTO `comm_address_area` VALUES ('441423000000', '441400000000', 3, 0, '丰顺县');
INSERT INTO `comm_address_area` VALUES ('441424000000', '441400000000', 3, 0, '五华县');
INSERT INTO `comm_address_area` VALUES ('441426000000', '441400000000', 3, 0, '平远县');
INSERT INTO `comm_address_area` VALUES ('441427000000', '441400000000', 3, 0, '蕉岭县');
INSERT INTO `comm_address_area` VALUES ('441481000000', '441400000000', 3, 0, '兴宁市');
INSERT INTO `comm_address_area` VALUES ('441500000000', '440000000000', 2, 0, '汕尾市');
INSERT INTO `comm_address_area` VALUES ('441502000000', '441500000000', 3, 0, '城区');
INSERT INTO `comm_address_area` VALUES ('441521000000', '441500000000', 3, 0, '海丰县');
INSERT INTO `comm_address_area` VALUES ('441523000000', '441500000000', 3, 0, '陆河县');
INSERT INTO `comm_address_area` VALUES ('441581000000', '441500000000', 3, 0, '陆丰市');
INSERT INTO `comm_address_area` VALUES ('441600000000', '440000000000', 2, 0, '河源市');
INSERT INTO `comm_address_area` VALUES ('441602000000', '441600000000', 3, 0, '源城区');
INSERT INTO `comm_address_area` VALUES ('441621000000', '441600000000', 3, 0, '紫金县');
INSERT INTO `comm_address_area` VALUES ('441622000000', '441600000000', 3, 0, '龙川县');
INSERT INTO `comm_address_area` VALUES ('441623000000', '441600000000', 3, 0, '连平县');
INSERT INTO `comm_address_area` VALUES ('441624000000', '441600000000', 3, 0, '和平县');
INSERT INTO `comm_address_area` VALUES ('441625000000', '441600000000', 3, 0, '东源县');
INSERT INTO `comm_address_area` VALUES ('441700000000', '440000000000', 2, 0, '阳江市');
INSERT INTO `comm_address_area` VALUES ('441702000000', '441700000000', 3, 0, '江城区');
INSERT INTO `comm_address_area` VALUES ('441721000000', '441700000000', 3, 0, '阳西县');
INSERT INTO `comm_address_area` VALUES ('441723000000', '441700000000', 3, 0, '阳东县');
INSERT INTO `comm_address_area` VALUES ('441781000000', '441700000000', 3, 0, '阳春市');
INSERT INTO `comm_address_area` VALUES ('441800000000', '440000000000', 2, 0, '清远市');
INSERT INTO `comm_address_area` VALUES ('441802000000', '441800000000', 3, 0, '清城区');
INSERT INTO `comm_address_area` VALUES ('441821000000', '441800000000', 3, 0, '佛冈县');
INSERT INTO `comm_address_area` VALUES ('441823000000', '441800000000', 3, 0, '阳山县');
INSERT INTO `comm_address_area` VALUES ('441825000000', '441800000000', 3, 0, '连山壮族瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('441826000000', '441800000000', 3, 0, '连南瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('441827000000', '441800000000', 3, 0, '清新县');
INSERT INTO `comm_address_area` VALUES ('441881000000', '441800000000', 3, 0, '英德市');
INSERT INTO `comm_address_area` VALUES ('441882000000', '441800000000', 3, 0, '连州市');
INSERT INTO `comm_address_area` VALUES ('441900000000', '440000000000', 2, 0, '东莞市');
INSERT INTO `comm_address_area` VALUES ('441900003000', '441900000000', 3, 0, '东城街道办事处');
INSERT INTO `comm_address_area` VALUES ('441900004000', '441900000000', 3, 0, '南城街道办事处');
INSERT INTO `comm_address_area` VALUES ('441900005000', '441900000000', 3, 0, '万江街道办事处');
INSERT INTO `comm_address_area` VALUES ('441900006000', '441900000000', 3, 0, '莞城街道办事处');
INSERT INTO `comm_address_area` VALUES ('441900101000', '441900000000', 3, 0, '石碣镇');
INSERT INTO `comm_address_area` VALUES ('441900102000', '441900000000', 3, 0, '石龙镇');
INSERT INTO `comm_address_area` VALUES ('441900103000', '441900000000', 3, 0, '茶山镇');
INSERT INTO `comm_address_area` VALUES ('441900104000', '441900000000', 3, 0, '石排镇');
INSERT INTO `comm_address_area` VALUES ('441900105000', '441900000000', 3, 0, '企石镇');
INSERT INTO `comm_address_area` VALUES ('441900106000', '441900000000', 3, 0, '横沥镇');
INSERT INTO `comm_address_area` VALUES ('441900107000', '441900000000', 3, 0, '桥头镇');
INSERT INTO `comm_address_area` VALUES ('441900108000', '441900000000', 3, 0, '谢岗镇');
INSERT INTO `comm_address_area` VALUES ('441900109000', '441900000000', 3, 0, '东坑镇');
INSERT INTO `comm_address_area` VALUES ('441900110000', '441900000000', 3, 0, '常平镇');
INSERT INTO `comm_address_area` VALUES ('441900111000', '441900000000', 3, 0, '寮步镇');
INSERT INTO `comm_address_area` VALUES ('441900112000', '441900000000', 3, 0, '樟木头镇');
INSERT INTO `comm_address_area` VALUES ('441900113000', '441900000000', 3, 0, '大朗镇');
INSERT INTO `comm_address_area` VALUES ('441900114000', '441900000000', 3, 0, '黄江镇');
INSERT INTO `comm_address_area` VALUES ('441900115000', '441900000000', 3, 0, '清溪镇');
INSERT INTO `comm_address_area` VALUES ('441900116000', '441900000000', 3, 0, '塘厦镇');
INSERT INTO `comm_address_area` VALUES ('441900117000', '441900000000', 3, 0, '凤岗镇');
INSERT INTO `comm_address_area` VALUES ('441900118000', '441900000000', 3, 0, '大岭山镇');
INSERT INTO `comm_address_area` VALUES ('441900119000', '441900000000', 3, 0, '长安镇');
INSERT INTO `comm_address_area` VALUES ('441900121000', '441900000000', 3, 0, '虎门镇');
INSERT INTO `comm_address_area` VALUES ('441900122000', '441900000000', 3, 0, '厚街镇');
INSERT INTO `comm_address_area` VALUES ('441900123000', '441900000000', 3, 0, '沙田镇');
INSERT INTO `comm_address_area` VALUES ('441900124000', '441900000000', 3, 0, '道滘镇');
INSERT INTO `comm_address_area` VALUES ('441900125000', '441900000000', 3, 0, '洪梅镇');
INSERT INTO `comm_address_area` VALUES ('441900126000', '441900000000', 3, 0, '麻涌镇');
INSERT INTO `comm_address_area` VALUES ('441900127000', '441900000000', 3, 0, '望牛墩镇');
INSERT INTO `comm_address_area` VALUES ('441900128000', '441900000000', 3, 0, '中堂镇');
INSERT INTO `comm_address_area` VALUES ('441900129000', '441900000000', 3, 0, '高埗镇');
INSERT INTO `comm_address_area` VALUES ('441900401000', '441900000000', 3, 0, '松山湖管委会');
INSERT INTO `comm_address_area` VALUES ('441900402000', '441900000000', 3, 0, '虎门港管委会');
INSERT INTO `comm_address_area` VALUES ('441900403000', '441900000000', 3, 0, '东莞生态园');
INSERT INTO `comm_address_area` VALUES ('442000000000', '440000000000', 2, 0, '中山市');
INSERT INTO `comm_address_area` VALUES ('442000001000', '442000000000', 3, 0, '石岐区街道办事处');
INSERT INTO `comm_address_area` VALUES ('442000002000', '442000000000', 3, 0, '东区街道办事处');
INSERT INTO `comm_address_area` VALUES ('442000003000', '442000000000', 3, 0, '火炬开发区街道办事处');
INSERT INTO `comm_address_area` VALUES ('442000004000', '442000000000', 3, 0, '西区街道办事处');
INSERT INTO `comm_address_area` VALUES ('442000005000', '442000000000', 3, 0, '南区街道办事处');
INSERT INTO `comm_address_area` VALUES ('442000006000', '442000000000', 3, 0, '五桂山街道办事处');
INSERT INTO `comm_address_area` VALUES ('442000100000', '442000000000', 3, 0, '小榄镇');
INSERT INTO `comm_address_area` VALUES ('442000101000', '442000000000', 3, 0, '黄圃镇');
INSERT INTO `comm_address_area` VALUES ('442000102000', '442000000000', 3, 0, '民众镇');
INSERT INTO `comm_address_area` VALUES ('442000103000', '442000000000', 3, 0, '东凤镇');
INSERT INTO `comm_address_area` VALUES ('442000104000', '442000000000', 3, 0, '东升镇');
INSERT INTO `comm_address_area` VALUES ('442000105000', '442000000000', 3, 0, '古镇镇');
INSERT INTO `comm_address_area` VALUES ('442000106000', '442000000000', 3, 0, '沙溪镇');
INSERT INTO `comm_address_area` VALUES ('442000107000', '442000000000', 3, 0, '坦洲镇');
INSERT INTO `comm_address_area` VALUES ('442000108000', '442000000000', 3, 0, '港口镇');
INSERT INTO `comm_address_area` VALUES ('442000109000', '442000000000', 3, 0, '三角镇');
INSERT INTO `comm_address_area` VALUES ('442000110000', '442000000000', 3, 0, '横栏镇');
INSERT INTO `comm_address_area` VALUES ('442000111000', '442000000000', 3, 0, '南头镇');
INSERT INTO `comm_address_area` VALUES ('442000112000', '442000000000', 3, 0, '阜沙镇');
INSERT INTO `comm_address_area` VALUES ('442000113000', '442000000000', 3, 0, '南朗镇');
INSERT INTO `comm_address_area` VALUES ('442000114000', '442000000000', 3, 0, '三乡镇');
INSERT INTO `comm_address_area` VALUES ('442000115000', '442000000000', 3, 0, '板芙镇');
INSERT INTO `comm_address_area` VALUES ('442000116000', '442000000000', 3, 0, '大涌镇');
INSERT INTO `comm_address_area` VALUES ('442000117000', '442000000000', 3, 0, '神湾镇');
INSERT INTO `comm_address_area` VALUES ('445100000000', '440000000000', 2, 0, '潮州市');
INSERT INTO `comm_address_area` VALUES ('445102000000', '445100000000', 3, 0, '湘桥区');
INSERT INTO `comm_address_area` VALUES ('445121000000', '445100000000', 3, 0, '潮安县');
INSERT INTO `comm_address_area` VALUES ('445122000000', '445100000000', 3, 0, '饶平县');
INSERT INTO `comm_address_area` VALUES ('445200000000', '440000000000', 2, 0, '揭阳市');
INSERT INTO `comm_address_area` VALUES ('445202000000', '445200000000', 3, 0, '榕城区');
INSERT INTO `comm_address_area` VALUES ('445221000000', '445200000000', 3, 0, '揭东县');
INSERT INTO `comm_address_area` VALUES ('445222000000', '445200000000', 3, 0, '揭西县');
INSERT INTO `comm_address_area` VALUES ('445224000000', '445200000000', 3, 0, '惠来县');
INSERT INTO `comm_address_area` VALUES ('445281000000', '445200000000', 3, 0, '普宁市');
INSERT INTO `comm_address_area` VALUES ('445300000000', '440000000000', 2, 0, '云浮市');
INSERT INTO `comm_address_area` VALUES ('445302000000', '445300000000', 3, 0, '云城区');
INSERT INTO `comm_address_area` VALUES ('445321000000', '445300000000', 3, 0, '新兴县');
INSERT INTO `comm_address_area` VALUES ('445322000000', '445300000000', 3, 0, '郁南县');
INSERT INTO `comm_address_area` VALUES ('445323000000', '445300000000', 3, 0, '云安县');
INSERT INTO `comm_address_area` VALUES ('445381000000', '445300000000', 3, 0, '罗定市');
INSERT INTO `comm_address_area` VALUES ('450000000000', '0', 1, 0, '广西壮族自治区');
INSERT INTO `comm_address_area` VALUES ('450100000000', '450000000000', 2, 0, '南宁市');
INSERT INTO `comm_address_area` VALUES ('450102000000', '450100000000', 3, 0, '兴宁区');
INSERT INTO `comm_address_area` VALUES ('450103000000', '450100000000', 3, 0, '青秀区');
INSERT INTO `comm_address_area` VALUES ('450105000000', '450100000000', 3, 0, '江南区');
INSERT INTO `comm_address_area` VALUES ('450107000000', '450100000000', 3, 0, '西乡塘区');
INSERT INTO `comm_address_area` VALUES ('450108000000', '450100000000', 3, 0, '良庆区');
INSERT INTO `comm_address_area` VALUES ('450127000000', '450100000000', 3, 0, '横县');
INSERT INTO `comm_address_area` VALUES ('450224000000', '450200000000', 3, 0, '融安县');
INSERT INTO `comm_address_area` VALUES ('450225000000', '450200000000', 3, 0, '融水苗族自治县');
INSERT INTO `comm_address_area` VALUES ('450109000000', '450100000000', 3, 0, '邕宁区');
INSERT INTO `comm_address_area` VALUES ('450122000000', '450100000000', 3, 0, '武鸣县');
INSERT INTO `comm_address_area` VALUES ('450123000000', '450100000000', 3, 0, '隆安县');
INSERT INTO `comm_address_area` VALUES ('450124000000', '450100000000', 3, 0, '马山县');
INSERT INTO `comm_address_area` VALUES ('450125000000', '450100000000', 3, 0, '上林县');
INSERT INTO `comm_address_area` VALUES ('450126000000', '450100000000', 3, 0, '宾阳县');
INSERT INTO `comm_address_area` VALUES ('450200000000', '450000000000', 2, 0, '柳州市');
INSERT INTO `comm_address_area` VALUES ('450202000000', '450200000000', 3, 0, '城中区');
INSERT INTO `comm_address_area` VALUES ('450203000000', '450200000000', 3, 0, '鱼峰区');
INSERT INTO `comm_address_area` VALUES ('450204000000', '450200000000', 3, 0, '柳南区');
INSERT INTO `comm_address_area` VALUES ('450205000000', '450200000000', 3, 0, '柳北区');
INSERT INTO `comm_address_area` VALUES ('450221000000', '450200000000', 3, 0, '柳江县');
INSERT INTO `comm_address_area` VALUES ('450222000000', '450200000000', 3, 0, '柳城县');
INSERT INTO `comm_address_area` VALUES ('450223000000', '450200000000', 3, 0, '鹿寨县');
INSERT INTO `comm_address_area` VALUES ('450226000000', '450200000000', 3, 0, '三江侗族自治县');
INSERT INTO `comm_address_area` VALUES ('450300000000', '450000000000', 2, 0, '桂林市');
INSERT INTO `comm_address_area` VALUES ('450302000000', '450300000000', 3, 0, '秀峰区');
INSERT INTO `comm_address_area` VALUES ('450303000000', '450300000000', 3, 0, '叠彩区');
INSERT INTO `comm_address_area` VALUES ('450304000000', '450300000000', 3, 0, '象山区');
INSERT INTO `comm_address_area` VALUES ('450305000000', '450300000000', 3, 0, '七星区');
INSERT INTO `comm_address_area` VALUES ('450311000000', '450300000000', 3, 0, '雁山区');
INSERT INTO `comm_address_area` VALUES ('450321000000', '450300000000', 3, 0, '阳朔县');
INSERT INTO `comm_address_area` VALUES ('450322000000', '450300000000', 3, 0, '临桂县');
INSERT INTO `comm_address_area` VALUES ('450323000000', '450300000000', 3, 0, '灵川县');
INSERT INTO `comm_address_area` VALUES ('450324000000', '450300000000', 3, 0, '全州县');
INSERT INTO `comm_address_area` VALUES ('450325000000', '450300000000', 3, 0, '兴安县');
INSERT INTO `comm_address_area` VALUES ('450326000000', '450300000000', 3, 0, '永福县');
INSERT INTO `comm_address_area` VALUES ('450327000000', '450300000000', 3, 0, '灌阳县');
INSERT INTO `comm_address_area` VALUES ('450328000000', '450300000000', 3, 0, '龙胜各族自治县');
INSERT INTO `comm_address_area` VALUES ('450329000000', '450300000000', 3, 0, '资源县');
INSERT INTO `comm_address_area` VALUES ('450330000000', '450300000000', 3, 0, '平乐县');
INSERT INTO `comm_address_area` VALUES ('450331000000', '450300000000', 3, 0, '荔蒲县');
INSERT INTO `comm_address_area` VALUES ('450332000000', '450300000000', 3, 0, '恭城瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('450400000000', '450000000000', 2, 0, '梧州市');
INSERT INTO `comm_address_area` VALUES ('450403000000', '450400000000', 3, 0, '万秀区');
INSERT INTO `comm_address_area` VALUES ('450404000000', '450400000000', 3, 0, '蝶山区');
INSERT INTO `comm_address_area` VALUES ('450405000000', '450400000000', 3, 0, '长洲区');
INSERT INTO `comm_address_area` VALUES ('450421000000', '450400000000', 3, 0, '苍梧县');
INSERT INTO `comm_address_area` VALUES ('450422000000', '450400000000', 3, 0, '藤县');
INSERT INTO `comm_address_area` VALUES ('450423000000', '450400000000', 3, 0, '蒙山县');
INSERT INTO `comm_address_area` VALUES ('450481000000', '450400000000', 3, 0, '岑溪市');
INSERT INTO `comm_address_area` VALUES ('450500000000', '450000000000', 2, 0, '北海市');
INSERT INTO `comm_address_area` VALUES ('450502000000', '450500000000', 3, 0, '海城区');
INSERT INTO `comm_address_area` VALUES ('450503000000', '450500000000', 3, 0, '银海区');
INSERT INTO `comm_address_area` VALUES ('450512000000', '450500000000', 3, 0, '铁山港区');
INSERT INTO `comm_address_area` VALUES ('450521000000', '450500000000', 3, 0, '合浦县');
INSERT INTO `comm_address_area` VALUES ('450600000000', '450000000000', 2, 0, '防城港市');
INSERT INTO `comm_address_area` VALUES ('450602000000', '450600000000', 3, 0, '港口区');
INSERT INTO `comm_address_area` VALUES ('450603000000', '450600000000', 3, 0, '防城区');
INSERT INTO `comm_address_area` VALUES ('450621000000', '450600000000', 3, 0, '上思县');
INSERT INTO `comm_address_area` VALUES ('450681000000', '450600000000', 3, 0, '东兴市');
INSERT INTO `comm_address_area` VALUES ('450700000000', '450000000000', 2, 0, '钦州市');
INSERT INTO `comm_address_area` VALUES ('450702000000', '450700000000', 3, 0, '钦南区');
INSERT INTO `comm_address_area` VALUES ('450703000000', '450700000000', 3, 0, '钦北区');
INSERT INTO `comm_address_area` VALUES ('450721000000', '450700000000', 3, 0, '灵山县');
INSERT INTO `comm_address_area` VALUES ('450722000000', '450700000000', 3, 0, '浦北县');
INSERT INTO `comm_address_area` VALUES ('450800000000', '450000000000', 2, 0, '贵港市');
INSERT INTO `comm_address_area` VALUES ('450802000000', '450800000000', 3, 0, '港北区');
INSERT INTO `comm_address_area` VALUES ('450803000000', '450800000000', 3, 0, '港南区');
INSERT INTO `comm_address_area` VALUES ('450804000000', '450800000000', 3, 0, '覃塘区');
INSERT INTO `comm_address_area` VALUES ('450821000000', '450800000000', 3, 0, '平南县');
INSERT INTO `comm_address_area` VALUES ('450881000000', '450800000000', 3, 0, '桂平市');
INSERT INTO `comm_address_area` VALUES ('450900000000', '450000000000', 2, 0, '玉林市');
INSERT INTO `comm_address_area` VALUES ('450902000000', '450900000000', 3, 0, '玉州区');
INSERT INTO `comm_address_area` VALUES ('450921000000', '450900000000', 3, 0, '容县');
INSERT INTO `comm_address_area` VALUES ('450922000000', '450900000000', 3, 0, '陆川县');
INSERT INTO `comm_address_area` VALUES ('450923000000', '450900000000', 3, 0, '博白县');
INSERT INTO `comm_address_area` VALUES ('450924000000', '450900000000', 3, 0, '兴业县');
INSERT INTO `comm_address_area` VALUES ('450981000000', '450900000000', 3, 0, '北流市');
INSERT INTO `comm_address_area` VALUES ('451000000000', '450000000000', 2, 0, '百色市');
INSERT INTO `comm_address_area` VALUES ('451002000000', '451000000000', 3, 0, '右江区');
INSERT INTO `comm_address_area` VALUES ('451021000000', '451000000000', 3, 0, '田阳县');
INSERT INTO `comm_address_area` VALUES ('451022000000', '451000000000', 3, 0, '田东县');
INSERT INTO `comm_address_area` VALUES ('451023000000', '451000000000', 3, 0, '平果县');
INSERT INTO `comm_address_area` VALUES ('451024000000', '451000000000', 3, 0, '德保县');
INSERT INTO `comm_address_area` VALUES ('451025000000', '451000000000', 3, 0, '靖西县');
INSERT INTO `comm_address_area` VALUES ('451026000000', '451000000000', 3, 0, '那坡县');
INSERT INTO `comm_address_area` VALUES ('451027000000', '451000000000', 3, 0, '凌云县');
INSERT INTO `comm_address_area` VALUES ('451028000000', '451000000000', 3, 0, '乐业县');
INSERT INTO `comm_address_area` VALUES ('451029000000', '451000000000', 3, 0, '田林县');
INSERT INTO `comm_address_area` VALUES ('451030000000', '451000000000', 3, 0, '西林县');
INSERT INTO `comm_address_area` VALUES ('451031000000', '451000000000', 3, 0, '隆林各族自治县');
INSERT INTO `comm_address_area` VALUES ('451100000000', '450000000000', 2, 0, '贺州市');
INSERT INTO `comm_address_area` VALUES ('451102000000', '451100000000', 3, 0, '八步区');
INSERT INTO `comm_address_area` VALUES ('451119000000', '451100000000', 3, 0, '平桂管理区');
INSERT INTO `comm_address_area` VALUES ('451121000000', '451100000000', 3, 0, '昭平县');
INSERT INTO `comm_address_area` VALUES ('451122000000', '451100000000', 3, 0, '钟山县');
INSERT INTO `comm_address_area` VALUES ('451123000000', '451100000000', 3, 0, '富川瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('451200000000', '450000000000', 2, 0, '河池市');
INSERT INTO `comm_address_area` VALUES ('451202000000', '451200000000', 3, 0, '金城江区');
INSERT INTO `comm_address_area` VALUES ('451221000000', '451200000000', 3, 0, '南丹县');
INSERT INTO `comm_address_area` VALUES ('451222000000', '451200000000', 3, 0, '天峨县');
INSERT INTO `comm_address_area` VALUES ('451223000000', '451200000000', 3, 0, '凤山县');
INSERT INTO `comm_address_area` VALUES ('451224000000', '451200000000', 3, 0, '东兰县');
INSERT INTO `comm_address_area` VALUES ('451225000000', '451200000000', 3, 0, '罗城仫佬族自治县');
INSERT INTO `comm_address_area` VALUES ('451226000000', '451200000000', 3, 0, '环江毛南族自治县');
INSERT INTO `comm_address_area` VALUES ('451227000000', '451200000000', 3, 0, '巴马瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('451228000000', '451200000000', 3, 0, '都安瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('451229000000', '451200000000', 3, 0, '大化瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('451281000000', '451200000000', 3, 0, '宜州市');
INSERT INTO `comm_address_area` VALUES ('451300000000', '450000000000', 2, 0, '来宾市');
INSERT INTO `comm_address_area` VALUES ('451302000000', '451300000000', 3, 0, '兴宾区');
INSERT INTO `comm_address_area` VALUES ('451321000000', '451300000000', 3, 0, '忻城县');
INSERT INTO `comm_address_area` VALUES ('451322000000', '451300000000', 3, 0, '象州县');
INSERT INTO `comm_address_area` VALUES ('451323000000', '451300000000', 3, 0, '武宣县');
INSERT INTO `comm_address_area` VALUES ('451324000000', '451300000000', 3, 0, '金秀瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('451381000000', '451300000000', 3, 0, '合山市');
INSERT INTO `comm_address_area` VALUES ('451400000000', '450000000000', 2, 0, '崇左市');
INSERT INTO `comm_address_area` VALUES ('451402000000', '451400000000', 3, 0, '江洲区');
INSERT INTO `comm_address_area` VALUES ('451421000000', '451400000000', 3, 0, '扶绥县');
INSERT INTO `comm_address_area` VALUES ('451422000000', '451400000000', 3, 0, '宁明县');
INSERT INTO `comm_address_area` VALUES ('451423000000', '451400000000', 3, 0, '龙州县');
INSERT INTO `comm_address_area` VALUES ('451424000000', '451400000000', 3, 0, '大新县');
INSERT INTO `comm_address_area` VALUES ('451425000000', '451400000000', 3, 0, '天等县');
INSERT INTO `comm_address_area` VALUES ('451481000000', '451400000000', 3, 0, '凭祥市');
INSERT INTO `comm_address_area` VALUES ('520000000000', '0', 1, 0, '贵州省');
INSERT INTO `comm_address_area` VALUES ('520527000000', '520500000000', 3, 0, '赫章县');
INSERT INTO `comm_address_area` VALUES ('460000000000', '0', 1, 0, '海南省');
INSERT INTO `comm_address_area` VALUES ('460100000000', '460000000000', 2, 0, '海口市');
INSERT INTO `comm_address_area` VALUES ('460105000000', '460100000000', 3, 0, '秀英区');
INSERT INTO `comm_address_area` VALUES ('460106000000', '460100000000', 3, 0, '龙华区');
INSERT INTO `comm_address_area` VALUES ('460107000000', '460100000000', 3, 0, '琼山区');
INSERT INTO `comm_address_area` VALUES ('460108000000', '460100000000', 3, 0, '美兰区');
INSERT INTO `comm_address_area` VALUES ('460200000000', '460000000000', 2, 0, '三亚市');
INSERT INTO `comm_address_area` VALUES ('469000000000', '460000000000', 2, 0, '省直辖县级行政区划');
INSERT INTO `comm_address_area` VALUES ('469001000000', '469000000000', 3, 0, '五指山市');
INSERT INTO `comm_address_area` VALUES ('469002000000', '469000000000', 3, 0, '琼海市');
INSERT INTO `comm_address_area` VALUES ('469003000000', '469000000000', 3, 0, '儋州市');
INSERT INTO `comm_address_area` VALUES ('469005000000', '469000000000', 3, 0, '文昌市');
INSERT INTO `comm_address_area` VALUES ('469021000000', '469000000000', 3, 0, '定安县');
INSERT INTO `comm_address_area` VALUES ('469006000000', '469000000000', 3, 0, '万宁市');
INSERT INTO `comm_address_area` VALUES ('469007000000', '469000000000', 3, 0, '东方市');
INSERT INTO `comm_address_area` VALUES ('469022000000', '469000000000', 3, 0, '屯昌县');
INSERT INTO `comm_address_area` VALUES ('469023000000', '469000000000', 3, 0, '澄迈县');
INSERT INTO `comm_address_area` VALUES ('469024000000', '469000000000', 3, 0, '临高县');
INSERT INTO `comm_address_area` VALUES ('469025000000', '469000000000', 3, 0, '白沙黎族自治县');
INSERT INTO `comm_address_area` VALUES ('469026000000', '469000000000', 3, 0, '昌江黎族自治县');
INSERT INTO `comm_address_area` VALUES ('469027000000', '469000000000', 3, 0, '乐东黎族自治县');
INSERT INTO `comm_address_area` VALUES ('469028000000', '469000000000', 3, 0, '陵水黎族自治县');
INSERT INTO `comm_address_area` VALUES ('469029000000', '469000000000', 3, 0, '保亭黎族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('469030000000', '469000000000', 3, 0, '琼中黎族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('469031000000', '469000000000', 3, 0, '西沙群岛');
INSERT INTO `comm_address_area` VALUES ('469032000000', '469000000000', 3, 0, '南沙群岛');
INSERT INTO `comm_address_area` VALUES ('469033000000', '469000000000', 3, 0, '中沙群岛的岛礁及其海域');
INSERT INTO `comm_address_area` VALUES ('130000000000', '0', 1, 0, '河北省');
INSERT INTO `comm_address_area` VALUES ('130100000000', '130000000000', 2, 0, '石家庄市');
INSERT INTO `comm_address_area` VALUES ('130102000000', '130100000000', 3, 0, '长安区');
INSERT INTO `comm_address_area` VALUES ('130103000000', '130100000000', 3, 0, '桥东区');
INSERT INTO `comm_address_area` VALUES ('130104000000', '130100000000', 3, 0, '桥西区');
INSERT INTO `comm_address_area` VALUES ('130105000000', '130100000000', 3, 0, '新华区');
INSERT INTO `comm_address_area` VALUES ('130107000000', '130100000000', 3, 0, '井陉矿区');
INSERT INTO `comm_address_area` VALUES ('130108000000', '130100000000', 3, 0, '裕华区');
INSERT INTO `comm_address_area` VALUES ('130121000000', '130100000000', 3, 0, '井陉县');
INSERT INTO `comm_address_area` VALUES ('130123000000', '130100000000', 3, 0, '正定县');
INSERT INTO `comm_address_area` VALUES ('130124000000', '130100000000', 3, 0, '栾城县');
INSERT INTO `comm_address_area` VALUES ('130125000000', '130100000000', 3, 0, '行唐县');
INSERT INTO `comm_address_area` VALUES ('130131000000', '130100000000', 3, 0, '平山县');
INSERT INTO `comm_address_area` VALUES ('130126000000', '130100000000', 3, 0, '灵寿县');
INSERT INTO `comm_address_area` VALUES ('130127000000', '130100000000', 3, 0, '高邑县');
INSERT INTO `comm_address_area` VALUES ('130128000000', '130100000000', 3, 0, '深泽县');
INSERT INTO `comm_address_area` VALUES ('130129000000', '130100000000', 3, 0, '赞皇县');
INSERT INTO `comm_address_area` VALUES ('130130000000', '130100000000', 3, 0, '无极县');
INSERT INTO `comm_address_area` VALUES ('130132000000', '130100000000', 3, 0, '元氏县');
INSERT INTO `comm_address_area` VALUES ('130133000000', '130100000000', 3, 0, '赵县');
INSERT INTO `comm_address_area` VALUES ('130181000000', '130100000000', 3, 0, '辛集市');
INSERT INTO `comm_address_area` VALUES ('130182000000', '130100000000', 3, 0, '藁城市');
INSERT INTO `comm_address_area` VALUES ('130183000000', '130100000000', 3, 0, '晋州市');
INSERT INTO `comm_address_area` VALUES ('130184000000', '130100000000', 3, 0, '新乐市');
INSERT INTO `comm_address_area` VALUES ('130185000000', '130100000000', 3, 0, '鹿泉市');
INSERT INTO `comm_address_area` VALUES ('130200000000', '130000000000', 2, 0, '唐山市');
INSERT INTO `comm_address_area` VALUES ('130202000000', '130200000000', 3, 0, '路南区');
INSERT INTO `comm_address_area` VALUES ('130203000000', '130200000000', 3, 0, '路北区');
INSERT INTO `comm_address_area` VALUES ('130204000000', '130200000000', 3, 0, '古冶区');
INSERT INTO `comm_address_area` VALUES ('130205000000', '130200000000', 3, 0, '开平区');
INSERT INTO `comm_address_area` VALUES ('130207000000', '130200000000', 3, 0, '丰南区');
INSERT INTO `comm_address_area` VALUES ('130208000000', '130200000000', 3, 0, '丰润区');
INSERT INTO `comm_address_area` VALUES ('130223000000', '130200000000', 3, 0, '滦县');
INSERT INTO `comm_address_area` VALUES ('130224000000', '130200000000', 3, 0, '滦南县');
INSERT INTO `comm_address_area` VALUES ('130225000000', '130200000000', 3, 0, '乐亭县');
INSERT INTO `comm_address_area` VALUES ('130227000000', '130200000000', 3, 0, '迁西县');
INSERT INTO `comm_address_area` VALUES ('130229000000', '130200000000', 3, 0, '玉田县');
INSERT INTO `comm_address_area` VALUES ('130230000000', '130200000000', 3, 0, '唐海县');
INSERT INTO `comm_address_area` VALUES ('130281000000', '130200000000', 3, 0, '遵化市');
INSERT INTO `comm_address_area` VALUES ('130283000000', '130200000000', 3, 0, '迁安市');
INSERT INTO `comm_address_area` VALUES ('130300000000', '130000000000', 2, 0, '秦皇岛市');
INSERT INTO `comm_address_area` VALUES ('130302000000', '130300000000', 3, 0, '海港区');
INSERT INTO `comm_address_area` VALUES ('130303000000', '130300000000', 3, 0, '山海关区');
INSERT INTO `comm_address_area` VALUES ('130304000000', '130300000000', 3, 0, '北戴河区');
INSERT INTO `comm_address_area` VALUES ('130321000000', '130300000000', 3, 0, '青龙满族自治县');
INSERT INTO `comm_address_area` VALUES ('130322000000', '130300000000', 3, 0, '昌黎县');
INSERT INTO `comm_address_area` VALUES ('130323000000', '130300000000', 3, 0, '抚宁县');
INSERT INTO `comm_address_area` VALUES ('130324000000', '130300000000', 3, 0, '卢龙县');
INSERT INTO `comm_address_area` VALUES ('130400000000', '130000000000', 2, 0, '邯郸市');
INSERT INTO `comm_address_area` VALUES ('130402000000', '130400000000', 3, 0, '邯山区');
INSERT INTO `comm_address_area` VALUES ('130403000000', '130400000000', 3, 0, '丛台区');
INSERT INTO `comm_address_area` VALUES ('130404000000', '130400000000', 3, 0, '复兴区');
INSERT INTO `comm_address_area` VALUES ('130406000000', '130400000000', 3, 0, '峰峰矿区');
INSERT INTO `comm_address_area` VALUES ('130421000000', '130400000000', 3, 0, '邯郸县');
INSERT INTO `comm_address_area` VALUES ('130423000000', '130400000000', 3, 0, '临漳县');
INSERT INTO `comm_address_area` VALUES ('130424000000', '130400000000', 3, 0, '成安县');
INSERT INTO `comm_address_area` VALUES ('130425000000', '130400000000', 3, 0, '大名县');
INSERT INTO `comm_address_area` VALUES ('130426000000', '130400000000', 3, 0, '涉县');
INSERT INTO `comm_address_area` VALUES ('130427000000', '130400000000', 3, 0, '磁县');
INSERT INTO `comm_address_area` VALUES ('130428000000', '130400000000', 3, 0, '肥乡县');
INSERT INTO `comm_address_area` VALUES ('130429000000', '130400000000', 3, 0, '永年县');
INSERT INTO `comm_address_area` VALUES ('130430000000', '130400000000', 3, 0, '邱县');
INSERT INTO `comm_address_area` VALUES ('130431000000', '130400000000', 3, 0, '鸡泽县');
INSERT INTO `comm_address_area` VALUES ('130432000000', '130400000000', 3, 0, '广平县');
INSERT INTO `comm_address_area` VALUES ('130433000000', '130400000000', 3, 0, '馆陶县');
INSERT INTO `comm_address_area` VALUES ('130434000000', '130400000000', 3, 0, '魏县');
INSERT INTO `comm_address_area` VALUES ('130435000000', '130400000000', 3, 0, '曲周县');
INSERT INTO `comm_address_area` VALUES ('130481000000', '130400000000', 3, 0, '武安市');
INSERT INTO `comm_address_area` VALUES ('130500000000', '130000000000', 2, 0, '邢台市');
INSERT INTO `comm_address_area` VALUES ('130502000000', '130500000000', 3, 0, '桥东区');
INSERT INTO `comm_address_area` VALUES ('130503000000', '130500000000', 3, 0, '桥西区');
INSERT INTO `comm_address_area` VALUES ('130521000000', '130500000000', 3, 0, '邢台县');
INSERT INTO `comm_address_area` VALUES ('130522000000', '130500000000', 3, 0, '临城县');
INSERT INTO `comm_address_area` VALUES ('130523000000', '130500000000', 3, 0, '内丘县');
INSERT INTO `comm_address_area` VALUES ('130524000000', '130500000000', 3, 0, '柏乡县');
INSERT INTO `comm_address_area` VALUES ('130525000000', '130500000000', 3, 0, '隆尧县');
INSERT INTO `comm_address_area` VALUES ('130526000000', '130500000000', 3, 0, '任县');
INSERT INTO `comm_address_area` VALUES ('130527000000', '130500000000', 3, 0, '南和县');
INSERT INTO `comm_address_area` VALUES ('130528000000', '130500000000', 3, 0, '宁晋县');
INSERT INTO `comm_address_area` VALUES ('130529000000', '130500000000', 3, 0, '巨鹿县');
INSERT INTO `comm_address_area` VALUES ('130530000000', '130500000000', 3, 0, '新河县');
INSERT INTO `comm_address_area` VALUES ('130531000000', '130500000000', 3, 0, '广宗县');
INSERT INTO `comm_address_area` VALUES ('130532000000', '130500000000', 3, 0, '平乡县');
INSERT INTO `comm_address_area` VALUES ('130533000000', '130500000000', 3, 0, '威县');
INSERT INTO `comm_address_area` VALUES ('130534000000', '130500000000', 3, 0, '清河县');
INSERT INTO `comm_address_area` VALUES ('130535000000', '130500000000', 3, 0, '临西县');
INSERT INTO `comm_address_area` VALUES ('130581000000', '130500000000', 3, 0, '南宫市');
INSERT INTO `comm_address_area` VALUES ('130582000000', '130500000000', 3, 0, '沙河市');
INSERT INTO `comm_address_area` VALUES ('130600000000', '130000000000', 2, 0, '保定市');
INSERT INTO `comm_address_area` VALUES ('130602000000', '130600000000', 3, 0, '新市区');
INSERT INTO `comm_address_area` VALUES ('130603000000', '130600000000', 3, 0, '北市区');
INSERT INTO `comm_address_area` VALUES ('130604000000', '130600000000', 3, 0, '南市区');
INSERT INTO `comm_address_area` VALUES ('130621000000', '130600000000', 3, 0, '满城县');
INSERT INTO `comm_address_area` VALUES ('130622000000', '130600000000', 3, 0, '清苑县');
INSERT INTO `comm_address_area` VALUES ('130623000000', '130600000000', 3, 0, '涞水县');
INSERT INTO `comm_address_area` VALUES ('130624000000', '130600000000', 3, 0, '阜平县');
INSERT INTO `comm_address_area` VALUES ('130625000000', '130600000000', 3, 0, '徐水县');
INSERT INTO `comm_address_area` VALUES ('130626000000', '130600000000', 3, 0, '定兴县');
INSERT INTO `comm_address_area` VALUES ('130627000000', '130600000000', 3, 0, '唐县');
INSERT INTO `comm_address_area` VALUES ('130628000000', '130600000000', 3, 0, '高阳县');
INSERT INTO `comm_address_area` VALUES ('130629000000', '130600000000', 3, 0, '容城县');
INSERT INTO `comm_address_area` VALUES ('130630000000', '130600000000', 3, 0, '涞源县');
INSERT INTO `comm_address_area` VALUES ('130631000000', '130600000000', 3, 0, '望都县');
INSERT INTO `comm_address_area` VALUES ('130632000000', '130600000000', 3, 0, '安新县');
INSERT INTO `comm_address_area` VALUES ('130633000000', '130600000000', 3, 0, '易县');
INSERT INTO `comm_address_area` VALUES ('130634000000', '130600000000', 3, 0, '曲阳县');
INSERT INTO `comm_address_area` VALUES ('130635000000', '130600000000', 3, 0, '蠡县');
INSERT INTO `comm_address_area` VALUES ('130636000000', '130600000000', 3, 0, '顺平县');
INSERT INTO `comm_address_area` VALUES ('130637000000', '130600000000', 3, 0, '博野县');
INSERT INTO `comm_address_area` VALUES ('130638000000', '130600000000', 3, 0, '雄县');
INSERT INTO `comm_address_area` VALUES ('130681000000', '130600000000', 3, 0, '涿州市');
INSERT INTO `comm_address_area` VALUES ('130682000000', '130600000000', 3, 0, '定州市');
INSERT INTO `comm_address_area` VALUES ('130683000000', '130600000000', 3, 0, '安国市');
INSERT INTO `comm_address_area` VALUES ('130684000000', '130600000000', 3, 0, '高碑店市');
INSERT INTO `comm_address_area` VALUES ('130700000000', '130000000000', 2, 0, '张家口市');
INSERT INTO `comm_address_area` VALUES ('130702000000', '130700000000', 3, 0, '桥东区');
INSERT INTO `comm_address_area` VALUES ('130703000000', '130700000000', 3, 0, '桥西区');
INSERT INTO `comm_address_area` VALUES ('130705000000', '130700000000', 3, 0, '宣化区');
INSERT INTO `comm_address_area` VALUES ('130706000000', '130700000000', 3, 0, '下花园区');
INSERT INTO `comm_address_area` VALUES ('130721000000', '130700000000', 3, 0, '宣化县');
INSERT INTO `comm_address_area` VALUES ('130722000000', '130700000000', 3, 0, '张北县');
INSERT INTO `comm_address_area` VALUES ('130723000000', '130700000000', 3, 0, '康保县');
INSERT INTO `comm_address_area` VALUES ('130724000000', '130700000000', 3, 0, '沽源县');
INSERT INTO `comm_address_area` VALUES ('130725000000', '130700000000', 3, 0, '尚义县');
INSERT INTO `comm_address_area` VALUES ('130726000000', '130700000000', 3, 0, '蔚县');
INSERT INTO `comm_address_area` VALUES ('130727000000', '130700000000', 3, 0, '阳原县');
INSERT INTO `comm_address_area` VALUES ('130728000000', '130700000000', 3, 0, '怀安县');
INSERT INTO `comm_address_area` VALUES ('130729000000', '130700000000', 3, 0, '万全县');
INSERT INTO `comm_address_area` VALUES ('130730000000', '130700000000', 3, 0, '怀来县');
INSERT INTO `comm_address_area` VALUES ('130731000000', '130700000000', 3, 0, '涿鹿县');
INSERT INTO `comm_address_area` VALUES ('130732000000', '130700000000', 3, 0, '赤城县');
INSERT INTO `comm_address_area` VALUES ('130733000000', '130700000000', 3, 0, '崇礼县');
INSERT INTO `comm_address_area` VALUES ('130800000000', '130000000000', 2, 0, '承德市');
INSERT INTO `comm_address_area` VALUES ('130802000000', '130800000000', 3, 0, '双桥区');
INSERT INTO `comm_address_area` VALUES ('130803000000', '130800000000', 3, 0, '双滦区');
INSERT INTO `comm_address_area` VALUES ('130804000000', '130800000000', 3, 0, '鹰手营子矿区');
INSERT INTO `comm_address_area` VALUES ('130821000000', '130800000000', 3, 0, '承德县');
INSERT INTO `comm_address_area` VALUES ('130822000000', '130800000000', 3, 0, '兴隆县');
INSERT INTO `comm_address_area` VALUES ('130823000000', '130800000000', 3, 0, '平泉县');
INSERT INTO `comm_address_area` VALUES ('130824000000', '130800000000', 3, 0, '滦平县');
INSERT INTO `comm_address_area` VALUES ('130825000000', '130800000000', 3, 0, '隆化县');
INSERT INTO `comm_address_area` VALUES ('130826000000', '130800000000', 3, 0, '丰宁满族自治县');
INSERT INTO `comm_address_area` VALUES ('130827000000', '130800000000', 3, 0, '宽城满族自治县');
INSERT INTO `comm_address_area` VALUES ('130828000000', '130800000000', 3, 0, '围场满族蒙古族自治县');
INSERT INTO `comm_address_area` VALUES ('130900000000', '130000000000', 2, 0, '沧州市');
INSERT INTO `comm_address_area` VALUES ('130902000000', '130900000000', 3, 0, '新华区');
INSERT INTO `comm_address_area` VALUES ('130903000000', '130900000000', 3, 0, '运河区');
INSERT INTO `comm_address_area` VALUES ('130921000000', '130900000000', 3, 0, '沧县');
INSERT INTO `comm_address_area` VALUES ('130922000000', '130900000000', 3, 0, '青县');
INSERT INTO `comm_address_area` VALUES ('130923000000', '130900000000', 3, 0, '东光县');
INSERT INTO `comm_address_area` VALUES ('130924000000', '130900000000', 3, 0, '海兴县');
INSERT INTO `comm_address_area` VALUES ('130925000000', '130900000000', 3, 0, '盐山县');
INSERT INTO `comm_address_area` VALUES ('130926000000', '130900000000', 3, 0, '肃宁县');
INSERT INTO `comm_address_area` VALUES ('130927000000', '130900000000', 3, 0, '南皮县');
INSERT INTO `comm_address_area` VALUES ('130928000000', '130900000000', 3, 0, '吴桥县');
INSERT INTO `comm_address_area` VALUES ('130929000000', '130900000000', 3, 0, '献县');
INSERT INTO `comm_address_area` VALUES ('130930000000', '130900000000', 3, 0, '孟村回族自治县');
INSERT INTO `comm_address_area` VALUES ('130981000000', '130900000000', 3, 0, '泊头市');
INSERT INTO `comm_address_area` VALUES ('130982000000', '130900000000', 3, 0, '任丘市');
INSERT INTO `comm_address_area` VALUES ('130983000000', '130900000000', 3, 0, '黄骅市');
INSERT INTO `comm_address_area` VALUES ('130984000000', '130900000000', 3, 0, '河间市');
INSERT INTO `comm_address_area` VALUES ('131000000000', '130000000000', 2, 0, '廊坊市');
INSERT INTO `comm_address_area` VALUES ('131002000000', '131000000000', 3, 0, '安次区');
INSERT INTO `comm_address_area` VALUES ('131003000000', '131000000000', 3, 0, '广阳区');
INSERT INTO `comm_address_area` VALUES ('131022000000', '131000000000', 3, 0, '固安县');
INSERT INTO `comm_address_area` VALUES ('131023000000', '131000000000', 3, 0, '永清县');
INSERT INTO `comm_address_area` VALUES ('131024000000', '131000000000', 3, 0, '香河县');
INSERT INTO `comm_address_area` VALUES ('131025000000', '131000000000', 3, 0, '大城县');
INSERT INTO `comm_address_area` VALUES ('131026000000', '131000000000', 3, 0, '文安县');
INSERT INTO `comm_address_area` VALUES ('131028000000', '131000000000', 3, 0, '大厂回族自治县');
INSERT INTO `comm_address_area` VALUES ('131081000000', '131000000000', 3, 0, '霸州市');
INSERT INTO `comm_address_area` VALUES ('131082000000', '131000000000', 3, 0, '三河市');
INSERT INTO `comm_address_area` VALUES ('131100000000', '130000000000', 2, 0, '衡水市');
INSERT INTO `comm_address_area` VALUES ('131102000000', '131100000000', 3, 0, '桃城区');
INSERT INTO `comm_address_area` VALUES ('131121000000', '131100000000', 3, 0, '枣强县');
INSERT INTO `comm_address_area` VALUES ('131122000000', '131100000000', 3, 0, '武邑县');
INSERT INTO `comm_address_area` VALUES ('131123000000', '131100000000', 3, 0, '武强县');
INSERT INTO `comm_address_area` VALUES ('131124000000', '131100000000', 3, 0, '饶阳县');
INSERT INTO `comm_address_area` VALUES ('131125000000', '131100000000', 3, 0, '安平县');
INSERT INTO `comm_address_area` VALUES ('131126000000', '131100000000', 3, 0, '故城县');
INSERT INTO `comm_address_area` VALUES ('131127000000', '131100000000', 3, 0, '景县');
INSERT INTO `comm_address_area` VALUES ('131128000000', '131100000000', 3, 0, '阜城县');
INSERT INTO `comm_address_area` VALUES ('131181000000', '131100000000', 3, 0, '冀州市');
INSERT INTO `comm_address_area` VALUES ('131182000000', '131100000000', 3, 0, '深州市');
INSERT INTO `comm_address_area` VALUES ('410000000000', '0', 1, 0, '河南省');
INSERT INTO `comm_address_area` VALUES ('410100000000', '410000000000', 2, 0, '郑州市');
INSERT INTO `comm_address_area` VALUES ('410102000000', '410100000000', 3, 0, '中原区');
INSERT INTO `comm_address_area` VALUES ('410103000000', '410100000000', 3, 0, '二七区');
INSERT INTO `comm_address_area` VALUES ('410104000000', '410100000000', 3, 0, '管城回族区');
INSERT INTO `comm_address_area` VALUES ('410105000000', '410100000000', 3, 0, '金水区');
INSERT INTO `comm_address_area` VALUES ('410106000000', '410100000000', 3, 0, '上街区');
INSERT INTO `comm_address_area` VALUES ('410108000000', '410100000000', 3, 0, '惠济区');
INSERT INTO `comm_address_area` VALUES ('410122000000', '410100000000', 3, 0, '中牟县');
INSERT INTO `comm_address_area` VALUES ('410181000000', '410100000000', 3, 0, '巩义市');
INSERT INTO `comm_address_area` VALUES ('410182000000', '410100000000', 3, 0, '荥阳市');
INSERT INTO `comm_address_area` VALUES ('410183000000', '410100000000', 3, 0, '新密市');
INSERT INTO `comm_address_area` VALUES ('410184000000', '410100000000', 3, 0, '新郑市');
INSERT INTO `comm_address_area` VALUES ('410185000000', '410100000000', 3, 0, '登封市');
INSERT INTO `comm_address_area` VALUES ('410200000000', '410000000000', 2, 0, '开封市');
INSERT INTO `comm_address_area` VALUES ('410202000000', '410200000000', 3, 0, '龙亭区');
INSERT INTO `comm_address_area` VALUES ('410203000000', '410200000000', 3, 0, '顺河回族区');
INSERT INTO `comm_address_area` VALUES ('410204000000', '410200000000', 3, 0, '鼓楼区');
INSERT INTO `comm_address_area` VALUES ('410205000000', '410200000000', 3, 0, '禹王台区');
INSERT INTO `comm_address_area` VALUES ('410211000000', '410200000000', 3, 0, '金明区');
INSERT INTO `comm_address_area` VALUES ('410221000000', '410200000000', 3, 0, '杞县');
INSERT INTO `comm_address_area` VALUES ('410222000000', '410200000000', 3, 0, '通许县');
INSERT INTO `comm_address_area` VALUES ('410223000000', '410200000000', 3, 0, '尉氏县');
INSERT INTO `comm_address_area` VALUES ('410224000000', '410200000000', 3, 0, '开封县');
INSERT INTO `comm_address_area` VALUES ('410225000000', '410200000000', 3, 0, '兰考县');
INSERT INTO `comm_address_area` VALUES ('410300000000', '410000000000', 2, 0, '洛阳市');
INSERT INTO `comm_address_area` VALUES ('410302000000', '410300000000', 3, 0, '老城区');
INSERT INTO `comm_address_area` VALUES ('410303000000', '410300000000', 3, 0, '西工区');
INSERT INTO `comm_address_area` VALUES ('410304000000', '410300000000', 3, 0, '瀍河回族区');
INSERT INTO `comm_address_area` VALUES ('410305000000', '410300000000', 3, 0, '涧西区');
INSERT INTO `comm_address_area` VALUES ('410306000000', '410300000000', 3, 0, '吉利区');
INSERT INTO `comm_address_area` VALUES ('410311000000', '410300000000', 3, 0, '洛龙区');
INSERT INTO `comm_address_area` VALUES ('410322000000', '410300000000', 3, 0, '孟津县');
INSERT INTO `comm_address_area` VALUES ('410323000000', '410300000000', 3, 0, '新安县');
INSERT INTO `comm_address_area` VALUES ('410324000000', '410300000000', 3, 0, '栾川县');
INSERT INTO `comm_address_area` VALUES ('410325000000', '410300000000', 3, 0, '嵩县');
INSERT INTO `comm_address_area` VALUES ('410326000000', '410300000000', 3, 0, '汝阳县');
INSERT INTO `comm_address_area` VALUES ('410327000000', '410300000000', 3, 0, '宜阳县');
INSERT INTO `comm_address_area` VALUES ('410328000000', '410300000000', 3, 0, '洛宁县');
INSERT INTO `comm_address_area` VALUES ('410329000000', '410300000000', 3, 0, '伊川县');
INSERT INTO `comm_address_area` VALUES ('410381000000', '410300000000', 3, 0, '偃师市');
INSERT INTO `comm_address_area` VALUES ('410400000000', '410000000000', 2, 0, '平顶山市');
INSERT INTO `comm_address_area` VALUES ('410402000000', '410400000000', 3, 0, '新华区');
INSERT INTO `comm_address_area` VALUES ('410403000000', '410400000000', 3, 0, '卫东区');
INSERT INTO `comm_address_area` VALUES ('410404000000', '410400000000', 3, 0, '石龙区');
INSERT INTO `comm_address_area` VALUES ('410411000000', '410400000000', 3, 0, '湛河区');
INSERT INTO `comm_address_area` VALUES ('410421000000', '410400000000', 3, 0, '宝丰县');
INSERT INTO `comm_address_area` VALUES ('410422000000', '410400000000', 3, 0, '叶县');
INSERT INTO `comm_address_area` VALUES ('410423000000', '410400000000', 3, 0, '鲁山县');
INSERT INTO `comm_address_area` VALUES ('410425000000', '410400000000', 3, 0, '郏县');
INSERT INTO `comm_address_area` VALUES ('410481000000', '410400000000', 3, 0, '舞钢市');
INSERT INTO `comm_address_area` VALUES ('410482000000', '410400000000', 3, 0, '汝州市');
INSERT INTO `comm_address_area` VALUES ('410500000000', '410000000000', 2, 0, '安阳市');
INSERT INTO `comm_address_area` VALUES ('410502000000', '410500000000', 3, 0, '文峰区');
INSERT INTO `comm_address_area` VALUES ('410503000000', '410500000000', 3, 0, '北关区');
INSERT INTO `comm_address_area` VALUES ('410505000000', '410500000000', 3, 0, '殷都区');
INSERT INTO `comm_address_area` VALUES ('410506000000', '410500000000', 3, 0, '龙安区');
INSERT INTO `comm_address_area` VALUES ('410522000000', '410500000000', 3, 0, '安阳县');
INSERT INTO `comm_address_area` VALUES ('410523000000', '410500000000', 3, 0, '汤阴县');
INSERT INTO `comm_address_area` VALUES ('410526000000', '410500000000', 3, 0, '滑县');
INSERT INTO `comm_address_area` VALUES ('410527000000', '410500000000', 3, 0, '内黄县');
INSERT INTO `comm_address_area` VALUES ('410581000000', '410500000000', 3, 0, '林州市');
INSERT INTO `comm_address_area` VALUES ('410600000000', '410000000000', 2, 0, '鹤壁市');
INSERT INTO `comm_address_area` VALUES ('410602000000', '410600000000', 3, 0, '鹤山区');
INSERT INTO `comm_address_area` VALUES ('410603000000', '410600000000', 3, 0, '山城区');
INSERT INTO `comm_address_area` VALUES ('410611000000', '410600000000', 3, 0, '淇滨区');
INSERT INTO `comm_address_area` VALUES ('410621000000', '410600000000', 3, 0, '浚县');
INSERT INTO `comm_address_area` VALUES ('410622000000', '410600000000', 3, 0, '淇县');
INSERT INTO `comm_address_area` VALUES ('410700000000', '410000000000', 2, 0, '新乡市');
INSERT INTO `comm_address_area` VALUES ('410702000000', '410700000000', 3, 0, '红旗区');
INSERT INTO `comm_address_area` VALUES ('410703000000', '410700000000', 3, 0, '卫滨区');
INSERT INTO `comm_address_area` VALUES ('410704000000', '410700000000', 3, 0, '凤泉区');
INSERT INTO `comm_address_area` VALUES ('410711000000', '410700000000', 3, 0, '牧野区');
INSERT INTO `comm_address_area` VALUES ('410721000000', '410700000000', 3, 0, '新乡县');
INSERT INTO `comm_address_area` VALUES ('410724000000', '410700000000', 3, 0, '获嘉县');
INSERT INTO `comm_address_area` VALUES ('410725000000', '410700000000', 3, 0, '原阳县');
INSERT INTO `comm_address_area` VALUES ('410726000000', '410700000000', 3, 0, '延津县');
INSERT INTO `comm_address_area` VALUES ('410727000000', '410700000000', 3, 0, '封丘县');
INSERT INTO `comm_address_area` VALUES ('410728000000', '410700000000', 3, 0, '长垣县');
INSERT INTO `comm_address_area` VALUES ('410781000000', '410700000000', 3, 0, '卫辉市');
INSERT INTO `comm_address_area` VALUES ('410782000000', '410700000000', 3, 0, '辉县市');
INSERT INTO `comm_address_area` VALUES ('410800000000', '410000000000', 2, 0, '焦作市');
INSERT INTO `comm_address_area` VALUES ('410802000000', '410800000000', 3, 0, '解放区');
INSERT INTO `comm_address_area` VALUES ('410803000000', '410800000000', 3, 0, '中站区');
INSERT INTO `comm_address_area` VALUES ('410804000000', '410800000000', 3, 0, '马村区');
INSERT INTO `comm_address_area` VALUES ('410811000000', '410800000000', 3, 0, '山阳区');
INSERT INTO `comm_address_area` VALUES ('410821000000', '410800000000', 3, 0, '修武县');
INSERT INTO `comm_address_area` VALUES ('410822000000', '410800000000', 3, 0, '博爱县');
INSERT INTO `comm_address_area` VALUES ('410823000000', '410800000000', 3, 0, '武陟县');
INSERT INTO `comm_address_area` VALUES ('410825000000', '410800000000', 3, 0, '温县');
INSERT INTO `comm_address_area` VALUES ('410882000000', '410800000000', 3, 0, '沁阳市');
INSERT INTO `comm_address_area` VALUES ('410883000000', '410800000000', 3, 0, '孟州市');
INSERT INTO `comm_address_area` VALUES ('410900000000', '410000000000', 2, 0, '濮阳市');
INSERT INTO `comm_address_area` VALUES ('410902000000', '410900000000', 3, 0, '华龙区');
INSERT INTO `comm_address_area` VALUES ('410922000000', '410900000000', 3, 0, '清丰县');
INSERT INTO `comm_address_area` VALUES ('410923000000', '410900000000', 3, 0, '南乐县');
INSERT INTO `comm_address_area` VALUES ('410926000000', '410900000000', 3, 0, '范县');
INSERT INTO `comm_address_area` VALUES ('410927000000', '410900000000', 3, 0, '台前县');
INSERT INTO `comm_address_area` VALUES ('410928000000', '410900000000', 3, 0, '濮阳县');
INSERT INTO `comm_address_area` VALUES ('411000000000', '410000000000', 2, 0, '许昌市');
INSERT INTO `comm_address_area` VALUES ('411002000000', '411000000000', 3, 0, '魏都区');
INSERT INTO `comm_address_area` VALUES ('411023000000', '411000000000', 3, 0, '许昌县');
INSERT INTO `comm_address_area` VALUES ('411024000000', '411000000000', 3, 0, '鄢陵县');
INSERT INTO `comm_address_area` VALUES ('411025000000', '411000000000', 3, 0, '襄城县');
INSERT INTO `comm_address_area` VALUES ('411081000000', '411000000000', 3, 0, '禹州市');
INSERT INTO `comm_address_area` VALUES ('411082000000', '411000000000', 3, 0, '长葛市');
INSERT INTO `comm_address_area` VALUES ('411100000000', '410000000000', 2, 0, '漯河市');
INSERT INTO `comm_address_area` VALUES ('411102000000', '411100000000', 3, 0, '源汇区');
INSERT INTO `comm_address_area` VALUES ('411103000000', '411100000000', 3, 0, '郾城区');
INSERT INTO `comm_address_area` VALUES ('411104000000', '411100000000', 3, 0, '召陵区');
INSERT INTO `comm_address_area` VALUES ('411121000000', '411100000000', 3, 0, '舞阳县');
INSERT INTO `comm_address_area` VALUES ('411122000000', '411100000000', 3, 0, '临颍县');
INSERT INTO `comm_address_area` VALUES ('411200000000', '410000000000', 2, 0, '三门峡市');
INSERT INTO `comm_address_area` VALUES ('411202000000', '411200000000', 3, 0, '湖滨区');
INSERT INTO `comm_address_area` VALUES ('411221000000', '411200000000', 3, 0, '渑池县');
INSERT INTO `comm_address_area` VALUES ('411222000000', '411200000000', 3, 0, '陕县');
INSERT INTO `comm_address_area` VALUES ('411224000000', '411200000000', 3, 0, '卢氏县');
INSERT INTO `comm_address_area` VALUES ('411281000000', '411200000000', 3, 0, '义马市');
INSERT INTO `comm_address_area` VALUES ('411282000000', '411200000000', 3, 0, '灵宝市');
INSERT INTO `comm_address_area` VALUES ('411300000000', '410000000000', 2, 0, '南阳市');
INSERT INTO `comm_address_area` VALUES ('411302000000', '411300000000', 3, 0, '宛城区');
INSERT INTO `comm_address_area` VALUES ('411303000000', '411300000000', 3, 0, '卧龙区');
INSERT INTO `comm_address_area` VALUES ('411321000000', '411300000000', 3, 0, '南召县');
INSERT INTO `comm_address_area` VALUES ('411322000000', '411300000000', 3, 0, '方城县');
INSERT INTO `comm_address_area` VALUES ('411323000000', '411300000000', 3, 0, '西峡县');
INSERT INTO `comm_address_area` VALUES ('411324000000', '411300000000', 3, 0, '镇平县');
INSERT INTO `comm_address_area` VALUES ('411325000000', '411300000000', 3, 0, '内乡县');
INSERT INTO `comm_address_area` VALUES ('411326000000', '411300000000', 3, 0, '淅川县');
INSERT INTO `comm_address_area` VALUES ('411327000000', '411300000000', 3, 0, '社旗县');
INSERT INTO `comm_address_area` VALUES ('411328000000', '411300000000', 3, 0, '唐河县');
INSERT INTO `comm_address_area` VALUES ('411329000000', '411300000000', 3, 0, '新野县');
INSERT INTO `comm_address_area` VALUES ('411330000000', '411300000000', 3, 0, '桐柏县');
INSERT INTO `comm_address_area` VALUES ('411381000000', '411300000000', 3, 0, '邓州市');
INSERT INTO `comm_address_area` VALUES ('411400000000', '410000000000', 2, 0, '商丘市');
INSERT INTO `comm_address_area` VALUES ('411402000000', '411400000000', 3, 0, '梁园区');
INSERT INTO `comm_address_area` VALUES ('411403000000', '411400000000', 3, 0, '睢阳区');
INSERT INTO `comm_address_area` VALUES ('411421000000', '411400000000', 3, 0, '民权县');
INSERT INTO `comm_address_area` VALUES ('411422000000', '411400000000', 3, 0, '睢县');
INSERT INTO `comm_address_area` VALUES ('411423000000', '411400000000', 3, 0, '宁陵县');
INSERT INTO `comm_address_area` VALUES ('411424000000', '411400000000', 3, 0, '柘城县');
INSERT INTO `comm_address_area` VALUES ('411425000000', '411400000000', 3, 0, '虞城县');
INSERT INTO `comm_address_area` VALUES ('411426000000', '411400000000', 3, 0, '夏邑县');
INSERT INTO `comm_address_area` VALUES ('411481000000', '411400000000', 3, 0, '永城市');
INSERT INTO `comm_address_area` VALUES ('411500000000', '410000000000', 2, 0, '信阳市');
INSERT INTO `comm_address_area` VALUES ('411502000000', '411500000000', 3, 0, '浉河区');
INSERT INTO `comm_address_area` VALUES ('411503000000', '411500000000', 3, 0, '平桥区');
INSERT INTO `comm_address_area` VALUES ('411521000000', '411500000000', 3, 0, '罗山县');
INSERT INTO `comm_address_area` VALUES ('411522000000', '411500000000', 3, 0, '光山县');
INSERT INTO `comm_address_area` VALUES ('411523000000', '411500000000', 3, 0, '新县');
INSERT INTO `comm_address_area` VALUES ('411524000000', '411500000000', 3, 0, '商城县');
INSERT INTO `comm_address_area` VALUES ('411525000000', '411500000000', 3, 0, '固始县');
INSERT INTO `comm_address_area` VALUES ('411526000000', '411500000000', 3, 0, '潢川县');
INSERT INTO `comm_address_area` VALUES ('411527000000', '411500000000', 3, 0, '淮滨县');
INSERT INTO `comm_address_area` VALUES ('411528000000', '411500000000', 3, 0, '息县');
INSERT INTO `comm_address_area` VALUES ('411600000000', '410000000000', 2, 0, '周口市');
INSERT INTO `comm_address_area` VALUES ('411602000000', '411600000000', 3, 0, '川汇区');
INSERT INTO `comm_address_area` VALUES ('411621000000', '411600000000', 3, 0, '扶沟县');
INSERT INTO `comm_address_area` VALUES ('411622000000', '411600000000', 3, 0, '西华县');
INSERT INTO `comm_address_area` VALUES ('411623000000', '411600000000', 3, 0, '商水县');
INSERT INTO `comm_address_area` VALUES ('411624000000', '411600000000', 3, 0, '沈丘县');
INSERT INTO `comm_address_area` VALUES ('411625000000', '411600000000', 3, 0, '郸城县');
INSERT INTO `comm_address_area` VALUES ('411626000000', '411600000000', 3, 0, '淮阳县');
INSERT INTO `comm_address_area` VALUES ('411627000000', '411600000000', 3, 0, '太康县');
INSERT INTO `comm_address_area` VALUES ('411628000000', '411600000000', 3, 0, '鹿邑县');
INSERT INTO `comm_address_area` VALUES ('411681000000', '411600000000', 3, 0, '项城市');
INSERT INTO `comm_address_area` VALUES ('411700000000', '410000000000', 2, 0, '驻马店市');
INSERT INTO `comm_address_area` VALUES ('411702000000', '411700000000', 3, 0, '驿城区');
INSERT INTO `comm_address_area` VALUES ('411721000000', '411700000000', 3, 0, '西平县');
INSERT INTO `comm_address_area` VALUES ('411722000000', '411700000000', 3, 0, '上蔡县');
INSERT INTO `comm_address_area` VALUES ('411723000000', '411700000000', 3, 0, '平舆县');
INSERT INTO `comm_address_area` VALUES ('411724000000', '411700000000', 3, 0, '正阳县');
INSERT INTO `comm_address_area` VALUES ('411725000000', '411700000000', 3, 0, '确山县');
INSERT INTO `comm_address_area` VALUES ('411726000000', '411700000000', 3, 0, '泌阳县');
INSERT INTO `comm_address_area` VALUES ('411727000000', '411700000000', 3, 0, '汝南县');
INSERT INTO `comm_address_area` VALUES ('411728000000', '411700000000', 3, 0, '遂平县');
INSERT INTO `comm_address_area` VALUES ('411729000000', '411700000000', 3, 0, '新蔡县');
INSERT INTO `comm_address_area` VALUES ('419000000000', '410000000000', 2, 0, '省直辖县级行政区划');
INSERT INTO `comm_address_area` VALUES ('419001000000', '419000000000', 3, 0, '济源市');
INSERT INTO `comm_address_area` VALUES ('230000000000', '0', 1, 0, '黑龙江省');
INSERT INTO `comm_address_area` VALUES ('230100000000', '230000000000', 2, 0, '哈尔滨市');
INSERT INTO `comm_address_area` VALUES ('230102000000', '230100000000', 3, 0, '道里区');
INSERT INTO `comm_address_area` VALUES ('230103000000', '230100000000', 3, 0, '南岗区');
INSERT INTO `comm_address_area` VALUES ('230104000000', '230100000000', 3, 0, '道外区');
INSERT INTO `comm_address_area` VALUES ('230108000000', '230100000000', 3, 0, '平房区');
INSERT INTO `comm_address_area` VALUES ('230109000000', '230100000000', 3, 0, '松北区');
INSERT INTO `comm_address_area` VALUES ('230110000000', '230100000000', 3, 0, '香坊区');
INSERT INTO `comm_address_area` VALUES ('230111000000', '230100000000', 3, 0, '呼兰区');
INSERT INTO `comm_address_area` VALUES ('230112000000', '230100000000', 3, 0, '阿城区');
INSERT INTO `comm_address_area` VALUES ('230123000000', '230100000000', 3, 0, '依兰县');
INSERT INTO `comm_address_area` VALUES ('230124000000', '230100000000', 3, 0, '方正县');
INSERT INTO `comm_address_area` VALUES ('230125000000', '230100000000', 3, 0, '宾县');
INSERT INTO `comm_address_area` VALUES ('230126000000', '230100000000', 3, 0, '巴彦县');
INSERT INTO `comm_address_area` VALUES ('230127000000', '230100000000', 3, 0, '木兰县');
INSERT INTO `comm_address_area` VALUES ('230128000000', '230100000000', 3, 0, '通河县');
INSERT INTO `comm_address_area` VALUES ('230129000000', '230100000000', 3, 0, '延寿县');
INSERT INTO `comm_address_area` VALUES ('230182000000', '230100000000', 3, 0, '双城市');
INSERT INTO `comm_address_area` VALUES ('230183000000', '230100000000', 3, 0, '尚志市');
INSERT INTO `comm_address_area` VALUES ('230184000000', '230100000000', 3, 0, '五常市');
INSERT INTO `comm_address_area` VALUES ('230200000000', '230000000000', 2, 0, '齐齐哈尔市');
INSERT INTO `comm_address_area` VALUES ('230202000000', '230200000000', 3, 0, '龙沙区');
INSERT INTO `comm_address_area` VALUES ('230203000000', '230200000000', 3, 0, '建华区');
INSERT INTO `comm_address_area` VALUES ('230204000000', '230200000000', 3, 0, '铁锋区');
INSERT INTO `comm_address_area` VALUES ('230205000000', '230200000000', 3, 0, '昂昂溪区');
INSERT INTO `comm_address_area` VALUES ('230206000000', '230200000000', 3, 0, '富拉尔基区');
INSERT INTO `comm_address_area` VALUES ('230207000000', '230200000000', 3, 0, '碾子山区');
INSERT INTO `comm_address_area` VALUES ('230208000000', '230200000000', 3, 0, '梅里斯达斡尔族区');
INSERT INTO `comm_address_area` VALUES ('230221000000', '230200000000', 3, 0, '龙江县');
INSERT INTO `comm_address_area` VALUES ('230223000000', '230200000000', 3, 0, '依安县');
INSERT INTO `comm_address_area` VALUES ('230224000000', '230200000000', 3, 0, '泰来县');
INSERT INTO `comm_address_area` VALUES ('230225000000', '230200000000', 3, 0, '甘南县');
INSERT INTO `comm_address_area` VALUES ('230227000000', '230200000000', 3, 0, '富裕县');
INSERT INTO `comm_address_area` VALUES ('230229000000', '230200000000', 3, 0, '克山县');
INSERT INTO `comm_address_area` VALUES ('230230000000', '230200000000', 3, 0, '克东县');
INSERT INTO `comm_address_area` VALUES ('230231000000', '230200000000', 3, 0, '拜泉县');
INSERT INTO `comm_address_area` VALUES ('230281000000', '230200000000', 3, 0, '讷河市');
INSERT INTO `comm_address_area` VALUES ('230300000000', '230000000000', 2, 0, '鸡西市');
INSERT INTO `comm_address_area` VALUES ('230302000000', '230300000000', 3, 0, '鸡冠区');
INSERT INTO `comm_address_area` VALUES ('230303000000', '230300000000', 3, 0, '恒山区');
INSERT INTO `comm_address_area` VALUES ('230304000000', '230300000000', 3, 0, '滴道区');
INSERT INTO `comm_address_area` VALUES ('230305000000', '230300000000', 3, 0, '梨树区');
INSERT INTO `comm_address_area` VALUES ('230306000000', '230300000000', 3, 0, '城子河区');
INSERT INTO `comm_address_area` VALUES ('230307000000', '230300000000', 3, 0, '麻山区');
INSERT INTO `comm_address_area` VALUES ('230321000000', '230300000000', 3, 0, '鸡东县');
INSERT INTO `comm_address_area` VALUES ('230381000000', '230300000000', 3, 0, '虎林市');
INSERT INTO `comm_address_area` VALUES ('230382000000', '230300000000', 3, 0, '密山市');
INSERT INTO `comm_address_area` VALUES ('230400000000', '230000000000', 2, 0, '鹤岗市');
INSERT INTO `comm_address_area` VALUES ('230402000000', '230400000000', 3, 0, '向阳区');
INSERT INTO `comm_address_area` VALUES ('230403000000', '230400000000', 3, 0, '工农区');
INSERT INTO `comm_address_area` VALUES ('230404000000', '230400000000', 3, 0, '南山区');
INSERT INTO `comm_address_area` VALUES ('230405000000', '230400000000', 3, 0, '兴安区');
INSERT INTO `comm_address_area` VALUES ('230406000000', '230400000000', 3, 0, '东山区');
INSERT INTO `comm_address_area` VALUES ('230407000000', '230400000000', 3, 0, '兴山区');
INSERT INTO `comm_address_area` VALUES ('230421000000', '230400000000', 3, 0, '萝北县');
INSERT INTO `comm_address_area` VALUES ('230422000000', '230400000000', 3, 0, '绥滨县');
INSERT INTO `comm_address_area` VALUES ('230500000000', '230000000000', 2, 0, '双鸭山市');
INSERT INTO `comm_address_area` VALUES ('230502000000', '230500000000', 3, 0, '尖山区');
INSERT INTO `comm_address_area` VALUES ('230503000000', '230500000000', 3, 0, '岭东区');
INSERT INTO `comm_address_area` VALUES ('230505000000', '230500000000', 3, 0, '四方台区');
INSERT INTO `comm_address_area` VALUES ('230506000000', '230500000000', 3, 0, '宝山区');
INSERT INTO `comm_address_area` VALUES ('230521000000', '230500000000', 3, 0, '集贤县');
INSERT INTO `comm_address_area` VALUES ('230522000000', '230500000000', 3, 0, '友谊县');
INSERT INTO `comm_address_area` VALUES ('230523000000', '230500000000', 3, 0, '宝清县');
INSERT INTO `comm_address_area` VALUES ('230524000000', '230500000000', 3, 0, '饶河县');
INSERT INTO `comm_address_area` VALUES ('230600000000', '230000000000', 2, 0, '大庆市');
INSERT INTO `comm_address_area` VALUES ('230602000000', '230600000000', 3, 0, '萨尔图区');
INSERT INTO `comm_address_area` VALUES ('230603000000', '230600000000', 3, 0, '龙凤区');
INSERT INTO `comm_address_area` VALUES ('230604000000', '230600000000', 3, 0, '让胡路区');
INSERT INTO `comm_address_area` VALUES ('230605000000', '230600000000', 3, 0, '红岗区');
INSERT INTO `comm_address_area` VALUES ('230606000000', '230600000000', 3, 0, '大同区');
INSERT INTO `comm_address_area` VALUES ('230621000000', '230600000000', 3, 0, '肇州县');
INSERT INTO `comm_address_area` VALUES ('230622000000', '230600000000', 3, 0, '肇源县');
INSERT INTO `comm_address_area` VALUES ('230623000000', '230600000000', 3, 0, '林甸县');
INSERT INTO `comm_address_area` VALUES ('230624000000', '230600000000', 3, 0, '杜尔伯特蒙古族自治县');
INSERT INTO `comm_address_area` VALUES ('230700000000', '230000000000', 2, 0, '伊春市');
INSERT INTO `comm_address_area` VALUES ('230702000000', '230700000000', 3, 0, '伊春区');
INSERT INTO `comm_address_area` VALUES ('230703000000', '230700000000', 3, 0, '南岔区');
INSERT INTO `comm_address_area` VALUES ('230704000000', '230700000000', 3, 0, '友好区');
INSERT INTO `comm_address_area` VALUES ('230705000000', '230700000000', 3, 0, '西林区');
INSERT INTO `comm_address_area` VALUES ('230706000000', '230700000000', 3, 0, '翠峦区');
INSERT INTO `comm_address_area` VALUES ('230707000000', '230700000000', 3, 0, '新青区');
INSERT INTO `comm_address_area` VALUES ('230708000000', '230700000000', 3, 0, '美溪区');
INSERT INTO `comm_address_area` VALUES ('230709000000', '230700000000', 3, 0, '金山屯区');
INSERT INTO `comm_address_area` VALUES ('230710000000', '230700000000', 3, 0, '五营区');
INSERT INTO `comm_address_area` VALUES ('230711000000', '230700000000', 3, 0, '乌马河区');
INSERT INTO `comm_address_area` VALUES ('230712000000', '230700000000', 3, 0, '汤旺河区');
INSERT INTO `comm_address_area` VALUES ('230713000000', '230700000000', 3, 0, '带岭区');
INSERT INTO `comm_address_area` VALUES ('230714000000', '230700000000', 3, 0, '乌伊岭区');
INSERT INTO `comm_address_area` VALUES ('230715000000', '230700000000', 3, 0, '红星区');
INSERT INTO `comm_address_area` VALUES ('230716000000', '230700000000', 3, 0, '上甘岭区');
INSERT INTO `comm_address_area` VALUES ('230722000000', '230700000000', 3, 0, '嘉荫县');
INSERT INTO `comm_address_area` VALUES ('230781000000', '230700000000', 3, 0, '铁力市');
INSERT INTO `comm_address_area` VALUES ('230800000000', '230000000000', 2, 0, '佳木斯市');
INSERT INTO `comm_address_area` VALUES ('230803000000', '230800000000', 3, 0, '向阳区');
INSERT INTO `comm_address_area` VALUES ('230804000000', '230800000000', 3, 0, '前进区');
INSERT INTO `comm_address_area` VALUES ('230805000000', '230800000000', 3, 0, '东风区');
INSERT INTO `comm_address_area` VALUES ('230811000000', '230800000000', 3, 0, '郊区');
INSERT INTO `comm_address_area` VALUES ('230822000000', '230800000000', 3, 0, '桦南县');
INSERT INTO `comm_address_area` VALUES ('230826000000', '230800000000', 3, 0, '桦川县');
INSERT INTO `comm_address_area` VALUES ('230828000000', '230800000000', 3, 0, '汤原县');
INSERT INTO `comm_address_area` VALUES ('230833000000', '230800000000', 3, 0, '抚远县');
INSERT INTO `comm_address_area` VALUES ('230881000000', '230800000000', 3, 0, '同江市');
INSERT INTO `comm_address_area` VALUES ('230882000000', '230800000000', 3, 0, '富锦市');
INSERT INTO `comm_address_area` VALUES ('230900000000', '230000000000', 2, 0, '七台河市');
INSERT INTO `comm_address_area` VALUES ('230902000000', '230900000000', 3, 0, '新兴区');
INSERT INTO `comm_address_area` VALUES ('230903000000', '230900000000', 3, 0, '桃山区');
INSERT INTO `comm_address_area` VALUES ('230904000000', '230900000000', 3, 0, '茄子河区');
INSERT INTO `comm_address_area` VALUES ('230921000000', '230900000000', 3, 0, '勃利县');
INSERT INTO `comm_address_area` VALUES ('231000000000', '230000000000', 2, 0, '牡丹江市');
INSERT INTO `comm_address_area` VALUES ('231002000000', '231000000000', 3, 0, '东安区');
INSERT INTO `comm_address_area` VALUES ('231003000000', '231000000000', 3, 0, '阳明区');
INSERT INTO `comm_address_area` VALUES ('231004000000', '231000000000', 3, 0, '爱民区');
INSERT INTO `comm_address_area` VALUES ('231005000000', '231000000000', 3, 0, '西安区');
INSERT INTO `comm_address_area` VALUES ('231024000000', '231000000000', 3, 0, '东宁县');
INSERT INTO `comm_address_area` VALUES ('231025000000', '231000000000', 3, 0, '林口县');
INSERT INTO `comm_address_area` VALUES ('231081000000', '231000000000', 3, 0, '绥芬河市');
INSERT INTO `comm_address_area` VALUES ('231083000000', '231000000000', 3, 0, '海林市');
INSERT INTO `comm_address_area` VALUES ('231084000000', '231000000000', 3, 0, '宁安市');
INSERT INTO `comm_address_area` VALUES ('231085000000', '231000000000', 3, 0, '穆棱市');
INSERT INTO `comm_address_area` VALUES ('231100000000', '230000000000', 2, 0, '黑河市');
INSERT INTO `comm_address_area` VALUES ('231102000000', '231100000000', 3, 0, '爱辉区');
INSERT INTO `comm_address_area` VALUES ('231121000000', '231100000000', 3, 0, '嫩江县');
INSERT INTO `comm_address_area` VALUES ('231123000000', '231100000000', 3, 0, '逊克县');
INSERT INTO `comm_address_area` VALUES ('231124000000', '231100000000', 3, 0, '孙吴县');
INSERT INTO `comm_address_area` VALUES ('231181000000', '231100000000', 3, 0, '北安市');
INSERT INTO `comm_address_area` VALUES ('231182000000', '231100000000', 3, 0, '五大连池市');
INSERT INTO `comm_address_area` VALUES ('231200000000', '230000000000', 2, 0, '绥化市');
INSERT INTO `comm_address_area` VALUES ('231202000000', '231200000000', 3, 0, '北林区');
INSERT INTO `comm_address_area` VALUES ('231221000000', '231200000000', 3, 0, '望奎县');
INSERT INTO `comm_address_area` VALUES ('231222000000', '231200000000', 3, 0, '兰西县');
INSERT INTO `comm_address_area` VALUES ('231223000000', '231200000000', 3, 0, '青冈县');
INSERT INTO `comm_address_area` VALUES ('231224000000', '231200000000', 3, 0, '庆安县');
INSERT INTO `comm_address_area` VALUES ('231225000000', '231200000000', 3, 0, '明水县');
INSERT INTO `comm_address_area` VALUES ('231226000000', '231200000000', 3, 0, '绥棱县');
INSERT INTO `comm_address_area` VALUES ('231281000000', '231200000000', 3, 0, '安达市');
INSERT INTO `comm_address_area` VALUES ('231282000000', '231200000000', 3, 0, '肇东市');
INSERT INTO `comm_address_area` VALUES ('231283000000', '231200000000', 3, 0, '海伦市');
INSERT INTO `comm_address_area` VALUES ('232700000000', '230000000000', 2, 0, '大兴安岭地区');
INSERT INTO `comm_address_area` VALUES ('232701000000', '232700000000', 3, 0, '加格达奇区');
INSERT INTO `comm_address_area` VALUES ('232702000000', '232700000000', 3, 0, '松岭区');
INSERT INTO `comm_address_area` VALUES ('232703000000', '232700000000', 3, 0, '新林区');
INSERT INTO `comm_address_area` VALUES ('232704000000', '232700000000', 3, 0, '呼中区');
INSERT INTO `comm_address_area` VALUES ('232721000000', '232700000000', 3, 0, '呼玛县');
INSERT INTO `comm_address_area` VALUES ('232722000000', '232700000000', 3, 0, '塔河县');
INSERT INTO `comm_address_area` VALUES ('232723000000', '232700000000', 3, 0, '漠河县');
INSERT INTO `comm_address_area` VALUES ('420000000000', '0', 1, 0, '湖北省');
INSERT INTO `comm_address_area` VALUES ('420100000000', '420000000000', 2, 0, '武汉市');
INSERT INTO `comm_address_area` VALUES ('420102000000', '420100000000', 3, 0, '江岸区');
INSERT INTO `comm_address_area` VALUES ('420103000000', '420100000000', 3, 0, '江汉区');
INSERT INTO `comm_address_area` VALUES ('420104000000', '420100000000', 3, 0, '硚口区');
INSERT INTO `comm_address_area` VALUES ('420105000000', '420100000000', 3, 0, '汉阳区');
INSERT INTO `comm_address_area` VALUES ('420106000000', '420100000000', 3, 0, '武昌区');
INSERT INTO `comm_address_area` VALUES ('420107000000', '420100000000', 3, 0, '青山区');
INSERT INTO `comm_address_area` VALUES ('420111000000', '420100000000', 3, 0, '洪山区');
INSERT INTO `comm_address_area` VALUES ('420112000000', '420100000000', 3, 0, '东西湖区');
INSERT INTO `comm_address_area` VALUES ('420113000000', '420100000000', 3, 0, '汉南区');
INSERT INTO `comm_address_area` VALUES ('420114000000', '420100000000', 3, 0, '蔡甸区');
INSERT INTO `comm_address_area` VALUES ('420115000000', '420100000000', 3, 0, '江夏区');
INSERT INTO `comm_address_area` VALUES ('420116000000', '420100000000', 3, 0, '黄陂区');
INSERT INTO `comm_address_area` VALUES ('420117000000', '420100000000', 3, 0, '新洲区');
INSERT INTO `comm_address_area` VALUES ('420200000000', '420000000000', 2, 0, '黄石市');
INSERT INTO `comm_address_area` VALUES ('420202000000', '420200000000', 3, 0, '黄石港区');
INSERT INTO `comm_address_area` VALUES ('420203000000', '420200000000', 3, 0, '西塞山区');
INSERT INTO `comm_address_area` VALUES ('420204000000', '420200000000', 3, 0, '下陆区');
INSERT INTO `comm_address_area` VALUES ('420205000000', '420200000000', 3, 0, '铁山区');
INSERT INTO `comm_address_area` VALUES ('420222000000', '420200000000', 3, 0, '阳新县');
INSERT INTO `comm_address_area` VALUES ('420281000000', '420200000000', 3, 0, '大冶市');
INSERT INTO `comm_address_area` VALUES ('420300000000', '420000000000', 2, 0, '十堰市');
INSERT INTO `comm_address_area` VALUES ('420302000000', '420300000000', 3, 0, '茅箭区');
INSERT INTO `comm_address_area` VALUES ('420303000000', '420300000000', 3, 0, '张湾区');
INSERT INTO `comm_address_area` VALUES ('420321000000', '420300000000', 3, 0, '郧县');
INSERT INTO `comm_address_area` VALUES ('420322000000', '420300000000', 3, 0, '郧西县');
INSERT INTO `comm_address_area` VALUES ('420323000000', '420300000000', 3, 0, '竹山县');
INSERT INTO `comm_address_area` VALUES ('420324000000', '420300000000', 3, 0, '竹溪县');
INSERT INTO `comm_address_area` VALUES ('420325000000', '420300000000', 3, 0, '房县');
INSERT INTO `comm_address_area` VALUES ('420381000000', '420300000000', 3, 0, '丹江口市');
INSERT INTO `comm_address_area` VALUES ('420500000000', '420000000000', 2, 0, '宜昌市');
INSERT INTO `comm_address_area` VALUES ('420502000000', '420500000000', 3, 0, '西陵区');
INSERT INTO `comm_address_area` VALUES ('420503000000', '420500000000', 3, 0, '伍家岗区');
INSERT INTO `comm_address_area` VALUES ('420504000000', '420500000000', 3, 0, '点军区');
INSERT INTO `comm_address_area` VALUES ('420505000000', '420500000000', 3, 0, '猇亭区');
INSERT INTO `comm_address_area` VALUES ('420506000000', '420500000000', 3, 0, '夷陵区');
INSERT INTO `comm_address_area` VALUES ('420525000000', '420500000000', 3, 0, '远安县');
INSERT INTO `comm_address_area` VALUES ('420526000000', '420500000000', 3, 0, '兴山县');
INSERT INTO `comm_address_area` VALUES ('420527000000', '420500000000', 3, 0, '秭归县');
INSERT INTO `comm_address_area` VALUES ('420528000000', '420500000000', 3, 0, '长阳土家族自治县');
INSERT INTO `comm_address_area` VALUES ('420529000000', '420500000000', 3, 0, '五峰土家族自治县');
INSERT INTO `comm_address_area` VALUES ('420581000000', '420500000000', 3, 0, '宜都市');
INSERT INTO `comm_address_area` VALUES ('420582000000', '420500000000', 3, 0, '当阳市');
INSERT INTO `comm_address_area` VALUES ('420583000000', '420500000000', 3, 0, '枝江市');
INSERT INTO `comm_address_area` VALUES ('420600000000', '420000000000', 2, 0, '襄阳市');
INSERT INTO `comm_address_area` VALUES ('420602000000', '420600000000', 3, 0, '襄城区');
INSERT INTO `comm_address_area` VALUES ('420606000000', '420600000000', 3, 0, '樊城区');
INSERT INTO `comm_address_area` VALUES ('420607000000', '420600000000', 3, 0, '襄州区');
INSERT INTO `comm_address_area` VALUES ('420624000000', '420600000000', 3, 0, '南漳县');
INSERT INTO `comm_address_area` VALUES ('420625000000', '420600000000', 3, 0, '谷城县');
INSERT INTO `comm_address_area` VALUES ('420626000000', '420600000000', 3, 0, '保康县');
INSERT INTO `comm_address_area` VALUES ('420682000000', '420600000000', 3, 0, '老河口市');
INSERT INTO `comm_address_area` VALUES ('420683000000', '420600000000', 3, 0, '枣阳市');
INSERT INTO `comm_address_area` VALUES ('420684000000', '420600000000', 3, 0, '宜城市');
INSERT INTO `comm_address_area` VALUES ('420700000000', '420000000000', 2, 0, '鄂州市');
INSERT INTO `comm_address_area` VALUES ('420702000000', '420700000000', 3, 0, '梁子湖区');
INSERT INTO `comm_address_area` VALUES ('420703000000', '420700000000', 3, 0, '华容区');
INSERT INTO `comm_address_area` VALUES ('420704000000', '420700000000', 3, 0, '鄂城区');
INSERT INTO `comm_address_area` VALUES ('420800000000', '420000000000', 2, 0, '荆门市');
INSERT INTO `comm_address_area` VALUES ('420802000000', '420800000000', 3, 0, '东宝区');
INSERT INTO `comm_address_area` VALUES ('420804000000', '420800000000', 3, 0, '掇刀区');
INSERT INTO `comm_address_area` VALUES ('420821000000', '420800000000', 3, 0, '京山县');
INSERT INTO `comm_address_area` VALUES ('420822000000', '420800000000', 3, 0, '沙洋县');
INSERT INTO `comm_address_area` VALUES ('420881000000', '420800000000', 3, 0, '钟祥市');
INSERT INTO `comm_address_area` VALUES ('420900000000', '420000000000', 2, 0, '孝感市');
INSERT INTO `comm_address_area` VALUES ('420902000000', '420900000000', 3, 0, '孝南区');
INSERT INTO `comm_address_area` VALUES ('420921000000', '420900000000', 3, 0, '孝昌县');
INSERT INTO `comm_address_area` VALUES ('420922000000', '420900000000', 3, 0, '大悟县');
INSERT INTO `comm_address_area` VALUES ('420923000000', '420900000000', 3, 0, '云梦县');
INSERT INTO `comm_address_area` VALUES ('420981000000', '420900000000', 3, 0, '应城市');
INSERT INTO `comm_address_area` VALUES ('420982000000', '420900000000', 3, 0, '安陆市');
INSERT INTO `comm_address_area` VALUES ('420984000000', '420900000000', 3, 0, '汉川市');
INSERT INTO `comm_address_area` VALUES ('421000000000', '420000000000', 2, 0, '荆州市');
INSERT INTO `comm_address_area` VALUES ('421002000000', '421000000000', 3, 0, '沙市区');
INSERT INTO `comm_address_area` VALUES ('421003000000', '421000000000', 3, 0, '荆州区');
INSERT INTO `comm_address_area` VALUES ('421022000000', '421000000000', 3, 0, '公安县');
INSERT INTO `comm_address_area` VALUES ('421023000000', '421000000000', 3, 0, '监利县');
INSERT INTO `comm_address_area` VALUES ('421024000000', '421000000000', 3, 0, '江陵县');
INSERT INTO `comm_address_area` VALUES ('421081000000', '421000000000', 3, 0, '石首市');
INSERT INTO `comm_address_area` VALUES ('421083000000', '421000000000', 3, 0, '洪湖市');
INSERT INTO `comm_address_area` VALUES ('421087000000', '421000000000', 3, 0, '松滋市');
INSERT INTO `comm_address_area` VALUES ('421100000000', '420000000000', 2, 0, '黄冈市');
INSERT INTO `comm_address_area` VALUES ('421102000000', '421100000000', 3, 0, '黄州区');
INSERT INTO `comm_address_area` VALUES ('421121000000', '421100000000', 3, 0, '团风县');
INSERT INTO `comm_address_area` VALUES ('421122000000', '421100000000', 3, 0, '红安县');
INSERT INTO `comm_address_area` VALUES ('421123000000', '421100000000', 3, 0, '罗田县');
INSERT INTO `comm_address_area` VALUES ('421124000000', '421100000000', 3, 0, '英山县');
INSERT INTO `comm_address_area` VALUES ('421125000000', '421100000000', 3, 0, '浠水县');
INSERT INTO `comm_address_area` VALUES ('421126000000', '421100000000', 3, 0, '蕲春县');
INSERT INTO `comm_address_area` VALUES ('421127000000', '421100000000', 3, 0, '黄梅县');
INSERT INTO `comm_address_area` VALUES ('421181000000', '421100000000', 3, 0, '麻城市');
INSERT INTO `comm_address_area` VALUES ('421182000000', '421100000000', 3, 0, '武穴市');
INSERT INTO `comm_address_area` VALUES ('421200000000', '420000000000', 2, 0, '咸宁市');
INSERT INTO `comm_address_area` VALUES ('421202000000', '421200000000', 3, 0, '咸安区');
INSERT INTO `comm_address_area` VALUES ('421221000000', '421200000000', 3, 0, '嘉鱼县');
INSERT INTO `comm_address_area` VALUES ('421222000000', '421200000000', 3, 0, '通城县');
INSERT INTO `comm_address_area` VALUES ('421223000000', '421200000000', 3, 0, '崇阳县');
INSERT INTO `comm_address_area` VALUES ('421224000000', '421200000000', 3, 0, '通山县');
INSERT INTO `comm_address_area` VALUES ('421281000000', '421200000000', 3, 0, '赤壁市');
INSERT INTO `comm_address_area` VALUES ('421300000000', '420000000000', 2, 0, '随州市');
INSERT INTO `comm_address_area` VALUES ('421303000000', '421300000000', 3, 0, '曾都区');
INSERT INTO `comm_address_area` VALUES ('421321000000', '421300000000', 3, 0, '随县');
INSERT INTO `comm_address_area` VALUES ('421381000000', '421300000000', 3, 0, '广水市');
INSERT INTO `comm_address_area` VALUES ('422800000000', '420000000000', 2, 0, '恩施土家族苗族自治州');
INSERT INTO `comm_address_area` VALUES ('422801000000', '422800000000', 3, 0, '恩施市');
INSERT INTO `comm_address_area` VALUES ('422802000000', '422800000000', 3, 0, '利川市');
INSERT INTO `comm_address_area` VALUES ('422822000000', '422800000000', 3, 0, '建始县');
INSERT INTO `comm_address_area` VALUES ('422823000000', '422800000000', 3, 0, '巴东县');
INSERT INTO `comm_address_area` VALUES ('422825000000', '422800000000', 3, 0, '宣恩县');
INSERT INTO `comm_address_area` VALUES ('422826000000', '422800000000', 3, 0, '咸丰县');
INSERT INTO `comm_address_area` VALUES ('422827000000', '422800000000', 3, 0, '来凤县');
INSERT INTO `comm_address_area` VALUES ('422828000000', '422800000000', 3, 0, '鹤峰县');
INSERT INTO `comm_address_area` VALUES ('429000000000', '420000000000', 2, 0, '省直辖县级行政区划');
INSERT INTO `comm_address_area` VALUES ('429004000000', '429000000000', 3, 0, '仙桃市');
INSERT INTO `comm_address_area` VALUES ('429005000000', '429000000000', 3, 0, '潜江市');
INSERT INTO `comm_address_area` VALUES ('429006000000', '429000000000', 3, 0, '天门市');
INSERT INTO `comm_address_area` VALUES ('429021000000', '429000000000', 3, 0, '神农架林区');
INSERT INTO `comm_address_area` VALUES ('220000000000', '0', 1, 0, '吉林省');
INSERT INTO `comm_address_area` VALUES ('220100000000', '220000000000', 2, 0, '长春市');
INSERT INTO `comm_address_area` VALUES ('220102000000', '220100000000', 3, 0, '南关区');
INSERT INTO `comm_address_area` VALUES ('220103000000', '220100000000', 3, 0, '宽城区');
INSERT INTO `comm_address_area` VALUES ('220181000000', '220100000000', 3, 0, '九台市');
INSERT INTO `comm_address_area` VALUES ('220104000000', '220100000000', 3, 0, '朝阳区');
INSERT INTO `comm_address_area` VALUES ('220105000000', '220100000000', 3, 0, '二道区');
INSERT INTO `comm_address_area` VALUES ('220106000000', '220100000000', 3, 0, '绿园区');
INSERT INTO `comm_address_area` VALUES ('220112000000', '220100000000', 3, 0, '双阳区');
INSERT INTO `comm_address_area` VALUES ('220122000000', '220100000000', 3, 0, '农安县');
INSERT INTO `comm_address_area` VALUES ('220182000000', '220100000000', 3, 0, '榆树市');
INSERT INTO `comm_address_area` VALUES ('220183000000', '220100000000', 3, 0, '德惠市');
INSERT INTO `comm_address_area` VALUES ('220200000000', '220000000000', 2, 0, '吉林市');
INSERT INTO `comm_address_area` VALUES ('220202000000', '220200000000', 3, 0, '昌邑区');
INSERT INTO `comm_address_area` VALUES ('220203000000', '220200000000', 3, 0, '龙潭区');
INSERT INTO `comm_address_area` VALUES ('220204000000', '220200000000', 3, 0, '船营区');
INSERT INTO `comm_address_area` VALUES ('220211000000', '220200000000', 3, 0, '丰满区');
INSERT INTO `comm_address_area` VALUES ('220221000000', '220200000000', 3, 0, '永吉县');
INSERT INTO `comm_address_area` VALUES ('220281000000', '220200000000', 3, 0, '蛟河市');
INSERT INTO `comm_address_area` VALUES ('220282000000', '220200000000', 3, 0, '桦甸市');
INSERT INTO `comm_address_area` VALUES ('220283000000', '220200000000', 3, 0, '舒兰市');
INSERT INTO `comm_address_area` VALUES ('220284000000', '220200000000', 3, 0, '磐石市');
INSERT INTO `comm_address_area` VALUES ('220300000000', '220000000000', 2, 0, '四平市');
INSERT INTO `comm_address_area` VALUES ('220302000000', '220300000000', 3, 0, '铁西区');
INSERT INTO `comm_address_area` VALUES ('220303000000', '220300000000', 3, 0, '铁东区');
INSERT INTO `comm_address_area` VALUES ('220322000000', '220300000000', 3, 0, '梨树县');
INSERT INTO `comm_address_area` VALUES ('220323000000', '220300000000', 3, 0, '伊通满族自治县');
INSERT INTO `comm_address_area` VALUES ('220381000000', '220300000000', 3, 0, '公主岭市');
INSERT INTO `comm_address_area` VALUES ('220382000000', '220300000000', 3, 0, '双辽市');
INSERT INTO `comm_address_area` VALUES ('220400000000', '220000000000', 2, 0, '辽源市');
INSERT INTO `comm_address_area` VALUES ('220402000000', '220400000000', 3, 0, '龙山区');
INSERT INTO `comm_address_area` VALUES ('220403000000', '220400000000', 3, 0, '西安区');
INSERT INTO `comm_address_area` VALUES ('220421000000', '220400000000', 3, 0, '东丰县');
INSERT INTO `comm_address_area` VALUES ('220422000000', '220400000000', 3, 0, '东辽县');
INSERT INTO `comm_address_area` VALUES ('220500000000', '220000000000', 2, 0, '通化市');
INSERT INTO `comm_address_area` VALUES ('220502000000', '220500000000', 3, 0, '东昌区');
INSERT INTO `comm_address_area` VALUES ('220503000000', '220500000000', 3, 0, '二道江区');
INSERT INTO `comm_address_area` VALUES ('220521000000', '220500000000', 3, 0, '通化县');
INSERT INTO `comm_address_area` VALUES ('220523000000', '220500000000', 3, 0, '辉南县');
INSERT INTO `comm_address_area` VALUES ('220524000000', '220500000000', 3, 0, '柳河县');
INSERT INTO `comm_address_area` VALUES ('220581000000', '220500000000', 3, 0, '梅河口市');
INSERT INTO `comm_address_area` VALUES ('220582000000', '220500000000', 3, 0, '集安市');
INSERT INTO `comm_address_area` VALUES ('220600000000', '220000000000', 2, 0, '白山市');
INSERT INTO `comm_address_area` VALUES ('220602000000', '220600000000', 3, 0, '八道江区');
INSERT INTO `comm_address_area` VALUES ('220605000000', '220600000000', 3, 0, '江源区');
INSERT INTO `comm_address_area` VALUES ('220621000000', '220600000000', 3, 0, '抚松县');
INSERT INTO `comm_address_area` VALUES ('220622000000', '220600000000', 3, 0, '靖宇县');
INSERT INTO `comm_address_area` VALUES ('220623000000', '220600000000', 3, 0, '长白朝鲜族自治县');
INSERT INTO `comm_address_area` VALUES ('220681000000', '220600000000', 3, 0, '临江市');
INSERT INTO `comm_address_area` VALUES ('220700000000', '220000000000', 2, 0, '松原市');
INSERT INTO `comm_address_area` VALUES ('220702000000', '220700000000', 3, 0, '宁江区');
INSERT INTO `comm_address_area` VALUES ('220721000000', '220700000000', 3, 0, '前郭尔罗斯蒙古族自治县');
INSERT INTO `comm_address_area` VALUES ('220722000000', '220700000000', 3, 0, '长岭县');
INSERT INTO `comm_address_area` VALUES ('220723000000', '220700000000', 3, 0, '乾安县');
INSERT INTO `comm_address_area` VALUES ('220724000000', '220700000000', 3, 0, '扶余县');
INSERT INTO `comm_address_area` VALUES ('220800000000', '220000000000', 2, 0, '白城市');
INSERT INTO `comm_address_area` VALUES ('220802000000', '220800000000', 3, 0, '洮北区');
INSERT INTO `comm_address_area` VALUES ('220821000000', '220800000000', 3, 0, '镇赉县');
INSERT INTO `comm_address_area` VALUES ('220822000000', '220800000000', 3, 0, '通榆县');
INSERT INTO `comm_address_area` VALUES ('220881000000', '220800000000', 3, 0, '洮南市');
INSERT INTO `comm_address_area` VALUES ('220882000000', '220800000000', 3, 0, '大安市');
INSERT INTO `comm_address_area` VALUES ('222400000000', '220000000000', 2, 0, '延边朝鲜族自治州');
INSERT INTO `comm_address_area` VALUES ('222401000000', '222400000000', 3, 0, '延吉市');
INSERT INTO `comm_address_area` VALUES ('222402000000', '222400000000', 3, 0, '图们市');
INSERT INTO `comm_address_area` VALUES ('222403000000', '222400000000', 3, 0, '敦化市');
INSERT INTO `comm_address_area` VALUES ('222404000000', '222400000000', 3, 0, '珲春市');
INSERT INTO `comm_address_area` VALUES ('222405000000', '222400000000', 3, 0, '龙井市');
INSERT INTO `comm_address_area` VALUES ('222406000000', '222400000000', 3, 0, '和龙市');
INSERT INTO `comm_address_area` VALUES ('222424000000', '222400000000', 3, 0, '汪清县');
INSERT INTO `comm_address_area` VALUES ('222426000000', '222400000000', 3, 0, '安图县');
INSERT INTO `comm_address_area` VALUES ('320000000000', '0', 1, 0, '江苏省');
INSERT INTO `comm_address_area` VALUES ('320100000000', '320000000000', 2, 0, '南京市');
INSERT INTO `comm_address_area` VALUES ('320102000000', '320100000000', 3, 0, '玄武区');
INSERT INTO `comm_address_area` VALUES ('320103000000', '320100000000', 3, 0, '白下区');
INSERT INTO `comm_address_area` VALUES ('320104000000', '320100000000', 3, 0, '秦淮区');
INSERT INTO `comm_address_area` VALUES ('320105000000', '320100000000', 3, 0, '建邺区');
INSERT INTO `comm_address_area` VALUES ('320106000000', '320100000000', 3, 0, '鼓楼区');
INSERT INTO `comm_address_area` VALUES ('320107000000', '320100000000', 3, 0, '下关区');
INSERT INTO `comm_address_area` VALUES ('320111000000', '320100000000', 3, 0, '浦口区');
INSERT INTO `comm_address_area` VALUES ('320113000000', '320100000000', 3, 0, '栖霞区');
INSERT INTO `comm_address_area` VALUES ('320114000000', '320100000000', 3, 0, '雨花台区');
INSERT INTO `comm_address_area` VALUES ('320115000000', '320100000000', 3, 0, '江宁区');
INSERT INTO `comm_address_area` VALUES ('320116000000', '320100000000', 3, 0, '六合区');
INSERT INTO `comm_address_area` VALUES ('320124000000', '320100000000', 3, 0, '溧水县');
INSERT INTO `comm_address_area` VALUES ('320125000000', '320100000000', 3, 0, '高淳县');
INSERT INTO `comm_address_area` VALUES ('320200000000', '320000000000', 2, 0, '无锡市');
INSERT INTO `comm_address_area` VALUES ('320202000000', '320200000000', 3, 0, '崇安区');
INSERT INTO `comm_address_area` VALUES ('320203000000', '320200000000', 3, 0, '南长区');
INSERT INTO `comm_address_area` VALUES ('320204000000', '320200000000', 3, 0, '北塘区');
INSERT INTO `comm_address_area` VALUES ('320205000000', '320200000000', 3, 0, '锡山区');
INSERT INTO `comm_address_area` VALUES ('320206000000', '320200000000', 3, 0, '惠山区');
INSERT INTO `comm_address_area` VALUES ('320211000000', '320200000000', 3, 0, '滨湖区');
INSERT INTO `comm_address_area` VALUES ('320281000000', '320200000000', 3, 0, '江阴市');
INSERT INTO `comm_address_area` VALUES ('320282000000', '320200000000', 3, 0, '宜兴市');
INSERT INTO `comm_address_area` VALUES ('320300000000', '320000000000', 2, 0, '徐州市');
INSERT INTO `comm_address_area` VALUES ('320302000000', '320300000000', 3, 0, '鼓楼区');
INSERT INTO `comm_address_area` VALUES ('320303000000', '320300000000', 3, 0, '云龙区');
INSERT INTO `comm_address_area` VALUES ('320305000000', '320300000000', 3, 0, '贾汪区');
INSERT INTO `comm_address_area` VALUES ('320311000000', '320300000000', 3, 0, '泉山区');
INSERT INTO `comm_address_area` VALUES ('320312000000', '320300000000', 3, 0, '铜山区');
INSERT INTO `comm_address_area` VALUES ('320321000000', '320300000000', 3, 0, '丰县');
INSERT INTO `comm_address_area` VALUES ('320322000000', '320300000000', 3, 0, '沛县');
INSERT INTO `comm_address_area` VALUES ('320324000000', '320300000000', 3, 0, '睢宁县');
INSERT INTO `comm_address_area` VALUES ('320381000000', '320300000000', 3, 0, '新沂市');
INSERT INTO `comm_address_area` VALUES ('320382000000', '320300000000', 3, 0, '邳州市');
INSERT INTO `comm_address_area` VALUES ('320400000000', '320000000000', 2, 0, '常州市');
INSERT INTO `comm_address_area` VALUES ('320402000000', '320400000000', 3, 0, '天宁区');
INSERT INTO `comm_address_area` VALUES ('320404000000', '320400000000', 3, 0, '钟楼区');
INSERT INTO `comm_address_area` VALUES ('320405000000', '320400000000', 3, 0, '戚墅堰区');
INSERT INTO `comm_address_area` VALUES ('320411000000', '320400000000', 3, 0, '新北区');
INSERT INTO `comm_address_area` VALUES ('320412000000', '320400000000', 3, 0, '武进区');
INSERT INTO `comm_address_area` VALUES ('320481000000', '320400000000', 3, 0, '溧阳市');
INSERT INTO `comm_address_area` VALUES ('320482000000', '320400000000', 3, 0, '金坛市');
INSERT INTO `comm_address_area` VALUES ('320500000000', '320000000000', 2, 0, '苏州市');
INSERT INTO `comm_address_area` VALUES ('320502000000', '320500000000', 3, 0, '沧浪区');
INSERT INTO `comm_address_area` VALUES ('320503000000', '320500000000', 3, 0, '平江区');
INSERT INTO `comm_address_area` VALUES ('320504000000', '320500000000', 3, 0, '金阊区');
INSERT INTO `comm_address_area` VALUES ('320505000000', '320500000000', 3, 0, '虎丘区');
INSERT INTO `comm_address_area` VALUES ('320506000000', '320500000000', 3, 0, '吴中区');
INSERT INTO `comm_address_area` VALUES ('320507000000', '320500000000', 3, 0, '相城区');
INSERT INTO `comm_address_area` VALUES ('320581000000', '320500000000', 3, 0, '常熟市');
INSERT INTO `comm_address_area` VALUES ('320582000000', '320500000000', 3, 0, '张家港市');
INSERT INTO `comm_address_area` VALUES ('320583000000', '320500000000', 3, 0, '昆山市');
INSERT INTO `comm_address_area` VALUES ('320584000000', '320500000000', 3, 0, '吴江市');
INSERT INTO `comm_address_area` VALUES ('320585000000', '320500000000', 3, 0, '太仓市');
INSERT INTO `comm_address_area` VALUES ('320600000000', '320000000000', 2, 0, '南通市');
INSERT INTO `comm_address_area` VALUES ('320602000000', '320600000000', 3, 0, '崇川区');
INSERT INTO `comm_address_area` VALUES ('320611000000', '320600000000', 3, 0, '港闸区');
INSERT INTO `comm_address_area` VALUES ('320612000000', '320600000000', 3, 0, '通州区');
INSERT INTO `comm_address_area` VALUES ('320621000000', '320600000000', 3, 0, '海安县');
INSERT INTO `comm_address_area` VALUES ('320623000000', '320600000000', 3, 0, '如东县');
INSERT INTO `comm_address_area` VALUES ('320681000000', '320600000000', 3, 0, '启东市');
INSERT INTO `comm_address_area` VALUES ('320682000000', '320600000000', 3, 0, '如皋市');
INSERT INTO `comm_address_area` VALUES ('320684000000', '320600000000', 3, 0, '海门市');
INSERT INTO `comm_address_area` VALUES ('320700000000', '320000000000', 2, 0, '连云港市');
INSERT INTO `comm_address_area` VALUES ('320703000000', '320700000000', 3, 0, '连云区');
INSERT INTO `comm_address_area` VALUES ('320705000000', '320700000000', 3, 0, '新浦区');
INSERT INTO `comm_address_area` VALUES ('320706000000', '320700000000', 3, 0, '海州区');
INSERT INTO `comm_address_area` VALUES ('320721000000', '320700000000', 3, 0, '赣榆县');
INSERT INTO `comm_address_area` VALUES ('320722000000', '320700000000', 3, 0, '东海县');
INSERT INTO `comm_address_area` VALUES ('320723000000', '320700000000', 3, 0, '灌云县');
INSERT INTO `comm_address_area` VALUES ('320724000000', '320700000000', 3, 0, '灌南县');
INSERT INTO `comm_address_area` VALUES ('320800000000', '320000000000', 2, 0, '淮安市');
INSERT INTO `comm_address_area` VALUES ('320802000000', '320800000000', 3, 0, '清河区');
INSERT INTO `comm_address_area` VALUES ('320803000000', '320800000000', 3, 0, '楚州区');
INSERT INTO `comm_address_area` VALUES ('320804000000', '320800000000', 3, 0, '淮阴区');
INSERT INTO `comm_address_area` VALUES ('320811000000', '320800000000', 3, 0, '清浦区');
INSERT INTO `comm_address_area` VALUES ('320826000000', '320800000000', 3, 0, '涟水县');
INSERT INTO `comm_address_area` VALUES ('320829000000', '320800000000', 3, 0, '洪泽县');
INSERT INTO `comm_address_area` VALUES ('320830000000', '320800000000', 3, 0, '盱眙县');
INSERT INTO `comm_address_area` VALUES ('320831000000', '320800000000', 3, 0, '金湖县');
INSERT INTO `comm_address_area` VALUES ('320900000000', '320000000000', 2, 0, '盐城市');
INSERT INTO `comm_address_area` VALUES ('320902000000', '320900000000', 3, 0, '亭湖区');
INSERT INTO `comm_address_area` VALUES ('320903000000', '320900000000', 3, 0, '盐都区');
INSERT INTO `comm_address_area` VALUES ('320921000000', '320900000000', 3, 0, '响水县');
INSERT INTO `comm_address_area` VALUES ('320922000000', '320900000000', 3, 0, '滨海县');
INSERT INTO `comm_address_area` VALUES ('320923000000', '320900000000', 3, 0, '阜宁县');
INSERT INTO `comm_address_area` VALUES ('320924000000', '320900000000', 3, 0, '射阳县');
INSERT INTO `comm_address_area` VALUES ('320925000000', '320900000000', 3, 0, '建湖县');
INSERT INTO `comm_address_area` VALUES ('320981000000', '320900000000', 3, 0, '东台市');
INSERT INTO `comm_address_area` VALUES ('320982000000', '320900000000', 3, 0, '大丰市');
INSERT INTO `comm_address_area` VALUES ('321000000000', '320000000000', 2, 0, '扬州市');
INSERT INTO `comm_address_area` VALUES ('321002000000', '321000000000', 3, 0, '广陵区');
INSERT INTO `comm_address_area` VALUES ('321003000000', '321000000000', 3, 0, '邗江区');
INSERT INTO `comm_address_area` VALUES ('321012000000', '321000000000', 3, 0, '江都区');
INSERT INTO `comm_address_area` VALUES ('321023000000', '321000000000', 3, 0, '宝应县');
INSERT INTO `comm_address_area` VALUES ('321081000000', '321000000000', 3, 0, '仪征市');
INSERT INTO `comm_address_area` VALUES ('321084000000', '321000000000', 3, 0, '高邮市');
INSERT INTO `comm_address_area` VALUES ('321100000000', '320000000000', 2, 0, '镇江市');
INSERT INTO `comm_address_area` VALUES ('321102000000', '321100000000', 3, 0, '京口区');
INSERT INTO `comm_address_area` VALUES ('321111000000', '321100000000', 3, 0, '润州区');
INSERT INTO `comm_address_area` VALUES ('321112000000', '321100000000', 3, 0, '丹徒区');
INSERT INTO `comm_address_area` VALUES ('321181000000', '321100000000', 3, 0, '丹阳市');
INSERT INTO `comm_address_area` VALUES ('321182000000', '321100000000', 3, 0, '扬中市');
INSERT INTO `comm_address_area` VALUES ('321183000000', '321100000000', 3, 0, '句容市');
INSERT INTO `comm_address_area` VALUES ('321200000000', '320000000000', 2, 0, '泰州市');
INSERT INTO `comm_address_area` VALUES ('321202000000', '321200000000', 3, 0, '海陵区');
INSERT INTO `comm_address_area` VALUES ('321203000000', '321200000000', 3, 0, '高港区');
INSERT INTO `comm_address_area` VALUES ('321281000000', '321200000000', 3, 0, '兴化市');
INSERT INTO `comm_address_area` VALUES ('321282000000', '321200000000', 3, 0, '靖江市');
INSERT INTO `comm_address_area` VALUES ('321283000000', '321200000000', 3, 0, '泰兴市');
INSERT INTO `comm_address_area` VALUES ('321284000000', '321200000000', 3, 0, '姜堰市');
INSERT INTO `comm_address_area` VALUES ('321300000000', '320000000000', 2, 0, '宿迁市');
INSERT INTO `comm_address_area` VALUES ('321302000000', '321300000000', 3, 0, '宿城区');
INSERT INTO `comm_address_area` VALUES ('321311000000', '321300000000', 3, 0, '宿豫区');
INSERT INTO `comm_address_area` VALUES ('321322000000', '321300000000', 3, 0, '沭阳县');
INSERT INTO `comm_address_area` VALUES ('321323000000', '321300000000', 3, 0, '泗阳县');
INSERT INTO `comm_address_area` VALUES ('321324000000', '321300000000', 3, 0, '泗洪县');
INSERT INTO `comm_address_area` VALUES ('360000000000', '0', 1, 0, '江西省');
INSERT INTO `comm_address_area` VALUES ('360100000000', '360000000000', 2, 0, '南昌市');
INSERT INTO `comm_address_area` VALUES ('360102000000', '360100000000', 3, 0, '东湖区');
INSERT INTO `comm_address_area` VALUES ('360103000000', '360100000000', 3, 0, '西湖区');
INSERT INTO `comm_address_area` VALUES ('360104000000', '360100000000', 3, 0, '青云谱区');
INSERT INTO `comm_address_area` VALUES ('360105000000', '360100000000', 3, 0, '湾里区');
INSERT INTO `comm_address_area` VALUES ('360111000000', '360100000000', 3, 0, '青山湖区');
INSERT INTO `comm_address_area` VALUES ('360121000000', '360100000000', 3, 0, '南昌县');
INSERT INTO `comm_address_area` VALUES ('360122000000', '360100000000', 3, 0, '新建县');
INSERT INTO `comm_address_area` VALUES ('360123000000', '360100000000', 3, 0, '安义县');
INSERT INTO `comm_address_area` VALUES ('360124000000', '360100000000', 3, 0, '进贤县');
INSERT INTO `comm_address_area` VALUES ('360200000000', '360000000000', 2, 0, '景德镇市');
INSERT INTO `comm_address_area` VALUES ('360202000000', '360200000000', 3, 0, '昌江区');
INSERT INTO `comm_address_area` VALUES ('360203000000', '360200000000', 3, 0, '珠山区');
INSERT INTO `comm_address_area` VALUES ('360222000000', '360200000000', 3, 0, '浮梁县');
INSERT INTO `comm_address_area` VALUES ('360281000000', '360200000000', 3, 0, '乐平市');
INSERT INTO `comm_address_area` VALUES ('360300000000', '360000000000', 2, 0, '萍乡市');
INSERT INTO `comm_address_area` VALUES ('360302000000', '360300000000', 3, 0, '安源区');
INSERT INTO `comm_address_area` VALUES ('360313000000', '360300000000', 3, 0, '湘东区');
INSERT INTO `comm_address_area` VALUES ('360321000000', '360300000000', 3, 0, '莲花县');
INSERT INTO `comm_address_area` VALUES ('360322000000', '360300000000', 3, 0, '上栗县');
INSERT INTO `comm_address_area` VALUES ('360323000000', '360300000000', 3, 0, '芦溪县');
INSERT INTO `comm_address_area` VALUES ('360400000000', '360000000000', 2, 0, '九江市');
INSERT INTO `comm_address_area` VALUES ('360402000000', '360400000000', 3, 0, '庐山区');
INSERT INTO `comm_address_area` VALUES ('360403000000', '360400000000', 3, 0, '浔阳区');
INSERT INTO `comm_address_area` VALUES ('360421000000', '360400000000', 3, 0, '九江县');
INSERT INTO `comm_address_area` VALUES ('360423000000', '360400000000', 3, 0, '武宁县');
INSERT INTO `comm_address_area` VALUES ('360424000000', '360400000000', 3, 0, '修水县');
INSERT INTO `comm_address_area` VALUES ('360425000000', '360400000000', 3, 0, '永修县');
INSERT INTO `comm_address_area` VALUES ('360426000000', '360400000000', 3, 0, '德安县');
INSERT INTO `comm_address_area` VALUES ('360427000000', '360400000000', 3, 0, '星子县');
INSERT INTO `comm_address_area` VALUES ('360428000000', '360400000000', 3, 0, '都昌县');
INSERT INTO `comm_address_area` VALUES ('360429000000', '360400000000', 3, 0, '湖口县');
INSERT INTO `comm_address_area` VALUES ('360430000000', '360400000000', 3, 0, '彭泽县');
INSERT INTO `comm_address_area` VALUES ('360481000000', '360400000000', 3, 0, '瑞昌市');
INSERT INTO `comm_address_area` VALUES ('360482000000', '360400000000', 3, 0, '共青城市');
INSERT INTO `comm_address_area` VALUES ('360500000000', '360000000000', 2, 0, '新余市');
INSERT INTO `comm_address_area` VALUES ('360502000000', '360500000000', 3, 0, '渝水区');
INSERT INTO `comm_address_area` VALUES ('360521000000', '360500000000', 3, 0, '分宜县');
INSERT INTO `comm_address_area` VALUES ('360600000000', '360000000000', 2, 0, '鹰潭市');
INSERT INTO `comm_address_area` VALUES ('360602000000', '360600000000', 3, 0, '月湖区');
INSERT INTO `comm_address_area` VALUES ('360622000000', '360600000000', 3, 0, '余江县');
INSERT INTO `comm_address_area` VALUES ('360681000000', '360600000000', 3, 0, '贵溪市');
INSERT INTO `comm_address_area` VALUES ('360700000000', '360000000000', 2, 0, '赣州市');
INSERT INTO `comm_address_area` VALUES ('360702000000', '360700000000', 3, 0, '章贡区');
INSERT INTO `comm_address_area` VALUES ('360721000000', '360700000000', 3, 0, '赣县');
INSERT INTO `comm_address_area` VALUES ('360722000000', '360700000000', 3, 0, '信丰县');
INSERT INTO `comm_address_area` VALUES ('360723000000', '360700000000', 3, 0, '大余县');
INSERT INTO `comm_address_area` VALUES ('360724000000', '360700000000', 3, 0, '上犹县');
INSERT INTO `comm_address_area` VALUES ('360725000000', '360700000000', 3, 0, '崇义县');
INSERT INTO `comm_address_area` VALUES ('360726000000', '360700000000', 3, 0, '安远县');
INSERT INTO `comm_address_area` VALUES ('360727000000', '360700000000', 3, 0, '龙南县');
INSERT INTO `comm_address_area` VALUES ('360728000000', '360700000000', 3, 0, '定南县');
INSERT INTO `comm_address_area` VALUES ('360729000000', '360700000000', 3, 0, '全南县');
INSERT INTO `comm_address_area` VALUES ('360730000000', '360700000000', 3, 0, '宁都县');
INSERT INTO `comm_address_area` VALUES ('360731000000', '360700000000', 3, 0, '于都县');
INSERT INTO `comm_address_area` VALUES ('360732000000', '360700000000', 3, 0, '兴国县');
INSERT INTO `comm_address_area` VALUES ('360733000000', '360700000000', 3, 0, '会昌县');
INSERT INTO `comm_address_area` VALUES ('360734000000', '360700000000', 3, 0, '寻乌县');
INSERT INTO `comm_address_area` VALUES ('360735000000', '360700000000', 3, 0, '石城县');
INSERT INTO `comm_address_area` VALUES ('360781000000', '360700000000', 3, 0, '瑞金市');
INSERT INTO `comm_address_area` VALUES ('360782000000', '360700000000', 3, 0, '南康市');
INSERT INTO `comm_address_area` VALUES ('360800000000', '360000000000', 2, 0, '吉安市');
INSERT INTO `comm_address_area` VALUES ('360802000000', '360800000000', 3, 0, '吉州区');
INSERT INTO `comm_address_area` VALUES ('360803000000', '360800000000', 3, 0, '青原区');
INSERT INTO `comm_address_area` VALUES ('360821000000', '360800000000', 3, 0, '吉安县');
INSERT INTO `comm_address_area` VALUES ('360822000000', '360800000000', 3, 0, '吉水县');
INSERT INTO `comm_address_area` VALUES ('360823000000', '360800000000', 3, 0, '峡江县');
INSERT INTO `comm_address_area` VALUES ('360824000000', '360800000000', 3, 0, '新干县');
INSERT INTO `comm_address_area` VALUES ('360825000000', '360800000000', 3, 0, '永丰县');
INSERT INTO `comm_address_area` VALUES ('360826000000', '360800000000', 3, 0, '泰和县');
INSERT INTO `comm_address_area` VALUES ('360827000000', '360800000000', 3, 0, '遂川县');
INSERT INTO `comm_address_area` VALUES ('360828000000', '360800000000', 3, 0, '万安县');
INSERT INTO `comm_address_area` VALUES ('360829000000', '360800000000', 3, 0, '安福县');
INSERT INTO `comm_address_area` VALUES ('360830000000', '360800000000', 3, 0, '永新县');
INSERT INTO `comm_address_area` VALUES ('360881000000', '360800000000', 3, 0, '井冈山市');
INSERT INTO `comm_address_area` VALUES ('360900000000', '360000000000', 2, 0, '宜春市');
INSERT INTO `comm_address_area` VALUES ('360902000000', '360900000000', 3, 0, '袁州区');
INSERT INTO `comm_address_area` VALUES ('360921000000', '360900000000', 3, 0, '奉新县');
INSERT INTO `comm_address_area` VALUES ('360922000000', '360900000000', 3, 0, '万载县');
INSERT INTO `comm_address_area` VALUES ('360923000000', '360900000000', 3, 0, '上高县');
INSERT INTO `comm_address_area` VALUES ('360924000000', '360900000000', 3, 0, '宜丰县');
INSERT INTO `comm_address_area` VALUES ('360925000000', '360900000000', 3, 0, '靖安县');
INSERT INTO `comm_address_area` VALUES ('360926000000', '360900000000', 3, 0, '铜鼓县');
INSERT INTO `comm_address_area` VALUES ('360981000000', '360900000000', 3, 0, '丰城市');
INSERT INTO `comm_address_area` VALUES ('360982000000', '360900000000', 3, 0, '樟树市');
INSERT INTO `comm_address_area` VALUES ('360983000000', '360900000000', 3, 0, '高安市');
INSERT INTO `comm_address_area` VALUES ('361000000000', '360000000000', 2, 0, '抚州市');
INSERT INTO `comm_address_area` VALUES ('361002000000', '361000000000', 3, 0, '临川区');
INSERT INTO `comm_address_area` VALUES ('361021000000', '361000000000', 3, 0, '南城县');
INSERT INTO `comm_address_area` VALUES ('361022000000', '361000000000', 3, 0, '黎川县');
INSERT INTO `comm_address_area` VALUES ('361023000000', '361000000000', 3, 0, '南丰县');
INSERT INTO `comm_address_area` VALUES ('361024000000', '361000000000', 3, 0, '崇仁县');
INSERT INTO `comm_address_area` VALUES ('361025000000', '361000000000', 3, 0, '乐安县');
INSERT INTO `comm_address_area` VALUES ('361026000000', '361000000000', 3, 0, '宜黄县');
INSERT INTO `comm_address_area` VALUES ('361027000000', '361000000000', 3, 0, '金溪县');
INSERT INTO `comm_address_area` VALUES ('361028000000', '361000000000', 3, 0, '资溪县');
INSERT INTO `comm_address_area` VALUES ('361029000000', '361000000000', 3, 0, '东乡县');
INSERT INTO `comm_address_area` VALUES ('361030000000', '361000000000', 3, 0, '广昌县');
INSERT INTO `comm_address_area` VALUES ('361100000000', '360000000000', 2, 0, '上饶市');
INSERT INTO `comm_address_area` VALUES ('361102000000', '361100000000', 3, 0, '信州区');
INSERT INTO `comm_address_area` VALUES ('361121000000', '361100000000', 3, 0, '上饶县');
INSERT INTO `comm_address_area` VALUES ('361122000000', '361100000000', 3, 0, '广丰县');
INSERT INTO `comm_address_area` VALUES ('361123000000', '361100000000', 3, 0, '玉山县');
INSERT INTO `comm_address_area` VALUES ('361124000000', '361100000000', 3, 0, '铅山县');
INSERT INTO `comm_address_area` VALUES ('361125000000', '361100000000', 3, 0, '横峰县');
INSERT INTO `comm_address_area` VALUES ('361126000000', '361100000000', 3, 0, '弋阳县');
INSERT INTO `comm_address_area` VALUES ('361127000000', '361100000000', 3, 0, '余干县');
INSERT INTO `comm_address_area` VALUES ('361128000000', '361100000000', 3, 0, '鄱阳县');
INSERT INTO `comm_address_area` VALUES ('361129000000', '361100000000', 3, 0, '万年县');
INSERT INTO `comm_address_area` VALUES ('361130000000', '361100000000', 3, 0, '婺源县');
INSERT INTO `comm_address_area` VALUES ('361181000000', '361100000000', 3, 0, '德兴市');
INSERT INTO `comm_address_area` VALUES ('210000000000', '0', 1, 0, '辽宁省');
INSERT INTO `comm_address_area` VALUES ('210100000000', '210000000000', 2, 0, '沈阳市');
INSERT INTO `comm_address_area` VALUES ('210102000000', '210100000000', 3, 0, '和平区');
INSERT INTO `comm_address_area` VALUES ('210103000000', '210100000000', 3, 0, '沈河区');
INSERT INTO `comm_address_area` VALUES ('210104000000', '210100000000', 3, 0, '大东区');
INSERT INTO `comm_address_area` VALUES ('210105000000', '210100000000', 3, 0, '皇姑区');
INSERT INTO `comm_address_area` VALUES ('210106000000', '210100000000', 3, 0, '铁西区');
INSERT INTO `comm_address_area` VALUES ('210111000000', '210100000000', 3, 0, '苏家屯区');
INSERT INTO `comm_address_area` VALUES ('210112000000', '210100000000', 3, 0, '东陵区');
INSERT INTO `comm_address_area` VALUES ('210113000000', '210100000000', 3, 0, '沈北新区');
INSERT INTO `comm_address_area` VALUES ('210114000000', '210100000000', 3, 0, '于洪区');
INSERT INTO `comm_address_area` VALUES ('210122000000', '210100000000', 3, 0, '辽中县');
INSERT INTO `comm_address_area` VALUES ('210123000000', '210100000000', 3, 0, '康平县');
INSERT INTO `comm_address_area` VALUES ('210124000000', '210100000000', 3, 0, '法库县');
INSERT INTO `comm_address_area` VALUES ('210181000000', '210100000000', 3, 0, '新民市');
INSERT INTO `comm_address_area` VALUES ('210200000000', '210000000000', 2, 0, '大连市');
INSERT INTO `comm_address_area` VALUES ('210202000000', '210200000000', 3, 0, '中山区');
INSERT INTO `comm_address_area` VALUES ('210203000000', '210200000000', 3, 0, '西岗区');
INSERT INTO `comm_address_area` VALUES ('210204000000', '210200000000', 3, 0, '沙河口区');
INSERT INTO `comm_address_area` VALUES ('210211000000', '210200000000', 3, 0, '甘井子区');
INSERT INTO `comm_address_area` VALUES ('210212000000', '210200000000', 3, 0, '旅顺口区');
INSERT INTO `comm_address_area` VALUES ('210213000000', '210200000000', 3, 0, '金州区');
INSERT INTO `comm_address_area` VALUES ('210224000000', '210200000000', 3, 0, '长海县');
INSERT INTO `comm_address_area` VALUES ('210281000000', '210200000000', 3, 0, '瓦房店市');
INSERT INTO `comm_address_area` VALUES ('210282000000', '210200000000', 3, 0, '普兰店市');
INSERT INTO `comm_address_area` VALUES ('210283000000', '210200000000', 3, 0, '庄河市');
INSERT INTO `comm_address_area` VALUES ('210300000000', '210000000000', 2, 0, '鞍山市');
INSERT INTO `comm_address_area` VALUES ('210302000000', '210300000000', 3, 0, '铁东区');
INSERT INTO `comm_address_area` VALUES ('210303000000', '210300000000', 3, 0, '铁西区');
INSERT INTO `comm_address_area` VALUES ('210304000000', '210300000000', 3, 0, '立山区');
INSERT INTO `comm_address_area` VALUES ('210311000000', '210300000000', 3, 0, '千山区');
INSERT INTO `comm_address_area` VALUES ('210321000000', '210300000000', 3, 0, '台安县');
INSERT INTO `comm_address_area` VALUES ('210323000000', '210300000000', 3, 0, '岫岩满族自治县');
INSERT INTO `comm_address_area` VALUES ('210381000000', '210300000000', 3, 0, '海城市');
INSERT INTO `comm_address_area` VALUES ('210400000000', '210000000000', 2, 0, '抚顺市');
INSERT INTO `comm_address_area` VALUES ('210402000000', '210400000000', 3, 0, '新抚区');
INSERT INTO `comm_address_area` VALUES ('210403000000', '210400000000', 3, 0, '东洲区');
INSERT INTO `comm_address_area` VALUES ('210404000000', '210400000000', 3, 0, '望花区');
INSERT INTO `comm_address_area` VALUES ('210411000000', '210400000000', 3, 0, '顺城区');
INSERT INTO `comm_address_area` VALUES ('210421000000', '210400000000', 3, 0, '抚顺县');
INSERT INTO `comm_address_area` VALUES ('210422000000', '210400000000', 3, 0, '新宾满族自治县');
INSERT INTO `comm_address_area` VALUES ('210423000000', '210400000000', 3, 0, '清原满族自治县');
INSERT INTO `comm_address_area` VALUES ('210500000000', '210000000000', 2, 0, '本溪市');
INSERT INTO `comm_address_area` VALUES ('210502000000', '210500000000', 3, 0, '平山区');
INSERT INTO `comm_address_area` VALUES ('210503000000', '210500000000', 3, 0, '溪湖区');
INSERT INTO `comm_address_area` VALUES ('210504000000', '210500000000', 3, 0, '明山区');
INSERT INTO `comm_address_area` VALUES ('210505000000', '210500000000', 3, 0, '南芬区');
INSERT INTO `comm_address_area` VALUES ('210521000000', '210500000000', 3, 0, '本溪满族自治县');
INSERT INTO `comm_address_area` VALUES ('210522000000', '210500000000', 3, 0, '桓仁满族自治县');
INSERT INTO `comm_address_area` VALUES ('210600000000', '210000000000', 2, 0, '丹东市');
INSERT INTO `comm_address_area` VALUES ('210602000000', '210600000000', 3, 0, '元宝区');
INSERT INTO `comm_address_area` VALUES ('210603000000', '210600000000', 3, 0, '振兴区');
INSERT INTO `comm_address_area` VALUES ('210604000000', '210600000000', 3, 0, '振安区');
INSERT INTO `comm_address_area` VALUES ('210624000000', '210600000000', 3, 0, '宽甸满族自治县');
INSERT INTO `comm_address_area` VALUES ('210681000000', '210600000000', 3, 0, '东港市');
INSERT INTO `comm_address_area` VALUES ('210682000000', '210600000000', 3, 0, '凤城市');
INSERT INTO `comm_address_area` VALUES ('210700000000', '210000000000', 2, 0, '锦州市');
INSERT INTO `comm_address_area` VALUES ('210702000000', '210700000000', 3, 0, '古塔区');
INSERT INTO `comm_address_area` VALUES ('210703000000', '210700000000', 3, 0, '凌河区');
INSERT INTO `comm_address_area` VALUES ('210711000000', '210700000000', 3, 0, '太和区');
INSERT INTO `comm_address_area` VALUES ('210726000000', '210700000000', 3, 0, '黑山县');
INSERT INTO `comm_address_area` VALUES ('210727000000', '210700000000', 3, 0, '义县');
INSERT INTO `comm_address_area` VALUES ('210781000000', '210700000000', 3, 0, '凌海市');
INSERT INTO `comm_address_area` VALUES ('210782000000', '210700000000', 3, 0, '北镇市');
INSERT INTO `comm_address_area` VALUES ('210800000000', '210000000000', 2, 0, '营口市');
INSERT INTO `comm_address_area` VALUES ('210802000000', '210800000000', 3, 0, '站前区');
INSERT INTO `comm_address_area` VALUES ('210803000000', '210800000000', 3, 0, '西市区');
INSERT INTO `comm_address_area` VALUES ('210804000000', '210800000000', 3, 0, '鲅鱼圈区');
INSERT INTO `comm_address_area` VALUES ('210811000000', '210800000000', 3, 0, '老边区');
INSERT INTO `comm_address_area` VALUES ('210881000000', '210800000000', 3, 0, '盖州市');
INSERT INTO `comm_address_area` VALUES ('210882000000', '210800000000', 3, 0, '大石桥市');
INSERT INTO `comm_address_area` VALUES ('210900000000', '210000000000', 2, 0, '阜新市');
INSERT INTO `comm_address_area` VALUES ('210902000000', '210900000000', 3, 0, '海州区');
INSERT INTO `comm_address_area` VALUES ('210903000000', '210900000000', 3, 0, '新邱区');
INSERT INTO `comm_address_area` VALUES ('210904000000', '210900000000', 3, 0, '太平区');
INSERT INTO `comm_address_area` VALUES ('210905000000', '210900000000', 3, 0, '清河门区');
INSERT INTO `comm_address_area` VALUES ('210911000000', '210900000000', 3, 0, '细河区');
INSERT INTO `comm_address_area` VALUES ('210921000000', '210900000000', 3, 0, '阜新蒙古族自治县');
INSERT INTO `comm_address_area` VALUES ('210922000000', '210900000000', 3, 0, '彰武县');
INSERT INTO `comm_address_area` VALUES ('211000000000', '210000000000', 2, 0, '辽阳市');
INSERT INTO `comm_address_area` VALUES ('211002000000', '211000000000', 3, 0, '白塔区');
INSERT INTO `comm_address_area` VALUES ('211003000000', '211000000000', 3, 0, '文圣区');
INSERT INTO `comm_address_area` VALUES ('211004000000', '211000000000', 3, 0, '宏伟区');
INSERT INTO `comm_address_area` VALUES ('211005000000', '211000000000', 3, 0, '弓长岭区');
INSERT INTO `comm_address_area` VALUES ('211011000000', '211000000000', 3, 0, '太子河区');
INSERT INTO `comm_address_area` VALUES ('211021000000', '211000000000', 3, 0, '辽阳县');
INSERT INTO `comm_address_area` VALUES ('211081000000', '211000000000', 3, 0, '灯塔市');
INSERT INTO `comm_address_area` VALUES ('211100000000', '210000000000', 2, 0, '盘锦市');
INSERT INTO `comm_address_area` VALUES ('211102000000', '211100000000', 3, 0, '双台子区');
INSERT INTO `comm_address_area` VALUES ('211103000000', '211100000000', 3, 0, '兴隆台区');
INSERT INTO `comm_address_area` VALUES ('211121000000', '211100000000', 3, 0, '大洼县');
INSERT INTO `comm_address_area` VALUES ('211122000000', '211100000000', 3, 0, '盘山县');
INSERT INTO `comm_address_area` VALUES ('211200000000', '210000000000', 2, 0, '铁岭市');
INSERT INTO `comm_address_area` VALUES ('211202000000', '211200000000', 3, 0, '银州区');
INSERT INTO `comm_address_area` VALUES ('211204000000', '211200000000', 3, 0, '清河区');
INSERT INTO `comm_address_area` VALUES ('211221000000', '211200000000', 3, 0, '铁岭县');
INSERT INTO `comm_address_area` VALUES ('211223000000', '211200000000', 3, 0, '西丰县');
INSERT INTO `comm_address_area` VALUES ('211224000000', '211200000000', 3, 0, '昌图县');
INSERT INTO `comm_address_area` VALUES ('211281000000', '211200000000', 3, 0, '调兵山市');
INSERT INTO `comm_address_area` VALUES ('211282000000', '211200000000', 3, 0, '开原市');
INSERT INTO `comm_address_area` VALUES ('211300000000', '210000000000', 2, 0, '朝阳市');
INSERT INTO `comm_address_area` VALUES ('211302000000', '211300000000', 3, 0, '双塔区');
INSERT INTO `comm_address_area` VALUES ('211303000000', '211300000000', 3, 0, '龙城区');
INSERT INTO `comm_address_area` VALUES ('211321000000', '211300000000', 3, 0, '朝阳县');
INSERT INTO `comm_address_area` VALUES ('211322000000', '211300000000', 3, 0, '建平县');
INSERT INTO `comm_address_area` VALUES ('211324000000', '211300000000', 3, 0, '喀喇沁左翼蒙古族自治县');
INSERT INTO `comm_address_area` VALUES ('211381000000', '211300000000', 3, 0, '北票市');
INSERT INTO `comm_address_area` VALUES ('211382000000', '211300000000', 3, 0, '凌源市');
INSERT INTO `comm_address_area` VALUES ('211400000000', '210000000000', 2, 0, '葫芦岛市');
INSERT INTO `comm_address_area` VALUES ('211402000000', '211400000000', 3, 0, '连山区');
INSERT INTO `comm_address_area` VALUES ('211403000000', '211400000000', 3, 0, '龙港区');
INSERT INTO `comm_address_area` VALUES ('211404000000', '211400000000', 3, 0, '南票区');
INSERT INTO `comm_address_area` VALUES ('211421000000', '211400000000', 3, 0, '绥中县');
INSERT INTO `comm_address_area` VALUES ('211422000000', '211400000000', 3, 0, '建昌县');
INSERT INTO `comm_address_area` VALUES ('211481000000', '211400000000', 3, 0, '兴城市');
INSERT INTO `comm_address_area` VALUES ('150000000000', '0', 1, 0, '内蒙古自治区');
INSERT INTO `comm_address_area` VALUES ('150100000000', '150000000000', 2, 0, '呼和浩特市');
INSERT INTO `comm_address_area` VALUES ('150102000000', '150100000000', 3, 0, '新城区');
INSERT INTO `comm_address_area` VALUES ('150103000000', '150100000000', 3, 0, '回民区');
INSERT INTO `comm_address_area` VALUES ('150104000000', '150100000000', 3, 0, '玉泉区');
INSERT INTO `comm_address_area` VALUES ('150105000000', '150100000000', 3, 0, '赛罕区');
INSERT INTO `comm_address_area` VALUES ('150121000000', '150100000000', 3, 0, '土默特左旗');
INSERT INTO `comm_address_area` VALUES ('150122000000', '150100000000', 3, 0, '托克托县');
INSERT INTO `comm_address_area` VALUES ('150123000000', '150100000000', 3, 0, '和林格尔县');
INSERT INTO `comm_address_area` VALUES ('150124000000', '150100000000', 3, 0, '清水河县');
INSERT INTO `comm_address_area` VALUES ('150125000000', '150100000000', 3, 0, '武川县');
INSERT INTO `comm_address_area` VALUES ('150200000000', '150000000000', 2, 0, '包头市');
INSERT INTO `comm_address_area` VALUES ('150202000000', '150200000000', 3, 0, '东河区');
INSERT INTO `comm_address_area` VALUES ('150203000000', '150200000000', 3, 0, '昆都仑区');
INSERT INTO `comm_address_area` VALUES ('150204000000', '150200000000', 3, 0, '青山区');
INSERT INTO `comm_address_area` VALUES ('150205000000', '150200000000', 3, 0, '石拐区');
INSERT INTO `comm_address_area` VALUES ('150206000000', '150200000000', 3, 0, '白云鄂博矿区');
INSERT INTO `comm_address_area` VALUES ('150207000000', '150200000000', 3, 0, '九原区');
INSERT INTO `comm_address_area` VALUES ('150221000000', '150200000000', 3, 0, '土默特右旗');
INSERT INTO `comm_address_area` VALUES ('150222000000', '150200000000', 3, 0, '固阳县');
INSERT INTO `comm_address_area` VALUES ('150223000000', '150200000000', 3, 0, '达尔罕茂明安联合旗');
INSERT INTO `comm_address_area` VALUES ('150300000000', '150000000000', 2, 0, '乌海市');
INSERT INTO `comm_address_area` VALUES ('150302000000', '150300000000', 3, 0, '海勃湾区');
INSERT INTO `comm_address_area` VALUES ('150303000000', '150300000000', 3, 0, '海南区');
INSERT INTO `comm_address_area` VALUES ('150304000000', '150300000000', 3, 0, '乌达区');
INSERT INTO `comm_address_area` VALUES ('150400000000', '150000000000', 2, 0, '赤峰市');
INSERT INTO `comm_address_area` VALUES ('150402000000', '150400000000', 3, 0, '红山区');
INSERT INTO `comm_address_area` VALUES ('150403000000', '150400000000', 3, 0, '元宝山区');
INSERT INTO `comm_address_area` VALUES ('150404000000', '150400000000', 3, 0, '松山区');
INSERT INTO `comm_address_area` VALUES ('150421000000', '150400000000', 3, 0, '阿鲁科尔沁旗');
INSERT INTO `comm_address_area` VALUES ('150422000000', '150400000000', 3, 0, '巴林左旗');
INSERT INTO `comm_address_area` VALUES ('150423000000', '150400000000', 3, 0, '巴林右旗');
INSERT INTO `comm_address_area` VALUES ('150424000000', '150400000000', 3, 0, '林西县');
INSERT INTO `comm_address_area` VALUES ('150425000000', '150400000000', 3, 0, '克什克腾旗');
INSERT INTO `comm_address_area` VALUES ('150426000000', '150400000000', 3, 0, '翁牛特旗');
INSERT INTO `comm_address_area` VALUES ('150428000000', '150400000000', 3, 0, '喀喇沁旗');
INSERT INTO `comm_address_area` VALUES ('150429000000', '150400000000', 3, 0, '宁城县');
INSERT INTO `comm_address_area` VALUES ('150430000000', '150400000000', 3, 0, '敖汉旗');
INSERT INTO `comm_address_area` VALUES ('150500000000', '150000000000', 2, 0, '通辽市');
INSERT INTO `comm_address_area` VALUES ('150502000000', '150500000000', 3, 0, '科尔沁区');
INSERT INTO `comm_address_area` VALUES ('150521000000', '150500000000', 3, 0, '科尔沁左翼中旗');
INSERT INTO `comm_address_area` VALUES ('150522000000', '150500000000', 3, 0, '科尔沁左翼后旗');
INSERT INTO `comm_address_area` VALUES ('150523000000', '150500000000', 3, 0, '开鲁县');
INSERT INTO `comm_address_area` VALUES ('150524000000', '150500000000', 3, 0, '库伦旗');
INSERT INTO `comm_address_area` VALUES ('150525000000', '150500000000', 3, 0, '奈曼旗');
INSERT INTO `comm_address_area` VALUES ('150526000000', '150500000000', 3, 0, '扎鲁特旗');
INSERT INTO `comm_address_area` VALUES ('150581000000', '150500000000', 3, 0, '霍林郭勒市');
INSERT INTO `comm_address_area` VALUES ('150600000000', '150000000000', 2, 0, '鄂尔多斯市');
INSERT INTO `comm_address_area` VALUES ('150602000000', '150600000000', 3, 0, '东胜区');
INSERT INTO `comm_address_area` VALUES ('150621000000', '150600000000', 3, 0, '达拉特旗');
INSERT INTO `comm_address_area` VALUES ('150622000000', '150600000000', 3, 0, '准格尔旗');
INSERT INTO `comm_address_area` VALUES ('150623000000', '150600000000', 3, 0, '鄂托克前旗');
INSERT INTO `comm_address_area` VALUES ('150624000000', '150600000000', 3, 0, '鄂托克旗');
INSERT INTO `comm_address_area` VALUES ('150625000000', '150600000000', 3, 0, '杭锦旗');
INSERT INTO `comm_address_area` VALUES ('150626000000', '150600000000', 3, 0, '乌审旗');
INSERT INTO `comm_address_area` VALUES ('150627000000', '150600000000', 3, 0, '伊金霍洛旗');
INSERT INTO `comm_address_area` VALUES ('150700000000', '150000000000', 2, 0, '呼伦贝尔市');
INSERT INTO `comm_address_area` VALUES ('150702000000', '150700000000', 3, 0, '海拉尔区');
INSERT INTO `comm_address_area` VALUES ('150721000000', '150700000000', 3, 0, '阿荣旗');
INSERT INTO `comm_address_area` VALUES ('150722000000', '150700000000', 3, 0, '莫力达瓦达斡尔族自治旗');
INSERT INTO `comm_address_area` VALUES ('150723000000', '150700000000', 3, 0, '鄂伦春自治旗');
INSERT INTO `comm_address_area` VALUES ('150724000000', '150700000000', 3, 0, '鄂温克族自治旗');
INSERT INTO `comm_address_area` VALUES ('150725000000', '150700000000', 3, 0, '陈巴尔虎旗');
INSERT INTO `comm_address_area` VALUES ('150726000000', '150700000000', 3, 0, '新巴尔虎左旗');
INSERT INTO `comm_address_area` VALUES ('150727000000', '150700000000', 3, 0, '新巴尔虎右旗');
INSERT INTO `comm_address_area` VALUES ('150781000000', '150700000000', 3, 0, '满洲里市');
INSERT INTO `comm_address_area` VALUES ('150782000000', '150700000000', 3, 0, '牙克石市');
INSERT INTO `comm_address_area` VALUES ('150783000000', '150700000000', 3, 0, '扎兰屯市');
INSERT INTO `comm_address_area` VALUES ('150784000000', '150700000000', 3, 0, '额尔古纳市');
INSERT INTO `comm_address_area` VALUES ('150785000000', '150700000000', 3, 0, '根河市');
INSERT INTO `comm_address_area` VALUES ('150800000000', '150000000000', 2, 0, '巴彦淖尔市');
INSERT INTO `comm_address_area` VALUES ('150802000000', '150800000000', 3, 0, '临河区');
INSERT INTO `comm_address_area` VALUES ('150821000000', '150800000000', 3, 0, '五原县');
INSERT INTO `comm_address_area` VALUES ('150822000000', '150800000000', 3, 0, '磴口县');
INSERT INTO `comm_address_area` VALUES ('150823000000', '150800000000', 3, 0, '乌拉特前旗');
INSERT INTO `comm_address_area` VALUES ('150824000000', '150800000000', 3, 0, '乌拉特中旗');
INSERT INTO `comm_address_area` VALUES ('150825000000', '150800000000', 3, 0, '乌拉特后旗');
INSERT INTO `comm_address_area` VALUES ('150826000000', '150800000000', 3, 0, '杭锦后旗');
INSERT INTO `comm_address_area` VALUES ('150900000000', '150000000000', 2, 0, '乌兰察布市');
INSERT INTO `comm_address_area` VALUES ('150902000000', '150900000000', 3, 0, '集宁区');
INSERT INTO `comm_address_area` VALUES ('150921000000', '150900000000', 3, 0, '卓资县');
INSERT INTO `comm_address_area` VALUES ('150922000000', '150900000000', 3, 0, '化德县');
INSERT INTO `comm_address_area` VALUES ('150923000000', '150900000000', 3, 0, '商都县');
INSERT INTO `comm_address_area` VALUES ('150924000000', '150900000000', 3, 0, '兴和县');
INSERT INTO `comm_address_area` VALUES ('150925000000', '150900000000', 3, 0, '凉城县');
INSERT INTO `comm_address_area` VALUES ('150926000000', '150900000000', 3, 0, '察哈尔右翼前旗');
INSERT INTO `comm_address_area` VALUES ('150927000000', '150900000000', 3, 0, '察哈尔右翼中旗');
INSERT INTO `comm_address_area` VALUES ('150928000000', '150900000000', 3, 0, '察哈尔右翼后旗');
INSERT INTO `comm_address_area` VALUES ('150929000000', '150900000000', 3, 0, '四子王旗');
INSERT INTO `comm_address_area` VALUES ('150981000000', '150900000000', 3, 0, '丰镇市');
INSERT INTO `comm_address_area` VALUES ('152200000000', '150000000000', 2, 0, '兴安盟');
INSERT INTO `comm_address_area` VALUES ('152201000000', '152200000000', 3, 0, '乌兰浩特市');
INSERT INTO `comm_address_area` VALUES ('152202000000', '152200000000', 3, 0, '阿尔山市');
INSERT INTO `comm_address_area` VALUES ('152221000000', '152200000000', 3, 0, '科尔沁右翼前旗');
INSERT INTO `comm_address_area` VALUES ('152222000000', '152200000000', 3, 0, '科尔沁右翼中旗');
INSERT INTO `comm_address_area` VALUES ('152223000000', '152200000000', 3, 0, '扎赉特旗');
INSERT INTO `comm_address_area` VALUES ('152224000000', '152200000000', 3, 0, '突泉县');
INSERT INTO `comm_address_area` VALUES ('152500000000', '150000000000', 2, 0, '锡林郭勒盟');
INSERT INTO `comm_address_area` VALUES ('152501000000', '152500000000', 3, 0, '二连浩特市');
INSERT INTO `comm_address_area` VALUES ('152502000000', '152500000000', 3, 0, '锡林浩特市');
INSERT INTO `comm_address_area` VALUES ('152522000000', '152500000000', 3, 0, '阿巴嘎旗');
INSERT INTO `comm_address_area` VALUES ('152523000000', '152500000000', 3, 0, '苏尼特左旗');
INSERT INTO `comm_address_area` VALUES ('152524000000', '152500000000', 3, 0, '苏尼特右旗');
INSERT INTO `comm_address_area` VALUES ('152525000000', '152500000000', 3, 0, '东乌珠穆沁旗');
INSERT INTO `comm_address_area` VALUES ('152526000000', '152500000000', 3, 0, '西乌珠穆沁旗');
INSERT INTO `comm_address_area` VALUES ('152527000000', '152500000000', 3, 0, '太仆寺旗');
INSERT INTO `comm_address_area` VALUES ('152528000000', '152500000000', 3, 0, '镶黄旗');
INSERT INTO `comm_address_area` VALUES ('152529000000', '152500000000', 3, 0, '正镶白旗');
INSERT INTO `comm_address_area` VALUES ('152530000000', '152500000000', 3, 0, '正蓝旗');
INSERT INTO `comm_address_area` VALUES ('152531000000', '152500000000', 3, 0, '多伦县');
INSERT INTO `comm_address_area` VALUES ('152900000000', '150000000000', 2, 0, '阿拉善盟');
INSERT INTO `comm_address_area` VALUES ('152921000000', '152900000000', 3, 0, '阿拉善左旗');
INSERT INTO `comm_address_area` VALUES ('152922000000', '152900000000', 3, 0, '阿拉善右旗');
INSERT INTO `comm_address_area` VALUES ('152923000000', '152900000000', 3, 0, '额济纳旗');
INSERT INTO `comm_address_area` VALUES ('640000000000', '0', 1, 0, '宁夏回族自治区');
INSERT INTO `comm_address_area` VALUES ('640100000000', '640000000000', 2, 0, '银川市');
INSERT INTO `comm_address_area` VALUES ('640104000000', '640100000000', 3, 0, '兴庆区');
INSERT INTO `comm_address_area` VALUES ('640105000000', '640100000000', 3, 0, '西夏区');
INSERT INTO `comm_address_area` VALUES ('640106000000', '640100000000', 3, 0, '金凤区');
INSERT INTO `comm_address_area` VALUES ('640121000000', '640100000000', 3, 0, '永宁县');
INSERT INTO `comm_address_area` VALUES ('640122000000', '640100000000', 3, 0, '贺兰县');
INSERT INTO `comm_address_area` VALUES ('640181000000', '640100000000', 3, 0, '灵武市');
INSERT INTO `comm_address_area` VALUES ('640200000000', '640000000000', 2, 0, '石嘴山市');
INSERT INTO `comm_address_area` VALUES ('640202000000', '640200000000', 3, 0, '大武口区');
INSERT INTO `comm_address_area` VALUES ('640205000000', '640200000000', 3, 0, '惠农区');
INSERT INTO `comm_address_area` VALUES ('640221000000', '640200000000', 3, 0, '平罗县');
INSERT INTO `comm_address_area` VALUES ('640300000000', '640000000000', 2, 0, '吴忠市');
INSERT INTO `comm_address_area` VALUES ('640302000000', '640300000000', 3, 0, '利通区');
INSERT INTO `comm_address_area` VALUES ('640303000000', '640300000000', 3, 0, '红寺堡区');
INSERT INTO `comm_address_area` VALUES ('640323000000', '640300000000', 3, 0, '盐池县');
INSERT INTO `comm_address_area` VALUES ('640324000000', '640300000000', 3, 0, '同心县');
INSERT INTO `comm_address_area` VALUES ('640381000000', '640300000000', 3, 0, '青铜峡市');
INSERT INTO `comm_address_area` VALUES ('640400000000', '640000000000', 2, 0, '固原市');
INSERT INTO `comm_address_area` VALUES ('640402000000', '640400000000', 3, 0, '原州区');
INSERT INTO `comm_address_area` VALUES ('640422000000', '640400000000', 3, 0, '西吉县');
INSERT INTO `comm_address_area` VALUES ('640423000000', '640400000000', 3, 0, '隆德县');
INSERT INTO `comm_address_area` VALUES ('640424000000', '640400000000', 3, 0, '泾源县');
INSERT INTO `comm_address_area` VALUES ('640425000000', '640400000000', 3, 0, '彭阳县');
INSERT INTO `comm_address_area` VALUES ('640500000000', '640000000000', 2, 0, '中卫市');
INSERT INTO `comm_address_area` VALUES ('640502000000', '640500000000', 3, 0, '沙坡头区');
INSERT INTO `comm_address_area` VALUES ('640521000000', '640500000000', 3, 0, '中宁县');
INSERT INTO `comm_address_area` VALUES ('640522000000', '640500000000', 3, 0, '海原县');
INSERT INTO `comm_address_area` VALUES ('630000000000', '0', 1, 0, '青海省');
INSERT INTO `comm_address_area` VALUES ('630100000000', '630000000000', 2, 0, '西宁市');
INSERT INTO `comm_address_area` VALUES ('630102000000', '630100000000', 3, 0, '城东区');
INSERT INTO `comm_address_area` VALUES ('630103000000', '630100000000', 3, 0, '城中区');
INSERT INTO `comm_address_area` VALUES ('630104000000', '630100000000', 3, 0, '城西区');
INSERT INTO `comm_address_area` VALUES ('630105000000', '630100000000', 3, 0, '城北区');
INSERT INTO `comm_address_area` VALUES ('630121000000', '630100000000', 3, 0, '大通回族土族自治县');
INSERT INTO `comm_address_area` VALUES ('630122000000', '630100000000', 3, 0, '湟中县');
INSERT INTO `comm_address_area` VALUES ('632123000000', '632100000000', 3, 0, '乐都县');
INSERT INTO `comm_address_area` VALUES ('632128000000', '632100000000', 3, 0, '循化撒拉族自治县');
INSERT INTO `comm_address_area` VALUES ('630123000000', '630100000000', 3, 0, '湟源县');
INSERT INTO `comm_address_area` VALUES ('632100000000', '630000000000', 2, 0, '海东地区');
INSERT INTO `comm_address_area` VALUES ('632121000000', '632100000000', 3, 0, '平安县');
INSERT INTO `comm_address_area` VALUES ('632122000000', '632100000000', 3, 0, '民和回族土族自治县');
INSERT INTO `comm_address_area` VALUES ('632126000000', '632100000000', 3, 0, '互助土族自治县');
INSERT INTO `comm_address_area` VALUES ('632127000000', '632100000000', 3, 0, '化隆回族自治县');
INSERT INTO `comm_address_area` VALUES ('632200000000', '630000000000', 2, 0, '海北藏族自治州');
INSERT INTO `comm_address_area` VALUES ('632221000000', '632200000000', 3, 0, '门源回族自治县');
INSERT INTO `comm_address_area` VALUES ('632222000000', '632200000000', 3, 0, '祁连县');
INSERT INTO `comm_address_area` VALUES ('632223000000', '632200000000', 3, 0, '海晏县');
INSERT INTO `comm_address_area` VALUES ('632224000000', '632200000000', 3, 0, '刚察县');
INSERT INTO `comm_address_area` VALUES ('632300000000', '630000000000', 2, 0, '黄南藏族自治州');
INSERT INTO `comm_address_area` VALUES ('632321000000', '632300000000', 3, 0, '同仁县');
INSERT INTO `comm_address_area` VALUES ('632322000000', '632300000000', 3, 0, '尖扎县');
INSERT INTO `comm_address_area` VALUES ('632323000000', '632300000000', 3, 0, '泽库县');
INSERT INTO `comm_address_area` VALUES ('632324000000', '632300000000', 3, 0, '河南蒙古族自治县');
INSERT INTO `comm_address_area` VALUES ('632500000000', '630000000000', 2, 0, '海南藏族自治州');
INSERT INTO `comm_address_area` VALUES ('632521000000', '632500000000', 3, 0, '共和县');
INSERT INTO `comm_address_area` VALUES ('632522000000', '632500000000', 3, 0, '同德县');
INSERT INTO `comm_address_area` VALUES ('632523000000', '632500000000', 3, 0, '贵德县');
INSERT INTO `comm_address_area` VALUES ('632524000000', '632500000000', 3, 0, '兴海县');
INSERT INTO `comm_address_area` VALUES ('632525000000', '632500000000', 3, 0, '贵南县');
INSERT INTO `comm_address_area` VALUES ('632600000000', '630000000000', 2, 0, '果洛藏族自治州');
INSERT INTO `comm_address_area` VALUES ('632621000000', '632600000000', 3, 0, '玛沁县');
INSERT INTO `comm_address_area` VALUES ('632622000000', '632600000000', 3, 0, '班玛县');
INSERT INTO `comm_address_area` VALUES ('632623000000', '632600000000', 3, 0, '甘德县');
INSERT INTO `comm_address_area` VALUES ('632624000000', '632600000000', 3, 0, '达日县');
INSERT INTO `comm_address_area` VALUES ('632625000000', '632600000000', 3, 0, '久治县');
INSERT INTO `comm_address_area` VALUES ('632626000000', '632600000000', 3, 0, '玛多县');
INSERT INTO `comm_address_area` VALUES ('632700000000', '630000000000', 2, 0, '玉树藏族自治州');
INSERT INTO `comm_address_area` VALUES ('632721000000', '632700000000', 3, 0, '玉树县');
INSERT INTO `comm_address_area` VALUES ('632722000000', '632700000000', 3, 0, '杂多县');
INSERT INTO `comm_address_area` VALUES ('632723000000', '632700000000', 3, 0, '称多县');
INSERT INTO `comm_address_area` VALUES ('632724000000', '632700000000', 3, 0, '治多县');
INSERT INTO `comm_address_area` VALUES ('632725000000', '632700000000', 3, 0, '囊谦县');
INSERT INTO `comm_address_area` VALUES ('632726000000', '632700000000', 3, 0, '曲麻莱县');
INSERT INTO `comm_address_area` VALUES ('632800000000', '630000000000', 2, 0, '海西蒙古族藏族自治州');
INSERT INTO `comm_address_area` VALUES ('632801000000', '632800000000', 3, 0, '格尔木市');
INSERT INTO `comm_address_area` VALUES ('632802000000', '632800000000', 3, 0, '德令哈市');
INSERT INTO `comm_address_area` VALUES ('632821000000', '632800000000', 3, 0, '乌兰县');
INSERT INTO `comm_address_area` VALUES ('632822000000', '632800000000', 3, 0, '都兰县');
INSERT INTO `comm_address_area` VALUES ('632823000000', '632800000000', 3, 0, '天峻县');
INSERT INTO `comm_address_area` VALUES ('370000000000', '0', 1, 0, '山东省');
INSERT INTO `comm_address_area` VALUES ('370100000000', '370000000000', 2, 0, '济南市');
INSERT INTO `comm_address_area` VALUES ('370102000000', '370100000000', 3, 0, '历下区');
INSERT INTO `comm_address_area` VALUES ('370103000000', '370100000000', 3, 0, '市中区');
INSERT INTO `comm_address_area` VALUES ('370104000000', '370100000000', 3, 0, '槐荫区');
INSERT INTO `comm_address_area` VALUES ('370105000000', '370100000000', 3, 0, '天桥区');
INSERT INTO `comm_address_area` VALUES ('370112000000', '370100000000', 3, 0, '历城区');
INSERT INTO `comm_address_area` VALUES ('370113000000', '370100000000', 3, 0, '长清区');
INSERT INTO `comm_address_area` VALUES ('370124000000', '370100000000', 3, 0, '平阴县');
INSERT INTO `comm_address_area` VALUES ('370125000000', '370100000000', 3, 0, '济阳县');
INSERT INTO `comm_address_area` VALUES ('370126000000', '370100000000', 3, 0, '商河县');
INSERT INTO `comm_address_area` VALUES ('370181000000', '370100000000', 3, 0, '章丘市');
INSERT INTO `comm_address_area` VALUES ('370200000000', '370000000000', 2, 0, '青岛市');
INSERT INTO `comm_address_area` VALUES ('370202000000', '370200000000', 3, 0, '市南区');
INSERT INTO `comm_address_area` VALUES ('370203000000', '370200000000', 3, 0, '市北区');
INSERT INTO `comm_address_area` VALUES ('370205000000', '370200000000', 3, 0, '四方区');
INSERT INTO `comm_address_area` VALUES ('370211000000', '370200000000', 3, 0, '黄岛区');
INSERT INTO `comm_address_area` VALUES ('370212000000', '370200000000', 3, 0, '崂山区');
INSERT INTO `comm_address_area` VALUES ('370213000000', '370200000000', 3, 0, '李沧区');
INSERT INTO `comm_address_area` VALUES ('370214000000', '370200000000', 3, 0, '城阳区');
INSERT INTO `comm_address_area` VALUES ('370281000000', '370200000000', 3, 0, '胶州市');
INSERT INTO `comm_address_area` VALUES ('370282000000', '370200000000', 3, 0, '即墨市');
INSERT INTO `comm_address_area` VALUES ('370283000000', '370200000000', 3, 0, '平度市');
INSERT INTO `comm_address_area` VALUES ('370284000000', '370200000000', 3, 0, '胶南市');
INSERT INTO `comm_address_area` VALUES ('370285000000', '370200000000', 3, 0, '莱西市');
INSERT INTO `comm_address_area` VALUES ('370300000000', '370000000000', 2, 0, '淄博市');
INSERT INTO `comm_address_area` VALUES ('370302000000', '370300000000', 3, 0, '淄川区');
INSERT INTO `comm_address_area` VALUES ('370303000000', '370300000000', 3, 0, '张店区');
INSERT INTO `comm_address_area` VALUES ('370304000000', '370300000000', 3, 0, '博山区');
INSERT INTO `comm_address_area` VALUES ('370305000000', '370300000000', 3, 0, '临淄区');
INSERT INTO `comm_address_area` VALUES ('370306000000', '370300000000', 3, 0, '周村区');
INSERT INTO `comm_address_area` VALUES ('370321000000', '370300000000', 3, 0, '桓台县');
INSERT INTO `comm_address_area` VALUES ('370322000000', '370300000000', 3, 0, '高青县');
INSERT INTO `comm_address_area` VALUES ('370323000000', '370300000000', 3, 0, '沂源县');
INSERT INTO `comm_address_area` VALUES ('370400000000', '370000000000', 2, 0, '枣庄市');
INSERT INTO `comm_address_area` VALUES ('370402000000', '370400000000', 3, 0, '市中区');
INSERT INTO `comm_address_area` VALUES ('370403000000', '370400000000', 3, 0, '薛城区');
INSERT INTO `comm_address_area` VALUES ('370404000000', '370400000000', 3, 0, '峄城区');
INSERT INTO `comm_address_area` VALUES ('370405000000', '370400000000', 3, 0, '台儿庄区');
INSERT INTO `comm_address_area` VALUES ('370406000000', '370400000000', 3, 0, '山亭区');
INSERT INTO `comm_address_area` VALUES ('370481000000', '370400000000', 3, 0, '滕州市');
INSERT INTO `comm_address_area` VALUES ('370500000000', '370000000000', 2, 0, '东营市');
INSERT INTO `comm_address_area` VALUES ('370502000000', '370500000000', 3, 0, '东营区');
INSERT INTO `comm_address_area` VALUES ('370503000000', '370500000000', 3, 0, '河口区');
INSERT INTO `comm_address_area` VALUES ('370521000000', '370500000000', 3, 0, '垦利县');
INSERT INTO `comm_address_area` VALUES ('370522000000', '370500000000', 3, 0, '利津县');
INSERT INTO `comm_address_area` VALUES ('370523000000', '370500000000', 3, 0, '广饶县');
INSERT INTO `comm_address_area` VALUES ('370600000000', '370000000000', 2, 0, '烟台市');
INSERT INTO `comm_address_area` VALUES ('370602000000', '370600000000', 3, 0, '芝罘区');
INSERT INTO `comm_address_area` VALUES ('370611000000', '370600000000', 3, 0, '福山区');
INSERT INTO `comm_address_area` VALUES ('370612000000', '370600000000', 3, 0, '牟平区');
INSERT INTO `comm_address_area` VALUES ('370613000000', '370600000000', 3, 0, '莱山区');
INSERT INTO `comm_address_area` VALUES ('370634000000', '370600000000', 3, 0, '长岛县');
INSERT INTO `comm_address_area` VALUES ('370681000000', '370600000000', 3, 0, '龙口市');
INSERT INTO `comm_address_area` VALUES ('370682000000', '370600000000', 3, 0, '莱阳市');
INSERT INTO `comm_address_area` VALUES ('370683000000', '370600000000', 3, 0, '莱州市');
INSERT INTO `comm_address_area` VALUES ('370684000000', '370600000000', 3, 0, '蓬莱市');
INSERT INTO `comm_address_area` VALUES ('370685000000', '370600000000', 3, 0, '招远市');
INSERT INTO `comm_address_area` VALUES ('370686000000', '370600000000', 3, 0, '栖霞市');
INSERT INTO `comm_address_area` VALUES ('370687000000', '370600000000', 3, 0, '海阳市');
INSERT INTO `comm_address_area` VALUES ('370700000000', '370000000000', 2, 0, '潍坊市');
INSERT INTO `comm_address_area` VALUES ('370702000000', '370700000000', 3, 0, '潍城区');
INSERT INTO `comm_address_area` VALUES ('370703000000', '370700000000', 3, 0, '寒亭区');
INSERT INTO `comm_address_area` VALUES ('370704000000', '370700000000', 3, 0, '坊子区');
INSERT INTO `comm_address_area` VALUES ('370705000000', '370700000000', 3, 0, '奎文区');
INSERT INTO `comm_address_area` VALUES ('370724000000', '370700000000', 3, 0, '临朐县');
INSERT INTO `comm_address_area` VALUES ('370725000000', '370700000000', 3, 0, '昌乐县');
INSERT INTO `comm_address_area` VALUES ('370781000000', '370700000000', 3, 0, '青州市');
INSERT INTO `comm_address_area` VALUES ('370782000000', '370700000000', 3, 0, '诸城市');
INSERT INTO `comm_address_area` VALUES ('370783000000', '370700000000', 3, 0, '寿光市');
INSERT INTO `comm_address_area` VALUES ('370784000000', '370700000000', 3, 0, '安丘市');
INSERT INTO `comm_address_area` VALUES ('370785000000', '370700000000', 3, 0, '高密市');
INSERT INTO `comm_address_area` VALUES ('370786000000', '370700000000', 3, 0, '昌邑市');
INSERT INTO `comm_address_area` VALUES ('370800000000', '370000000000', 2, 0, '济宁市');
INSERT INTO `comm_address_area` VALUES ('370802000000', '370800000000', 3, 0, '市中区');
INSERT INTO `comm_address_area` VALUES ('370811000000', '370800000000', 3, 0, '任城区');
INSERT INTO `comm_address_area` VALUES ('370826000000', '370800000000', 3, 0, '微山县');
INSERT INTO `comm_address_area` VALUES ('370827000000', '370800000000', 3, 0, '鱼台县');
INSERT INTO `comm_address_area` VALUES ('370828000000', '370800000000', 3, 0, '金乡县');
INSERT INTO `comm_address_area` VALUES ('370829000000', '370800000000', 3, 0, '嘉祥县');
INSERT INTO `comm_address_area` VALUES ('370830000000', '370800000000', 3, 0, '汶上县');
INSERT INTO `comm_address_area` VALUES ('370831000000', '370800000000', 3, 0, '泗水县');
INSERT INTO `comm_address_area` VALUES ('370832000000', '370800000000', 3, 0, '梁山县');
INSERT INTO `comm_address_area` VALUES ('370881000000', '370800000000', 3, 0, '曲阜市');
INSERT INTO `comm_address_area` VALUES ('370882000000', '370800000000', 3, 0, '兖州市');
INSERT INTO `comm_address_area` VALUES ('370883000000', '370800000000', 3, 0, '邹城市');
INSERT INTO `comm_address_area` VALUES ('370900000000', '370000000000', 2, 0, '泰安市');
INSERT INTO `comm_address_area` VALUES ('370902000000', '370900000000', 3, 0, '泰山区');
INSERT INTO `comm_address_area` VALUES ('370911000000', '370900000000', 3, 0, '岱岳区');
INSERT INTO `comm_address_area` VALUES ('370921000000', '370900000000', 3, 0, '宁阳县');
INSERT INTO `comm_address_area` VALUES ('370923000000', '370900000000', 3, 0, '东平县');
INSERT INTO `comm_address_area` VALUES ('370982000000', '370900000000', 3, 0, '新泰市');
INSERT INTO `comm_address_area` VALUES ('370983000000', '370900000000', 3, 0, '肥城市');
INSERT INTO `comm_address_area` VALUES ('371000000000', '370000000000', 2, 0, '威海市');
INSERT INTO `comm_address_area` VALUES ('371002000000', '371000000000', 3, 0, '环翠区');
INSERT INTO `comm_address_area` VALUES ('371081000000', '371000000000', 3, 0, '文登市');
INSERT INTO `comm_address_area` VALUES ('371082000000', '371000000000', 3, 0, '荣成市');
INSERT INTO `comm_address_area` VALUES ('371083000000', '371000000000', 3, 0, '乳山市');
INSERT INTO `comm_address_area` VALUES ('371100000000', '370000000000', 2, 0, '日照市');
INSERT INTO `comm_address_area` VALUES ('371102000000', '371100000000', 3, 0, '东港区');
INSERT INTO `comm_address_area` VALUES ('371103000000', '371100000000', 3, 0, '岚山区');
INSERT INTO `comm_address_area` VALUES ('371121000000', '371100000000', 3, 0, '五莲县');
INSERT INTO `comm_address_area` VALUES ('371122000000', '371100000000', 3, 0, '莒县');
INSERT INTO `comm_address_area` VALUES ('371200000000', '370000000000', 2, 0, '莱芜市');
INSERT INTO `comm_address_area` VALUES ('371202000000', '371200000000', 3, 0, '莱城区');
INSERT INTO `comm_address_area` VALUES ('371203000000', '371200000000', 3, 0, '钢城区');
INSERT INTO `comm_address_area` VALUES ('371300000000', '370000000000', 2, 0, '临沂市');
INSERT INTO `comm_address_area` VALUES ('371302000000', '371300000000', 3, 0, '兰山区');
INSERT INTO `comm_address_area` VALUES ('371311000000', '371300000000', 3, 0, '罗庄区');
INSERT INTO `comm_address_area` VALUES ('371312000000', '371300000000', 3, 0, '河东区');
INSERT INTO `comm_address_area` VALUES ('371321000000', '371300000000', 3, 0, '沂南县');
INSERT INTO `comm_address_area` VALUES ('371322000000', '371300000000', 3, 0, '郯城县');
INSERT INTO `comm_address_area` VALUES ('371323000000', '371300000000', 3, 0, '沂水县');
INSERT INTO `comm_address_area` VALUES ('371324000000', '371300000000', 3, 0, '苍山县');
INSERT INTO `comm_address_area` VALUES ('371325000000', '371300000000', 3, 0, '费县');
INSERT INTO `comm_address_area` VALUES ('371326000000', '371300000000', 3, 0, '平邑县');
INSERT INTO `comm_address_area` VALUES ('371327000000', '371300000000', 3, 0, '莒南县');
INSERT INTO `comm_address_area` VALUES ('371328000000', '371300000000', 3, 0, '蒙阴县');
INSERT INTO `comm_address_area` VALUES ('371329000000', '371300000000', 3, 0, '临沭县');
INSERT INTO `comm_address_area` VALUES ('371400000000', '370000000000', 2, 0, '德州市');
INSERT INTO `comm_address_area` VALUES ('371402000000', '371400000000', 3, 0, '德城区');
INSERT INTO `comm_address_area` VALUES ('371421000000', '371400000000', 3, 0, '陵县');
INSERT INTO `comm_address_area` VALUES ('371422000000', '371400000000', 3, 0, '宁津县');
INSERT INTO `comm_address_area` VALUES ('371423000000', '371400000000', 3, 0, '庆云县');
INSERT INTO `comm_address_area` VALUES ('371424000000', '371400000000', 3, 0, '临邑县');
INSERT INTO `comm_address_area` VALUES ('371425000000', '371400000000', 3, 0, '齐河县');
INSERT INTO `comm_address_area` VALUES ('371426000000', '371400000000', 3, 0, '平原县');
INSERT INTO `comm_address_area` VALUES ('371427000000', '371400000000', 3, 0, '夏津县');
INSERT INTO `comm_address_area` VALUES ('371428000000', '371400000000', 3, 0, '武城县');
INSERT INTO `comm_address_area` VALUES ('371481000000', '371400000000', 3, 0, '乐陵市');
INSERT INTO `comm_address_area` VALUES ('371482000000', '371400000000', 3, 0, '禹城市');
INSERT INTO `comm_address_area` VALUES ('371500000000', '370000000000', 2, 0, '聊城市');
INSERT INTO `comm_address_area` VALUES ('371502000000', '371500000000', 3, 0, '东昌府区');
INSERT INTO `comm_address_area` VALUES ('371521000000', '371500000000', 3, 0, '阳谷县');
INSERT INTO `comm_address_area` VALUES ('371522000000', '371500000000', 3, 0, '莘县');
INSERT INTO `comm_address_area` VALUES ('371523000000', '371500000000', 3, 0, '茌平县');
INSERT INTO `comm_address_area` VALUES ('371524000000', '371500000000', 3, 0, '东阿县');
INSERT INTO `comm_address_area` VALUES ('371525000000', '371500000000', 3, 0, '冠县');
INSERT INTO `comm_address_area` VALUES ('371526000000', '371500000000', 3, 0, '高唐县');
INSERT INTO `comm_address_area` VALUES ('371581000000', '371500000000', 3, 0, '临清市');
INSERT INTO `comm_address_area` VALUES ('371600000000', '370000000000', 2, 0, '滨州市');
INSERT INTO `comm_address_area` VALUES ('371602000000', '371600000000', 3, 0, '滨城区');
INSERT INTO `comm_address_area` VALUES ('371621000000', '371600000000', 3, 0, '惠民县');
INSERT INTO `comm_address_area` VALUES ('371622000000', '371600000000', 3, 0, '阳信县');
INSERT INTO `comm_address_area` VALUES ('371623000000', '371600000000', 3, 0, '无棣县');
INSERT INTO `comm_address_area` VALUES ('371624000000', '371600000000', 3, 0, '沾化县');
INSERT INTO `comm_address_area` VALUES ('371625000000', '371600000000', 3, 0, '博兴县');
INSERT INTO `comm_address_area` VALUES ('371626000000', '371600000000', 3, 0, '邹平县');
INSERT INTO `comm_address_area` VALUES ('371700000000', '370000000000', 2, 0, '菏泽市');
INSERT INTO `comm_address_area` VALUES ('371702000000', '371700000000', 3, 0, '牡丹区');
INSERT INTO `comm_address_area` VALUES ('371721000000', '371700000000', 3, 0, '曹县');
INSERT INTO `comm_address_area` VALUES ('371722000000', '371700000000', 3, 0, '单县');
INSERT INTO `comm_address_area` VALUES ('371723000000', '371700000000', 3, 0, '成武县');
INSERT INTO `comm_address_area` VALUES ('371724000000', '371700000000', 3, 0, '巨野县');
INSERT INTO `comm_address_area` VALUES ('371725000000', '371700000000', 3, 0, '郓城县');
INSERT INTO `comm_address_area` VALUES ('371726000000', '371700000000', 3, 0, '鄄城县');
INSERT INTO `comm_address_area` VALUES ('371727000000', '371700000000', 3, 0, '定陶县');
INSERT INTO `comm_address_area` VALUES ('371728000000', '371700000000', 3, 0, '东明县');
INSERT INTO `comm_address_area` VALUES ('140000000000', '0', 1, 0, '山西省');
INSERT INTO `comm_address_area` VALUES ('140100000000', '140000000000', 2, 0, '太原市');
INSERT INTO `comm_address_area` VALUES ('140105000000', '140100000000', 3, 0, '小店区');
INSERT INTO `comm_address_area` VALUES ('140106000000', '140100000000', 3, 0, '迎泽区');
INSERT INTO `comm_address_area` VALUES ('140107000000', '140100000000', 3, 0, '杏花岭区');
INSERT INTO `comm_address_area` VALUES ('140108000000', '140100000000', 3, 0, '尖草坪区');
INSERT INTO `comm_address_area` VALUES ('140109000000', '140100000000', 3, 0, '万柏林区');
INSERT INTO `comm_address_area` VALUES ('140110000000', '140100000000', 3, 0, '晋源区');
INSERT INTO `comm_address_area` VALUES ('140121000000', '140100000000', 3, 0, '清徐县');
INSERT INTO `comm_address_area` VALUES ('140122000000', '140100000000', 3, 0, '阳曲县');
INSERT INTO `comm_address_area` VALUES ('140123000000', '140100000000', 3, 0, '娄烦县');
INSERT INTO `comm_address_area` VALUES ('140222000000', '140200000000', 3, 0, '天镇县');
INSERT INTO `comm_address_area` VALUES ('140181000000', '140100000000', 3, 0, '古交市');
INSERT INTO `comm_address_area` VALUES ('140200000000', '140000000000', 2, 0, '大同市');
INSERT INTO `comm_address_area` VALUES ('140202000000', '140200000000', 3, 0, '城区');
INSERT INTO `comm_address_area` VALUES ('140203000000', '140200000000', 3, 0, '矿区');
INSERT INTO `comm_address_area` VALUES ('140211000000', '140200000000', 3, 0, '南郊区');
INSERT INTO `comm_address_area` VALUES ('140212000000', '140200000000', 3, 0, '新荣区');
INSERT INTO `comm_address_area` VALUES ('140221000000', '140200000000', 3, 0, '阳高县');
INSERT INTO `comm_address_area` VALUES ('140223000000', '140200000000', 3, 0, '广灵县');
INSERT INTO `comm_address_area` VALUES ('140224000000', '140200000000', 3, 0, '灵丘县');
INSERT INTO `comm_address_area` VALUES ('140225000000', '140200000000', 3, 0, '浑源县');
INSERT INTO `comm_address_area` VALUES ('140226000000', '140200000000', 3, 0, '左云县');
INSERT INTO `comm_address_area` VALUES ('140227000000', '140200000000', 3, 0, '大同县');
INSERT INTO `comm_address_area` VALUES ('140300000000', '140000000000', 2, 0, '阳泉市');
INSERT INTO `comm_address_area` VALUES ('140302000000', '140300000000', 3, 0, '城区');
INSERT INTO `comm_address_area` VALUES ('140303000000', '140300000000', 3, 0, '矿区');
INSERT INTO `comm_address_area` VALUES ('140311000000', '140300000000', 3, 0, '郊区');
INSERT INTO `comm_address_area` VALUES ('140321000000', '140300000000', 3, 0, '平定县');
INSERT INTO `comm_address_area` VALUES ('140322000000', '140300000000', 3, 0, '盂县');
INSERT INTO `comm_address_area` VALUES ('140400000000', '140000000000', 2, 0, '长治市');
INSERT INTO `comm_address_area` VALUES ('140402000000', '140400000000', 3, 0, '城区');
INSERT INTO `comm_address_area` VALUES ('140411000000', '140400000000', 3, 0, '郊区');
INSERT INTO `comm_address_area` VALUES ('140421000000', '140400000000', 3, 0, '长治县');
INSERT INTO `comm_address_area` VALUES ('140423000000', '140400000000', 3, 0, '襄垣县');
INSERT INTO `comm_address_area` VALUES ('140424000000', '140400000000', 3, 0, '屯留县');
INSERT INTO `comm_address_area` VALUES ('140425000000', '140400000000', 3, 0, '平顺县');
INSERT INTO `comm_address_area` VALUES ('140426000000', '140400000000', 3, 0, '黎城县');
INSERT INTO `comm_address_area` VALUES ('140427000000', '140400000000', 3, 0, '壶关县');
INSERT INTO `comm_address_area` VALUES ('140428000000', '140400000000', 3, 0, '长子县');
INSERT INTO `comm_address_area` VALUES ('140429000000', '140400000000', 3, 0, '武乡县');
INSERT INTO `comm_address_area` VALUES ('140430000000', '140400000000', 3, 0, '沁县');
INSERT INTO `comm_address_area` VALUES ('140431000000', '140400000000', 3, 0, '沁源县');
INSERT INTO `comm_address_area` VALUES ('140481000000', '140400000000', 3, 0, '潞城市');
INSERT INTO `comm_address_area` VALUES ('140500000000', '140000000000', 2, 0, '晋城市');
INSERT INTO `comm_address_area` VALUES ('140502000000', '140500000000', 3, 0, '城区');
INSERT INTO `comm_address_area` VALUES ('140521000000', '140500000000', 3, 0, '沁水县');
INSERT INTO `comm_address_area` VALUES ('140522000000', '140500000000', 3, 0, '阳城县');
INSERT INTO `comm_address_area` VALUES ('140524000000', '140500000000', 3, 0, '陵川县');
INSERT INTO `comm_address_area` VALUES ('140525000000', '140500000000', 3, 0, '泽州县');
INSERT INTO `comm_address_area` VALUES ('140581000000', '140500000000', 3, 0, '高平市');
INSERT INTO `comm_address_area` VALUES ('140600000000', '140000000000', 2, 0, '朔州市');
INSERT INTO `comm_address_area` VALUES ('140602000000', '140600000000', 3, 0, '朔城区');
INSERT INTO `comm_address_area` VALUES ('140603000000', '140600000000', 3, 0, '平鲁区');
INSERT INTO `comm_address_area` VALUES ('140621000000', '140600000000', 3, 0, '山阴县');
INSERT INTO `comm_address_area` VALUES ('140622000000', '140600000000', 3, 0, '应县');
INSERT INTO `comm_address_area` VALUES ('140623000000', '140600000000', 3, 0, '右玉县');
INSERT INTO `comm_address_area` VALUES ('140624000000', '140600000000', 3, 0, '怀仁县');
INSERT INTO `comm_address_area` VALUES ('140700000000', '140000000000', 2, 0, '晋中市');
INSERT INTO `comm_address_area` VALUES ('140702000000', '140700000000', 3, 0, '榆次区');
INSERT INTO `comm_address_area` VALUES ('140721000000', '140700000000', 3, 0, '榆社县');
INSERT INTO `comm_address_area` VALUES ('140722000000', '140700000000', 3, 0, '左权县');
INSERT INTO `comm_address_area` VALUES ('140723000000', '140700000000', 3, 0, '和顺县');
INSERT INTO `comm_address_area` VALUES ('140724000000', '140700000000', 3, 0, '昔阳县');
INSERT INTO `comm_address_area` VALUES ('140725000000', '140700000000', 3, 0, '寿阳县');
INSERT INTO `comm_address_area` VALUES ('140726000000', '140700000000', 3, 0, '太谷县');
INSERT INTO `comm_address_area` VALUES ('140727000000', '140700000000', 3, 0, '祁县');
INSERT INTO `comm_address_area` VALUES ('140728000000', '140700000000', 3, 0, '平遥县');
INSERT INTO `comm_address_area` VALUES ('140729000000', '140700000000', 3, 0, '灵石县');
INSERT INTO `comm_address_area` VALUES ('140781000000', '140700000000', 3, 0, '介休市');
INSERT INTO `comm_address_area` VALUES ('140800000000', '140000000000', 2, 0, '运城市');
INSERT INTO `comm_address_area` VALUES ('140802000000', '140800000000', 3, 0, '盐湖区');
INSERT INTO `comm_address_area` VALUES ('140821000000', '140800000000', 3, 0, '临猗县');
INSERT INTO `comm_address_area` VALUES ('140822000000', '140800000000', 3, 0, '万荣县');
INSERT INTO `comm_address_area` VALUES ('140823000000', '140800000000', 3, 0, '闻喜县');
INSERT INTO `comm_address_area` VALUES ('140824000000', '140800000000', 3, 0, '稷山县');
INSERT INTO `comm_address_area` VALUES ('140825000000', '140800000000', 3, 0, '新绛县');
INSERT INTO `comm_address_area` VALUES ('140826000000', '140800000000', 3, 0, '绛县');
INSERT INTO `comm_address_area` VALUES ('140827000000', '140800000000', 3, 0, '垣曲县');
INSERT INTO `comm_address_area` VALUES ('140828000000', '140800000000', 3, 0, '夏县');
INSERT INTO `comm_address_area` VALUES ('140829000000', '140800000000', 3, 0, '平陆县');
INSERT INTO `comm_address_area` VALUES ('140830000000', '140800000000', 3, 0, '芮城县');
INSERT INTO `comm_address_area` VALUES ('140881000000', '140800000000', 3, 0, '永济市');
INSERT INTO `comm_address_area` VALUES ('140882000000', '140800000000', 3, 0, '河津市');
INSERT INTO `comm_address_area` VALUES ('140900000000', '140000000000', 2, 0, '忻州市');
INSERT INTO `comm_address_area` VALUES ('140902000000', '140900000000', 3, 0, '忻府区');
INSERT INTO `comm_address_area` VALUES ('140921000000', '140900000000', 3, 0, '定襄县');
INSERT INTO `comm_address_area` VALUES ('140922000000', '140900000000', 3, 0, '五台县');
INSERT INTO `comm_address_area` VALUES ('140923000000', '140900000000', 3, 0, '代县');
INSERT INTO `comm_address_area` VALUES ('140924000000', '140900000000', 3, 0, '繁峙县');
INSERT INTO `comm_address_area` VALUES ('140925000000', '140900000000', 3, 0, '宁武县');
INSERT INTO `comm_address_area` VALUES ('140926000000', '140900000000', 3, 0, '静乐县');
INSERT INTO `comm_address_area` VALUES ('140927000000', '140900000000', 3, 0, '神池县');
INSERT INTO `comm_address_area` VALUES ('140928000000', '140900000000', 3, 0, '五寨县');
INSERT INTO `comm_address_area` VALUES ('140929000000', '140900000000', 3, 0, '岢岚县');
INSERT INTO `comm_address_area` VALUES ('140930000000', '140900000000', 3, 0, '河曲县');
INSERT INTO `comm_address_area` VALUES ('140931000000', '140900000000', 3, 0, '保德县');
INSERT INTO `comm_address_area` VALUES ('140932000000', '140900000000', 3, 0, '偏关县');
INSERT INTO `comm_address_area` VALUES ('140981000000', '140900000000', 3, 0, '原平市');
INSERT INTO `comm_address_area` VALUES ('141000000000', '140000000000', 2, 0, '临汾市');
INSERT INTO `comm_address_area` VALUES ('141002000000', '141000000000', 3, 0, '尧都区');
INSERT INTO `comm_address_area` VALUES ('141021000000', '141000000000', 3, 0, '曲沃县');
INSERT INTO `comm_address_area` VALUES ('141022000000', '141000000000', 3, 0, '翼城县');
INSERT INTO `comm_address_area` VALUES ('141023000000', '141000000000', 3, 0, '襄汾县');
INSERT INTO `comm_address_area` VALUES ('141024000000', '141000000000', 3, 0, '洪洞县');
INSERT INTO `comm_address_area` VALUES ('141025000000', '141000000000', 3, 0, '古县');
INSERT INTO `comm_address_area` VALUES ('141026000000', '141000000000', 3, 0, '安泽县');
INSERT INTO `comm_address_area` VALUES ('141027000000', '141000000000', 3, 0, '浮山县');
INSERT INTO `comm_address_area` VALUES ('141028000000', '141000000000', 3, 0, '吉县');
INSERT INTO `comm_address_area` VALUES ('141029000000', '141000000000', 3, 0, '乡宁县');
INSERT INTO `comm_address_area` VALUES ('141030000000', '141000000000', 3, 0, '大宁县');
INSERT INTO `comm_address_area` VALUES ('141031000000', '141000000000', 3, 0, '隰县');
INSERT INTO `comm_address_area` VALUES ('141032000000', '141000000000', 3, 0, '永和县');
INSERT INTO `comm_address_area` VALUES ('141033000000', '141000000000', 3, 0, '蒲县');
INSERT INTO `comm_address_area` VALUES ('141034000000', '141000000000', 3, 0, '汾西县');
INSERT INTO `comm_address_area` VALUES ('141081000000', '141000000000', 3, 0, '侯马市');
INSERT INTO `comm_address_area` VALUES ('141082000000', '141000000000', 3, 0, '霍州市');
INSERT INTO `comm_address_area` VALUES ('141100000000', '140000000000', 2, 0, '吕梁市');
INSERT INTO `comm_address_area` VALUES ('141102000000', '141100000000', 3, 0, '离石区');
INSERT INTO `comm_address_area` VALUES ('141121000000', '141100000000', 3, 0, '文水县');
INSERT INTO `comm_address_area` VALUES ('141122000000', '141100000000', 3, 0, '交城县');
INSERT INTO `comm_address_area` VALUES ('141123000000', '141100000000', 3, 0, '兴县');
INSERT INTO `comm_address_area` VALUES ('141124000000', '141100000000', 3, 0, '临县');
INSERT INTO `comm_address_area` VALUES ('141125000000', '141100000000', 3, 0, '柳林县');
INSERT INTO `comm_address_area` VALUES ('141126000000', '141100000000', 3, 0, '石楼县');
INSERT INTO `comm_address_area` VALUES ('141127000000', '141100000000', 3, 0, '岚县');
INSERT INTO `comm_address_area` VALUES ('141128000000', '141100000000', 3, 0, '方山县');
INSERT INTO `comm_address_area` VALUES ('141129000000', '141100000000', 3, 0, '中阳县');
INSERT INTO `comm_address_area` VALUES ('141130000000', '141100000000', 3, 0, '交口县');
INSERT INTO `comm_address_area` VALUES ('141181000000', '141100000000', 3, 0, '孝义市');
INSERT INTO `comm_address_area` VALUES ('141182000000', '141100000000', 3, 0, '汾阳市');
INSERT INTO `comm_address_area` VALUES ('610000000000', '0', 1, 0, '陕西省');
INSERT INTO `comm_address_area` VALUES ('610100000000', '610000000000', 2, 0, '西安市');
INSERT INTO `comm_address_area` VALUES ('610102000000', '610100000000', 3, 0, '新城区');
INSERT INTO `comm_address_area` VALUES ('610103000000', '610100000000', 3, 0, '碑林区');
INSERT INTO `comm_address_area` VALUES ('610104000000', '610100000000', 3, 0, '莲湖区');
INSERT INTO `comm_address_area` VALUES ('610111000000', '610100000000', 3, 0, '灞桥区');
INSERT INTO `comm_address_area` VALUES ('610112000000', '610100000000', 3, 0, '未央区');
INSERT INTO `comm_address_area` VALUES ('610113000000', '610100000000', 3, 0, '雁塔区');
INSERT INTO `comm_address_area` VALUES ('610114000000', '610100000000', 3, 0, '阎良区');
INSERT INTO `comm_address_area` VALUES ('610115000000', '610100000000', 3, 0, '临潼区');
INSERT INTO `comm_address_area` VALUES ('610116000000', '610100000000', 3, 0, '长安区');
INSERT INTO `comm_address_area` VALUES ('610122000000', '610100000000', 3, 0, '蓝田县');
INSERT INTO `comm_address_area` VALUES ('610124000000', '610100000000', 3, 0, '周至县');
INSERT INTO `comm_address_area` VALUES ('610125000000', '610100000000', 3, 0, '户县');
INSERT INTO `comm_address_area` VALUES ('610126000000', '610100000000', 3, 0, '高陵县');
INSERT INTO `comm_address_area` VALUES ('610200000000', '610000000000', 2, 0, '铜川市');
INSERT INTO `comm_address_area` VALUES ('610202000000', '610200000000', 3, 0, '王益区');
INSERT INTO `comm_address_area` VALUES ('610203000000', '610200000000', 3, 0, '印台区');
INSERT INTO `comm_address_area` VALUES ('610204000000', '610200000000', 3, 0, '耀州区');
INSERT INTO `comm_address_area` VALUES ('610222000000', '610200000000', 3, 0, '宜君县');
INSERT INTO `comm_address_area` VALUES ('610300000000', '610000000000', 2, 0, '宝鸡市');
INSERT INTO `comm_address_area` VALUES ('610302000000', '610300000000', 3, 0, '渭滨区');
INSERT INTO `comm_address_area` VALUES ('610303000000', '610300000000', 3, 0, '金台区');
INSERT INTO `comm_address_area` VALUES ('610304000000', '610300000000', 3, 0, '陈仓区');
INSERT INTO `comm_address_area` VALUES ('610322000000', '610300000000', 3, 0, '凤翔县');
INSERT INTO `comm_address_area` VALUES ('610323000000', '610300000000', 3, 0, '岐山县');
INSERT INTO `comm_address_area` VALUES ('610324000000', '610300000000', 3, 0, '扶风县');
INSERT INTO `comm_address_area` VALUES ('610326000000', '610300000000', 3, 0, '眉县');
INSERT INTO `comm_address_area` VALUES ('610327000000', '610300000000', 3, 0, '陇县');
INSERT INTO `comm_address_area` VALUES ('610328000000', '610300000000', 3, 0, '千阳县');
INSERT INTO `comm_address_area` VALUES ('610329000000', '610300000000', 3, 0, '麟游县');
INSERT INTO `comm_address_area` VALUES ('610330000000', '610300000000', 3, 0, '凤县');
INSERT INTO `comm_address_area` VALUES ('610331000000', '610300000000', 3, 0, '太白县');
INSERT INTO `comm_address_area` VALUES ('610400000000', '610000000000', 2, 0, '咸阳市');
INSERT INTO `comm_address_area` VALUES ('610402000000', '610400000000', 3, 0, '秦都区');
INSERT INTO `comm_address_area` VALUES ('610403000000', '610400000000', 3, 0, '杨陵区');
INSERT INTO `comm_address_area` VALUES ('610404000000', '610400000000', 3, 0, '渭城区');
INSERT INTO `comm_address_area` VALUES ('610422000000', '610400000000', 3, 0, '三原县');
INSERT INTO `comm_address_area` VALUES ('610423000000', '610400000000', 3, 0, '泾阳县');
INSERT INTO `comm_address_area` VALUES ('610424000000', '610400000000', 3, 0, '乾县');
INSERT INTO `comm_address_area` VALUES ('610425000000', '610400000000', 3, 0, '礼泉县');
INSERT INTO `comm_address_area` VALUES ('610426000000', '610400000000', 3, 0, '永寿县');
INSERT INTO `comm_address_area` VALUES ('610427000000', '610400000000', 3, 0, '彬县');
INSERT INTO `comm_address_area` VALUES ('610428000000', '610400000000', 3, 0, '长武县');
INSERT INTO `comm_address_area` VALUES ('610429000000', '610400000000', 3, 0, '旬邑县');
INSERT INTO `comm_address_area` VALUES ('610430000000', '610400000000', 3, 0, '淳化县');
INSERT INTO `comm_address_area` VALUES ('610431000000', '610400000000', 3, 0, '武功县');
INSERT INTO `comm_address_area` VALUES ('610481000000', '610400000000', 3, 0, '兴平市');
INSERT INTO `comm_address_area` VALUES ('610500000000', '610000000000', 2, 0, '渭南市');
INSERT INTO `comm_address_area` VALUES ('610502000000', '610500000000', 3, 0, '临渭区');
INSERT INTO `comm_address_area` VALUES ('610521000000', '610500000000', 3, 0, '华县');
INSERT INTO `comm_address_area` VALUES ('610522000000', '610500000000', 3, 0, '潼关县');
INSERT INTO `comm_address_area` VALUES ('610523000000', '610500000000', 3, 0, '大荔县');
INSERT INTO `comm_address_area` VALUES ('610524000000', '610500000000', 3, 0, '合阳县');
INSERT INTO `comm_address_area` VALUES ('610525000000', '610500000000', 3, 0, '澄城县');
INSERT INTO `comm_address_area` VALUES ('610526000000', '610500000000', 3, 0, '蒲城县');
INSERT INTO `comm_address_area` VALUES ('610527000000', '610500000000', 3, 0, '白水县');
INSERT INTO `comm_address_area` VALUES ('610528000000', '610500000000', 3, 0, '富平县');
INSERT INTO `comm_address_area` VALUES ('610581000000', '610500000000', 3, 0, '韩城市');
INSERT INTO `comm_address_area` VALUES ('610582000000', '610500000000', 3, 0, '华阴市');
INSERT INTO `comm_address_area` VALUES ('610600000000', '610000000000', 2, 0, '延安市');
INSERT INTO `comm_address_area` VALUES ('610602000000', '610600000000', 3, 0, '宝塔区');
INSERT INTO `comm_address_area` VALUES ('610621000000', '610600000000', 3, 0, '延长县');
INSERT INTO `comm_address_area` VALUES ('610622000000', '610600000000', 3, 0, '延川县');
INSERT INTO `comm_address_area` VALUES ('610623000000', '610600000000', 3, 0, '子长县');
INSERT INTO `comm_address_area` VALUES ('610624000000', '610600000000', 3, 0, '安塞县');
INSERT INTO `comm_address_area` VALUES ('610625000000', '610600000000', 3, 0, '志丹县');
INSERT INTO `comm_address_area` VALUES ('610626000000', '610600000000', 3, 0, '吴起县');
INSERT INTO `comm_address_area` VALUES ('610627000000', '610600000000', 3, 0, '甘泉县');
INSERT INTO `comm_address_area` VALUES ('610628000000', '610600000000', 3, 0, '富县');
INSERT INTO `comm_address_area` VALUES ('610629000000', '610600000000', 3, 0, '洛川县');
INSERT INTO `comm_address_area` VALUES ('610630000000', '610600000000', 3, 0, '宜川县');
INSERT INTO `comm_address_area` VALUES ('610631000000', '610600000000', 3, 0, '黄龙县');
INSERT INTO `comm_address_area` VALUES ('610632000000', '610600000000', 3, 0, '黄陵县');
INSERT INTO `comm_address_area` VALUES ('610700000000', '610000000000', 2, 0, '汉中市');
INSERT INTO `comm_address_area` VALUES ('610702000000', '610700000000', 3, 0, '汉台区');
INSERT INTO `comm_address_area` VALUES ('610721000000', '610700000000', 3, 0, '南郑县');
INSERT INTO `comm_address_area` VALUES ('610722000000', '610700000000', 3, 0, '城固县');
INSERT INTO `comm_address_area` VALUES ('610723000000', '610700000000', 3, 0, '洋县');
INSERT INTO `comm_address_area` VALUES ('610724000000', '610700000000', 3, 0, '西乡县');
INSERT INTO `comm_address_area` VALUES ('610725000000', '610700000000', 3, 0, '勉县');
INSERT INTO `comm_address_area` VALUES ('610726000000', '610700000000', 3, 0, '宁强县');
INSERT INTO `comm_address_area` VALUES ('610727000000', '610700000000', 3, 0, '略阳县');
INSERT INTO `comm_address_area` VALUES ('610728000000', '610700000000', 3, 0, '镇巴县');
INSERT INTO `comm_address_area` VALUES ('610729000000', '610700000000', 3, 0, '留坝县');
INSERT INTO `comm_address_area` VALUES ('610730000000', '610700000000', 3, 0, '佛坪县');
INSERT INTO `comm_address_area` VALUES ('610800000000', '610000000000', 2, 0, '榆林市');
INSERT INTO `comm_address_area` VALUES ('610802000000', '610800000000', 3, 0, '榆阳区');
INSERT INTO `comm_address_area` VALUES ('610821000000', '610800000000', 3, 0, '神木县');
INSERT INTO `comm_address_area` VALUES ('610822000000', '610800000000', 3, 0, '府谷县');
INSERT INTO `comm_address_area` VALUES ('610823000000', '610800000000', 3, 0, '横山县');
INSERT INTO `comm_address_area` VALUES ('610824000000', '610800000000', 3, 0, '靖边县');
INSERT INTO `comm_address_area` VALUES ('610825000000', '610800000000', 3, 0, '定边县');
INSERT INTO `comm_address_area` VALUES ('610826000000', '610800000000', 3, 0, '绥德县');
INSERT INTO `comm_address_area` VALUES ('610827000000', '610800000000', 3, 0, '米脂县');
INSERT INTO `comm_address_area` VALUES ('610828000000', '610800000000', 3, 0, '佳县');
INSERT INTO `comm_address_area` VALUES ('610829000000', '610800000000', 3, 0, '吴堡县');
INSERT INTO `comm_address_area` VALUES ('610830000000', '610800000000', 3, 0, '清涧县');
INSERT INTO `comm_address_area` VALUES ('610831000000', '610800000000', 3, 0, '子洲县');
INSERT INTO `comm_address_area` VALUES ('610900000000', '610000000000', 2, 0, '安康市');
INSERT INTO `comm_address_area` VALUES ('610902000000', '610900000000', 3, 0, '汉滨区');
INSERT INTO `comm_address_area` VALUES ('610921000000', '610900000000', 3, 0, '汉阴县');
INSERT INTO `comm_address_area` VALUES ('610922000000', '610900000000', 3, 0, '石泉县');
INSERT INTO `comm_address_area` VALUES ('610923000000', '610900000000', 3, 0, '宁陕县');
INSERT INTO `comm_address_area` VALUES ('610924000000', '610900000000', 3, 0, '紫阳县');
INSERT INTO `comm_address_area` VALUES ('610925000000', '610900000000', 3, 0, '岚皋县');
INSERT INTO `comm_address_area` VALUES ('610926000000', '610900000000', 3, 0, '平利县');
INSERT INTO `comm_address_area` VALUES ('610927000000', '610900000000', 3, 0, '镇坪县');
INSERT INTO `comm_address_area` VALUES ('610928000000', '610900000000', 3, 0, '旬阳县');
INSERT INTO `comm_address_area` VALUES ('610929000000', '610900000000', 3, 0, '白河县');
INSERT INTO `comm_address_area` VALUES ('611000000000', '610000000000', 2, 0, '商洛市');
INSERT INTO `comm_address_area` VALUES ('611002000000', '611000000000', 3, 0, '商州区');
INSERT INTO `comm_address_area` VALUES ('611021000000', '611000000000', 3, 0, '洛南县');
INSERT INTO `comm_address_area` VALUES ('611022000000', '611000000000', 3, 0, '丹凤县');
INSERT INTO `comm_address_area` VALUES ('611023000000', '611000000000', 3, 0, '商南县');
INSERT INTO `comm_address_area` VALUES ('611024000000', '611000000000', 3, 0, '山阳县');
INSERT INTO `comm_address_area` VALUES ('611025000000', '611000000000', 3, 0, '镇安县');
INSERT INTO `comm_address_area` VALUES ('611026000000', '611000000000', 3, 0, '柞水县');
INSERT INTO `comm_address_area` VALUES ('310000000000', '0', 1, 0, '上海市');
INSERT INTO `comm_address_area` VALUES ('310101000000', '310000000000', 2, 0, '黄浦区');
INSERT INTO `comm_address_area` VALUES ('310104000000', '310000000000', 2, 0, '徐汇区');
INSERT INTO `comm_address_area` VALUES ('310105000000', '310000000000', 2, 0, '长宁区');
INSERT INTO `comm_address_area` VALUES ('310106000000', '310000000000', 2, 0, '静安区');
INSERT INTO `comm_address_area` VALUES ('310107000000', '310000000000', 2, 0, '普陀区');
INSERT INTO `comm_address_area` VALUES ('310108000000', '310000000000', 2, 0, '闸北区');
INSERT INTO `comm_address_area` VALUES ('310109000000', '310000000000', 2, 0, '虹口区');
INSERT INTO `comm_address_area` VALUES ('310110000000', '310000000000', 2, 0, '杨浦区');
INSERT INTO `comm_address_area` VALUES ('310112000000', '310000000000', 2, 0, '闵行区');
INSERT INTO `comm_address_area` VALUES ('310113000000', '310000000000', 2, 0, '宝山区');
INSERT INTO `comm_address_area` VALUES ('310114000000', '310000000000', 2, 0, '嘉定区');
INSERT INTO `comm_address_area` VALUES ('310115000000', '310000000000', 2, 0, '浦东新区');
INSERT INTO `comm_address_area` VALUES ('310116000000', '310000000000', 2, 0, '金山区');
INSERT INTO `comm_address_area` VALUES ('310117000000', '310000000000', 2, 0, '松江区');
INSERT INTO `comm_address_area` VALUES ('310118000000', '310000000000', 2, 0, '青浦区');
INSERT INTO `comm_address_area` VALUES ('310120000000', '310000000000', 2, 0, '奉贤区');
INSERT INTO `comm_address_area` VALUES ('310230000000', '310000000000', 2, 0, '崇明县');
INSERT INTO `comm_address_area` VALUES ('510000000000', '0', 1, 0, '四川省');
INSERT INTO `comm_address_area` VALUES ('510100000000', '510000000000', 2, 0, '成都市');
INSERT INTO `comm_address_area` VALUES ('510104000000', '510100000000', 3, 0, '锦江区');
INSERT INTO `comm_address_area` VALUES ('510105000000', '510100000000', 3, 0, '青羊区');
INSERT INTO `comm_address_area` VALUES ('510106000000', '510100000000', 3, 0, '金牛区');
INSERT INTO `comm_address_area` VALUES ('510107000000', '510100000000', 3, 0, '武侯区');
INSERT INTO `comm_address_area` VALUES ('510108000000', '510100000000', 3, 0, '成华区');
INSERT INTO `comm_address_area` VALUES ('510112000000', '510100000000', 3, 0, '龙泉驿区');
INSERT INTO `comm_address_area` VALUES ('510113000000', '510100000000', 3, 0, '青白江区');
INSERT INTO `comm_address_area` VALUES ('510114000000', '510100000000', 3, 0, '新都区');
INSERT INTO `comm_address_area` VALUES ('510115000000', '510100000000', 3, 0, '温江区');
INSERT INTO `comm_address_area` VALUES ('510121000000', '510100000000', 3, 0, '金堂县');
INSERT INTO `comm_address_area` VALUES ('510122000000', '510100000000', 3, 0, '双流县');
INSERT INTO `comm_address_area` VALUES ('510124000000', '510100000000', 3, 0, '郫县');
INSERT INTO `comm_address_area` VALUES ('510129000000', '510100000000', 3, 0, '大邑县');
INSERT INTO `comm_address_area` VALUES ('510131000000', '510100000000', 3, 0, '蒲江县');
INSERT INTO `comm_address_area` VALUES ('510132000000', '510100000000', 3, 0, '新津县');
INSERT INTO `comm_address_area` VALUES ('510181000000', '510100000000', 3, 0, '都江堰市');
INSERT INTO `comm_address_area` VALUES ('510182000000', '510100000000', 3, 0, '彭州市');
INSERT INTO `comm_address_area` VALUES ('510183000000', '510100000000', 3, 0, '邛崃市');
INSERT INTO `comm_address_area` VALUES ('510184000000', '510100000000', 3, 0, '崇州市');
INSERT INTO `comm_address_area` VALUES ('510300000000', '510000000000', 2, 0, '自贡市');
INSERT INTO `comm_address_area` VALUES ('510302000000', '510300000000', 3, 0, '自流井区');
INSERT INTO `comm_address_area` VALUES ('510303000000', '510300000000', 3, 0, '贡井区');
INSERT INTO `comm_address_area` VALUES ('510304000000', '510300000000', 3, 0, '大安区');
INSERT INTO `comm_address_area` VALUES ('510311000000', '510300000000', 3, 0, '沿滩区');
INSERT INTO `comm_address_area` VALUES ('510321000000', '510300000000', 3, 0, '荣县');
INSERT INTO `comm_address_area` VALUES ('510322000000', '510300000000', 3, 0, '富顺县');
INSERT INTO `comm_address_area` VALUES ('510400000000', '510000000000', 2, 0, '攀枝花市');
INSERT INTO `comm_address_area` VALUES ('510402000000', '510400000000', 3, 0, '东区');
INSERT INTO `comm_address_area` VALUES ('510403000000', '510400000000', 3, 0, '西区');
INSERT INTO `comm_address_area` VALUES ('510411000000', '510400000000', 3, 0, '仁和区');
INSERT INTO `comm_address_area` VALUES ('510421000000', '510400000000', 3, 0, '米易县');
INSERT INTO `comm_address_area` VALUES ('510422000000', '510400000000', 3, 0, '盐边县');
INSERT INTO `comm_address_area` VALUES ('510500000000', '510000000000', 2, 0, '泸州市');
INSERT INTO `comm_address_area` VALUES ('510502000000', '510500000000', 3, 0, '江阳区');
INSERT INTO `comm_address_area` VALUES ('510503000000', '510500000000', 3, 0, '纳溪区');
INSERT INTO `comm_address_area` VALUES ('510504000000', '510500000000', 3, 0, '龙马潭区');
INSERT INTO `comm_address_area` VALUES ('510521000000', '510500000000', 3, 0, '泸县');
INSERT INTO `comm_address_area` VALUES ('510522000000', '510500000000', 3, 0, '合江县');
INSERT INTO `comm_address_area` VALUES ('510524000000', '510500000000', 3, 0, '叙永县');
INSERT INTO `comm_address_area` VALUES ('510525000000', '510500000000', 3, 0, '古蔺县');
INSERT INTO `comm_address_area` VALUES ('510600000000', '510000000000', 2, 0, '德阳市');
INSERT INTO `comm_address_area` VALUES ('510603000000', '510600000000', 3, 0, '旌阳区');
INSERT INTO `comm_address_area` VALUES ('510623000000', '510600000000', 3, 0, '中江县');
INSERT INTO `comm_address_area` VALUES ('510626000000', '510600000000', 3, 0, '罗江县');
INSERT INTO `comm_address_area` VALUES ('510681000000', '510600000000', 3, 0, '广汉市');
INSERT INTO `comm_address_area` VALUES ('510682000000', '510600000000', 3, 0, '什邡市');
INSERT INTO `comm_address_area` VALUES ('510683000000', '510600000000', 3, 0, '绵竹市');
INSERT INTO `comm_address_area` VALUES ('510700000000', '510000000000', 2, 0, '绵阳市');
INSERT INTO `comm_address_area` VALUES ('510703000000', '510700000000', 3, 0, '涪城区');
INSERT INTO `comm_address_area` VALUES ('510704000000', '510700000000', 3, 0, '游仙区');
INSERT INTO `comm_address_area` VALUES ('510722000000', '510700000000', 3, 0, '三台县');
INSERT INTO `comm_address_area` VALUES ('510723000000', '510700000000', 3, 0, '盐亭县');
INSERT INTO `comm_address_area` VALUES ('510724000000', '510700000000', 3, 0, '安县');
INSERT INTO `comm_address_area` VALUES ('510725000000', '510700000000', 3, 0, '梓潼县');
INSERT INTO `comm_address_area` VALUES ('510726000000', '510700000000', 3, 0, '北川羌族自治县');
INSERT INTO `comm_address_area` VALUES ('510727000000', '510700000000', 3, 0, '平武县');
INSERT INTO `comm_address_area` VALUES ('510781000000', '510700000000', 3, 0, '江油市');
INSERT INTO `comm_address_area` VALUES ('510800000000', '510000000000', 2, 0, '广元市');
INSERT INTO `comm_address_area` VALUES ('510802000000', '510800000000', 3, 0, '利州区');
INSERT INTO `comm_address_area` VALUES ('510811000000', '510800000000', 3, 0, '元坝区');
INSERT INTO `comm_address_area` VALUES ('510812000000', '510800000000', 3, 0, '朝天区');
INSERT INTO `comm_address_area` VALUES ('510821000000', '510800000000', 3, 0, '旺苍县');
INSERT INTO `comm_address_area` VALUES ('510822000000', '510800000000', 3, 0, '青川县');
INSERT INTO `comm_address_area` VALUES ('510823000000', '510800000000', 3, 0, '剑阁县');
INSERT INTO `comm_address_area` VALUES ('510824000000', '510800000000', 3, 0, '苍溪县');
INSERT INTO `comm_address_area` VALUES ('510900000000', '510000000000', 2, 0, '遂宁市');
INSERT INTO `comm_address_area` VALUES ('510903000000', '510900000000', 3, 0, '船山区');
INSERT INTO `comm_address_area` VALUES ('510904000000', '510900000000', 3, 0, '安居区');
INSERT INTO `comm_address_area` VALUES ('510921000000', '510900000000', 3, 0, '蓬溪县');
INSERT INTO `comm_address_area` VALUES ('510922000000', '510900000000', 3, 0, '射洪县');
INSERT INTO `comm_address_area` VALUES ('510923000000', '510900000000', 3, 0, '大英县');
INSERT INTO `comm_address_area` VALUES ('511000000000', '510000000000', 2, 0, '内江市');
INSERT INTO `comm_address_area` VALUES ('511002000000', '511000000000', 3, 0, '市中区');
INSERT INTO `comm_address_area` VALUES ('511011000000', '511000000000', 3, 0, '东兴区');
INSERT INTO `comm_address_area` VALUES ('511024000000', '511000000000', 3, 0, '威远县');
INSERT INTO `comm_address_area` VALUES ('511025000000', '511000000000', 3, 0, '资中县');
INSERT INTO `comm_address_area` VALUES ('511028000000', '511000000000', 3, 0, '隆昌县');
INSERT INTO `comm_address_area` VALUES ('511100000000', '510000000000', 2, 0, '乐山市');
INSERT INTO `comm_address_area` VALUES ('511102000000', '511100000000', 3, 0, '市中区');
INSERT INTO `comm_address_area` VALUES ('511111000000', '511100000000', 3, 0, '沙湾区');
INSERT INTO `comm_address_area` VALUES ('511112000000', '511100000000', 3, 0, '五通桥区');
INSERT INTO `comm_address_area` VALUES ('511113000000', '511100000000', 3, 0, '金口河区');
INSERT INTO `comm_address_area` VALUES ('511123000000', '511100000000', 3, 0, '犍为县');
INSERT INTO `comm_address_area` VALUES ('511124000000', '511100000000', 3, 0, '井研县');
INSERT INTO `comm_address_area` VALUES ('511126000000', '511100000000', 3, 0, '夹江县');
INSERT INTO `comm_address_area` VALUES ('511129000000', '511100000000', 3, 0, '沐川县');
INSERT INTO `comm_address_area` VALUES ('511132000000', '511100000000', 3, 0, '峨边彝族自治县');
INSERT INTO `comm_address_area` VALUES ('511133000000', '511100000000', 3, 0, '马边彝族自治县');
INSERT INTO `comm_address_area` VALUES ('511181000000', '511100000000', 3, 0, '峨眉山市');
INSERT INTO `comm_address_area` VALUES ('511300000000', '510000000000', 2, 0, '南充市');
INSERT INTO `comm_address_area` VALUES ('511302000000', '511300000000', 3, 0, '顺庆区');
INSERT INTO `comm_address_area` VALUES ('511303000000', '511300000000', 3, 0, '高坪区');
INSERT INTO `comm_address_area` VALUES ('511304000000', '511300000000', 3, 0, '嘉陵区');
INSERT INTO `comm_address_area` VALUES ('511321000000', '511300000000', 3, 0, '南部县');
INSERT INTO `comm_address_area` VALUES ('511322000000', '511300000000', 3, 0, '营山县');
INSERT INTO `comm_address_area` VALUES ('511323000000', '511300000000', 3, 0, '蓬安县');
INSERT INTO `comm_address_area` VALUES ('511324000000', '511300000000', 3, 0, '仪陇县');
INSERT INTO `comm_address_area` VALUES ('511325000000', '511300000000', 3, 0, '西充县');
INSERT INTO `comm_address_area` VALUES ('511381000000', '511300000000', 3, 0, '阆中市');
INSERT INTO `comm_address_area` VALUES ('511400000000', '510000000000', 2, 0, '眉山市');
INSERT INTO `comm_address_area` VALUES ('511402000000', '511400000000', 3, 0, '东坡区');
INSERT INTO `comm_address_area` VALUES ('511421000000', '511400000000', 3, 0, '仁寿县');
INSERT INTO `comm_address_area` VALUES ('511422000000', '511400000000', 3, 0, '彭山县');
INSERT INTO `comm_address_area` VALUES ('511423000000', '511400000000', 3, 0, '洪雅县');
INSERT INTO `comm_address_area` VALUES ('511424000000', '511400000000', 3, 0, '丹棱县');
INSERT INTO `comm_address_area` VALUES ('511425000000', '511400000000', 3, 0, '青神县');
INSERT INTO `comm_address_area` VALUES ('511500000000', '510000000000', 2, 0, '宜宾市');
INSERT INTO `comm_address_area` VALUES ('511502000000', '511500000000', 3, 0, '翠屏区');
INSERT INTO `comm_address_area` VALUES ('511503000000', '511500000000', 3, 0, '南溪区');
INSERT INTO `comm_address_area` VALUES ('511521000000', '511500000000', 3, 0, '宜宾县');
INSERT INTO `comm_address_area` VALUES ('511523000000', '511500000000', 3, 0, '江安县');
INSERT INTO `comm_address_area` VALUES ('511524000000', '511500000000', 3, 0, '长宁县');
INSERT INTO `comm_address_area` VALUES ('511525000000', '511500000000', 3, 0, '高县');
INSERT INTO `comm_address_area` VALUES ('511526000000', '511500000000', 3, 0, '珙县');
INSERT INTO `comm_address_area` VALUES ('511527000000', '511500000000', 3, 0, '筠连县');
INSERT INTO `comm_address_area` VALUES ('511528000000', '511500000000', 3, 0, '兴文县');
INSERT INTO `comm_address_area` VALUES ('511529000000', '511500000000', 3, 0, '屏山县');
INSERT INTO `comm_address_area` VALUES ('511600000000', '510000000000', 2, 0, '广安市');
INSERT INTO `comm_address_area` VALUES ('511602000000', '511600000000', 3, 0, '广安区');
INSERT INTO `comm_address_area` VALUES ('511621000000', '511600000000', 3, 0, '岳池县');
INSERT INTO `comm_address_area` VALUES ('511622000000', '511600000000', 3, 0, '武胜县');
INSERT INTO `comm_address_area` VALUES ('511623000000', '511600000000', 3, 0, '邻水县');
INSERT INTO `comm_address_area` VALUES ('511681000000', '511600000000', 3, 0, '华蓥市');
INSERT INTO `comm_address_area` VALUES ('511700000000', '510000000000', 2, 0, '达州市');
INSERT INTO `comm_address_area` VALUES ('511702000000', '511700000000', 3, 0, '通川区');
INSERT INTO `comm_address_area` VALUES ('511721000000', '511700000000', 3, 0, '达县');
INSERT INTO `comm_address_area` VALUES ('511722000000', '511700000000', 3, 0, '宣汉县');
INSERT INTO `comm_address_area` VALUES ('511723000000', '511700000000', 3, 0, '开江县');
INSERT INTO `comm_address_area` VALUES ('511724000000', '511700000000', 3, 0, '大竹县');
INSERT INTO `comm_address_area` VALUES ('511725000000', '511700000000', 3, 0, '渠县');
INSERT INTO `comm_address_area` VALUES ('511781000000', '511700000000', 3, 0, '万源市');
INSERT INTO `comm_address_area` VALUES ('511800000000', '510000000000', 2, 0, '雅安市');
INSERT INTO `comm_address_area` VALUES ('511802000000', '511800000000', 3, 0, '雨城区');
INSERT INTO `comm_address_area` VALUES ('511821000000', '511800000000', 3, 0, '名山县');
INSERT INTO `comm_address_area` VALUES ('511822000000', '511800000000', 3, 0, '荥经县');
INSERT INTO `comm_address_area` VALUES ('511823000000', '511800000000', 3, 0, '汉源县');
INSERT INTO `comm_address_area` VALUES ('511824000000', '511800000000', 3, 0, '石棉县');
INSERT INTO `comm_address_area` VALUES ('511825000000', '511800000000', 3, 0, '天全县');
INSERT INTO `comm_address_area` VALUES ('511826000000', '511800000000', 3, 0, '芦山县');
INSERT INTO `comm_address_area` VALUES ('511827000000', '511800000000', 3, 0, '宝兴县');
INSERT INTO `comm_address_area` VALUES ('511900000000', '510000000000', 2, 0, '巴中市');
INSERT INTO `comm_address_area` VALUES ('511902000000', '511900000000', 3, 0, '巴州区');
INSERT INTO `comm_address_area` VALUES ('511921000000', '511900000000', 3, 0, '通江县');
INSERT INTO `comm_address_area` VALUES ('511922000000', '511900000000', 3, 0, '南江县');
INSERT INTO `comm_address_area` VALUES ('511923000000', '511900000000', 3, 0, '平昌县');
INSERT INTO `comm_address_area` VALUES ('512000000000', '510000000000', 2, 0, '资阳市');
INSERT INTO `comm_address_area` VALUES ('512002000000', '512000000000', 3, 0, '雁江区');
INSERT INTO `comm_address_area` VALUES ('512021000000', '512000000000', 3, 0, '安岳县');
INSERT INTO `comm_address_area` VALUES ('512022000000', '512000000000', 3, 0, '乐至县');
INSERT INTO `comm_address_area` VALUES ('512081000000', '512000000000', 3, 0, '简阳市');
INSERT INTO `comm_address_area` VALUES ('513200000000', '510000000000', 2, 0, '阿坝藏族羌族自治州');
INSERT INTO `comm_address_area` VALUES ('513221000000', '513200000000', 3, 0, '汶川县');
INSERT INTO `comm_address_area` VALUES ('513222000000', '513200000000', 3, 0, '理县');
INSERT INTO `comm_address_area` VALUES ('513223000000', '513200000000', 3, 0, '茂县');
INSERT INTO `comm_address_area` VALUES ('513224000000', '513200000000', 3, 0, '松潘县');
INSERT INTO `comm_address_area` VALUES ('513225000000', '513200000000', 3, 0, '九寨沟县');
INSERT INTO `comm_address_area` VALUES ('513226000000', '513200000000', 3, 0, '金川县');
INSERT INTO `comm_address_area` VALUES ('513227000000', '513200000000', 3, 0, '小金县');
INSERT INTO `comm_address_area` VALUES ('513228000000', '513200000000', 3, 0, '黑水县');
INSERT INTO `comm_address_area` VALUES ('513229000000', '513200000000', 3, 0, '马尔康县');
INSERT INTO `comm_address_area` VALUES ('513230000000', '513200000000', 3, 0, '壤塘县');
INSERT INTO `comm_address_area` VALUES ('513231000000', '513200000000', 3, 0, '阿坝县');
INSERT INTO `comm_address_area` VALUES ('513232000000', '513200000000', 3, 0, '若尔盖县');
INSERT INTO `comm_address_area` VALUES ('513233000000', '513200000000', 3, 0, '红原县');
INSERT INTO `comm_address_area` VALUES ('513300000000', '510000000000', 2, 0, '甘孜藏族自治州');
INSERT INTO `comm_address_area` VALUES ('513321000000', '513300000000', 3, 0, '康定县');
INSERT INTO `comm_address_area` VALUES ('513322000000', '513300000000', 3, 0, '泸定县');
INSERT INTO `comm_address_area` VALUES ('513323000000', '513300000000', 3, 0, '丹巴县');
INSERT INTO `comm_address_area` VALUES ('513324000000', '513300000000', 3, 0, '九龙县');
INSERT INTO `comm_address_area` VALUES ('513325000000', '513300000000', 3, 0, '雅江县');
INSERT INTO `comm_address_area` VALUES ('513326000000', '513300000000', 3, 0, '道孚县');
INSERT INTO `comm_address_area` VALUES ('513327000000', '513300000000', 3, 0, '炉霍县');
INSERT INTO `comm_address_area` VALUES ('513328000000', '513300000000', 3, 0, '甘孜县');
INSERT INTO `comm_address_area` VALUES ('513329000000', '513300000000', 3, 0, '新龙县');
INSERT INTO `comm_address_area` VALUES ('513330000000', '513300000000', 3, 0, '德格县');
INSERT INTO `comm_address_area` VALUES ('513331000000', '513300000000', 3, 0, '白玉县');
INSERT INTO `comm_address_area` VALUES ('513332000000', '513300000000', 3, 0, '石渠县');
INSERT INTO `comm_address_area` VALUES ('513333000000', '513300000000', 3, 0, '色达县');
INSERT INTO `comm_address_area` VALUES ('513334000000', '513300000000', 3, 0, '理塘县');
INSERT INTO `comm_address_area` VALUES ('513335000000', '513300000000', 3, 0, '巴塘县');
INSERT INTO `comm_address_area` VALUES ('513336000000', '513300000000', 3, 0, '乡城县');
INSERT INTO `comm_address_area` VALUES ('513337000000', '513300000000', 3, 0, '稻城县');
INSERT INTO `comm_address_area` VALUES ('513338000000', '513300000000', 3, 0, '得荣县');
INSERT INTO `comm_address_area` VALUES ('513400000000', '510000000000', 2, 0, '凉山彝族自治州');
INSERT INTO `comm_address_area` VALUES ('513401000000', '513400000000', 3, 0, '西昌市');
INSERT INTO `comm_address_area` VALUES ('513422000000', '513400000000', 3, 0, '木里藏族自治县');
INSERT INTO `comm_address_area` VALUES ('513423000000', '513400000000', 3, 0, '盐源县');
INSERT INTO `comm_address_area` VALUES ('513424000000', '513400000000', 3, 0, '德昌县');
INSERT INTO `comm_address_area` VALUES ('513425000000', '513400000000', 3, 0, '会理县');
INSERT INTO `comm_address_area` VALUES ('513426000000', '513400000000', 3, 0, '会东县');
INSERT INTO `comm_address_area` VALUES ('513427000000', '513400000000', 3, 0, '宁南县');
INSERT INTO `comm_address_area` VALUES ('513428000000', '513400000000', 3, 0, '普格县');
INSERT INTO `comm_address_area` VALUES ('513429000000', '513400000000', 3, 0, '布拖县');
INSERT INTO `comm_address_area` VALUES ('513430000000', '513400000000', 3, 0, '金阳县');
INSERT INTO `comm_address_area` VALUES ('513431000000', '513400000000', 3, 0, '昭觉县');
INSERT INTO `comm_address_area` VALUES ('513432000000', '513400000000', 3, 0, '喜德县');
INSERT INTO `comm_address_area` VALUES ('513433000000', '513400000000', 3, 0, '冕宁县');
INSERT INTO `comm_address_area` VALUES ('513434000000', '513400000000', 3, 0, '越西县');
INSERT INTO `comm_address_area` VALUES ('513435000000', '513400000000', 3, 0, '甘洛县');
INSERT INTO `comm_address_area` VALUES ('513436000000', '513400000000', 3, 0, '美姑县');
INSERT INTO `comm_address_area` VALUES ('513437000000', '513400000000', 3, 0, '雷波县');
INSERT INTO `comm_address_area` VALUES ('120000000000', '0', 1, 0, '天津市');
INSERT INTO `comm_address_area` VALUES ('120101000000', '120000000000', 2, 0, '和平区');
INSERT INTO `comm_address_area` VALUES ('120102000000', '120000000000', 2, 0, '河东区');
INSERT INTO `comm_address_area` VALUES ('120103000000', '120000000000', 2, 0, '河西区');
INSERT INTO `comm_address_area` VALUES ('120104000000', '120000000000', 2, 0, '南开区');
INSERT INTO `comm_address_area` VALUES ('120105000000', '120000000000', 2, 0, '河北区');
INSERT INTO `comm_address_area` VALUES ('120106000000', '120000000000', 2, 0, '红桥区');
INSERT INTO `comm_address_area` VALUES ('120110000000', '120000000000', 2, 0, '东丽区');
INSERT INTO `comm_address_area` VALUES ('120111000000', '120000000000', 2, 0, '西青区');
INSERT INTO `comm_address_area` VALUES ('120112000000', '120000000000', 2, 0, '津南区');
INSERT INTO `comm_address_area` VALUES ('120113000000', '120000000000', 2, 0, '北辰区');
INSERT INTO `comm_address_area` VALUES ('120114000000', '120000000000', 2, 0, '武清区');
INSERT INTO `comm_address_area` VALUES ('120115000000', '120000000000', 2, 0, '宝坻区');
INSERT INTO `comm_address_area` VALUES ('120116000000', '120000000000', 2, 0, '滨海新区');
INSERT INTO `comm_address_area` VALUES ('120221000000', '120000000000', 2, 0, '宁河县');
INSERT INTO `comm_address_area` VALUES ('120223000000', '120000000000', 2, 0, '静海县');
INSERT INTO `comm_address_area` VALUES ('120225000000', '120000000000', 2, 0, '蓟县');
INSERT INTO `comm_address_area` VALUES ('540000000000', '0', 1, 0, '西藏自治区');
INSERT INTO `comm_address_area` VALUES ('540100000000', '540000000000', 2, 0, '拉萨市');
INSERT INTO `comm_address_area` VALUES ('540102000000', '540100000000', 3, 0, '城关区');
INSERT INTO `comm_address_area` VALUES ('540121000000', '540100000000', 3, 0, '林周县');
INSERT INTO `comm_address_area` VALUES ('540122000000', '540100000000', 3, 0, '当雄县');
INSERT INTO `comm_address_area` VALUES ('540123000000', '540100000000', 3, 0, '尼木县');
INSERT INTO `comm_address_area` VALUES ('540124000000', '540100000000', 3, 0, '曲水县');
INSERT INTO `comm_address_area` VALUES ('540125000000', '540100000000', 3, 0, '堆龙德庆县');
INSERT INTO `comm_address_area` VALUES ('540126000000', '540100000000', 3, 0, '达孜县');
INSERT INTO `comm_address_area` VALUES ('540127000000', '540100000000', 3, 0, '墨竹工卡县');
INSERT INTO `comm_address_area` VALUES ('542100000000', '540000000000', 2, 0, '昌都地区');
INSERT INTO `comm_address_area` VALUES ('542121000000', '542100000000', 3, 0, '昌都县');
INSERT INTO `comm_address_area` VALUES ('542122000000', '542100000000', 3, 0, '江达县');
INSERT INTO `comm_address_area` VALUES ('542123000000', '542100000000', 3, 0, '贡觉县');
INSERT INTO `comm_address_area` VALUES ('542124000000', '542100000000', 3, 0, '类乌齐县');
INSERT INTO `comm_address_area` VALUES ('542125000000', '542100000000', 3, 0, '丁青县');
INSERT INTO `comm_address_area` VALUES ('542126000000', '542100000000', 3, 0, '察雅县');
INSERT INTO `comm_address_area` VALUES ('542127000000', '542100000000', 3, 0, '八宿县');
INSERT INTO `comm_address_area` VALUES ('542128000000', '542100000000', 3, 0, '左贡县');
INSERT INTO `comm_address_area` VALUES ('542129000000', '542100000000', 3, 0, '芒康县');
INSERT INTO `comm_address_area` VALUES ('542132000000', '542100000000', 3, 0, '洛隆县');
INSERT INTO `comm_address_area` VALUES ('542133000000', '542100000000', 3, 0, '边坝县');
INSERT INTO `comm_address_area` VALUES ('542200000000', '540000000000', 2, 0, '山南地区');
INSERT INTO `comm_address_area` VALUES ('542221000000', '542200000000', 3, 0, '乃东县');
INSERT INTO `comm_address_area` VALUES ('542222000000', '542200000000', 3, 0, '扎囊县');
INSERT INTO `comm_address_area` VALUES ('542223000000', '542200000000', 3, 0, '贡嘎县');
INSERT INTO `comm_address_area` VALUES ('542224000000', '542200000000', 3, 0, '桑日县');
INSERT INTO `comm_address_area` VALUES ('542225000000', '542200000000', 3, 0, '琼结县');
INSERT INTO `comm_address_area` VALUES ('542226000000', '542200000000', 3, 0, '曲松县');
INSERT INTO `comm_address_area` VALUES ('542227000000', '542200000000', 3, 0, '措美县');
INSERT INTO `comm_address_area` VALUES ('542228000000', '542200000000', 3, 0, '洛扎县');
INSERT INTO `comm_address_area` VALUES ('542229000000', '542200000000', 3, 0, '加查县');
INSERT INTO `comm_address_area` VALUES ('542231000000', '542200000000', 3, 0, '隆子县');
INSERT INTO `comm_address_area` VALUES ('542232000000', '542200000000', 3, 0, '错那县');
INSERT INTO `comm_address_area` VALUES ('542233000000', '542200000000', 3, 0, '浪卡子县');
INSERT INTO `comm_address_area` VALUES ('542300000000', '540000000000', 2, 0, '日喀则地区');
INSERT INTO `comm_address_area` VALUES ('542301000000', '542300000000', 3, 0, '日喀则市');
INSERT INTO `comm_address_area` VALUES ('542322000000', '542300000000', 3, 0, '南木林县');
INSERT INTO `comm_address_area` VALUES ('542323000000', '542300000000', 3, 0, '江孜县');
INSERT INTO `comm_address_area` VALUES ('542324000000', '542300000000', 3, 0, '定日县');
INSERT INTO `comm_address_area` VALUES ('542325000000', '542300000000', 3, 0, '萨迦县');
INSERT INTO `comm_address_area` VALUES ('542326000000', '542300000000', 3, 0, '拉孜县');
INSERT INTO `comm_address_area` VALUES ('542327000000', '542300000000', 3, 0, '昂仁县');
INSERT INTO `comm_address_area` VALUES ('542328000000', '542300000000', 3, 0, '谢通门县');
INSERT INTO `comm_address_area` VALUES ('542329000000', '542300000000', 3, 0, '白朗县');
INSERT INTO `comm_address_area` VALUES ('542330000000', '542300000000', 3, 0, '仁布县');
INSERT INTO `comm_address_area` VALUES ('542331000000', '542300000000', 3, 0, '康马县');
INSERT INTO `comm_address_area` VALUES ('542332000000', '542300000000', 3, 0, '定结县');
INSERT INTO `comm_address_area` VALUES ('542333000000', '542300000000', 3, 0, '仲巴县');
INSERT INTO `comm_address_area` VALUES ('542334000000', '542300000000', 3, 0, '亚东县');
INSERT INTO `comm_address_area` VALUES ('542335000000', '542300000000', 3, 0, '吉隆县');
INSERT INTO `comm_address_area` VALUES ('542336000000', '542300000000', 3, 0, '聂拉木县');
INSERT INTO `comm_address_area` VALUES ('542337000000', '542300000000', 3, 0, '萨嘎县');
INSERT INTO `comm_address_area` VALUES ('542338000000', '542300000000', 3, 0, '岗巴县');
INSERT INTO `comm_address_area` VALUES ('542400000000', '540000000000', 2, 0, '那曲地区');
INSERT INTO `comm_address_area` VALUES ('542421000000', '542400000000', 3, 0, '那曲县');
INSERT INTO `comm_address_area` VALUES ('542422000000', '542400000000', 3, 0, '嘉黎县');
INSERT INTO `comm_address_area` VALUES ('542423000000', '542400000000', 3, 0, '比如县');
INSERT INTO `comm_address_area` VALUES ('542424000000', '542400000000', 3, 0, '聂荣县');
INSERT INTO `comm_address_area` VALUES ('542425000000', '542400000000', 3, 0, '安多县');
INSERT INTO `comm_address_area` VALUES ('542426000000', '542400000000', 3, 0, '申扎县');
INSERT INTO `comm_address_area` VALUES ('542427000000', '542400000000', 3, 0, '索县');
INSERT INTO `comm_address_area` VALUES ('542428000000', '542400000000', 3, 0, '班戈县');
INSERT INTO `comm_address_area` VALUES ('542429000000', '542400000000', 3, 0, '巴青县');
INSERT INTO `comm_address_area` VALUES ('542430000000', '542400000000', 3, 0, '尼玛县');
INSERT INTO `comm_address_area` VALUES ('542500000000', '540000000000', 2, 0, '阿里地区');
INSERT INTO `comm_address_area` VALUES ('542521000000', '542500000000', 3, 0, '普兰县');
INSERT INTO `comm_address_area` VALUES ('542522000000', '542500000000', 3, 0, '札达县');
INSERT INTO `comm_address_area` VALUES ('542523000000', '542500000000', 3, 0, '噶尔县');
INSERT INTO `comm_address_area` VALUES ('542524000000', '542500000000', 3, 0, '日土县');
INSERT INTO `comm_address_area` VALUES ('542525000000', '542500000000', 3, 0, '革吉县');
INSERT INTO `comm_address_area` VALUES ('542526000000', '542500000000', 3, 0, '改则县');
INSERT INTO `comm_address_area` VALUES ('542527000000', '542500000000', 3, 0, '措勤县');
INSERT INTO `comm_address_area` VALUES ('542600000000', '540000000000', 2, 0, '林芝地区');
INSERT INTO `comm_address_area` VALUES ('542621000000', '542600000000', 3, 0, '林芝县');
INSERT INTO `comm_address_area` VALUES ('542622000000', '542600000000', 3, 0, '工布江达县');
INSERT INTO `comm_address_area` VALUES ('542623000000', '542600000000', 3, 0, '米林县');
INSERT INTO `comm_address_area` VALUES ('542624000000', '542600000000', 3, 0, '墨脱县');
INSERT INTO `comm_address_area` VALUES ('542625000000', '542600000000', 3, 0, '波密县');
INSERT INTO `comm_address_area` VALUES ('542626000000', '542600000000', 3, 0, '察隅县');
INSERT INTO `comm_address_area` VALUES ('542627000000', '542600000000', 3, 0, '朗县');
INSERT INTO `comm_address_area` VALUES ('650000000000', '0', 1, 0, '新疆维吾尔自治区');
INSERT INTO `comm_address_area` VALUES ('650100000000', '650000000000', 2, 0, '乌鲁木齐市');
INSERT INTO `comm_address_area` VALUES ('650102000000', '650100000000', 3, 0, '天山区');
INSERT INTO `comm_address_area` VALUES ('650103000000', '650100000000', 3, 0, '沙依巴克区');
INSERT INTO `comm_address_area` VALUES ('650104000000', '650100000000', 3, 0, '新市区');
INSERT INTO `comm_address_area` VALUES ('650105000000', '650100000000', 3, 0, '水磨沟区');
INSERT INTO `comm_address_area` VALUES ('650107000000', '650100000000', 3, 0, '达坂城区');
INSERT INTO `comm_address_area` VALUES ('650109000000', '650100000000', 3, 0, '米东区');
INSERT INTO `comm_address_area` VALUES ('650121000000', '650100000000', 3, 0, '乌鲁木齐县');
INSERT INTO `comm_address_area` VALUES ('650106000000', '650100000000', 3, 0, '头屯河区');
INSERT INTO `comm_address_area` VALUES ('652324000000', '652300000000', 3, 0, '玛纳斯县');
INSERT INTO `comm_address_area` VALUES ('650200000000', '650000000000', 2, 0, '克拉玛依市');
INSERT INTO `comm_address_area` VALUES ('650202000000', '650200000000', 3, 0, '独山子区');
INSERT INTO `comm_address_area` VALUES ('650203000000', '650200000000', 3, 0, '克拉玛依区');
INSERT INTO `comm_address_area` VALUES ('650204000000', '650200000000', 3, 0, '白碱滩区');
INSERT INTO `comm_address_area` VALUES ('650205000000', '650200000000', 3, 0, '乌尔禾区');
INSERT INTO `comm_address_area` VALUES ('652100000000', '650000000000', 2, 0, '吐鲁番地区');
INSERT INTO `comm_address_area` VALUES ('652101000000', '652100000000', 3, 0, '吐鲁番市');
INSERT INTO `comm_address_area` VALUES ('652122000000', '652100000000', 3, 0, '鄯善县');
INSERT INTO `comm_address_area` VALUES ('652123000000', '652100000000', 3, 0, '托克逊县');
INSERT INTO `comm_address_area` VALUES ('652200000000', '650000000000', 2, 0, '哈密地区');
INSERT INTO `comm_address_area` VALUES ('652201000000', '652200000000', 3, 0, '哈密市');
INSERT INTO `comm_address_area` VALUES ('652222000000', '652200000000', 3, 0, '巴里坤哈萨克自治县');
INSERT INTO `comm_address_area` VALUES ('652223000000', '652200000000', 3, 0, '伊吾县');
INSERT INTO `comm_address_area` VALUES ('652300000000', '650000000000', 2, 0, '昌吉回族自治州');
INSERT INTO `comm_address_area` VALUES ('652301000000', '652300000000', 3, 0, '昌吉市');
INSERT INTO `comm_address_area` VALUES ('652302000000', '652300000000', 3, 0, '阜康市');
INSERT INTO `comm_address_area` VALUES ('652323000000', '652300000000', 3, 0, '呼图壁县');
INSERT INTO `comm_address_area` VALUES ('652325000000', '652300000000', 3, 0, '奇台县');
INSERT INTO `comm_address_area` VALUES ('652327000000', '652300000000', 3, 0, '吉木萨尔县');
INSERT INTO `comm_address_area` VALUES ('652328000000', '652300000000', 3, 0, '木垒哈萨克自治县');
INSERT INTO `comm_address_area` VALUES ('652700000000', '650000000000', 2, 0, '博尔塔拉蒙古自治州');
INSERT INTO `comm_address_area` VALUES ('652701000000', '652700000000', 3, 0, '博乐市');
INSERT INTO `comm_address_area` VALUES ('652722000000', '652700000000', 3, 0, '精河县');
INSERT INTO `comm_address_area` VALUES ('652723000000', '652700000000', 3, 0, '温泉县');
INSERT INTO `comm_address_area` VALUES ('652800000000', '650000000000', 2, 0, '巴音郭楞蒙古自治州');
INSERT INTO `comm_address_area` VALUES ('652801000000', '652800000000', 3, 0, '库尔勒市');
INSERT INTO `comm_address_area` VALUES ('652822000000', '652800000000', 3, 0, '轮台县');
INSERT INTO `comm_address_area` VALUES ('652823000000', '652800000000', 3, 0, '尉犁县');
INSERT INTO `comm_address_area` VALUES ('652824000000', '652800000000', 3, 0, '若羌县');
INSERT INTO `comm_address_area` VALUES ('652825000000', '652800000000', 3, 0, '且末县');
INSERT INTO `comm_address_area` VALUES ('652826000000', '652800000000', 3, 0, '焉耆回族自治县');
INSERT INTO `comm_address_area` VALUES ('652827000000', '652800000000', 3, 0, '和静县');
INSERT INTO `comm_address_area` VALUES ('652828000000', '652800000000', 3, 0, '和硕县');
INSERT INTO `comm_address_area` VALUES ('652829000000', '652800000000', 3, 0, '博湖县');
INSERT INTO `comm_address_area` VALUES ('652900000000', '650000000000', 2, 0, '阿克苏地区');
INSERT INTO `comm_address_area` VALUES ('652901000000', '652900000000', 3, 0, '阿克苏市');
INSERT INTO `comm_address_area` VALUES ('652922000000', '652900000000', 3, 0, '温宿县');
INSERT INTO `comm_address_area` VALUES ('652923000000', '652900000000', 3, 0, '库车县');
INSERT INTO `comm_address_area` VALUES ('652924000000', '652900000000', 3, 0, '沙雅县');
INSERT INTO `comm_address_area` VALUES ('652925000000', '652900000000', 3, 0, '新和县');
INSERT INTO `comm_address_area` VALUES ('652926000000', '652900000000', 3, 0, '拜城县');
INSERT INTO `comm_address_area` VALUES ('652927000000', '652900000000', 3, 0, '乌什县');
INSERT INTO `comm_address_area` VALUES ('652928000000', '652900000000', 3, 0, '阿瓦提县');
INSERT INTO `comm_address_area` VALUES ('652929000000', '652900000000', 3, 0, '柯坪县');
INSERT INTO `comm_address_area` VALUES ('653000000000', '650000000000', 2, 0, '克孜勒苏柯尔克孜自治州');
INSERT INTO `comm_address_area` VALUES ('653001000000', '653000000000', 3, 0, '阿图什市');
INSERT INTO `comm_address_area` VALUES ('653022000000', '653000000000', 3, 0, '阿克陶县');
INSERT INTO `comm_address_area` VALUES ('653023000000', '653000000000', 3, 0, '阿合奇县');
INSERT INTO `comm_address_area` VALUES ('653024000000', '653000000000', 3, 0, '乌恰县');
INSERT INTO `comm_address_area` VALUES ('653100000000', '650000000000', 2, 0, '喀什地区');
INSERT INTO `comm_address_area` VALUES ('653101000000', '653100000000', 3, 0, '喀什市');
INSERT INTO `comm_address_area` VALUES ('653121000000', '653100000000', 3, 0, '疏附县');
INSERT INTO `comm_address_area` VALUES ('653122000000', '653100000000', 3, 0, '疏勒县');
INSERT INTO `comm_address_area` VALUES ('653123000000', '653100000000', 3, 0, '英吉沙县');
INSERT INTO `comm_address_area` VALUES ('653124000000', '653100000000', 3, 0, '泽普县');
INSERT INTO `comm_address_area` VALUES ('653125000000', '653100000000', 3, 0, '莎车县');
INSERT INTO `comm_address_area` VALUES ('653126000000', '653100000000', 3, 0, '叶城县');
INSERT INTO `comm_address_area` VALUES ('653127000000', '653100000000', 3, 0, '麦盖提县');
INSERT INTO `comm_address_area` VALUES ('653128000000', '653100000000', 3, 0, '岳普湖县');
INSERT INTO `comm_address_area` VALUES ('653129000000', '653100000000', 3, 0, '伽师县');
INSERT INTO `comm_address_area` VALUES ('653130000000', '653100000000', 3, 0, '巴楚县');
INSERT INTO `comm_address_area` VALUES ('653131000000', '653100000000', 3, 0, '塔什库尔干塔吉克自治县');
INSERT INTO `comm_address_area` VALUES ('653200000000', '650000000000', 2, 0, '和田地区');
INSERT INTO `comm_address_area` VALUES ('653201000000', '653200000000', 3, 0, '和田市');
INSERT INTO `comm_address_area` VALUES ('653221000000', '653200000000', 3, 0, '和田县');
INSERT INTO `comm_address_area` VALUES ('653222000000', '653200000000', 3, 0, '墨玉县');
INSERT INTO `comm_address_area` VALUES ('653223000000', '653200000000', 3, 0, '皮山县');
INSERT INTO `comm_address_area` VALUES ('653224000000', '653200000000', 3, 0, '洛浦县');
INSERT INTO `comm_address_area` VALUES ('653225000000', '653200000000', 3, 0, '策勒县');
INSERT INTO `comm_address_area` VALUES ('653226000000', '653200000000', 3, 0, '于田县');
INSERT INTO `comm_address_area` VALUES ('653227000000', '653200000000', 3, 0, '民丰县');
INSERT INTO `comm_address_area` VALUES ('654000000000', '650000000000', 2, 0, '伊犁哈萨克自治州');
INSERT INTO `comm_address_area` VALUES ('654002000000', '654000000000', 3, 0, '伊宁市');
INSERT INTO `comm_address_area` VALUES ('654003000000', '654000000000', 3, 0, '奎屯市');
INSERT INTO `comm_address_area` VALUES ('654021000000', '654000000000', 3, 0, '伊宁县');
INSERT INTO `comm_address_area` VALUES ('654022000000', '654000000000', 3, 0, '察布查尔锡伯自治县');
INSERT INTO `comm_address_area` VALUES ('654023000000', '654000000000', 3, 0, '霍城县');
INSERT INTO `comm_address_area` VALUES ('654024000000', '654000000000', 3, 0, '巩留县');
INSERT INTO `comm_address_area` VALUES ('654025000000', '654000000000', 3, 0, '新源县');
INSERT INTO `comm_address_area` VALUES ('654026000000', '654000000000', 3, 0, '昭苏县');
INSERT INTO `comm_address_area` VALUES ('654027000000', '654000000000', 3, 0, '特克斯县');
INSERT INTO `comm_address_area` VALUES ('654028000000', '654000000000', 3, 0, '尼勒克县');
INSERT INTO `comm_address_area` VALUES ('654200000000', '650000000000', 2, 0, '塔城地区');
INSERT INTO `comm_address_area` VALUES ('654201000000', '654200000000', 3, 0, '塔城市');
INSERT INTO `comm_address_area` VALUES ('654202000000', '654200000000', 3, 0, '乌苏市');
INSERT INTO `comm_address_area` VALUES ('654221000000', '654200000000', 3, 0, '额敏县');
INSERT INTO `comm_address_area` VALUES ('654223000000', '654200000000', 3, 0, '沙湾县');
INSERT INTO `comm_address_area` VALUES ('654224000000', '654200000000', 3, 0, '托里县');
INSERT INTO `comm_address_area` VALUES ('654225000000', '654200000000', 3, 0, '裕民县');
INSERT INTO `comm_address_area` VALUES ('654226000000', '654200000000', 3, 0, '和布克赛尔蒙古自治县');
INSERT INTO `comm_address_area` VALUES ('654300000000', '650000000000', 2, 0, '阿勒泰地区');
INSERT INTO `comm_address_area` VALUES ('654301000000', '654300000000', 3, 0, '阿勒泰市');
INSERT INTO `comm_address_area` VALUES ('654321000000', '654300000000', 3, 0, '布尔津县');
INSERT INTO `comm_address_area` VALUES ('654322000000', '654300000000', 3, 0, '富蕴县');
INSERT INTO `comm_address_area` VALUES ('654323000000', '654300000000', 3, 0, '福海县');
INSERT INTO `comm_address_area` VALUES ('654324000000', '654300000000', 3, 0, '哈巴河县');
INSERT INTO `comm_address_area` VALUES ('654325000000', '654300000000', 3, 0, '青河县');
INSERT INTO `comm_address_area` VALUES ('654326000000', '654300000000', 3, 0, '吉木乃县');
INSERT INTO `comm_address_area` VALUES ('659000000000', '650000000000', 2, 0, '自治区直辖县级行政区划');
INSERT INTO `comm_address_area` VALUES ('659001000000', '659000000000', 3, 0, '石河子市');
INSERT INTO `comm_address_area` VALUES ('659002000000', '659000000000', 3, 0, '阿拉尔市');
INSERT INTO `comm_address_area` VALUES ('659003000000', '659000000000', 3, 0, '图木舒克市');
INSERT INTO `comm_address_area` VALUES ('659004000000', '659000000000', 3, 0, '五家渠市');
INSERT INTO `comm_address_area` VALUES ('530000000000', '0', 1, 0, '云南省');
INSERT INTO `comm_address_area` VALUES ('530100000000', '530000000000', 2, 0, '昆明市');
INSERT INTO `comm_address_area` VALUES ('530102000000', '530100000000', 3, 0, '五华区');
INSERT INTO `comm_address_area` VALUES ('530103000000', '530100000000', 3, 0, '盘龙区');
INSERT INTO `comm_address_area` VALUES ('530111000000', '530100000000', 3, 0, '官渡区');
INSERT INTO `comm_address_area` VALUES ('530112000000', '530100000000', 3, 0, '西山区');
INSERT INTO `comm_address_area` VALUES ('530113000000', '530100000000', 3, 0, '东川区');
INSERT INTO `comm_address_area` VALUES ('530114000000', '530100000000', 3, 0, '呈贡区');
INSERT INTO `comm_address_area` VALUES ('530122000000', '530100000000', 3, 0, '晋宁县');
INSERT INTO `comm_address_area` VALUES ('530124000000', '530100000000', 3, 0, '富民县');
INSERT INTO `comm_address_area` VALUES ('530125000000', '530100000000', 3, 0, '宜良县');
INSERT INTO `comm_address_area` VALUES ('530126000000', '530100000000', 3, 0, '石林彝族自治县');
INSERT INTO `comm_address_area` VALUES ('530127000000', '530100000000', 3, 0, '嵩明县');
INSERT INTO `comm_address_area` VALUES ('530128000000', '530100000000', 3, 0, '禄劝彝族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('530325000000', '530300000000', 3, 0, '富源县');
INSERT INTO `comm_address_area` VALUES ('530326000000', '530300000000', 3, 0, '会泽县');
INSERT INTO `comm_address_area` VALUES ('530129000000', '530100000000', 3, 0, '寻甸回族彝族自治县');
INSERT INTO `comm_address_area` VALUES ('530181000000', '530100000000', 3, 0, '安宁市');
INSERT INTO `comm_address_area` VALUES ('530300000000', '530000000000', 2, 0, '曲靖市');
INSERT INTO `comm_address_area` VALUES ('530302000000', '530300000000', 3, 0, '麒麟区');
INSERT INTO `comm_address_area` VALUES ('530321000000', '530300000000', 3, 0, '马龙县');
INSERT INTO `comm_address_area` VALUES ('530322000000', '530300000000', 3, 0, '陆良县');
INSERT INTO `comm_address_area` VALUES ('530323000000', '530300000000', 3, 0, '师宗县');
INSERT INTO `comm_address_area` VALUES ('530324000000', '530300000000', 3, 0, '罗平县');
INSERT INTO `comm_address_area` VALUES ('530328000000', '530300000000', 3, 0, '沾益县');
INSERT INTO `comm_address_area` VALUES ('530381000000', '530300000000', 3, 0, '宣威市');
INSERT INTO `comm_address_area` VALUES ('530400000000', '530000000000', 2, 0, '玉溪市');
INSERT INTO `comm_address_area` VALUES ('530402000000', '530400000000', 3, 0, '红塔区');
INSERT INTO `comm_address_area` VALUES ('530421000000', '530400000000', 3, 0, '江川县');
INSERT INTO `comm_address_area` VALUES ('530422000000', '530400000000', 3, 0, '澄江县');
INSERT INTO `comm_address_area` VALUES ('530423000000', '530400000000', 3, 0, '通海县');
INSERT INTO `comm_address_area` VALUES ('530424000000', '530400000000', 3, 0, '华宁县');
INSERT INTO `comm_address_area` VALUES ('530425000000', '530400000000', 3, 0, '易门县');
INSERT INTO `comm_address_area` VALUES ('530426000000', '530400000000', 3, 0, '峨山彝族自治县');
INSERT INTO `comm_address_area` VALUES ('530427000000', '530400000000', 3, 0, '新平彝族傣族自治县');
INSERT INTO `comm_address_area` VALUES ('530428000000', '530400000000', 3, 0, '元江哈尼族彝族傣族自治县');
INSERT INTO `comm_address_area` VALUES ('530500000000', '530000000000', 2, 0, '保山市');
INSERT INTO `comm_address_area` VALUES ('530502000000', '530500000000', 3, 0, '隆阳区');
INSERT INTO `comm_address_area` VALUES ('530521000000', '530500000000', 3, 0, '施甸县');
INSERT INTO `comm_address_area` VALUES ('530522000000', '530500000000', 3, 0, '腾冲县');
INSERT INTO `comm_address_area` VALUES ('530523000000', '530500000000', 3, 0, '龙陵县');
INSERT INTO `comm_address_area` VALUES ('530524000000', '530500000000', 3, 0, '昌宁县');
INSERT INTO `comm_address_area` VALUES ('530600000000', '530000000000', 2, 0, '昭通市');
INSERT INTO `comm_address_area` VALUES ('530602000000', '530600000000', 3, 0, '昭阳区');
INSERT INTO `comm_address_area` VALUES ('530621000000', '530600000000', 3, 0, '鲁甸县');
INSERT INTO `comm_address_area` VALUES ('530622000000', '530600000000', 3, 0, '巧家县');
INSERT INTO `comm_address_area` VALUES ('530623000000', '530600000000', 3, 0, '盐津县');
INSERT INTO `comm_address_area` VALUES ('530624000000', '530600000000', 3, 0, '大关县');
INSERT INTO `comm_address_area` VALUES ('530625000000', '530600000000', 3, 0, '永善县');
INSERT INTO `comm_address_area` VALUES ('530626000000', '530600000000', 3, 0, '绥江县');
INSERT INTO `comm_address_area` VALUES ('530627000000', '530600000000', 3, 0, '镇雄县');
INSERT INTO `comm_address_area` VALUES ('530628000000', '530600000000', 3, 0, '彝良县');
INSERT INTO `comm_address_area` VALUES ('530629000000', '530600000000', 3, 0, '威信县');
INSERT INTO `comm_address_area` VALUES ('530630000000', '530600000000', 3, 0, '水富县');
INSERT INTO `comm_address_area` VALUES ('530700000000', '530000000000', 2, 0, '丽江市');
INSERT INTO `comm_address_area` VALUES ('530702000000', '530700000000', 3, 0, '古城区');
INSERT INTO `comm_address_area` VALUES ('530721000000', '530700000000', 3, 0, '玉龙纳西族自治县');
INSERT INTO `comm_address_area` VALUES ('530722000000', '530700000000', 3, 0, '永胜县');
INSERT INTO `comm_address_area` VALUES ('530723000000', '530700000000', 3, 0, '华坪县');
INSERT INTO `comm_address_area` VALUES ('530724000000', '530700000000', 3, 0, '宁蒗彝族自治县');
INSERT INTO `comm_address_area` VALUES ('530800000000', '530000000000', 2, 0, '普洱市');
INSERT INTO `comm_address_area` VALUES ('530802000000', '530800000000', 3, 0, '思茅区');
INSERT INTO `comm_address_area` VALUES ('530821000000', '530800000000', 3, 0, '宁洱哈尼族彝族自治县');
INSERT INTO `comm_address_area` VALUES ('530822000000', '530800000000', 3, 0, '墨江哈尼族自治县');
INSERT INTO `comm_address_area` VALUES ('530823000000', '530800000000', 3, 0, '景东彝族自治县');
INSERT INTO `comm_address_area` VALUES ('530824000000', '530800000000', 3, 0, '景谷傣族彝族自治县');
INSERT INTO `comm_address_area` VALUES ('530825000000', '530800000000', 3, 0, '镇沅彝族哈尼族拉祜族自治县');
INSERT INTO `comm_address_area` VALUES ('530826000000', '530800000000', 3, 0, '江城哈尼族彝族自治县');
INSERT INTO `comm_address_area` VALUES ('530827000000', '530800000000', 3, 0, '孟连傣族拉祜族佤族自治县');
INSERT INTO `comm_address_area` VALUES ('530828000000', '530800000000', 3, 0, '澜沧拉祜族自治县');
INSERT INTO `comm_address_area` VALUES ('530829000000', '530800000000', 3, 0, '西盟佤族自治县');
INSERT INTO `comm_address_area` VALUES ('530900000000', '530000000000', 2, 0, '临沧市');
INSERT INTO `comm_address_area` VALUES ('530902000000', '530900000000', 3, 0, '临翔区');
INSERT INTO `comm_address_area` VALUES ('530921000000', '530900000000', 3, 0, '凤庆县');
INSERT INTO `comm_address_area` VALUES ('530922000000', '530900000000', 3, 0, '云县');
INSERT INTO `comm_address_area` VALUES ('530923000000', '530900000000', 3, 0, '永德县');
INSERT INTO `comm_address_area` VALUES ('530924000000', '530900000000', 3, 0, '镇康县');
INSERT INTO `comm_address_area` VALUES ('530925000000', '530900000000', 3, 0, '双江拉祜族佤族布朗族傣族自治县');
INSERT INTO `comm_address_area` VALUES ('530926000000', '530900000000', 3, 0, '耿马傣族佤族自治县');
INSERT INTO `comm_address_area` VALUES ('530927000000', '530900000000', 3, 0, '沧源佤族自治县');
INSERT INTO `comm_address_area` VALUES ('532300000000', '530000000000', 2, 0, '楚雄彝族自治州');
INSERT INTO `comm_address_area` VALUES ('532301000000', '532300000000', 3, 0, '楚雄市');
INSERT INTO `comm_address_area` VALUES ('532322000000', '532300000000', 3, 0, '双柏县');
INSERT INTO `comm_address_area` VALUES ('532323000000', '532300000000', 3, 0, '牟定县');
INSERT INTO `comm_address_area` VALUES ('532324000000', '532300000000', 3, 0, '南华县');
INSERT INTO `comm_address_area` VALUES ('532325000000', '532300000000', 3, 0, '姚安县');
INSERT INTO `comm_address_area` VALUES ('532326000000', '532300000000', 3, 0, '大姚县');
INSERT INTO `comm_address_area` VALUES ('532327000000', '532300000000', 3, 0, '永仁县');
INSERT INTO `comm_address_area` VALUES ('532328000000', '532300000000', 3, 0, '元谋县');
INSERT INTO `comm_address_area` VALUES ('532329000000', '532300000000', 3, 0, '武定县');
INSERT INTO `comm_address_area` VALUES ('532331000000', '532300000000', 3, 0, '禄丰县');
INSERT INTO `comm_address_area` VALUES ('532500000000', '530000000000', 2, 0, '红河哈尼族彝族自治州');
INSERT INTO `comm_address_area` VALUES ('532501000000', '532500000000', 3, 0, '个旧市');
INSERT INTO `comm_address_area` VALUES ('532502000000', '532500000000', 3, 0, '开远市');
INSERT INTO `comm_address_area` VALUES ('532503000000', '532500000000', 3, 0, '蒙自市');
INSERT INTO `comm_address_area` VALUES ('532523000000', '532500000000', 3, 0, '屏边苗族自治县');
INSERT INTO `comm_address_area` VALUES ('532524000000', '532500000000', 3, 0, '建水县');
INSERT INTO `comm_address_area` VALUES ('532525000000', '532500000000', 3, 0, '石屏县');
INSERT INTO `comm_address_area` VALUES ('532526000000', '532500000000', 3, 0, '弥勒县');
INSERT INTO `comm_address_area` VALUES ('532527000000', '532500000000', 3, 0, '泸西县');
INSERT INTO `comm_address_area` VALUES ('532528000000', '532500000000', 3, 0, '元阳县');
INSERT INTO `comm_address_area` VALUES ('532529000000', '532500000000', 3, 0, '红河县');
INSERT INTO `comm_address_area` VALUES ('532530000000', '532500000000', 3, 0, '金平苗族瑶族傣族自治县');
INSERT INTO `comm_address_area` VALUES ('532531000000', '532500000000', 3, 0, '绿春县');
INSERT INTO `comm_address_area` VALUES ('532532000000', '532500000000', 3, 0, '河口瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('532600000000', '530000000000', 2, 0, '文山壮族苗族自治州');
INSERT INTO `comm_address_area` VALUES ('532601000000', '532600000000', 3, 0, '文山市');
INSERT INTO `comm_address_area` VALUES ('532622000000', '532600000000', 3, 0, '砚山县');
INSERT INTO `comm_address_area` VALUES ('532623000000', '532600000000', 3, 0, '西畴县');
INSERT INTO `comm_address_area` VALUES ('532624000000', '532600000000', 3, 0, '麻栗坡县');
INSERT INTO `comm_address_area` VALUES ('532625000000', '532600000000', 3, 0, '马关县');
INSERT INTO `comm_address_area` VALUES ('532626000000', '532600000000', 3, 0, '丘北县');
INSERT INTO `comm_address_area` VALUES ('532627000000', '532600000000', 3, 0, '广南县');
INSERT INTO `comm_address_area` VALUES ('532628000000', '532600000000', 3, 0, '富宁县');
INSERT INTO `comm_address_area` VALUES ('532800000000', '530000000000', 2, 0, '西双版纳傣族自治州');
INSERT INTO `comm_address_area` VALUES ('532801000000', '532800000000', 3, 0, '景洪市');
INSERT INTO `comm_address_area` VALUES ('532822000000', '532800000000', 3, 0, '勐海县');
INSERT INTO `comm_address_area` VALUES ('532823000000', '532800000000', 3, 0, '勐腊县');
INSERT INTO `comm_address_area` VALUES ('532900000000', '530000000000', 2, 0, '大理白族自治州');
INSERT INTO `comm_address_area` VALUES ('532901000000', '532900000000', 3, 0, '大理市');
INSERT INTO `comm_address_area` VALUES ('532922000000', '532900000000', 3, 0, '漾濞彝族自治县');
INSERT INTO `comm_address_area` VALUES ('532923000000', '532900000000', 3, 0, '祥云县');
INSERT INTO `comm_address_area` VALUES ('532924000000', '532900000000', 3, 0, '宾川县');
INSERT INTO `comm_address_area` VALUES ('532925000000', '532900000000', 3, 0, '弥渡县');
INSERT INTO `comm_address_area` VALUES ('532926000000', '532900000000', 3, 0, '南涧彝族自治县');
INSERT INTO `comm_address_area` VALUES ('532927000000', '532900000000', 3, 0, '巍山彝族回族自治县');
INSERT INTO `comm_address_area` VALUES ('532928000000', '532900000000', 3, 0, '永平县');
INSERT INTO `comm_address_area` VALUES ('532929000000', '532900000000', 3, 0, '云龙县');
INSERT INTO `comm_address_area` VALUES ('532930000000', '532900000000', 3, 0, '洱源县');
INSERT INTO `comm_address_area` VALUES ('532931000000', '532900000000', 3, 0, '剑川县');
INSERT INTO `comm_address_area` VALUES ('532932000000', '532900000000', 3, 0, '鹤庆县');
INSERT INTO `comm_address_area` VALUES ('533100000000', '530000000000', 2, 0, '德宏傣族景颇族自治州');
INSERT INTO `comm_address_area` VALUES ('533102000000', '533100000000', 3, 0, '瑞丽市');
INSERT INTO `comm_address_area` VALUES ('533103000000', '533100000000', 3, 0, '芒市');
INSERT INTO `comm_address_area` VALUES ('533122000000', '533100000000', 3, 0, '梁河县');
INSERT INTO `comm_address_area` VALUES ('533123000000', '533100000000', 3, 0, '盈江县');
INSERT INTO `comm_address_area` VALUES ('533124000000', '533100000000', 3, 0, '陇川县');
INSERT INTO `comm_address_area` VALUES ('533300000000', '530000000000', 2, 0, '怒江傈僳族自治州');
INSERT INTO `comm_address_area` VALUES ('533321000000', '533300000000', 3, 0, '泸水县');
INSERT INTO `comm_address_area` VALUES ('533323000000', '533300000000', 3, 0, '福贡县');
INSERT INTO `comm_address_area` VALUES ('533324000000', '533300000000', 3, 0, '贡山独龙族怒族自治县');
INSERT INTO `comm_address_area` VALUES ('533325000000', '533300000000', 3, 0, '兰坪白族普米族自治县');
INSERT INTO `comm_address_area` VALUES ('533400000000', '530000000000', 2, 0, '迪庆藏族自治州');
INSERT INTO `comm_address_area` VALUES ('533421000000', '533400000000', 3, 0, '香格里拉县');
INSERT INTO `comm_address_area` VALUES ('533422000000', '533400000000', 3, 0, '德钦县');
INSERT INTO `comm_address_area` VALUES ('533423000000', '533400000000', 3, 0, '维西傈僳族自治县');
INSERT INTO `comm_address_area` VALUES ('500000000000', '0', 1, 0, '重庆市');
INSERT INTO `comm_address_area` VALUES ('500101000000', '500000000000', 2, 0, '万州区');
INSERT INTO `comm_address_area` VALUES ('500102000000', '500000000000', 2, 0, '涪陵区');
INSERT INTO `comm_address_area` VALUES ('500103000000', '500000000000', 2, 0, '渝中区');
INSERT INTO `comm_address_area` VALUES ('500104000000', '500000000000', 2, 0, '大渡口区');
INSERT INTO `comm_address_area` VALUES ('500105000000', '500000000000', 2, 0, '江北区');
INSERT INTO `comm_address_area` VALUES ('500106000000', '500000000000', 2, 0, '沙坪坝区');
INSERT INTO `comm_address_area` VALUES ('500107000000', '500000000000', 2, 0, '九龙坡区');
INSERT INTO `comm_address_area` VALUES ('500108000000', '500000000000', 2, 0, '南岸区');
INSERT INTO `comm_address_area` VALUES ('500109000000', '500000000000', 2, 0, '北碚区');
INSERT INTO `comm_address_area` VALUES ('500110000000', '500000000000', 2, 0, '綦江区');
INSERT INTO `comm_address_area` VALUES ('500111000000', '500000000000', 2, 0, '大足区');
INSERT INTO `comm_address_area` VALUES ('500112000000', '500000000000', 2, 0, '渝北区');
INSERT INTO `comm_address_area` VALUES ('500113000000', '500000000000', 2, 0, '巴南区');
INSERT INTO `comm_address_area` VALUES ('500114000000', '500000000000', 2, 0, '黔江区');
INSERT INTO `comm_address_area` VALUES ('500115000000', '500000000000', 2, 0, '长寿区');
INSERT INTO `comm_address_area` VALUES ('500116000000', '500000000000', 2, 0, '江津区');
INSERT INTO `comm_address_area` VALUES ('500117000000', '500000000000', 2, 0, '合川区');
INSERT INTO `comm_address_area` VALUES ('500118000000', '500000000000', 2, 0, '永川区');
INSERT INTO `comm_address_area` VALUES ('500119000000', '500000000000', 2, 0, '南川区');
INSERT INTO `comm_address_area` VALUES ('500223000000', '500000000000', 2, 0, '潼南县');
INSERT INTO `comm_address_area` VALUES ('500224000000', '500000000000', 2, 0, '铜梁县');
INSERT INTO `comm_address_area` VALUES ('500226000000', '500000000000', 2, 0, '荣昌县');
INSERT INTO `comm_address_area` VALUES ('500227000000', '500000000000', 2, 0, '璧山县');
INSERT INTO `comm_address_area` VALUES ('500228000000', '500000000000', 2, 0, '梁平县');
INSERT INTO `comm_address_area` VALUES ('500229000000', '500000000000', 2, 0, '城口县');
INSERT INTO `comm_address_area` VALUES ('500230000000', '500000000000', 2, 0, '丰都县');
INSERT INTO `comm_address_area` VALUES ('500231000000', '500000000000', 2, 0, '垫江县');
INSERT INTO `comm_address_area` VALUES ('500232000000', '500000000000', 2, 0, '武隆县');
INSERT INTO `comm_address_area` VALUES ('500233000000', '500000000000', 2, 0, '忠县');
INSERT INTO `comm_address_area` VALUES ('500234000000', '500000000000', 2, 0, '开县');
INSERT INTO `comm_address_area` VALUES ('500235000000', '500000000000', 2, 0, '云阳县');
INSERT INTO `comm_address_area` VALUES ('500236000000', '500000000000', 2, 0, '奉节县');
INSERT INTO `comm_address_area` VALUES ('500237000000', '500000000000', 2, 0, '巫山县');
INSERT INTO `comm_address_area` VALUES ('500238000000', '500000000000', 2, 0, '巫溪县');
INSERT INTO `comm_address_area` VALUES ('500240000000', '500000000000', 2, 0, '石柱土家族自治县');
INSERT INTO `comm_address_area` VALUES ('500241000000', '500000000000', 2, 0, '秀山土家族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('500242000000', '500000000000', 2, 0, '酉阳土家族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('500243000000', '500000000000', 2, 0, '彭水苗族土家族自治县');
INSERT INTO `comm_address_area` VALUES ('710000000000', '0', 1, 0, '台湾省');
INSERT INTO `comm_address_area` VALUES ('810000000000', '0', 1, 0, '香港');
INSERT INTO `comm_address_area` VALUES ('820000000000', '0', 1, 0, '澳门');
INSERT INTO `comm_address_area` VALUES ('330000000000', '0', 1, 0, '浙江省');
INSERT INTO `comm_address_area` VALUES ('330100000000', '330000000000', 2, 0, '杭州市');
INSERT INTO `comm_address_area` VALUES ('330102000000', '330100000000', 3, 0, '上城区');
INSERT INTO `comm_address_area` VALUES ('330103000000', '330100000000', 3, 0, '下城区');
INSERT INTO `comm_address_area` VALUES ('330104000000', '330100000000', 3, 0, '江干区');
INSERT INTO `comm_address_area` VALUES ('330105000000', '330100000000', 3, 0, '拱墅区');
INSERT INTO `comm_address_area` VALUES ('330106000000', '330100000000', 3, 0, '西湖区');
INSERT INTO `comm_address_area` VALUES ('330108000000', '330100000000', 3, 0, '滨江区');
INSERT INTO `comm_address_area` VALUES ('330109000000', '330100000000', 3, 0, '萧山区');
INSERT INTO `comm_address_area` VALUES ('330110000000', '330100000000', 3, 0, '余杭区');
INSERT INTO `comm_address_area` VALUES ('330122000000', '330100000000', 3, 0, '桐庐县');
INSERT INTO `comm_address_area` VALUES ('330127000000', '330100000000', 3, 0, '淳安县');
INSERT INTO `comm_address_area` VALUES ('330182000000', '330100000000', 3, 0, '建德市');
INSERT INTO `comm_address_area` VALUES ('330183000000', '330100000000', 3, 0, '富阳市');
INSERT INTO `comm_address_area` VALUES ('330185000000', '330100000000', 3, 0, '临安市');
INSERT INTO `comm_address_area` VALUES ('330200000000', '330000000000', 2, 0, '宁波市');
INSERT INTO `comm_address_area` VALUES ('330203000000', '330200000000', 3, 0, '海曙区');
INSERT INTO `comm_address_area` VALUES ('330204000000', '330200000000', 3, 0, '江东区');
INSERT INTO `comm_address_area` VALUES ('330205000000', '330200000000', 3, 0, '江北区');
INSERT INTO `comm_address_area` VALUES ('330206000000', '330200000000', 3, 0, '北仑区');
INSERT INTO `comm_address_area` VALUES ('330211000000', '330200000000', 3, 0, '镇海区');
INSERT INTO `comm_address_area` VALUES ('330212000000', '330200000000', 3, 0, '鄞州区');
INSERT INTO `comm_address_area` VALUES ('330225000000', '330200000000', 3, 0, '象山县');
INSERT INTO `comm_address_area` VALUES ('330226000000', '330200000000', 3, 0, '宁海县');
INSERT INTO `comm_address_area` VALUES ('330281000000', '330200000000', 3, 0, '余姚市');
INSERT INTO `comm_address_area` VALUES ('330282000000', '330200000000', 3, 0, '慈溪市');
INSERT INTO `comm_address_area` VALUES ('330283000000', '330200000000', 3, 0, '奉化市');
INSERT INTO `comm_address_area` VALUES ('330300000000', '330000000000', 2, 0, '温州市');
INSERT INTO `comm_address_area` VALUES ('330302000000', '330300000000', 3, 0, '鹿城区');
INSERT INTO `comm_address_area` VALUES ('330303000000', '330300000000', 3, 0, '龙湾区');
INSERT INTO `comm_address_area` VALUES ('330304000000', '330300000000', 3, 0, '瓯海区');
INSERT INTO `comm_address_area` VALUES ('330322000000', '330300000000', 3, 0, '洞头县');
INSERT INTO `comm_address_area` VALUES ('330324000000', '330300000000', 3, 0, '永嘉县');
INSERT INTO `comm_address_area` VALUES ('330326000000', '330300000000', 3, 0, '平阳县');
INSERT INTO `comm_address_area` VALUES ('330327000000', '330300000000', 3, 0, '苍南县');
INSERT INTO `comm_address_area` VALUES ('330328000000', '330300000000', 3, 0, '文成县');
INSERT INTO `comm_address_area` VALUES ('330329000000', '330300000000', 3, 0, '泰顺县');
INSERT INTO `comm_address_area` VALUES ('330381000000', '330300000000', 3, 0, '瑞安市');
INSERT INTO `comm_address_area` VALUES ('330382000000', '330300000000', 3, 0, '乐清市');
INSERT INTO `comm_address_area` VALUES ('330400000000', '330000000000', 2, 0, '嘉兴市');
INSERT INTO `comm_address_area` VALUES ('330402000000', '330400000000', 3, 0, '南湖区');
INSERT INTO `comm_address_area` VALUES ('330411000000', '330400000000', 3, 0, '秀洲区');
INSERT INTO `comm_address_area` VALUES ('330421000000', '330400000000', 3, 0, '嘉善县');
INSERT INTO `comm_address_area` VALUES ('330424000000', '330400000000', 3, 0, '海盐县');
INSERT INTO `comm_address_area` VALUES ('330481000000', '330400000000', 3, 0, '海宁市');
INSERT INTO `comm_address_area` VALUES ('330482000000', '330400000000', 3, 0, '平湖市');
INSERT INTO `comm_address_area` VALUES ('330483000000', '330400000000', 3, 0, '桐乡市');
INSERT INTO `comm_address_area` VALUES ('330500000000', '330000000000', 2, 0, '湖州市');
INSERT INTO `comm_address_area` VALUES ('330502000000', '330500000000', 3, 0, '吴兴区');
INSERT INTO `comm_address_area` VALUES ('330503000000', '330500000000', 3, 0, '南浔区');
INSERT INTO `comm_address_area` VALUES ('330521000000', '330500000000', 3, 0, '德清县');
INSERT INTO `comm_address_area` VALUES ('330522000000', '330500000000', 3, 0, '长兴县');
INSERT INTO `comm_address_area` VALUES ('330523000000', '330500000000', 3, 0, '安吉县');
INSERT INTO `comm_address_area` VALUES ('330600000000', '330000000000', 2, 0, '绍兴市');
INSERT INTO `comm_address_area` VALUES ('330602000000', '330600000000', 3, 0, '越城区');
INSERT INTO `comm_address_area` VALUES ('330621000000', '330600000000', 3, 0, '绍兴县');
INSERT INTO `comm_address_area` VALUES ('330624000000', '330600000000', 3, 0, '新昌县');
INSERT INTO `comm_address_area` VALUES ('330681000000', '330600000000', 3, 0, '诸暨市');
INSERT INTO `comm_address_area` VALUES ('330682000000', '330600000000', 3, 0, '上虞市');
INSERT INTO `comm_address_area` VALUES ('330683000000', '330600000000', 3, 0, '嵊州市');
INSERT INTO `comm_address_area` VALUES ('330700000000', '330000000000', 2, 0, '金华市');
INSERT INTO `comm_address_area` VALUES ('330702000000', '330700000000', 3, 0, '婺城区');
INSERT INTO `comm_address_area` VALUES ('330703000000', '330700000000', 3, 0, '金东区');
INSERT INTO `comm_address_area` VALUES ('330723000000', '330700000000', 3, 0, '武义县');
INSERT INTO `comm_address_area` VALUES ('330726000000', '330700000000', 3, 0, '浦江县');
INSERT INTO `comm_address_area` VALUES ('330727000000', '330700000000', 3, 0, '磐安县');
INSERT INTO `comm_address_area` VALUES ('330781000000', '330700000000', 3, 0, '兰溪市');
INSERT INTO `comm_address_area` VALUES ('330782000000', '330700000000', 3, 0, '义乌市');
INSERT INTO `comm_address_area` VALUES ('330783000000', '330700000000', 3, 0, '东阳市');
INSERT INTO `comm_address_area` VALUES ('330784000000', '330700000000', 3, 0, '永康市');
INSERT INTO `comm_address_area` VALUES ('330800000000', '330000000000', 2, 0, '衢州市');
INSERT INTO `comm_address_area` VALUES ('330802000000', '330800000000', 3, 0, '柯城区');
INSERT INTO `comm_address_area` VALUES ('330803000000', '330800000000', 3, 0, '衢江区');
INSERT INTO `comm_address_area` VALUES ('330822000000', '330800000000', 3, 0, '常山县');
INSERT INTO `comm_address_area` VALUES ('330824000000', '330800000000', 3, 0, '开化县');
INSERT INTO `comm_address_area` VALUES ('330825000000', '330800000000', 3, 0, '龙游县');
INSERT INTO `comm_address_area` VALUES ('330881000000', '330800000000', 3, 0, '江山市');
INSERT INTO `comm_address_area` VALUES ('330900000000', '330000000000', 2, 0, '舟山市');
INSERT INTO `comm_address_area` VALUES ('330902000000', '330900000000', 3, 0, '定海区');
INSERT INTO `comm_address_area` VALUES ('330903000000', '330900000000', 3, 0, '普陀区');
INSERT INTO `comm_address_area` VALUES ('330921000000', '330900000000', 3, 0, '岱山县');
INSERT INTO `comm_address_area` VALUES ('330922000000', '330900000000', 3, 0, '嵊泗县');
INSERT INTO `comm_address_area` VALUES ('331000000000', '330000000000', 2, 0, '台州市');
INSERT INTO `comm_address_area` VALUES ('331002000000', '331000000000', 3, 0, '椒江区');
INSERT INTO `comm_address_area` VALUES ('331003000000', '331000000000', 3, 0, '黄岩区');
INSERT INTO `comm_address_area` VALUES ('331004000000', '331000000000', 3, 0, '路桥区');
INSERT INTO `comm_address_area` VALUES ('331021000000', '331000000000', 3, 0, '玉环县');
INSERT INTO `comm_address_area` VALUES ('331022000000', '331000000000', 3, 0, '三门县');
INSERT INTO `comm_address_area` VALUES ('331023000000', '331000000000', 3, 0, '天台县');
INSERT INTO `comm_address_area` VALUES ('331024000000', '331000000000', 3, 0, '仙居县');
INSERT INTO `comm_address_area` VALUES ('331081000000', '331000000000', 3, 0, '温岭市');
INSERT INTO `comm_address_area` VALUES ('331082000000', '331000000000', 3, 0, '临海市');
INSERT INTO `comm_address_area` VALUES ('331100000000', '330000000000', 2, 0, '丽水市');
INSERT INTO `comm_address_area` VALUES ('331102000000', '331100000000', 3, 0, '莲都区');
INSERT INTO `comm_address_area` VALUES ('331121000000', '331100000000', 3, 0, '青田县');
INSERT INTO `comm_address_area` VALUES ('331122000000', '331100000000', 3, 0, '缙云县');
INSERT INTO `comm_address_area` VALUES ('331123000000', '331100000000', 3, 0, '遂昌县');
INSERT INTO `comm_address_area` VALUES ('331124000000', '331100000000', 3, 0, '松阳县');
INSERT INTO `comm_address_area` VALUES ('331125000000', '331100000000', 3, 0, '云和县');
INSERT INTO `comm_address_area` VALUES ('331126000000', '331100000000', 3, 0, '庆元县');
INSERT INTO `comm_address_area` VALUES ('331127000000', '331100000000', 3, 0, '景宁畲族自治县');
INSERT INTO `comm_address_area` VALUES ('331181000000', '331100000000', 3, 0, '龙泉市');
INSERT INTO `comm_address_area` VALUES ('430000000000', '0', 1, 0, '湖南省');
INSERT INTO `comm_address_area` VALUES ('430100000000', '430000000000', 2, 0, '长沙市');
INSERT INTO `comm_address_area` VALUES ('430102000000', '430100000000', 3, 0, '芙蓉区');
INSERT INTO `comm_address_area` VALUES ('430103000000', '430100000000', 3, 0, '天心区');
INSERT INTO `comm_address_area` VALUES ('430104000000', '430100000000', 3, 0, '岳麓区');
INSERT INTO `comm_address_area` VALUES ('430105000000', '430100000000', 3, 0, '开福区');
INSERT INTO `comm_address_area` VALUES ('430111000000', '430100000000', 3, 0, '雨花区');
INSERT INTO `comm_address_area` VALUES ('430112000000', '430100000000', 3, 0, '望城区');
INSERT INTO `comm_address_area` VALUES ('430121000000', '430100000000', 3, 0, '长沙县');
INSERT INTO `comm_address_area` VALUES ('430124000000', '430100000000', 3, 0, '宁乡县');
INSERT INTO `comm_address_area` VALUES ('430181000000', '430100000000', 3, 0, '浏阳市');
INSERT INTO `comm_address_area` VALUES ('430200000000', '430000000000', 2, 0, '株洲市');
INSERT INTO `comm_address_area` VALUES ('430202000000', '430200000000', 3, 0, '荷塘区');
INSERT INTO `comm_address_area` VALUES ('430203000000', '430200000000', 3, 0, '芦淞区');
INSERT INTO `comm_address_area` VALUES ('430204000000', '430200000000', 3, 0, '石峰区');
INSERT INTO `comm_address_area` VALUES ('430211000000', '430200000000', 3, 0, '天元区');
INSERT INTO `comm_address_area` VALUES ('430221000000', '430200000000', 3, 0, '株洲县');
INSERT INTO `comm_address_area` VALUES ('430223000000', '430200000000', 3, 0, '攸县');
INSERT INTO `comm_address_area` VALUES ('430224000000', '430200000000', 3, 0, '茶陵县');
INSERT INTO `comm_address_area` VALUES ('430225000000', '430200000000', 3, 0, '炎陵县');
INSERT INTO `comm_address_area` VALUES ('430281000000', '430200000000', 3, 0, '醴陵市');
INSERT INTO `comm_address_area` VALUES ('430300000000', '430000000000', 2, 0, '湘潭市');
INSERT INTO `comm_address_area` VALUES ('430302000000', '430300000000', 3, 0, '雨湖区');
INSERT INTO `comm_address_area` VALUES ('430304000000', '430300000000', 3, 0, '岳塘区');
INSERT INTO `comm_address_area` VALUES ('430321000000', '430300000000', 3, 0, '湘潭县');
INSERT INTO `comm_address_area` VALUES ('430381000000', '430300000000', 3, 0, '湘乡市');
INSERT INTO `comm_address_area` VALUES ('430382000000', '430300000000', 3, 0, '韶山市');
INSERT INTO `comm_address_area` VALUES ('430400000000', '430000000000', 2, 0, '衡阳市');
INSERT INTO `comm_address_area` VALUES ('430405000000', '430400000000', 3, 0, '珠晖区');
INSERT INTO `comm_address_area` VALUES ('430406000000', '430400000000', 3, 0, '雁峰区');
INSERT INTO `comm_address_area` VALUES ('430407000000', '430400000000', 3, 0, '石鼓区');
INSERT INTO `comm_address_area` VALUES ('430408000000', '430400000000', 3, 0, '蒸湘区');
INSERT INTO `comm_address_area` VALUES ('430412000000', '430400000000', 3, 0, '南岳区');
INSERT INTO `comm_address_area` VALUES ('430421000000', '430400000000', 3, 0, '衡阳县');
INSERT INTO `comm_address_area` VALUES ('430422000000', '430400000000', 3, 0, '衡南县');
INSERT INTO `comm_address_area` VALUES ('430423000000', '430400000000', 3, 0, '衡山县');
INSERT INTO `comm_address_area` VALUES ('430424000000', '430400000000', 3, 0, '衡东县');
INSERT INTO `comm_address_area` VALUES ('430426000000', '430400000000', 3, 0, '祁东县');
INSERT INTO `comm_address_area` VALUES ('430481000000', '430400000000', 3, 0, '耒阳市');
INSERT INTO `comm_address_area` VALUES ('430482000000', '430400000000', 3, 0, '常宁市');
INSERT INTO `comm_address_area` VALUES ('430500000000', '430000000000', 2, 0, '邵阳市');
INSERT INTO `comm_address_area` VALUES ('430502000000', '430500000000', 3, 0, '双清区');
INSERT INTO `comm_address_area` VALUES ('430503000000', '430500000000', 3, 0, '大祥区');
INSERT INTO `comm_address_area` VALUES ('430511000000', '430500000000', 3, 0, '北塔区');
INSERT INTO `comm_address_area` VALUES ('430521000000', '430500000000', 3, 0, '邵东县');
INSERT INTO `comm_address_area` VALUES ('430522000000', '430500000000', 3, 0, '新邵县');
INSERT INTO `comm_address_area` VALUES ('430523000000', '430500000000', 3, 0, '邵阳县');
INSERT INTO `comm_address_area` VALUES ('430524000000', '430500000000', 3, 0, '隆回县');
INSERT INTO `comm_address_area` VALUES ('430525000000', '430500000000', 3, 0, '洞口县');
INSERT INTO `comm_address_area` VALUES ('430527000000', '430500000000', 3, 0, '绥宁县');
INSERT INTO `comm_address_area` VALUES ('430528000000', '430500000000', 3, 0, '新宁县');
INSERT INTO `comm_address_area` VALUES ('430529000000', '430500000000', 3, 0, '城步苗族自治县');
INSERT INTO `comm_address_area` VALUES ('430581000000', '430500000000', 3, 0, '武冈市');
INSERT INTO `comm_address_area` VALUES ('430600000000', '430000000000', 2, 0, '岳阳市');
INSERT INTO `comm_address_area` VALUES ('430602000000', '430600000000', 3, 0, '岳阳楼区');
INSERT INTO `comm_address_area` VALUES ('430603000000', '430600000000', 3, 0, '云溪区');
INSERT INTO `comm_address_area` VALUES ('430611000000', '430600000000', 3, 0, '君山区');
INSERT INTO `comm_address_area` VALUES ('430621000000', '430600000000', 3, 0, '岳阳县');
INSERT INTO `comm_address_area` VALUES ('430623000000', '430600000000', 3, 0, '华容县');
INSERT INTO `comm_address_area` VALUES ('430624000000', '430600000000', 3, 0, '湘阴县');
INSERT INTO `comm_address_area` VALUES ('430626000000', '430600000000', 3, 0, '平江县');
INSERT INTO `comm_address_area` VALUES ('430681000000', '430600000000', 3, 0, '汨罗市');
INSERT INTO `comm_address_area` VALUES ('430682000000', '430600000000', 3, 0, '临湘市');
INSERT INTO `comm_address_area` VALUES ('430700000000', '430000000000', 2, 0, '常德市');
INSERT INTO `comm_address_area` VALUES ('430702000000', '430700000000', 3, 0, '武陵区');
INSERT INTO `comm_address_area` VALUES ('430703000000', '430700000000', 3, 0, '鼎城区');
INSERT INTO `comm_address_area` VALUES ('430721000000', '430700000000', 3, 0, '安乡县');
INSERT INTO `comm_address_area` VALUES ('430722000000', '430700000000', 3, 0, '汉寿县');
INSERT INTO `comm_address_area` VALUES ('430723000000', '430700000000', 3, 0, '澧县');
INSERT INTO `comm_address_area` VALUES ('430724000000', '430700000000', 3, 0, '临澧县');
INSERT INTO `comm_address_area` VALUES ('430725000000', '430700000000', 3, 0, '桃源县');
INSERT INTO `comm_address_area` VALUES ('430726000000', '430700000000', 3, 0, '石门县');
INSERT INTO `comm_address_area` VALUES ('430781000000', '430700000000', 3, 0, '津市市');
INSERT INTO `comm_address_area` VALUES ('430800000000', '430000000000', 2, 0, '张家界市');
INSERT INTO `comm_address_area` VALUES ('430802000000', '430800000000', 3, 0, '永定区');
INSERT INTO `comm_address_area` VALUES ('430811000000', '430800000000', 3, 0, '武陵源区');
INSERT INTO `comm_address_area` VALUES ('430821000000', '430800000000', 3, 0, '慈利县');
INSERT INTO `comm_address_area` VALUES ('430822000000', '430800000000', 3, 0, '桑植县');
INSERT INTO `comm_address_area` VALUES ('430900000000', '430000000000', 2, 0, '益阳市');
INSERT INTO `comm_address_area` VALUES ('430902000000', '430900000000', 3, 0, '资阳区');
INSERT INTO `comm_address_area` VALUES ('430903000000', '430900000000', 3, 0, '赫山区');
INSERT INTO `comm_address_area` VALUES ('430921000000', '430900000000', 3, 0, '南县');
INSERT INTO `comm_address_area` VALUES ('430922000000', '430900000000', 3, 0, '桃江县');
INSERT INTO `comm_address_area` VALUES ('430923000000', '430900000000', 3, 0, '安化县');
INSERT INTO `comm_address_area` VALUES ('430981000000', '430900000000', 3, 0, '沅江市');
INSERT INTO `comm_address_area` VALUES ('431000000000', '430000000000', 2, 0, '郴州市');
INSERT INTO `comm_address_area` VALUES ('431002000000', '431000000000', 3, 0, '北湖区');
INSERT INTO `comm_address_area` VALUES ('431003000000', '431000000000', 3, 0, '苏仙区');
INSERT INTO `comm_address_area` VALUES ('431021000000', '431000000000', 3, 0, '桂阳县');
INSERT INTO `comm_address_area` VALUES ('431022000000', '431000000000', 3, 0, '宜章县');
INSERT INTO `comm_address_area` VALUES ('431023000000', '431000000000', 3, 0, '永兴县');
INSERT INTO `comm_address_area` VALUES ('431024000000', '431000000000', 3, 0, '嘉禾县');
INSERT INTO `comm_address_area` VALUES ('431025000000', '431000000000', 3, 0, '临武县');
INSERT INTO `comm_address_area` VALUES ('431026000000', '431000000000', 3, 0, '汝城县');
INSERT INTO `comm_address_area` VALUES ('431027000000', '431000000000', 3, 0, '桂东县');
INSERT INTO `comm_address_area` VALUES ('431028000000', '431000000000', 3, 0, '安仁县');
INSERT INTO `comm_address_area` VALUES ('431081000000', '431000000000', 3, 0, '资兴市');
INSERT INTO `comm_address_area` VALUES ('431100000000', '430000000000', 2, 0, '永州市');
INSERT INTO `comm_address_area` VALUES ('431102000000', '431100000000', 3, 0, '零陵区');
INSERT INTO `comm_address_area` VALUES ('431103000000', '431100000000', 3, 0, '冷水滩区');
INSERT INTO `comm_address_area` VALUES ('431121000000', '431100000000', 3, 0, '祁阳县');
INSERT INTO `comm_address_area` VALUES ('431122000000', '431100000000', 3, 0, '东安县');
INSERT INTO `comm_address_area` VALUES ('431123000000', '431100000000', 3, 0, '双牌县');
INSERT INTO `comm_address_area` VALUES ('431124000000', '431100000000', 3, 0, '道县');
INSERT INTO `comm_address_area` VALUES ('431125000000', '431100000000', 3, 0, '江永县');
INSERT INTO `comm_address_area` VALUES ('431126000000', '431100000000', 3, 0, '宁远县');
INSERT INTO `comm_address_area` VALUES ('431127000000', '431100000000', 3, 0, '蓝山县');
INSERT INTO `comm_address_area` VALUES ('431128000000', '431100000000', 3, 0, '新田县');
INSERT INTO `comm_address_area` VALUES ('431129000000', '431100000000', 3, 0, '江华瑶族自治县');
INSERT INTO `comm_address_area` VALUES ('431200000000', '430000000000', 2, 0, '怀化市');
INSERT INTO `comm_address_area` VALUES ('431202000000', '431200000000', 3, 0, '鹤城区');
INSERT INTO `comm_address_area` VALUES ('431221000000', '431200000000', 3, 0, '中方县');
INSERT INTO `comm_address_area` VALUES ('431222000000', '431200000000', 3, 0, '沅陵县');
INSERT INTO `comm_address_area` VALUES ('431223000000', '431200000000', 3, 0, '辰溪县');
INSERT INTO `comm_address_area` VALUES ('431224000000', '431200000000', 3, 0, '溆浦县');
INSERT INTO `comm_address_area` VALUES ('431225000000', '431200000000', 3, 0, '会同县');
INSERT INTO `comm_address_area` VALUES ('431226000000', '431200000000', 3, 0, '麻阳苗族自治县');
INSERT INTO `comm_address_area` VALUES ('431227000000', '431200000000', 3, 0, '新晃侗族自治县');
INSERT INTO `comm_address_area` VALUES ('431228000000', '431200000000', 3, 0, '芷江侗族自治县');
INSERT INTO `comm_address_area` VALUES ('431229000000', '431200000000', 3, 0, '靖州苗族侗族自治县');
INSERT INTO `comm_address_area` VALUES ('431230000000', '431200000000', 3, 0, '通道侗族自治县');
INSERT INTO `comm_address_area` VALUES ('431281000000', '431200000000', 3, 0, '洪江市');
INSERT INTO `comm_address_area` VALUES ('431300000000', '430000000000', 2, 0, '娄底市');
INSERT INTO `comm_address_area` VALUES ('431302000000', '431300000000', 3, 0, '娄星区');
INSERT INTO `comm_address_area` VALUES ('431321000000', '431300000000', 3, 0, '双峰县');
INSERT INTO `comm_address_area` VALUES ('431322000000', '431300000000', 3, 0, '新化县');
INSERT INTO `comm_address_area` VALUES ('431381000000', '431300000000', 3, 0, '冷水江市');
INSERT INTO `comm_address_area` VALUES ('431382000000', '431300000000', 3, 0, '涟源市');
INSERT INTO `comm_address_area` VALUES ('433100000000', '430000000000', 2, 0, '湘西土家族苗族自治州');
INSERT INTO `comm_address_area` VALUES ('433101000000', '433100000000', 3, 0, '吉首市');
INSERT INTO `comm_address_area` VALUES ('433122000000', '433100000000', 3, 0, '泸溪县');
INSERT INTO `comm_address_area` VALUES ('433123000000', '433100000000', 3, 0, '凤凰县');
INSERT INTO `comm_address_area` VALUES ('433124000000', '433100000000', 3, 0, '花垣县');
INSERT INTO `comm_address_area` VALUES ('433125000000', '433100000000', 3, 0, '保靖县');
INSERT INTO `comm_address_area` VALUES ('433126000000', '433100000000', 3, 0, '古丈县');
INSERT INTO `comm_address_area` VALUES ('433127000000', '433100000000', 3, 0, '永顺县');
INSERT INTO `comm_address_area` VALUES ('433130000000', '433100000000', 3, 0, '龙山县');
INSERT INTO `comm_address_area` VALUES ('520525000000', '520500000000', 3, 0, '纳雍县');
INSERT INTO `comm_address_area` VALUES ('520526000000', '520500000000', 3, 0, '威宁彝族回族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('520524000000', '520500000000', 3, 0, '织金县');
INSERT INTO `comm_address_area` VALUES ('520523000000', '520500000000', 3, 0, '金沙县');
INSERT INTO `comm_address_area` VALUES ('520522000000', '520500000000', 3, 0, '黔西县');
INSERT INTO `comm_address_area` VALUES ('520521000000', '520500000000', 3, 0, '大方县');
INSERT INTO `comm_address_area` VALUES ('520502000000', '520500000000', 3, 0, '七星关区');
INSERT INTO `comm_address_area` VALUES ('520500000000', '520000000000', 2, 0, '毕节市');
INSERT INTO `comm_address_area` VALUES ('520425000000', '520400000000', 3, 0, '紫云苗族布依族自治县');
INSERT INTO `comm_address_area` VALUES ('520424000000', '520400000000', 3, 0, '关岭布依族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('520423000000', '520400000000', 3, 0, '镇宁布依族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('520422000000', '520400000000', 3, 0, '普定县');
INSERT INTO `comm_address_area` VALUES ('520421000000', '520400000000', 3, 0, '平坝县');
INSERT INTO `comm_address_area` VALUES ('520402000000', '520400000000', 3, 0, '西秀区');
INSERT INTO `comm_address_area` VALUES ('520400000000', '520000000000', 2, 0, '安顺市');
INSERT INTO `comm_address_area` VALUES ('520382000000', '520300000000', 3, 0, '仁怀市');
INSERT INTO `comm_address_area` VALUES ('520381000000', '520300000000', 3, 0, '赤水市');
INSERT INTO `comm_address_area` VALUES ('520330000000', '520300000000', 3, 0, '习水县');
INSERT INTO `comm_address_area` VALUES ('520329000000', '520300000000', 3, 0, '余庆县');
INSERT INTO `comm_address_area` VALUES ('520328000000', '520300000000', 3, 0, '湄潭县');
INSERT INTO `comm_address_area` VALUES ('520327000000', '520300000000', 3, 0, '凤冈县');
INSERT INTO `comm_address_area` VALUES ('520326000000', '520300000000', 3, 0, '务川仡佬族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('520325000000', '520300000000', 3, 0, '道真仡佬族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('520324000000', '520300000000', 3, 0, '正安县');
INSERT INTO `comm_address_area` VALUES ('520323000000', '520300000000', 3, 0, '绥阳县');
INSERT INTO `comm_address_area` VALUES ('520322000000', '520300000000', 3, 0, '桐梓县');
INSERT INTO `comm_address_area` VALUES ('520321000000', '520300000000', 3, 0, '遵义县');
INSERT INTO `comm_address_area` VALUES ('520303000000', '520300000000', 3, 0, '汇川区');
INSERT INTO `comm_address_area` VALUES ('520302000000', '520300000000', 3, 0, '红花岗区');
INSERT INTO `comm_address_area` VALUES ('520300000000', '520000000000', 2, 0, '遵义市');
INSERT INTO `comm_address_area` VALUES ('520222000000', '520200000000', 3, 0, '盘县');
INSERT INTO `comm_address_area` VALUES ('520221000000', '520200000000', 3, 0, '水城县');
INSERT INTO `comm_address_area` VALUES ('520203000000', '520200000000', 3, 0, '六枝特区');
INSERT INTO `comm_address_area` VALUES ('520201000000', '520200000000', 3, 0, '钟山区');
INSERT INTO `comm_address_area` VALUES ('520200000000', '520000000000', 2, 0, '六盘水市');
INSERT INTO `comm_address_area` VALUES ('520181000000', '520100000000', 3, 0, '清镇市');
INSERT INTO `comm_address_area` VALUES ('520123000000', '520100000000', 3, 0, '修文县');
INSERT INTO `comm_address_area` VALUES ('520122000000', '520100000000', 3, 0, '息烽县');
INSERT INTO `comm_address_area` VALUES ('520121000000', '520100000000', 3, 0, '开阳县');
INSERT INTO `comm_address_area` VALUES ('520111000000', '520100000000', 3, 0, '花溪区');
INSERT INTO `comm_address_area` VALUES ('520114000000', '520100000000', 3, 0, '小河区');
INSERT INTO `comm_address_area` VALUES ('520113000000', '520100000000', 3, 0, '白云区');
INSERT INTO `comm_address_area` VALUES ('520103000000', '520100000000', 3, 0, '云岩区');
INSERT INTO `comm_address_area` VALUES ('520102000000', '520100000000', 3, 0, '南明区');
INSERT INTO `comm_address_area` VALUES ('520100000000', '520000000000', 2, 0, '贵阳市');
INSERT INTO `comm_address_area` VALUES ('520112000000', '520100000000', 3, 0, '乌当区');
INSERT INTO `comm_address_area` VALUES ('520600000000', '520000000000', 2, 0, '铜仁市');
INSERT INTO `comm_address_area` VALUES ('520602000000', '520600000000', 3, 0, '碧江区');
INSERT INTO `comm_address_area` VALUES ('520603000000', '520600000000', 3, 0, '万山区');
INSERT INTO `comm_address_area` VALUES ('520621000000', '520600000000', 3, 0, '江口县');
INSERT INTO `comm_address_area` VALUES ('520622000000', '520600000000', 3, 0, '玉屏侗族自治县');
INSERT INTO `comm_address_area` VALUES ('520623000000', '520600000000', 3, 0, '石阡县');
INSERT INTO `comm_address_area` VALUES ('520624000000', '520600000000', 3, 0, '思南县');
INSERT INTO `comm_address_area` VALUES ('520625000000', '520600000000', 3, 0, '印江土家族苗族自治县');
INSERT INTO `comm_address_area` VALUES ('520626000000', '520600000000', 3, 0, '德江县');
INSERT INTO `comm_address_area` VALUES ('520627000000', '520600000000', 3, 0, '沿河土家族自治县');
INSERT INTO `comm_address_area` VALUES ('520628000000', '520600000000', 3, 0, '松桃苗族自治县');
INSERT INTO `comm_address_area` VALUES ('522300000000', '520000000000', 2, 0, '黔西南布依族苗族自治州');
INSERT INTO `comm_address_area` VALUES ('522301000000', '522300000000', 3, 0, '兴义市');
INSERT INTO `comm_address_area` VALUES ('522322000000', '522300000000', 3, 0, '兴仁县');
INSERT INTO `comm_address_area` VALUES ('522323000000', '522300000000', 3, 0, '普安县');
INSERT INTO `comm_address_area` VALUES ('522324000000', '522300000000', 3, 0, '晴隆县');
INSERT INTO `comm_address_area` VALUES ('522325000000', '522300000000', 3, 0, '贞丰县');
INSERT INTO `comm_address_area` VALUES ('522326000000', '522300000000', 3, 0, '望谟县');
INSERT INTO `comm_address_area` VALUES ('522327000000', '522300000000', 3, 0, '册亨县');
INSERT INTO `comm_address_area` VALUES ('522328000000', '522300000000', 3, 0, '安龙县');
INSERT INTO `comm_address_area` VALUES ('522600000000', '520000000000', 2, 0, '黔东南苗族侗族自治州');
INSERT INTO `comm_address_area` VALUES ('522601000000', '522600000000', 3, 0, '凯里市');
INSERT INTO `comm_address_area` VALUES ('522622000000', '522600000000', 3, 0, '黄平县');
INSERT INTO `comm_address_area` VALUES ('522623000000', '522600000000', 3, 0, '施秉县');
INSERT INTO `comm_address_area` VALUES ('522624000000', '522600000000', 3, 0, '三穗县');
INSERT INTO `comm_address_area` VALUES ('522625000000', '522600000000', 3, 0, '镇远县');
INSERT INTO `comm_address_area` VALUES ('522626000000', '522600000000', 3, 0, '岑巩县');
INSERT INTO `comm_address_area` VALUES ('522627000000', '522600000000', 3, 0, '天柱县');
INSERT INTO `comm_address_area` VALUES ('522628000000', '522600000000', 3, 0, '锦屏县');
INSERT INTO `comm_address_area` VALUES ('522629000000', '522600000000', 3, 0, '剑河县');
INSERT INTO `comm_address_area` VALUES ('522630000000', '522600000000', 3, 0, '台江县');
INSERT INTO `comm_address_area` VALUES ('522631000000', '522600000000', 3, 0, '黎平县');
INSERT INTO `comm_address_area` VALUES ('522632000000', '522600000000', 3, 0, '榕江县');
INSERT INTO `comm_address_area` VALUES ('522633000000', '522600000000', 3, 0, '从江县');
INSERT INTO `comm_address_area` VALUES ('522634000000', '522600000000', 3, 0, '雷山县');
INSERT INTO `comm_address_area` VALUES ('522635000000', '522600000000', 3, 0, '麻江县');
INSERT INTO `comm_address_area` VALUES ('522636000000', '522600000000', 3, 0, '丹寨县');
INSERT INTO `comm_address_area` VALUES ('522700000000', '520000000000', 2, 0, '黔南布依族苗族自治州');
INSERT INTO `comm_address_area` VALUES ('522701000000', '522700000000', 3, 0, '都匀市');
INSERT INTO `comm_address_area` VALUES ('522702000000', '522700000000', 3, 0, '福泉市');
INSERT INTO `comm_address_area` VALUES ('522722000000', '522700000000', 3, 0, '荔波县');
INSERT INTO `comm_address_area` VALUES ('522723000000', '522700000000', 3, 0, '贵定县');
INSERT INTO `comm_address_area` VALUES ('522725000000', '522700000000', 3, 0, '瓮安县');
INSERT INTO `comm_address_area` VALUES ('522726000000', '522700000000', 3, 0, '独山县');
INSERT INTO `comm_address_area` VALUES ('522727000000', '522700000000', 3, 0, '平塘县');
INSERT INTO `comm_address_area` VALUES ('522728000000', '522700000000', 3, 0, '罗甸县');
INSERT INTO `comm_address_area` VALUES ('522729000000', '522700000000', 3, 0, '长顺县');
INSERT INTO `comm_address_area` VALUES ('522730000000', '522700000000', 3, 0, '龙里县');
INSERT INTO `comm_address_area` VALUES ('522731000000', '522700000000', 3, 0, '惠水县');
INSERT INTO `comm_address_area` VALUES ('522732000000', '522700000000', 3, 0, '三都水族自治县');
COMMIT;

-- ----------------------------
-- Table structure for comm_allot
-- ----------------------------
DROP TABLE IF EXISTS `comm_allot`;
CREATE TABLE `comm_allot` (
  `allot_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '调拨单ID',
  `company_code` char(8) NOT NULL COMMENT '账套',
  `customer_code` char(8) NOT NULL COMMENT '来源客户编号',
  `company_code_to` char(8) NOT NULL COMMENT '目标客户编号',
  `allot_approve_user` char(10) NOT NULL DEFAULT '' COMMENT '审核用户编号',
  `allot_approve_time` int(10) NOT NULL DEFAULT '0' COMMENT '审核时间',
  `allot_approve_view` varchar(128) NOT NULL DEFAULT '' COMMENT '审核意见',
  `allot_type` tinyint(1) unsigned NOT NULL COMMENT '调拨申请单类型:0整车 暂作废',
  `allot_status` tinyint(1) unsigned NOT NULL COMMENT '调拨状态：0-已创建 1-已提交 2-已审核 3-审核未通过 4-已作废 ',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  `submit_user` char(10) NOT NULL COMMENT '提交用户编号',
  `submit_time` int(10) unsigned NOT NULL COMMENT '提交时间',
  PRIMARY KEY (`allot_id`) USING BTREE,
  UNIQUE KEY `customer_code_unique_index` (`customer_code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='调拨申请单(4s->4s)';

-- ----------------------------
-- Records of comm_allot
-- ----------------------------
BEGIN;
INSERT INTO `comm_allot` VALUES (1, 'tiger', 'a2018918', 'b2018918', 'tiger', 1527576724, '111222', 0, 3, 'tiger', 1526624891, 'tiger', 1526627289, 'tiger', 1527576296);
INSERT INTO `comm_allot` VALUES (7, 'tiger', 'c2018918', 'd2018918', '', 0, '', 0, 0, 'tiger', 1527590944, '', 0, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for comm_allot_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_allot_detail`;
CREATE TABLE `comm_allot_detail` (
  `allot_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '调拨单明细ID',
  `company_code` char(10) NOT NULL COMMENT '账套',
  `allot_id` int(10) unsigned NOT NULL COMMENT '调拨申请单ID',
  `material_code` char(10) NOT NULL COMMENT '物料编号',
  `allot_detail_quantity` decimal(8,5) NOT NULL COMMENT '调拨数量',
  `batch_mgr_code` varchar(20) NOT NULL DEFAULT '' COMMENT '批次号 暂作废',
  `seq_code` varchar(20) NOT NULL DEFAULT '' COMMENT '序列号',
  `warehouse_code` char(10) NOT NULL COMMENT '源仓库编号',
  PRIMARY KEY (`allot_detail_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8 COMMENT='调拨申请单-明细(*)';

-- ----------------------------
-- Records of comm_allot_detail
-- ----------------------------
BEGIN;
INSERT INTO `comm_allot_detail` VALUES (5, 'tiger', 2, 'material11', 211.11111, 'batchmgrcode10000001', 'seqcode1000000000001', 'warehous11');
INSERT INTO `comm_allot_detail` VALUES (6, 'tiger', 2, 'material12', 211.11112, 'batchmgrcode10000002', 'seqcode1000000000002', 'warehous12');
INSERT INTO `comm_allot_detail` VALUES (7, 'tiger', 2, 'material13', 211.11113, 'batchmgrcode10000003', 'seqcode1000000000003', 'warehous13');
INSERT INTO `comm_allot_detail` VALUES (8, 'tiger', 2, 'material14', 211.11114, 'batchmgrcode10000004', 'seqcode1000000000004', 'warehous14');
INSERT INTO `comm_allot_detail` VALUES (45, 'tiger', 1, 'material31', 211.11111, 'batchmgrcode10000001', 'seqcode1000000000001', 'warehous11');
INSERT INTO `comm_allot_detail` VALUES (46, 'tiger', 1, 'material32', 211.11112, 'batchmgrcode10000002', 'seqcode1000000000002', 'warehous12');
INSERT INTO `comm_allot_detail` VALUES (47, 'tiger', 1, 'material33', 211.11113, 'batchmgrcode10000003', 'seqcode1000000000003', 'warehous13');
INSERT INTO `comm_allot_detail` VALUES (48, 'tiger', 1, 'material34', 211.11114, 'batchmgrcode10000004', 'seqcode1000000000004', 'warehous14');
INSERT INTO `comm_allot_detail` VALUES (49, 'tiger', 3, 'material11', 211.11111, 'batchmgrcode10000001', 'seqcode1000000000001', 'warehous11');
INSERT INTO `comm_allot_detail` VALUES (50, 'tiger', 3, 'material12', 211.11112, 'batchmgrcode10000002', 'seqcode1000000000002', 'warehous12');
INSERT INTO `comm_allot_detail` VALUES (51, 'tiger', 3, 'material13', 211.11113, 'batchmgrcode10000003', 'seqcode1000000000003', 'warehous13');
INSERT INTO `comm_allot_detail` VALUES (52, 'tiger', 3, 'material14', 211.11114, 'batchmgrcode10000004', 'seqcode1000000000004', 'warehous14');
INSERT INTO `comm_allot_detail` VALUES (57, 'tiger', 4, 'material31', 211.11111, '', 'seqcode1000000000001', 'warehous11');
INSERT INTO `comm_allot_detail` VALUES (58, 'tiger', 4, 'material32', 211.11112, '', 'seqcode1000000000002', 'warehous12');
INSERT INTO `comm_allot_detail` VALUES (59, 'tiger', 4, 'material33', 211.11113, '', 'seqcode1000000000003', 'warehous13');
INSERT INTO `comm_allot_detail` VALUES (60, 'tiger', 4, 'material34', 211.11114, '', 'seqcode1000000000004', 'warehous14');
INSERT INTO `comm_allot_detail` VALUES (61, 'tiger', 5, 'material11', 211.11111, '', 'seqcode1000000000001', 'warehous11');
INSERT INTO `comm_allot_detail` VALUES (62, 'tiger', 5, 'material12', 211.11112, '', 'seqcode1000000000002', 'warehous12');
INSERT INTO `comm_allot_detail` VALUES (63, 'tiger', 5, 'material13', 211.11113, '', 'seqcode1000000000003', 'warehous13');
INSERT INTO `comm_allot_detail` VALUES (64, 'tiger', 5, 'material14', 211.11114, '', 'seqcode1000000000004', 'warehous14');
INSERT INTO `comm_allot_detail` VALUES (65, 'tiger', 6, 'material11', 211.11111, '', 'seqcode1000000000001', 'warehous11');
INSERT INTO `comm_allot_detail` VALUES (66, 'tiger', 6, 'material12', 211.11112, '', 'seqcode1000000000002', 'warehous12');
INSERT INTO `comm_allot_detail` VALUES (67, 'tiger', 6, 'material13', 211.11113, '', 'seqcode1000000000003', 'warehous13');
INSERT INTO `comm_allot_detail` VALUES (68, 'tiger', 6, 'material14', 211.11114, '', 'seqcode1000000000004', 'warehous14');
INSERT INTO `comm_allot_detail` VALUES (69, 'tiger', 7, 'material11', 211.11111, '', 'seqcode1000000000001', 'warehous11');
INSERT INTO `comm_allot_detail` VALUES (70, 'tiger', 7, 'material12', 211.11112, '', 'seqcode1000000000002', 'warehous12');
INSERT INTO `comm_allot_detail` VALUES (71, 'tiger', 7, 'material13', 211.11113, '', 'seqcode1000000000003', 'warehous13');
INSERT INTO `comm_allot_detail` VALUES (72, 'tiger', 7, 'material14', 211.11114, '', 'seqcode1000000000004', 'warehous14');
COMMIT;

-- ----------------------------
-- Table structure for comm_bank
-- ----------------------------
DROP TABLE IF EXISTS `comm_bank`;
CREATE TABLE `comm_bank` (
  `bank_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `bank_name` varchar(50) NOT NULL COMMENT '开户行',
  `bank_account_name` varchar(20) NOT NULL COMMENT '账号名称',
  `bank_account_number` varchar(30) NOT NULL COMMENT '账号',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`bank_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='银行账户表';

-- ----------------------------
-- Table structure for comm_consume_record
-- ----------------------------
DROP TABLE IF EXISTS `comm_consume_record`;
CREATE TABLE `comm_consume_record` (
  `consume_record_id` int(11) unsigned NOT NULL COMMENT '消耗日志ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `consume_record_code` char(12) NOT NULL COMMENT '单据编号',
  `consume_id` int(11) unsigned NOT NULL COMMENT '消耗日志名称',
  `org_id` int(10) unsigned NOT NULL COMMENT '产生消耗的组织ID',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`consume_record_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消耗日志';

-- ----------------------------
-- Table structure for comm_consume_record_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_consume_record_detail`;
CREATE TABLE `comm_consume_record_detail` (
  `consume_record_detail_id` bigint(20) unsigned NOT NULL COMMENT '消耗日志明细ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `consume_record_id` int(11) unsigned NOT NULL COMMENT '消耗日志ID',
  `material_code` varchar(30) NOT NULL COMMENT '物料编号',
  `batch_mgr_code` varchar(20) NOT NULL DEFAULT '' COMMENT '批次号',
  `seq_code` varchar(20) NOT NULL DEFAULT '' COMMENT '序列号',
  `consume_record_detail_quantity` decimal(8,5) unsigned NOT NULL COMMENT '物料数量',
  `unit_id` int(11) unsigned NOT NULL COMMENT '单位',
  `warehouse_code` char(10) NOT NULL COMMENT '仓库编号',
  `warehouse_space_code` char(20) NOT NULL DEFAULT '' COMMENT '仓位编号',
  `cargo_space_code` char(20) NOT NULL DEFAULT '' COMMENT '货位编号',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`consume_record_detail_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消耗日志明细';

-- ----------------------------
-- Table structure for comm_consume_type
-- ----------------------------
DROP TABLE IF EXISTS `comm_consume_type`;
CREATE TABLE `comm_consume_type` (
  `consume_type_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '消耗日志类型id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `consume_type_name` varchar(20) NOT NULL COMMENT '消耗日志名称',
  `consume_type_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态 0-停用 1-启用',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`consume_type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消耗日志类型表';

-- ----------------------------
-- Table structure for comm_deduct_record
-- ----------------------------
DROP TABLE IF EXISTS `comm_deduct_record`;
CREATE TABLE `comm_deduct_record` (
  `deduct_record_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '其他抵扣款记录ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `customer_code` char(8) NOT NULL DEFAULT '' COMMENT '客户编号',
  `io_type_id` int(10) unsigned NOT NULL COMMENT '出入库类型ID，关联名字',
  `deduct_record_amount` decimal(8,5) NOT NULL COMMENT '金额',
  `deduct_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`deduct_record_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='其他抵扣款记录表';

-- ----------------------------
-- Table structure for comm_deliver
-- ----------------------------
DROP TABLE IF EXISTS `comm_deliver`;
CREATE TABLE `comm_deliver` (
  `deliver_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '出库单ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `deliver_code` char(12) NOT NULL COMMENT '出库单编号',
  `sells_code` char(12) NOT NULL COMMENT '销售订单编号 ',
  `warehouse_code` char(10) NOT NULL COMMENT '仓库编号',
  `stocking_code` char(12) NOT NULL COMMENT '备货单编号',
  `deliver_time` int(10) NOT NULL DEFAULT '0' COMMENT '出货时间',
  `deliver_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '出库单状态 0-已创建 1-已提交 10-已作废',
  `deliver_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(11) unsigned DEFAULT '0' COMMENT '修改时间',
  `submit_user` char(10) DEFAULT '' COMMENT '提交用户编号',
  `submit_time` int(10) unsigned DEFAULT '0' COMMENT '提交时间',
  PRIMARY KEY (`deliver_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COMMENT='出库单';

-- ----------------------------
-- Records of comm_deliver
-- ----------------------------
BEGIN;
INSERT INTO `comm_deliver` VALUES (39, 'tiger', 'CH18050039', 'XS18050026', 'wc002', 'BH18050039', 0, 1, '我修改了111', 'tiger', 1527242778, 'tiger', 1527491663, 'tiger', 1527489237);
INSERT INTO `comm_deliver` VALUES (41, 'sy001', 'CH18050040', 'XS18050028', 'wc001', 'BH18050008', 0, 10, '我被作废了', 'tiger', 1527560033, 'tiger', 1527566551, 'tiger', 1527566322);
COMMIT;

-- ----------------------------
-- Table structure for comm_deliver_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_deliver_detail`;
CREATE TABLE `comm_deliver_detail` (
  `deliver_detail_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '出库明细ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `deliver_id` int(10) unsigned NOT NULL COMMENT '出库单主表ID',
  `sells_id` int(10) unsigned NOT NULL COMMENT '销售订单主表ID',
  `meterial_code` varchar(30) NOT NULL COMMENT '物料编号',
  `deliver_detail_meterial_quantity` decimal(13,5) unsigned NOT NULL COMMENT '物料数量',
  `shipping_detail_meterial_quantity` decimal(13,5) NOT NULL COMMENT '剩余发运量',
  `warehouse_code` char(10) NOT NULL COMMENT '仓库编号',
  `warehouse_space_code` char(20) NOT NULL DEFAULT '' COMMENT '仓位编号',
  `cargo_space_code` char(20) NOT NULL DEFAULT '' COMMENT '货位编号',
  `batch_mgr_code` varchar(20) NOT NULL DEFAULT '' COMMENT '批次号',
  `seq_code` varchar(20) NOT NULL DEFAULT '' COMMENT '序列编号',
  `is_shipping` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否发运 0-否 1-是',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(11) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`deliver_detail_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='出库单明细';

-- ----------------------------
-- Records of comm_deliver_detail
-- ----------------------------
BEGIN;
INSERT INTO `comm_deliver_detail` VALUES (19, 'tiger', 39, 20, 'WL003', 20.00000, 20.00000, 'wc002', 'wpc001', 'csc001', 'pc001', '', 0, 'tiger', 1527242999, '', 0);
INSERT INTO `comm_deliver_detail` VALUES (20, 'tiger', 39, 20, 'WL004', 10.00000, 10.00000, 'wc002', 'wpc001', 'csc002', 'pc001', '', 0, 'tiger', 1527242999, '', 0);
INSERT INTO `comm_deliver_detail` VALUES (25, 'sy001', 41, 22, 'WL0001', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc001', '', 'sc001', 0, 'tiger', 1527560034, '', 0);
INSERT INTO `comm_deliver_detail` VALUES (26, 'sy001', 41, 22, 'WL0001', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc001', '', 'sc002', 0, 'tiger', 1527560034, '', 0);
INSERT INTO `comm_deliver_detail` VALUES (27, 'sy001', 41, 22, 'WL0002', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc002', '', 'sc010', 0, 'tiger', 1527560034, '', 0);
INSERT INTO `comm_deliver_detail` VALUES (28, 'sy001', 41, 22, 'WL0002', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc002', '', 'sc011', 0, 'tiger', 1527560034, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for comm_invoice
-- ----------------------------
DROP TABLE IF EXISTS `comm_invoice`;
CREATE TABLE `comm_invoice` (
  `invoice_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '发票ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `invoice_type` tinyint(1) unsigned NOT NULL COMMENT '发票种类：1-增值税普通发票 2-增值税专用发票',
  `invoice_number` varchar(45) NOT NULL COMMENT '发票号',
  `invoice_time` int(10) unsigned NOT NULL COMMENT '开票日期',
  `invoice_subtotal` decimal(8,5) NOT NULL COMMENT '未含税金额合计',
  `invoice_tax` decimal(8,5) NOT NULL COMMENT '税额',
  `invoice_total` decimal(8,5) NOT NULL COMMENT '实际订单最终金额',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建日期',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`invoice_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发票表';

-- ----------------------------
-- Table structure for comm_invoice_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_invoice_detail`;
CREATE TABLE `comm_invoice_detail` (
  `invoice_detail_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '发票明细ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `invoice_id` int(11) unsigned NOT NULL COMMENT '发票ID',
  `invoice_detail_name` varchar(45) NOT NULL COMMENT '货物或应税劳务名称',
  `invoice_detail_type` varchar(80) NOT NULL DEFAULT '' COMMENT '规格型号',
  `invoice_detail_quantity` decimal(8,5) unsigned NOT NULL COMMENT '数量',
  `unit_id` int(10) unsigned NOT NULL COMMENT '单位',
  `invoice_detail_price` decimal(8,5) NOT NULL COMMENT '单价',
  `invoice_detail_subtotal` decimal(8,5) NOT NULL COMMENT '单价合计',
  `invoice_detail_tax_rate` tinyint(1) unsigned NOT NULL COMMENT '税率 1- 税率17%、 2- 税率13%、3- 税率11%、4-税率 6%、5-税率 0%',
  `invoice_detail_tax` decimal(8,5) NOT NULL COMMENT '税额',
  PRIMARY KEY (`invoice_detail_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发票表-明细';

-- ----------------------------
-- Table structure for comm_invoice_request
-- ----------------------------
DROP TABLE IF EXISTS `comm_invoice_request`;
CREATE TABLE `comm_invoice_request` (
  `invoice_request_id` int(10) unsigned NOT NULL COMMENT '开票申请单ID',
  `company_code` char(5) NOT NULL COMMENT '公司账套',
  `invoice_request_code` char(12) NOT NULL COMMENT '开票申请单编号',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `invoice_request_type` tinyint(1) unsigned NOT NULL COMMENT '发票种类：1-增值税普通发票 2-增值税专用发票 (页面默认选择2)',
  `invoice_request_status` tinyint(1) unsigned NOT NULL COMMENT '申请状态 ： 0-已创建 1-已提交 2-已审核 3-已开票 4-已驳回 5-已作废',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`invoice_request_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开票申请单';

-- ----------------------------
-- Table structure for comm_invoice_request_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_invoice_request_detail`;
CREATE TABLE `comm_invoice_request_detail` (
  `invoice_requst_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_code` char(5) NOT NULL COMMENT '公司账套',
  `invoice_request_id` int(10) unsigned NOT NULL COMMENT '开票申请单ID',
  `sells_code` char(12) NOT NULL COMMENT '销售订单编号',
  `deliver_code` char(12) NOT NULL COMMENT '出库单编号',
  PRIMARY KEY (`invoice_requst_detail_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='开票申请单-明细';

-- ----------------------------
-- Table structure for comm_price_rule
-- ----------------------------
DROP TABLE IF EXISTS `comm_price_rule`;
CREATE TABLE `comm_price_rule` (
  `price_rule_id` int(11) unsigned NOT NULL COMMENT '规则ID',
  `price_rule_version_id` int(11) unsigned NOT NULL COMMENT '版本id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `customer_code` char(10) NOT NULL COMMENT '客户编号',
  `material_category_id` int(11) unsigned NOT NULL COMMENT '物料分类',
  `material_code` varchar(30) NOT NULL COMMENT '物料编号',
  `price_rule_percent` decimal(8,5) unsigned NOT NULL COMMENT '浮动系数(实际价格=价格*浮动系数)',
  `price_rule_status` tinyint(1) unsigned NOT NULL COMMENT '状态 1-已创建 2-已启用 3- 已停用 4-已作废',
  `price_rule_start_time` int(10) unsigned NOT NULL COMMENT '有效期开始时间',
  `price_rule_end_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '有效期结束时间  0 表示永久有效',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '编辑用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '编辑时间',
  PRIMARY KEY (`price_rule_id`) USING BTREE,
  KEY `idx_category` (`material_category_id`) USING BTREE,
  KEY `idx_time` (`price_rule_start_time`,`price_rule_end_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='价格规则表(物料or物料分类， 价格规则审核版本子表)';

-- ----------------------------
-- Table structure for comm_price_rule_version
-- ----------------------------
DROP TABLE IF EXISTS `comm_price_rule_version`;
CREATE TABLE `comm_price_rule_version` (
  `price_rule_version_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `price_rule_version_code` char(12) NOT NULL COMMENT '价格规则版本编号',
  `create_user` char(10) NOT NULL COMMENT '创建人编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`price_rule_version_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='价格规则审核版本';

-- ----------------------------
-- Table structure for comm_punish_rules
-- ----------------------------
DROP TABLE IF EXISTS `comm_punish_rules`;
CREATE TABLE `comm_punish_rules` (
  `punish_rules_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `punish_rules_name` varchar(20) NOT NULL COMMENT '规则名称',
  `punish_rules_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '规则简单描述',
  `punish_rules_type` tinyint(1) unsigned NOT NULL COMMENT '规则使用类型 1 加急超次数 2 余额不足超次数 3其他  ',
  `punish_rules_period` tinyint(1) unsigned NOT NULL COMMENT '统计周期  1 - 月  2 - 季度 3 - 年',
  `punish_rules_period_num` tinyint(1) unsigned NOT NULL COMMENT '统计周期内 处罚起始次数',
  `punish_rules_subtotal` decimal(8,5) NOT NULL COMMENT '处罚金额',
  `punish_rules_status` tinyint(1) unsigned NOT NULL COMMENT '状态 0-停用 1-启用 2-作废',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`punish_rules_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='惩罚规则表';

-- ----------------------------
-- Table structure for comm_receipt
-- ----------------------------
DROP TABLE IF EXISTS `comm_receipt`;
CREATE TABLE `comm_receipt` (
  `receipt_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_code` char(5) NOT NULL COMMENT '公司账套',
  `customer_code` char(10) NOT NULL COMMENT '客户编号',
  `customer_type` tinyint(1) unsigned NOT NULL COMMENT '客户类型： 0-普通客户，1-经销商',
  `receipt_code` char(10) NOT NULL COMMENT '收款单编号',
  `remittance_id` int(11) NOT NULL DEFAULT '0' COMMENT '打款单主键id（客户类型为经销商时，保存对应打款单主键id）',
  `settlement_id` int(10) unsigned NOT NULL COMMENT '资金结算方式',
  `settlement_name` varchar(20) NOT NULL COMMENT '资金结算方式名称',
  `receipt_number` varchar(80) NOT NULL COMMENT '原始凭证号',
  `receipt_time` int(10) unsigned NOT NULL COMMENT '打款时间',
  `receipt_subtotal` decimal(13,5) unsigned NOT NULL COMMENT '金额',
  `receipt_mark` varchar(255) NOT NULL DEFAULT '' COMMENT '摘要',
  `receipt_status` tinyint(1) unsigned NOT NULL COMMENT '状态  0-已创建  1- 已提交  2-已审核 3-已完成  4-已驳回 5-已作废',
  `receipt_submit_user` char(10) NOT NULL DEFAULT '' COMMENT '提交人编号',
  `receipt_submit_time` int(10) NOT NULL DEFAULT '0' COMMENT '提交时间',
  `receipt_check_user` char(10) NOT NULL DEFAULT '' COMMENT '审核人编号(确认资金到账)',
  `receipt_check_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核时间',
  `receipt_dealer_user` char(10) NOT NULL DEFAULT '' COMMENT '处理员编号(处理余额/废弃)',
  `receipt_dealer_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '处理时间',
  `receipt_check_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '驳回原因',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`receipt_id`),
  KEY `idx_company_code` (`company_code`,`customer_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='收款表';

-- ----------------------------
-- Records of comm_receipt
-- ----------------------------
BEGIN;
INSERT INTO `comm_receipt` VALUES (4, '4s001', '4s001cus01', 1, 'shoukuan04', 0, 2, '现金', '362223322666333111', 1526457768, 70000.00000, '预收款', 3, '4s001caiwu', 1527318037, '4s001caiwu', 1527318037, '4s001caiwu', 1527318037, '', '4s001caiwu', 1527245420, '4s001caiwu', 1527318037);
INSERT INTO `comm_receipt` VALUES (5, '4s001', '4s001cus01', 1, 'shoukuan03', 0, 2, '现金', '362223322666333111', 1526457768, 55000.00000, '预收款', 3, '4s001caiwu', 1527318206, '4s001caiwu', 1527318206, '4s001caiwu', 1527318206, '', '4s001caiwu', 1527245551, '4s001caiwu', 1527318206);
INSERT INTO `comm_receipt` VALUES (6, '4s001', '4s001cus01', 1, 'shoukuan01', 0, 2, '现金', '362223322666333111', 4294967295, 55000.00000, '预收款', 5, '', 0, '', 0, '', 0, '', '4s001caiwu', 1527246632, '4s001caiwu', 1527324519);
INSERT INTO `comm_receipt` VALUES (11, 'gs001', '4s001_self', 1, 'shoukuan01', 2, 10, '三方承兑', '33321001244552211222', 1527324076, 2000000.00000, '打款200万，整车150万，备件50万', 3, '4s001caiwu', 1527327441, 'gs001caiwu', 1527328844, 'gs001caiwu', 1527328893, '', '4s001caiwu', 1527327441, 'gs001caiwu', 1527328893);
INSERT INTO `comm_receipt` VALUES (12, 'gs001', '4s001_self', 1, 'shoukuan01', 1, 10, '三方承兑', '33321001244552211222', 1527324076, 2000000.00000, '打款200万，整车150万，备件50万', 5, '4s001caiwu', 1527327658, 'gs001caiwu', 1527329088, '', 0, ' 资金没到账', '4s001caiwu', 1527327658, 'gs001caiwu', 1527329172);
COMMIT;

-- ----------------------------
-- Table structure for comm_receipt_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_receipt_detail`;
CREATE TABLE `comm_receipt_detail` (
  `receipt_detail_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `receipt_id` int(11) unsigned NOT NULL COMMENT '主表id',
  `fund_usage_id` int(10) unsigned NOT NULL COMMENT '资金用途(资金用途表id)',
  `fund_usage_name` varchar(45) NOT NULL COMMENT '资金用途名称',
  `receipt_detail_fund_type` varchar(45) DEFAULT NULL COMMENT '资金类型 1-正常 2-借款',
  `receipt_detail_amount` decimal(13,5) NOT NULL COMMENT '金额',
  PRIMARY KEY (`receipt_detail_id`),
  KEY `idx_receipt_id` (`receipt_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COMMENT='收款表-明细';

-- ----------------------------
-- Records of comm_receipt_detail
-- ----------------------------
BEGIN;
INSERT INTO `comm_receipt_detail` VALUES (8, 4, 4, '代收保险', '1', 20000.00000);
INSERT INTO `comm_receipt_detail` VALUES (9, 5, 1, '整车款', '1', 50000.00000);
INSERT INTO `comm_receipt_detail` VALUES (10, 5, 4, '代收保险', '1', 5000.00000);
INSERT INTO `comm_receipt_detail` VALUES (11, 6, 1, '整车款', '1', 50000.00000);
INSERT INTO `comm_receipt_detail` VALUES (12, 6, 4, '代收保险', '1', 5000.00000);
INSERT INTO `comm_receipt_detail` VALUES (21, 11, 5, '整车款', '1', 1500000.00000);
INSERT INTO `comm_receipt_detail` VALUES (22, 11, 6, '备件款', '1', 500000.00000);
INSERT INTO `comm_receipt_detail` VALUES (23, 12, 5, '整车款', '1', 1000000.00000);
INSERT INTO `comm_receipt_detail` VALUES (24, 12, 6, '备件款', '1', 1000000.00000);
COMMIT;

-- ----------------------------
-- Table structure for comm_remittance
-- ----------------------------
DROP TABLE IF EXISTS `comm_remittance`;
CREATE TABLE `comm_remittance` (
  `remittance_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_code` char(5) NOT NULL COMMENT '公司账套',
  `supplier_code` char(10) NOT NULL COMMENT '供应商编号',
  `supplier_type` tinyint(1) unsigned NOT NULL COMMENT '供应商类型： 1-销售公司  2-外采供应商',
  `remittance_code` char(10) NOT NULL COMMENT '打款单编号',
  `receipt_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '收款单编号（供应商类型为销售公司时，保存对应收款单id）',
  `settlement_id` int(10) unsigned NOT NULL COMMENT '资金结算方式（资金结算方式表id）',
  `settlement_name` varchar(20) NOT NULL COMMENT '资金结算方式名称',
  `remittance_number` varchar(80) NOT NULL COMMENT '原始凭证号',
  `remittance_time` int(10) unsigned NOT NULL COMMENT '打款时间',
  `remittance_subtotal` decimal(13,5) unsigned NOT NULL COMMENT '金额',
  `remittance_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '摘要',
  `remittance_status` tinyint(1) unsigned NOT NULL COMMENT '状态  0-已创建  1- 已提交  2-已审核 3-已完成  4-已驳回 5-已作废',
  `remittance_submit_user` char(10) NOT NULL DEFAULT '' COMMENT '提交人',
  `remittance_submit_time` int(10) NOT NULL DEFAULT '0' COMMENT '提交时间',
  `remittance_check_user` char(10) NOT NULL DEFAULT '' COMMENT '审核人编号(确认资金到账)',
  `remittance_check_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核时间',
  `remittance_dealer_user` char(10) NOT NULL DEFAULT '' COMMENT '处理员编号(处理余额/废弃)',
  `remittance_dealer_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '处理时间',
  `remittance_check_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '驳回原因',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`remittance_id`),
  KEY `idx_company_code` (`company_code`,`supplier_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='打款表';

-- ----------------------------
-- Records of comm_remittance
-- ----------------------------
BEGIN;
INSERT INTO `comm_remittance` VALUES (1, '4s001', '00000gs001', 1, 'fukuan0001', 12, 10, '三方承兑', '33321001244552211222', 1527324076, 2000000.00000, '打款200万，整车150万，备件50万', 5, '4s001caiwu', 1527327658, 'gs001caiwu', 1527329088, '', 0, ' 资金没到账', '4s001caiwu', 1527325075, '4s001caiwu', 1527329272);
INSERT INTO `comm_remittance` VALUES (2, '4s001', '00000gs001', 1, 'fukuan0001', 11, 10, '三方承兑', '33321001244552211222', 1527324076, 2000000.00000, '打款200万，整车150万，备件50万', 3, '4s001caiwu', 1527327441, 'gs001caiwu', 1527328844, 'gs001caiwu', 1527328893, '', '4s001caiwu', 1527326123, 'gs001caiwu', 1527328893);
INSERT INTO `comm_remittance` VALUES (3, '4s001', '00000gs001', 1, 'fukuan0001', 0, 10, '三方承兑', '33321001244552211222', 1527324076, 2000000.00000, '打款200万，整车150万，备件50万', 5, '', 0, '', 0, '', 0, '', '4s001caiwu', 1527326136, '4s001caiwu', 1527328620);
INSERT INTO `comm_remittance` VALUES (4, '4s001', '00000gs001', 1, 'fukuan0001', 0, 10, '三方承兑', '33321001244552211222', 1527324076, 2000000.00000, '打款200万，整车150万，备件50万', 0, '', 0, '', 0, '', 0, '', '4s001caiwu', 1527326139, '4s001caiwu', 1527326139);
COMMIT;

-- ----------------------------
-- Table structure for comm_remittance_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_remittance_detail`;
CREATE TABLE `comm_remittance_detail` (
  `remittance_detail_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `remittance_id` int(11) unsigned NOT NULL COMMENT '主表id',
  `fund_usage_id` int(10) unsigned NOT NULL COMMENT '资金用途(资金用途表id)',
  `fund_usage_name` varchar(45) NOT NULL COMMENT '资金用途名称',
  `remittance_detail_fund_type` tinyint(1) DEFAULT NULL COMMENT '资金类型 1-正常 2-借款',
  `remittance_detail_amount` decimal(13,5) NOT NULL COMMENT '金额',
  PRIMARY KEY (`remittance_detail_id`),
  KEY `idx_remittance_id` (`remittance_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='打款表-明细';

-- ----------------------------
-- Records of comm_remittance_detail
-- ----------------------------
BEGIN;
INSERT INTO `comm_remittance_detail` VALUES (3, 2, 5, '整车款', 1, 1500000.00000);
INSERT INTO `comm_remittance_detail` VALUES (4, 2, 6, '备件款', 1, 500000.00000);
INSERT INTO `comm_remittance_detail` VALUES (5, 3, 5, '整车款', 1, 1500000.00000);
INSERT INTO `comm_remittance_detail` VALUES (6, 3, 6, '备件款', 1, 500000.00000);
INSERT INTO `comm_remittance_detail` VALUES (7, 4, 5, '整车款', 1, 1500000.00000);
INSERT INTO `comm_remittance_detail` VALUES (8, 4, 6, '备件款', 1, 500000.00000);
INSERT INTO `comm_remittance_detail` VALUES (11, 1, 5, '整车款', 1, 1000000.00000);
INSERT INTO `comm_remittance_detail` VALUES (12, 1, 6, '备件款', 1, 1000000.00000);
COMMIT;

-- ----------------------------
-- Table structure for comm_sales_auth
-- ----------------------------
DROP TABLE IF EXISTS `comm_sales_auth`;
CREATE TABLE `comm_sales_auth` (
  `sales_auth_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '授权ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `meterial_code` varchar(40) NOT NULL COMMENT '物料编码',
  `sales_auth_time` int(10) unsigned NOT NULL COMMENT '授权有效开始时间',
  `sales_auth_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注信息',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`sales_auth_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='车型（销售）授权表';

-- ----------------------------
-- Table structure for comm_sells
-- ----------------------------
DROP TABLE IF EXISTS `comm_sells`;
CREATE TABLE `comm_sells` (
  `sells_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '销售订单ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `sells_code` char(12) NOT NULL COMMENT '销售订单编号',
  `sells_type` tinyint(1) unsigned NOT NULL COMMENT '订单类型, 0-整车,1-备件',
  `sells_state` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '订单加急类型 0-正常 1-紧急',
  `address_id` int(10) unsigned NOT NULL COMMENT '收货地址ID',
  `sells_address_name` varchar(255) NOT NULL DEFAULT '' COMMENT '订单地址名称',
  `fund_usage_id` int(11) unsigned NOT NULL COMMENT '款项用途',
  `sell_region_id` int(10) unsigned NOT NULL COMMENT '销售区域ID',
  `sells_is_return` tinyint(1) unsigned NOT NULL COMMENT '是否是退货单 0- 不是 1- 是',
  `sells_is_agent` tinyint(1) unsigned NOT NULL COMMENT '是否是总部代下单 0-不是 1是',
  `sells_receiver` varchar(30) NOT NULL DEFAULT '' COMMENT '收货人姓名',
  `sells_receiver_tel` varchar(45) NOT NULL DEFAULT '' COMMENT '收货人电话',
  `sells_mount` decimal(13,5) NOT NULL COMMENT '订单总额',
  `sells_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '订单备注',
  `sells_discard_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `sells_status` int(10) unsigned NOT NULL COMMENT '订单状态 0-已创建,1-已提交,  2-已审核, 3-已复核 (4-已备车 5-已发货) 6-已发运 7-已收货 8-已开票 10-已退回 20-已作废 30-已驳回',
  `customer_group_id` int(10) unsigned NOT NULL COMMENT '客户组(备用)',
  `tax_group_id` int(10) unsigned NOT NULL COMMENT '销售税组(备用)',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(11) DEFAULT '0' COMMENT '修改时间',
  `submit_user` char(10) DEFAULT '' COMMENT '提交用户编号',
  `submit_time` int(10) unsigned DEFAULT '0' COMMENT '提交时间',
  `sells_approver` char(10) NOT NULL DEFAULT '' COMMENT '审核用户编号',
  `sells_approve_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '审核时间',
  `sells_approve_view` varchar(128) NOT NULL DEFAULT '' COMMENT '审核意见',
  `sells_reviewer` char(10) NOT NULL DEFAULT '' COMMENT '复核用户编号',
  `sells_review_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '复核时间',
  `sells_review_view` varchar(128) NOT NULL DEFAULT '' COMMENT '复审意见',
  PRIMARY KEY (`sells_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COMMENT='销售订单';

-- ----------------------------
-- Records of comm_sells
-- ----------------------------
BEGIN;
INSERT INTO `comm_sells` VALUES (1, 'tiger', '', '', 0, 0, 0, '', 0, 0, 0, 0, '', '0', 0.00000, '', '', 6, 0, 0, '', 0, '', 0, '', 0, '', 0, '', '', 0, '');
INSERT INTO `comm_sells` VALUES (2, 'tiger', '', '', 0, 0, 0, '', 0, 0, 0, 0, '', '0', 0.00000, '', '', 6, 0, 0, '', 0, '', 0, '', 0, '', 0, '', '', 0, '');
INSERT INTO `comm_sells` VALUES (18, 'sy001', 'sy000000', 'XS18050025', 0, 0, 0, '陕西西安高新区摩尔中心', 0, 10, 0, 0, 'sy', '13088997555', 2940000.00000, '', '测试作废', 20, 0, 0, 'sy', 1527320564, 'sy', 1527323451, '', 0, '', 0, '', '', 0, '');
INSERT INTO `comm_sells` VALUES (19, 'sy001', 'sy000000', 'XS18050026', 0, 0, 0, '陕西西安高新区摩尔中心', 10, 10, 0, 0, 'sy', '13088997555', 2940000.00000, '', '', 3, 0, 0, 'sy', 1527323549, '', 0, '', 0, 'sy', 1527324302, '', 'sy', 1527325214, '金额有问题');
INSERT INTO `comm_sells` VALUES (20, 'tiger', 'tig00000', 'XS18050026', 0, 0, 0, '陕西西安高新区摩尔中心', 10, 10, 0, 0, 'bkh', '13327272727', 3494999.00000, '', '测试订单已创建', 2, 0, 0, 'bkh', 1527633333, 'tiger', 1527489238, '', 0, '', 0, '', '', 0, '');
INSERT INTO `comm_sells` VALUES (21, 'sy001', 'sy000000', 'XS18050027', 0, 0, 0, '陕西西安高新区摩尔中心', 10, 10, 0, 0, 'sy', '13088997555', 2940000.00000, '', '', 3, 0, 0, 'sy', 1527325519, '', 0, 'sy', 1527326173, '', 0, '', '', 0, '');
INSERT INTO `comm_sells` VALUES (22, 'sy001', 'sy000000', 'XS18050028', 0, 0, 0, '陕西西安高新区摩尔中心', 10, 10, 0, 0, 'sy', '13088997555', 2940000.00000, '', '', 3, 0, 0, 'sy', 1527327557, '', 0, 'sy', 1527327584, '', 0, '', '', 0, '');
COMMIT;

-- ----------------------------
-- Table structure for comm_sells_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_sells_detail`;
CREATE TABLE `comm_sells_detail` (
  `sells_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '销售订单明细ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(11) unsigned NOT NULL COMMENT '修改时间',
  `sells_id` int(10) unsigned NOT NULL COMMENT '销售订单主表ID',
  `meterial_code` varchar(30) NOT NULL COMMENT '物料编号',
  `sells_detail_quantity` decimal(13,5) NOT NULL COMMENT '数量',
  `sells_detail_price` decimal(13,5) unsigned NOT NULL COMMENT '单价',
  `sells_detail_amount` decimal(13,5) NOT NULL COMMENT '总价',
  `sells_detail_status` tinyint(1) unsigned NOT NULL COMMENT '明细状态 0-未完成 1-已完成 2- 停止(暂定)',
  `sells_detail_remain_stock_quantity` decimal(13,5) NOT NULL COMMENT '剩余备货量',
  `sells_detail_remain_delivery_quantity` decimal(13,5) NOT NULL COMMENT '剩余交货量',
  `sells_detail_remain_invoice_quantity` decimal(13,5) NOT NULL COMMENT '剩余开票量',
  `batch_mgr_code` varchar(20) NOT NULL DEFAULT '' COMMENT '批次编号(退货专用)',
  `seq_code` varchar(20) NOT NULL DEFAULT '' COMMENT '序列编号',
  PRIMARY KEY (`sells_detail_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8 COMMENT='销售订单-明细';

-- ----------------------------
-- Records of comm_sells_detail
-- ----------------------------
BEGIN;
INSERT INTO `comm_sells_detail` VALUES (1, 'tiger', '', 0, '', 0, 1, '', 1.00000, 0.00000, 0.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (4, 'tiger', '', 0, '', 0, 2, '', 1.00000, 0.00000, 0.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (44, 'sy001', 'sy', 1527320648, '', 0, 18, 'WL0001', 10.00000, 98000.00000, 980000.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (45, 'sy001', 'sy', 1527320648, '', 0, 18, 'WL0002', 10.00000, 97000.00000, 970000.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (46, 'sy001', 'sy', 1527320648, '', 0, 18, 'WL0003', 10.00000, 99000.00000, 990000.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (47, 'sy001', 'sy', 1527323550, '', 0, 19, 'WL0001', 10.00000, 98000.00000, 980000.00000, 0, 10.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (48, 'sy001', 'sy', 1527323550, '', 0, 19, 'WL0002', 10.00000, 97000.00000, 970000.00000, 0, 10.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (49, 'sy001', 'sy', 1527323550, '', 0, 19, 'WL0003', 10.00000, 99000.00000, 990000.00000, 0, 10.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (50, 'tiger', 'bkh', 1527323550, '', 0, 20, 'WL003', 20.00000, 99999.00000, 99999.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (51, 'tiger', 'bkh', 1527323550, '', 0, 20, 'WL004', 10.00000, 9999.00000, 99999.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (53, 'sy001', 'sy', 1527325520, '', 0, 21, 'WL0001', 11.00000, 98000.00000, 980000.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (54, 'sy001', 'sy', 1527325520, '', 0, 21, 'WL0002', 12.00000, 97000.00000, 970000.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (55, 'sy001', 'sy', 1527325520, '', 0, 21, 'WL0003', 10.00000, 99000.00000, 990000.00000, 0, 0.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (56, 'sy001', 'sy', 1527327558, '', 0, 22, 'WL0001', 10.00000, 98000.00000, 980000.00000, 0, 4.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (57, 'sy001', 'sy', 1527327558, '', 0, 22, 'WL0002', 10.00000, 97000.00000, 970000.00000, 0, 6.00000, 0.00000, 0.00000, '', '');
INSERT INTO `comm_sells_detail` VALUES (58, 'sy001', 'sy', 1527327558, '', 0, 22, 'WL0003', 10.00000, 99000.00000, 990000.00000, 0, 10.00000, 0.00000, 0.00000, '', '');
COMMIT;

-- ----------------------------
-- Table structure for comm_shipping
-- ----------------------------
DROP TABLE IF EXISTS `comm_shipping`;
CREATE TABLE `comm_shipping` (
  `shipping_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '发运单ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `shipping_code` char(12) NOT NULL COMMENT '发运单编号',
  `shipping_address` varchar(64) NOT NULL COMMENT '发运单粗略地址',
  `shipping_order_no` varchar(32) NOT NULL COMMENT '物理运输单号',
  `shipping_status` tinyint(1) unsigned DEFAULT NULL COMMENT '发运单状态 0-已创建 1-已提交 10-已作废',
  `shipping_amout` decimal(8,5) unsigned DEFAULT NULL COMMENT '运费总额',
  `shipping_miles` decimal(8,5) unsigned DEFAULT NULL COMMENT '公里数',
  `shipping_company_code` varchar(20) NOT NULL COMMENT '承运商编号',
  `shipping_mode_id` int(10) unsigned NOT NULL COMMENT '运输方式ID',
  `shipping_driver` varchar(45) NOT NULL COMMENT '司机姓名',
  `shipping_driver_tel` varchar(45) NOT NULL DEFAULT '' COMMENT '司机联系电话',
  `shipping_plate_number` varchar(45) NOT NULL COMMENT '车牌号',
  `shipping_charge_mode_id` int(10) unsigned NOT NULL COMMENT '计费方式',
  `shipping_time` int(11) unsigned NOT NULL COMMENT '发运时间',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  `submit_user` char(10) DEFAULT '' COMMENT '提交用户编号',
  `submit_time` int(10) unsigned DEFAULT '0' COMMENT '提交时间',
  PRIMARY KEY (`shipping_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='发运单';

-- ----------------------------
-- Records of comm_shipping
-- ----------------------------
BEGIN;
INSERT INTO `comm_shipping` VALUES (5, 'tiger', '1111133', '小菜', '12', 1, 133.00000, NULL, '', 0, '', '', '', 0, 0, 'tiger', 1526971773, '', 0, 'tiger', 1527220835);
COMMIT;

-- ----------------------------
-- Table structure for comm_shipping_charge_mode
-- ----------------------------
DROP TABLE IF EXISTS `comm_shipping_charge_mode`;
CREATE TABLE `comm_shipping_charge_mode` (
  `comm_shipping_charge_mode_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '运输计费方式ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `comm_shipping_charge_mode_name` varchar(45) NOT NULL COMMENT '运输计费方式名称',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(11) unsigned DEFAULT '0' COMMENT '修改时间',
  `comm_shipping_charge_mode_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `comm_shipping_charge_mode_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  PRIMARY KEY (`comm_shipping_charge_mode_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='运输计费方式';

-- ----------------------------
-- Records of comm_shipping_charge_mode
-- ----------------------------
BEGIN;
INSERT INTO `comm_shipping_charge_mode` VALUES (1, 'tiger', '数据sd', 'tiger', 1526611815, 'tiger', 1526611841, 3, 'dddd');
INSERT INTO `comm_shipping_charge_mode` VALUES (2, 'tiger', '数据', 'tiger', 1527560176, '', 0, 1, '');
COMMIT;

-- ----------------------------
-- Table structure for comm_shipping_company
-- ----------------------------
DROP TABLE IF EXISTS `comm_shipping_company`;
CREATE TABLE `comm_shipping_company` (
  `shipping_company_id` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT COMMENT '承运商ID',
  `shipping_company_code` varchar(20) NOT NULL COMMENT '承运商编号',
  `shipping_company_name` varchar(45) DEFAULT NULL COMMENT '承运商名称',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `shipping_company_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `shipping_company_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '编辑用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '编辑时间',
  PRIMARY KEY (`shipping_company_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='承运商';

-- ----------------------------
-- Records of comm_shipping_company
-- ----------------------------
BEGIN;
INSERT INTO `comm_shipping_company` VALUES (0000000001, '3422', 'judd', 'tiger', 3, '', 'tiger', 1526612494, 'tiger', 1526612799);
INSERT INTO `comm_shipping_company` VALUES (0000000002, '3422', 'jud', 'tiger', 1, '', 'tiger', 1526612593, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for comm_shipping_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_shipping_detail`;
CREATE TABLE `comm_shipping_detail` (
  `shipping_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '发运单明细ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `deliver_detail_id` int(10) unsigned NOT NULL COMMENT '出库单明细ID',
  `meterial_code` varchar(30) NOT NULL DEFAULT '' COMMENT '物料编号',
  `shipping_detail_meterial_quantity` decimal(13,5) unsigned NOT NULL COMMENT '物料数量',
  `accept_detail_meterial_quantity` decimal(13,5) NOT NULL COMMENT '剩余交货量',
  `shipping_id` int(10) unsigned NOT NULL COMMENT '发运单主表ID',
  `sells_id` int(10) unsigned NOT NULL COMMENT '销售订单主表ID',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `shipping_detail_mark` varchar(128) NOT NULL DEFAULT '' COMMENT '备注',
  `shipping_detail_amount` decimal(8,5) unsigned NOT NULL DEFAULT '0.00000' COMMENT '明细物品运费(备用)',
  `batch_mgr_code` varchar(20) NOT NULL DEFAULT '' COMMENT '批次号',
  `seq_code` varchar(20) NOT NULL DEFAULT '' COMMENT '序列号',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '编辑用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '编辑时间',
  PRIMARY KEY (`shipping_detail_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='发运单-明细';

-- ----------------------------
-- Records of comm_shipping_detail
-- ----------------------------
BEGIN;
INSERT INTO `comm_shipping_detail` VALUES (1, 'tiger', 19, 'a', 1.00000, 7.00000, 5, 1, '', '', 0.00000, '', 'a', 'tiger', 1526971773, 'ljx', 1527326985);
INSERT INTO `comm_shipping_detail` VALUES (2, 'tiger', 19, 'b', 1.00000, 3.00000, 5, 2, '', '', 0.00000, '', 'b', 'tiger', 1526971773, 'ljx', 1527326985);
COMMIT;

-- ----------------------------
-- Table structure for comm_shipping_mode
-- ----------------------------
DROP TABLE IF EXISTS `comm_shipping_mode`;
CREATE TABLE `comm_shipping_mode` (
  `shipping_mode_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '运输方式ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `shipping_mode_name` varchar(45) DEFAULT NULL COMMENT '运输方式名称',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT NULL COMMENT '修改用户编号',
  `modify_time` int(11) DEFAULT NULL COMMENT '修改时间',
  `shipping_mode_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态 1-正常 2-停用 3-作废',
  `shipping_mode_remark` varchar(128) NOT NULL DEFAULT '' COMMENT '作废备注',
  PRIMARY KEY (`shipping_mode_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='运输方式';

-- ----------------------------
-- Records of comm_shipping_mode
-- ----------------------------
BEGIN;
INSERT INTO `comm_shipping_mode` VALUES (1, 'tiger', '顺丰2', 'tiger', 1526614173, 'tiger', 1526614195, 3, '');
INSERT INTO `comm_shipping_mode` VALUES (2, 'tiger', '顺丰', 'tiger', 1527561854, NULL, NULL, 1, '');
COMMIT;

-- ----------------------------
-- Table structure for comm_stocking
-- ----------------------------
DROP TABLE IF EXISTS `comm_stocking`;
CREATE TABLE `comm_stocking` (
  `stocking_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '备货单ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `stocking_code` char(12) NOT NULL COMMENT '备货单编号',
  `stocking_status` tinyint(1) unsigned NOT NULL COMMENT '备货单状态 0-已创建 1-已提交 10-已作废',
  `sells_code` char(12) NOT NULL COMMENT '销售订单编号',
  `stocking_mark` varchar(64) NOT NULL DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(11) unsigned DEFAULT '0' COMMENT '修改时间',
  `submit_user` char(10) DEFAULT '' COMMENT '提交用户编号',
  `submit_time` int(10) unsigned DEFAULT '0' COMMENT '提交时间',
  PRIMARY KEY (`stocking_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='备货单';

-- ----------------------------
-- Records of comm_stocking
-- ----------------------------
BEGIN;
INSERT INTO `comm_stocking` VALUES (1, 'sy001', 'BH18050004', 10, 'XS18050028', 'XS18050028订单分批备货1', 'sy', 1527472022, 'sy', 1527473893, '', 0);
INSERT INTO `comm_stocking` VALUES (2, 'sy001', 'BH18050005', 1, 'XS18050028', 'XS18050028订单分批备货', 'sy', 1527472504, '', 0, 'sy', 1527476334);
INSERT INTO `comm_stocking` VALUES (3, 'sy001', 'BH18050006', 1, 'XS18050028', 'XS18050028订单分批备货', 'sy', 1527472550, '', 0, 'sy', 1527479550);
INSERT INTO `comm_stocking` VALUES (4, 'sy001', 'BH18050007', 0, 'XS18050028', 'XS18050028订单分批备货', 'sy', 1527472721, '', 0, '', 0);
INSERT INTO `comm_stocking` VALUES (5, 'sy001', 'BH18050008', 0, 'XS18050028', 'XS18050028订单分批备货', 'sy', 1527472768, '', 0, '', 0);
INSERT INTO `comm_stocking` VALUES (6, 'tiger', 'BH18050039', 1, 'XS18050026', 'XS18050026订单分批备货', 'kh', 1527472768, '', 0, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for comm_stocking_detail
-- ----------------------------
DROP TABLE IF EXISTS `comm_stocking_detail`;
CREATE TABLE `comm_stocking_detail` (
  `stocking_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '备货单明细ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL DEFAULT '' COMMENT '编辑用户编号',
  `modify_time` int(11) NOT NULL DEFAULT '0' COMMENT '编辑时间',
  `stocking_id` int(10) unsigned NOT NULL COMMENT '备货单主表ID',
  `sells_id` int(10) unsigned NOT NULL COMMENT '销售订单主表ID',
  `meterial_code` varchar(30) NOT NULL COMMENT '物料编号',
  `stocking_detail_meterial_quantity` decimal(13,5) unsigned NOT NULL COMMENT '物料数量',
  `deliver_detail_meterial_quantity` decimal(13,5) NOT NULL COMMENT '剩余出货数量',
  `warehouse_code` char(10) NOT NULL COMMENT '仓库编号',
  `warehouse_space_code` char(20) NOT NULL DEFAULT '' COMMENT '仓位编号',
  `cargo_space_code` char(20) NOT NULL DEFAULT '' COMMENT '货位编号',
  `batch_mgr_code` varchar(20) NOT NULL DEFAULT '' COMMENT '批次号',
  `seq_code` varchar(20) NOT NULL DEFAULT '' COMMENT '序列号',
  `sells_detail_id` int(10) unsigned NOT NULL COMMENT '销售订单行号',
  PRIMARY KEY (`stocking_detail_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8 COMMENT='备货单-明细';

-- ----------------------------
-- Records of comm_stocking_detail
-- ----------------------------
BEGIN;
INSERT INTO `comm_stocking_detail` VALUES (11, 'sy001', 'sy', 1527472504, '', 0, 2, 22, 'WL0001', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc001', '', 'sc001', 56);
INSERT INTO `comm_stocking_detail` VALUES (12, 'sy001', 'sy', 1527472504, '', 0, 2, 22, 'WL0001', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc001', '', 'sc002', 56);
INSERT INTO `comm_stocking_detail` VALUES (13, 'sy001', 'sy', 1527472504, '', 0, 2, 22, 'WL0001', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc001', '', 'sc003', 56);
INSERT INTO `comm_stocking_detail` VALUES (14, 'sy001', 'sy', 1527472504, '', 0, 2, 22, 'WL0002', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc002', '', 'sc010', 57);
INSERT INTO `comm_stocking_detail` VALUES (15, 'sy001', 'sy', 1527472504, '', 0, 2, 22, 'WL0002', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc002', '', 'sc011', 57);
INSERT INTO `comm_stocking_detail` VALUES (16, 'sy001', 'sy', 1527472550, '', 0, 3, 22, 'WL0001', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc001', '', 'sc001', 56);
INSERT INTO `comm_stocking_detail` VALUES (17, 'sy001', 'sy', 1527472550, '', 0, 3, 22, 'WL0001', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc001', '', 'sc002', 56);
INSERT INTO `comm_stocking_detail` VALUES (18, 'sy001', 'sy', 1527472550, '', 0, 3, 22, 'WL0001', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc001', '', 'sc003', 56);
INSERT INTO `comm_stocking_detail` VALUES (19, 'sy001', 'sy', 1527472550, '', 0, 3, 22, 'WL0002', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc002', '', 'sc010', 57);
INSERT INTO `comm_stocking_detail` VALUES (20, 'sy001', 'sy', 1527472550, '', 0, 3, 22, 'WL0002', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc002', '', 'sc011', 57);
INSERT INTO `comm_stocking_detail` VALUES (21, 'sy001', 'sy', 1527472722, '', 0, 4, 22, 'WL0001', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc001', '', 'sc001', 56);
INSERT INTO `comm_stocking_detail` VALUES (22, 'sy001', 'sy', 1527472722, '', 0, 4, 22, 'WL0001', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc001', '', 'sc002', 56);
INSERT INTO `comm_stocking_detail` VALUES (24, 'sy001', 'sy', 1527472722, '', 0, 4, 22, 'WL0002', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc002', '', 'sc010', 57);
INSERT INTO `comm_stocking_detail` VALUES (25, 'sy001', 'sy', 1527472722, '', 0, 4, 22, 'WL0002', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc002', '', 'sc011', 57);
INSERT INTO `comm_stocking_detail` VALUES (26, 'sy001', 'sy', 1527472768, '', 0, 5, 22, 'WL0001', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc001', '', 'sc001', 56);
INSERT INTO `comm_stocking_detail` VALUES (27, 'sy001', 'sy', 1527472768, '', 0, 5, 22, 'WL0001', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc001', '', 'sc002', 56);
INSERT INTO `comm_stocking_detail` VALUES (29, 'sy001', 'sy', 1527472768, '', 0, 5, 22, 'WL0002', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc002', '', 'sc010', 57);
INSERT INTO `comm_stocking_detail` VALUES (30, 'sy001', 'sy', 1527472768, '', 0, 5, 22, 'WL0002', 1.00000, 0.00000, 'wc001', 'wsc001', 'csc002', '', 'sc011', 57);
INSERT INTO `comm_stocking_detail` VALUES (43, 'sy001', 'sy', 1527473482, '', 0, 1, 22, 'WL0001', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc001', '', 'sc001', 56);
INSERT INTO `comm_stocking_detail` VALUES (44, 'sy001', 'sy', 1527473482, '', 0, 1, 22, 'WL0001', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc001', '', 'sc002', 56);
INSERT INTO `comm_stocking_detail` VALUES (45, 'sy001', 'sy', 1527473482, '', 0, 1, 22, 'WL0002', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc002', '', 'sc010', 57);
INSERT INTO `comm_stocking_detail` VALUES (46, 'sy001', 'sy', 1527473482, '', 0, 1, 22, 'WL0002', 1.00000, 1.00000, 'wc001', 'wsc001', 'csc002', '', 'sc011', 57);
INSERT INTO `comm_stocking_detail` VALUES (47, 'tiger', 'bkh', 1527473482, '', 0, 6, 20, 'WL003', 20.00000, 0.00000, 'wc002', 'wpc001', 'csc001', 'pc001', '', 50);
INSERT INTO `comm_stocking_detail` VALUES (48, 'tiger', 'bkh', 1527473482, '', 0, 6, 20, 'WL004', 10.00000, 0.00000, 'wc002', 'wpc001', 'csc002', 'pc001', '', 51);
COMMIT;

-- ----------------------------
-- Table structure for comm_supplier
-- ----------------------------
DROP TABLE IF EXISTS `comm_supplier`;
CREATE TABLE `comm_supplier` (
  `supplier_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `supplier_code` char(10) NOT NULL COMMENT '供应商编号',
  `supplier_name` varchar(32) NOT NULL COMMENT '供应商公司全称',
  `supplier_alias` varchar(20) NOT NULL COMMENT '供应商简称',
  `supplier_type` tinyint(1) unsigned NOT NULL COMMENT '供应商类型：1-销售公司  2-外采供应商 3-其他',
  `supplier_brand` varchar(45) NOT NULL DEFAULT '' COMMENT '供应商主营品牌',
  `supplier_legal_person` varchar(32) NOT NULL COMMENT '法人',
  `supplier_tax_code` varchar(20) NOT NULL COMMENT '供应商税号',
  `supplier_invoice_address` varchar(45) NOT NULL COMMENT '供应商 开票地址',
  `supplier_account_day` int(10) unsigned NOT NULL COMMENT '供应商 结算日',
  `supplier_bank_name` varchar(50) NOT NULL COMMENT '开户行',
  `supplier_bank_account_name` varchar(20) NOT NULL COMMENT '账号名称',
  `supplier_bank_account_number` varchar(30) NOT NULL COMMENT '银行账号',
  `supplier_tel` varchar(20) NOT NULL COMMENT '供应商电话',
  `supplier_linkman` varchar(20) NOT NULL COMMENT '联系人',
  `supplier_linkman_tel` varchar(20) NOT NULL COMMENT '联系人电话',
  `supplier_status` tinyint(1) unsigned NOT NULL COMMENT '状态 1-正常 2-停用 3-作废',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`supplier_id`) USING BTREE,
  KEY `idx_company_supplier_code` (`company_code`,`supplier_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='供应商';

-- ----------------------------
-- Records of comm_supplier
-- ----------------------------
BEGIN;
INSERT INTO `comm_supplier` VALUES (1, 'tiger', '222111', '小的', '说的', 1, '电热毯', '小爱', '112333', '打得过', 111, '说到底 ', '说的', '172634', '17691224255', '多岁的', '17691224255', 0, 'tiger', 1527563799, '', 0);
INSERT INTO `comm_supplier` VALUES (2, 'tiger', '222111', '小的', '说的', 1, '电热毯', '小爱', '112333', '打得过', 111, '说到底 ', '说的', '172634', '17691224255', '多岁的', '17691224255', 1, 'tiger', 1527564026, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for comm_supplier_balance
-- ----------------------------
DROP TABLE IF EXISTS `comm_supplier_balance`;
CREATE TABLE `comm_supplier_balance` (
  `supplier_balance_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `supplier_code` char(10) NOT NULL COMMENT '供应商编号',
  `supplier_balance_total` decimal(13,5) NOT NULL COMMENT '供应商余额',
  `supplier_balance_lock` decimal(13,5) NOT NULL COMMENT '冻结金额',
  `supplier_balance_available` decimal(13,5) NOT NULL COMMENT '可用金额',
  `supplier_balance_credit` decimal(13,5) NOT NULL COMMENT '信用金额（贷款金额）',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`supplier_balance_id`),
  KEY `idx_company_supplier_code` (`company_code`,`supplier_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='供应商余额表';

-- ----------------------------
-- Table structure for comm_supplier_trade
-- ----------------------------
DROP TABLE IF EXISTS `comm_supplier_trade`;
CREATE TABLE `comm_supplier_trade` (
  `supplier_trade_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_code` char(5) NOT NULL COMMENT '公司账套',
  `supplier_code` char(10) NOT NULL COMMENT '供应商编号',
  `fund_usage_id` int(10) unsigned NOT NULL COMMENT '资金用途(资金用途表id)',
  `supplier_trade_io` tinyint(1) unsigned NOT NULL COMMENT '往来类型  1 -应付 2-预付',
  `supplier_trade_io_type` tinyint(1) unsigned NOT NULL COMMENT '收款类型 1-收 2-付',
  `supplier_trade_io_status` tinyint(1) NOT NULL COMMENT '状态：1-正常 2-冻结 3-反冻结',
  `supplier_trade_src_type` varchar(20) NOT NULL COMMENT '单据来源',
  `supplier_trade_src_code` char(10) NOT NULL COMMENT '单据编号',
  `supplier_trade_time` int(10) unsigned NOT NULL COMMENT '交易时间',
  `supplier_trade_amount` decimal(13,5) NOT NULL COMMENT '金额',
  `supplier_trade_summary` varchar(128) NOT NULL DEFAULT '' COMMENT '摘要',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`supplier_trade_id`),
  KEY `idx_company_supplier_code` (`company_code`,`supplier_code`) USING BTREE,
  KEY `idx_supplier_trade_time` (`supplier_trade_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='供应商交易记录';

-- ----------------------------
-- Records of comm_supplier_trade
-- ----------------------------
BEGIN;
INSERT INTO `comm_supplier_trade` VALUES (1, '4s001', '00000gs001', 5, 2, 2, 1, 'dealer_remittance', 'fukuan0001', 1527328893, 1500000.00000, '打款200万，整车150万，备件50万', 'gs001caiwu', 1527328893);
INSERT INTO `comm_supplier_trade` VALUES (2, '4s001', '00000gs001', 6, 2, 2, 1, 'dealer_remittance', 'fukuan0001', 1527328893, 500000.00000, '打款200万，整车150万，备件50万', 'gs001caiwu', 1527328893);
COMMIT;

-- ----------------------------
-- Table structure for comm_trade
-- ----------------------------
DROP TABLE IF EXISTS `comm_trade`;
CREATE TABLE `comm_trade` (
  `trade_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_code` char(5) NOT NULL COMMENT '公司账套',
  `customer_code` char(10) NOT NULL COMMENT '客户编号',
  `fund_usage_id` int(10) unsigned NOT NULL COMMENT '资金用途(资金用途表id)',
  `trade_io` tinyint(1) unsigned NOT NULL COMMENT '往来类型  1 -应收 2-预收',
  `trade_io_type` tinyint(1) unsigned NOT NULL COMMENT '收款类型 1-收 2-付 ',
  `trade_io_status` tinyint(1) NOT NULL COMMENT '状态：1-正常 2-冻结 3-反冻结',
  `trade_src_type` varchar(20) NOT NULL COMMENT '单据来源',
  `trade_src_code` char(10) NOT NULL COMMENT '单据编号',
  `trade_time` int(10) unsigned NOT NULL COMMENT '交易时间',
  `trade_amount` decimal(13,5) NOT NULL COMMENT '金额',
  `trade_summary` varchar(128) NOT NULL DEFAULT '' COMMENT '摘要',
  `create_user` char(10) NOT NULL COMMENT '创建用户',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`trade_id`),
  KEY `idx_company_customer_code` (`company_code`,`customer_code`) USING BTREE,
  KEY `idx_trade_time` (`trade_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='客户交易记录表';

-- ----------------------------
-- Records of comm_trade
-- ----------------------------
BEGIN;
INSERT INTO `comm_trade` VALUES (1, '4s001', '4s001cus01', 4, 1, 1, 1, 'factory_receipt', 'shoukuan04', 1527318037, 20000.00000, '预收款', '4s001caiwu', 1527318037);
INSERT INTO `comm_trade` VALUES (2, '4s001', '4s001cus01', 1, 1, 1, 1, 'factory_receipt', 'shoukuan03', 1527318206, 50000.00000, '预收款', '4s001caiwu', 1527318206);
INSERT INTO `comm_trade` VALUES (3, '4s001', '4s001cus01', 4, 1, 1, 1, 'factory_receipt', 'shoukuan03', 1527318206, 5000.00000, '预收款', '4s001caiwu', 1527318206);
INSERT INTO `comm_trade` VALUES (4, 'gs001', '4s001_self', 5, 1, 1, 1, 'factory_receipt', 'shoukuan01', 1527328893, 1500000.00000, '打款200万，整车150万，备件50万', 'gs001caiwu', 1527328893);
INSERT INTO `comm_trade` VALUES (5, 'gs001', '4s001_self', 6, 1, 1, 1, 'factory_receipt', 'shoukuan01', 1527328893, 500000.00000, '打款200万，整车150万，备件50万', 'gs001caiwu', 1527328893);
COMMIT;

-- ----------------------------
-- Table structure for inv_io_bills
-- ----------------------------
DROP TABLE IF EXISTS `inv_io_bills`;
CREATE TABLE `inv_io_bills` (
  `io_bills_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '出入库单ID',
  `seq_type_id` int(10) unsigned NOT NULL COMMENT '出入库类型ID',
  `company_code` char(5) NOT NULL COMMENT '账套(源)',
  `io_bills_code` char(12) NOT NULL COMMENT '单据编号(根据seq_type_id对应规则生成)',
  `io_bills_mark` varchar(64) NOT NULL DEFAULT '' COMMENT '单据描述',
  `io_bills_io_time` int(10) unsigned NOT NULL COMMENT '出入库日期',
  `io_bills_status` tinyint(1) unsigned NOT NULL COMMENT '单据状态 0-默认, 1-已提交, 10-已作废',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`io_bills_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='出入库单-主表';

-- ----------------------------
-- Records of inv_io_bills
-- ----------------------------
BEGIN;
INSERT INTO `inv_io_bills` VALUES (1, 6, 'lijix', 'CR18050020', '', 0, 0, 'ljx', 1527321517, '', 0);
INSERT INTO `inv_io_bills` VALUES (2, 6, 'lijix', 'CR18050024', '', 0, 0, 'ljx', 1527321649, '', 0);
INSERT INTO `inv_io_bills` VALUES (3, 6, 'lijix', 'CR18050027', '', 0, 0, 'ljx', 1527321712, '', 0);
INSERT INTO `inv_io_bills` VALUES (4, 6, 'lijix', 'CR18050029', '', 0, 0, 'ljx', 1527321825, '', 0);
INSERT INTO `inv_io_bills` VALUES (5, 6, 'lijix', 'CR18050031', '', 0, 0, 'ljx', 1527321848, '', 0);
INSERT INTO `inv_io_bills` VALUES (6, 6, 'lijix', 'CR18050033', '', 0, 0, 'ljx', 1527321968, '', 0);
INSERT INTO `inv_io_bills` VALUES (7, 6, 'lijix', 'CR18050034', '', 0, 10, 'ljx', 1527321993, 'ljx', 1527323846);
INSERT INTO `inv_io_bills` VALUES (8, 6, 'lijix', 'CR18050036', '', 0, 0, 'ljx', 1527322158, '', 0);
INSERT INTO `inv_io_bills` VALUES (9, 6, 'lijix', 'CR18050037', '', 0, 0, 'ljx', 1527322160, '', 0);
INSERT INTO `inv_io_bills` VALUES (10, 6, 'lijix', 'CR18050038', '', 0, 0, 'ljx', 1527322196, '', 0);
INSERT INTO `inv_io_bills` VALUES (11, 6, 'lijix', 'CR18050039', '', 0, 0, 'ljx', 1527322212, '', 0);
INSERT INTO `inv_io_bills` VALUES (30, 6, 'lijix', 'CR18050058', '', 0, 0, 'ljx', 1527322725, '', 0);
INSERT INTO `inv_io_bills` VALUES (32, 6, 'lijix', 'CR18050073', '', 1527325609, 1, 'ljx', 1527322792, 'ljx', 1527325609);
INSERT INTO `inv_io_bills` VALUES (39, 6, 'lijix', 'CR18050080', '', 1527326882, 1, 'ljx', 1527326882, '', 0);
INSERT INTO `inv_io_bills` VALUES (41, 6, 'lijix', 'CR18050082', '', 1527326985, 1, 'ljx', 1527326985, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for inv_io_bills_detail
-- ----------------------------
DROP TABLE IF EXISTS `inv_io_bills_detail`;
CREATE TABLE `inv_io_bills_detail` (
  `io_bills_detail_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '出入库单明细ID',
  `io_bills_id` int(10) unsigned NOT NULL COMMENT '出入库单ID',
  `shipping_detail_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发运单明细ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `meterial_code` varchar(30) NOT NULL COMMENT '物料编号',
  `io_bills_detail_quantity` decimal(13,5) unsigned DEFAULT NULL COMMENT '物料数量',
  `warehouse_code` char(10) NOT NULL COMMENT '仓库编号(源)',
  `warehouse_code_to` char(10) NOT NULL DEFAULT '' COMMENT '仓库编号(目标)',
  `warehouse_space_code` char(20) NOT NULL DEFAULT '' COMMENT '仓位(源)',
  `warehouse_space_code_to` char(20) NOT NULL DEFAULT '' COMMENT '仓位(目标)',
  `cargo_space_code_to` char(20) NOT NULL DEFAULT '' COMMENT '货位(目标)',
  `batch_mgr_code` char(10) NOT NULL DEFAULT '' COMMENT '批次号',
  `seq_code` varchar(20) NOT NULL DEFAULT '' COMMENT '序列号',
  `io_bills_detail_price` decimal(8,3) unsigned NOT NULL COMMENT '单价',
  `unit_id` int(10) unsigned NOT NULL COMMENT '单位',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`io_bills_detail_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='出入库单-明细表';

-- ----------------------------
-- Records of inv_io_bills_detail
-- ----------------------------
BEGIN;
INSERT INTO `inv_io_bills_detail` VALUES (1, 32, 1, 'lijix', '1111', 1.00000, '', '', '', '', '', '1', '', 66.000, 0, 'ljx', 1527322726, '', 0);
INSERT INTO `inv_io_bills_detail` VALUES (2, 32, 2, 'lijix', '1111', 1.00000, '', '', '', '', '', '1', '', 66.000, 0, 'ljx', 1527322726, '', 0);
INSERT INTO `inv_io_bills_detail` VALUES (16, 39, 1, 'lijix', '1111', 1.00000, '', '', '', '', '', '1', '', 66.000, 1, 'ljx', 1527326882, '', 0);
INSERT INTO `inv_io_bills_detail` VALUES (17, 39, 2, 'lijix', '1111', 1.00000, '', '', '', '', '', '1', '', 66.000, 1, 'ljx', 1527326882, '', 0);
INSERT INTO `inv_io_bills_detail` VALUES (20, 41, 1, 'lijix', '1111', 1.00000, '', '', '', '', '', '1', '', 66.000, 1, 'ljx', 1527326985, '', 0);
INSERT INTO `inv_io_bills_detail` VALUES (21, 41, 2, 'lijix', '1111', 1.00000, '', '', '', '', '', '1', '', 66.000, 1, 'ljx', 1527326985, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for inv_io_type
-- ----------------------------
DROP TABLE IF EXISTS `inv_io_type`;
CREATE TABLE `inv_io_type` (
  `io_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '出入库类型ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `io_type_name` varchar(45) NOT NULL COMMENT '出入库类型名称',
  `io_type_dir` tinyint(1) unsigned NOT NULL COMMENT '出入库类型 0 - 出库, 1-入库, 2-组织内调拨',
  `org_id` int(10) unsigned NOT NULL COMMENT '组织ID',
  `seq_rule_id` int(10) unsigned NOT NULL COMMENT '编号生成规则ID',
  PRIMARY KEY (`io_type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出入库类型表';

-- ----------------------------
-- Table structure for sys_balance
-- ----------------------------
DROP TABLE IF EXISTS `sys_balance`;
CREATE TABLE `sys_balance` (
  `balance_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `customer_code` char(10) NOT NULL COMMENT '客户编号',
  `fund_usage_type` tinyint(1) unsigned NOT NULL COMMENT '资金用途(类型)  0-通用 1-整车 2-备件 3-保证金',
  `balance_total` decimal(13,5) NOT NULL COMMENT '客户余额',
  `balance_lock` decimal(13,5) NOT NULL COMMENT '冻结金额',
  `balance_available` decimal(13,5) NOT NULL COMMENT '可用金额',
  `balance_credit` decimal(13,5) NOT NULL COMMENT '信用金额（贷款金额）',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) NOT NULL COMMENT '修改用户编号',
  `modify_time` int(10) unsigned NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`balance_id`),
  KEY `idx_company_customer_code` (`company_code`,`customer_code`,`fund_usage_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='客户余额表';

-- ----------------------------
-- Records of sys_balance
-- ----------------------------
BEGIN;
INSERT INTO `sys_balance` VALUES (1, '4s001', '4s001cus01', 0, 80000.00000, 0.00000, 80000.00000, 0.00000, 'liquan', 1527217214, '4s001caiwu', 1527318206);
INSERT INTO `sys_balance` VALUES (2, 'gs001', '4s001_self', 1, 1500000.00000, 0.00000, 1500000.00000, 0.00000, 'gs001caiwu', 1527328893, 'gs001caiwu', 1527328893);
INSERT INTO `sys_balance` VALUES (3, 'gs001', '4s001_self', 2, 500000.00000, 0.00000, 500000.00000, 0.00000, 'gs001caiwu', 1527328893, 'gs001caiwu', 1527328893);
COMMIT;

-- ----------------------------
-- Table structure for sys_company
-- ----------------------------
DROP TABLE IF EXISTS `sys_company`;
CREATE TABLE `sys_company` (
  `company_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '公司ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `company_name` varchar(32) NOT NULL COMMENT '公司全称',
  `company_alias` varchar(45) NOT NULL COMMENT '公司简称',
  `company_type` tinyint(1) unsigned NOT NULL COMMENT '公司类型 0-4s,1-整车厂,2-服务站,3-虚拟公司',
  `company_logo` varchar(128) NOT NULL DEFAULT '' COMMENT '公司徽标地址',
  `company_tax_code` varchar(20) NOT NULL DEFAULT '' COMMENT '公司税号',
  `company_address` varchar(128) NOT NULL DEFAULT '' COMMENT '公司注册地址',
  `company_tel` varchar(45) NOT NULL DEFAULT '' COMMENT '联系电话',
  `company_legal_person` varchar(45) NOT NULL DEFAULT '' COMMENT '公司法人',
  `company_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1正常 2停用 3作废',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(11) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`company_id`) USING BTREE,
  UNIQUE KEY `company_code_UNIQUE` (`company_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='公司';

-- ----------------------------
-- Records of sys_company
-- ----------------------------
BEGIN;
INSERT INTO `sys_company` VALUES (1, 'tiger', 'tiger', '', 0, '', '', '', '', '', 1, '', 0, '', 0);
INSERT INTO `sys_company` VALUES (3, 'ldh', '李虎', '李', 1, '', '', '', '', '', 1, 'tiger', 1526873376, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `config_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `config_key` varchar(32) NOT NULL COMMENT '配置名',
  `config_value` varchar(128) NOT NULL DEFAULT '' COMMENT '配置值',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='系统配置表';

-- ----------------------------
-- Records of sys_config
-- ----------------------------
BEGIN;
INSERT INTO `sys_config` VALUES (1, '12345', 'test', 'test1112');
INSERT INTO `sys_config` VALUES (2, '12345', 'test', 'test');
INSERT INTO `sys_config` VALUES (3, '12345', 'test', 'test');
INSERT INTO `sys_config` VALUES (4, '12345', 'test', 'test');
INSERT INTO `sys_config` VALUES (5, '12345', 'test', 'test');
INSERT INTO `sys_config` VALUES (6, '12345', 'test', 'test');
INSERT INTO `sys_config` VALUES (7, '12345', 'test', 'test');
INSERT INTO `sys_config` VALUES (8, '12345', 'test', 'test');
INSERT INTO `sys_config` VALUES (9, '12345', 'test', 'test1112');
COMMIT;

-- ----------------------------
-- Table structure for sys_customer
-- ----------------------------
DROP TABLE IF EXISTS `sys_customer`;
CREATE TABLE `sys_customer` (
  `customer_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '客户ID',
  `company_code` char(5) NOT NULL COMMENT '账套（上级公司的账套）',
  `customer_code` char(10) NOT NULL COMMENT '客户编号',
  `customer_name` varchar(45) NOT NULL COMMENT '客户名称',
  `customer_nickname` varchar(45) NOT NULL COMMENT '客户简称',
  `customer_type` tinyint(1) unsigned NOT NULL COMMENT '客户类型 1-普通客户，2-经销商， 3-其他',
  `customer_level` tinyint(1) unsigned NOT NULL COMMENT '客户级别',
  `customer_ref_company_code` char(5) NOT NULL DEFAULT '' COMMENT '关联账套（客户自己的账套，只有客户类型为4S店时才有值）',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(11) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`customer_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='客户表';

-- ----------------------------
-- Records of sys_customer
-- ----------------------------
BEGIN;
INSERT INTO `sys_customer` VALUES (1, '', 'ldh', '', '', 1, 0, '', '', 0, '', 0);
INSERT INTO `sys_customer` VALUES (2, 'gs001', '4s001_self', '4S店1', '4S店1', 2, 1, '4s001', 'liquan', 1527129186, 'liquan', 1527129186);
INSERT INTO `sys_customer` VALUES (3, '4s001', '4s001cus01', '4S店1客户01', '客户01', 1, 0, '', 'liquan', 1527129186, 'liquan', 1527129186);
COMMIT;

-- ----------------------------
-- Table structure for sys_customer_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_customer_group`;
CREATE TABLE `sys_customer_group` (
  `customer_group_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '客户组ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `customer_group_pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '客户组父ID',
  `customer_group_name` varchar(45) NOT NULL COMMENT '客户组名称',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(11) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`customer_group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户组';

-- ----------------------------
-- Table structure for sys_customer_s360
-- ----------------------------
DROP TABLE IF EXISTS `sys_customer_s360`;
CREATE TABLE `sys_customer_s360` (
  `customer_s360_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `customer_s360_code` char(10) NOT NULL COMMENT 'S360经销商编号',
  `customer_s360_name` varchar(45) NOT NULL COMMENT 'S360经销商简称',
  `customer_s360_no` char(24) NOT NULL COMMENT 'S360经销商号码',
  `owner_company_code` char(8) NOT NULL COMMENT '账套(4S店)',
  `company_code` char(5) NOT NULL COMMENT '账套（4s店对应的主机厂）',
  PRIMARY KEY (`customer_s360_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='DMS经销商与360经销商对应表';

-- ----------------------------
-- Table structure for sys_field_option_dic
-- ----------------------------
DROP TABLE IF EXISTS `sys_field_option_dic`;
CREATE TABLE `sys_field_option_dic` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `func_code` varchar(20) NOT NULL COMMENT '功能编号，如org_list',
  `field_name` varchar(32) NOT NULL COMMENT '字段名，如sex',
  `option` text NOT NULL COMMENT '该字段所有枚举值（json串形式），形如{"1":"正常","2":"停用","3":"作废"}',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `func_code` (`func_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='字段枚举值字典表（系统维护）';

-- ----------------------------
-- Records of sys_field_option_dic
-- ----------------------------
BEGIN;
INSERT INTO `sys_field_option_dic` VALUES (1, 'org_list', 'org_status', '{\"1\":\"正常\",\"2\":\"停用\",\"3\":\"作废\"}');
INSERT INTO `sys_field_option_dic` VALUES (2, 'role_list', 'role_status', '{\"1\":\"正常\",\"2\":\"停用\",\"3\":\"作废\"}');
INSERT INTO `sys_field_option_dic` VALUES (3, 'user_list', 'user_status', '{\"1\":\"正常\",\"2\":\"停用\",\"3\":\"作废\"}');
INSERT INTO `sys_field_option_dic` VALUES (4, 'user_list', 'user_gender', '{\"0\":\"未知\",\"1\":\"男\",\"2\":\"女\"}');
INSERT INTO `sys_field_option_dic` VALUES (5, '4s_fund_usage_list', 'fund_usage_status', '{\"1\":\"启用\",\"2\":\"停用\",\"3\":\"作废\"}');
COMMIT;

-- ----------------------------
-- Table structure for sys_func
-- ----------------------------
DROP TABLE IF EXISTS `sys_func`;
CREATE TABLE `sys_func` (
  `func_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '功能ID',
  `func_code` varchar(20) NOT NULL COMMENT '功能编号',
  `func_name` varchar(45) NOT NULL COMMENT '功能名称',
  `func_type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '权限类型：1-仅做菜单 2-视图权限，3-操作权限',
  `func_router` varchar(128) NOT NULL DEFAULT '' COMMENT '功能路由、前端路由（moduleName/className/funcName）',
  `func_parent` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父级功能ID',
  `func_db` varchar(64) NOT NULL DEFAULT '' COMMENT '功能对应数据库表名称',
  `func_icon` varchar(50) DEFAULT '' COMMENT '图标class',
  `func_remark` varchar(255) DEFAULT '' COMMENT '功能备注',
  `func_extra` text COMMENT '该功能涉及所有字段（json串形式且全量展示），形式为[{"field":"company_code","name":"账套","sort":2,"type":"text","go_detail":2,"is_header_show":2,"now_data_url":"","next_data_url":"","match":"","need_validate":"1"}]',
  `func_owner` tinyint(1) unsigned NOT NULL COMMENT '权限归属 1-主机厂 2-4s店',
  PRIMARY KEY (`func_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='功能集合表（系统维护）';

-- ----------------------------
-- Records of sys_func
-- ----------------------------
BEGIN;
INSERT INTO `sys_func` VALUES (1, 'system_manage', '系统管理', 1, '', 0, '', '', '系统管理一级菜单', NULL, 1);
INSERT INTO `sys_func` VALUES (2, 'system_config', '系统设置', 1, '', 1, '', '', '系统管理二级菜单', NULL, 1);
INSERT INTO `sys_func` VALUES (3, 'org_list', '组织架构', 2, 'system/Org/Index', 2, 'sys_org', '', '组织架构列表', '[{\"field\":\"org_id\",\"name\":\"组织ID\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"company_code\",\"name\":\"账套\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"1\"},{\"field\":\"org_pid\",\"name\":\"组织父ID\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"org_name\",\"name\":\"组织名称\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"org_simplify_name\",\"name\":\"组织简称\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"org_status\",\"name\":\"组织状态\",\"sort\":\"1\",\"type\":\"select\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"org_describe\",\"name\":\"组织描述\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_user\",\"name\":\"创建人\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_time\",\"name\":\"创建时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"}]', 1);
INSERT INTO `sys_func` VALUES (4, 'org_add', '新增组织', 3, 'system/Org/Add', 3, 'sys_org', '', '新增组织', NULL, 1);
INSERT INTO `sys_func` VALUES (5, 'org_edit', '编辑组织', 3, 'system/Org/Edit', 3, 'sys_org', '', '更新组织', NULL, 1);
INSERT INTO `sys_func` VALUES (6, 'org_delete', '删除组织', 3, 'system/Org/Delete', 3, 'sys_org', '', '删除组织', NULL, 1);
INSERT INTO `sys_func` VALUES (7, 'job_list', '职务设置', 2, 'system/Job/Index', 2, '', '', '职务列表', '[{\"field\":\"job_id\",\"name\":\"职务ID\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"company_code\",\"name\":\"账套\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"1\"},{\"field\":\"job_name\",\"name\":\"职务名称\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"job_status\",\"name\":\"职务状态\",\"sort\":\"1\",\"type\":\"select\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_user\",\"name\":\"创建人\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_time\",\"name\":\"创建时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"modify_user\",\"name\":\"修改人\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"modify_time\",\"name\":\"修改时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"}]', 1);
INSERT INTO `sys_func` VALUES (8, 'role_list', '角色设置', 2, 'system/Role/index', 2, 'sys_role', '', '职务列表', '[{\"field\":\"role_id\",\"name\":\"角色ID\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"company_code\",\"name\":\"账套\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"1\"},{\"field\":\"role_name\",\"name\":\"角色名称\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"role_status\",\"name\":\"角色状态\",\"sort\":\"1\",\"type\":\"select\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"role_desc\",\"name\":\"角色描述\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_user\",\"name\":\"创建人\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_time\",\"name\":\"创建时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"modify_user\",\"name\":\"修改人\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"modify_time\",\"name\":\"修改时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"}]', 1);
INSERT INTO `sys_func` VALUES (9, 'user_list', '用户设置', 2, 'system/User/index', 2, 'sys_user', '', '用户列表', '[{\"field\":\"user_id\",\"name\":\"用户ID\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_code\",\"name\":\"用户编号\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"def_company_code\",\"name\":\"默认账套\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"1\"},{\"field\":\"user_password\",\"name\":\"密码\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_status\",\"name\":\"用户状态\",\"sort\":\"1\",\"type\":\"select\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_job_id\",\"name\":\"用户职务id\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_job_name\",\"name\":\"职务名称\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_org_id\",\"name\":\"用户所属组织id\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_org_name\",\"name\":\"组织名称\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_realname\",\"name\":\"用户姓名\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_gender\",\"name\":\"性别\",\"sort\":\"1\",\"type\":\"select\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_phone\",\"name\":\"手机\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_tel\",\"name\":\"固定电话\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_email\",\"name\":\"邮箱\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_last_time\",\"name\":\"最后登陆时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"is_super\",\"name\":\"是否超级管理员\",\"sort\":\"2\",\"type\":\"select\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_user\",\"name\":\"创建人\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_time\",\"name\":\"创建时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"modify_user\",\"name\":\"修改人\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"modify_time\",\"name\":\"修改时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"user_remark\",\"name\":\"备注\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"}]', 1);
INSERT INTO `sys_func` VALUES (10, '4s_finance_manage', '财务管理', 1, '', 0, '', '', '经销商财务管理', '', 2);
INSERT INTO `sys_func` VALUES (11, '4s_fund_usage_list', '资金用途列表', 2, 'account/FundUsage/List', 10, 'base_fund_usage', '', '', '[{\"field\":\"fund_usage_id\",\"name\":\"资金用途ID\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"company_code\",\"name\":\"账套\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"1\"},{\"field\":\"fund_usage_name\",\"name\":\"资金用途名称\",\"sort\":\"1\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"fund_usage_type\",\"name\":\"业务类型\",\"sort\":\"1\",\"type\":\"select\",\"go_detail\":\"2\",\"is_header_show\":\"2\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"fund_usage_status\",\"name\":\"资金用途状态\",\"sort\":\"1\",\"type\":\"select\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_user\",\"name\":\"创建人\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"create_time\",\"name\":\"创建时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"modify_user\",\"name\":\"修改人\",\"sort\":\"2\",\"type\":\"text\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"},{\"field\":\"modify_time\",\"name\":\"修改时间\",\"sort\":\"1\",\"type\":\"datetime\",\"go_detail\":\"2\",\"is_header_show\":\"1\",\"now_data_url\":\"\",\"next_data_url\":\"\",\"match\":\"\",\"need_validate\":\"2\"}]', 2);
INSERT INTO `sys_func` VALUES (12, '4s_fund_usage_add', '新增资金用途', 3, 'account/FundUsage/Add', 11, 'base_fund_usage', '', '', '', 2);
INSERT INTO `sys_func` VALUES (13, '4s_fund_usage_edit', '资金用途编辑', 3, 'account/FundUsage/Edit', 11, 'base_fund_usage', '', '', NULL, 0);
INSERT INTO `sys_func` VALUES (14, 'org_enable', '启用组织', 3, 'system/Org/Enable', 3, 'sys_org', '', '启用组织', '', 1);
INSERT INTO `sys_func` VALUES (15, 'org_disable', '停用组织', 3, 'system/Org/Disable', 3, 'sys_org', '', '停用组织', '', 1);
INSERT INTO `sys_func` VALUES (16, 'job_add', '新增职务', 3, 'system/Job/Add', 7, '', '', '新增职务', '', 1);
INSERT INTO `sys_func` VALUES (17, 'job_edit', '编辑职务', 3, 'system/Job/Edit', 7, '', '', '编辑职务', '', 1);
INSERT INTO `sys_func` VALUES (18, 'job_get', '获取职务详情', 3, 'system/Job/GetJobDetail', 7, '', '', '获取职务详情', '', 1);
INSERT INTO `sys_func` VALUES (19, 'job_enable', '启用职务', 3, 'system/Job/Enable', 7, '', '', '启用职务', '', 1);
INSERT INTO `sys_func` VALUES (20, 'job_disable', '停用职务', 3, 'system/Job/Disable', 7, '', '', '停用职务', '', 1);
INSERT INTO `sys_func` VALUES (21, 'job_discard', '作废职务', 3, 'system/Job/Discard', 7, '', '', '作废职务', '', 1);
INSERT INTO `sys_func` VALUES (22, 'org_get', '获取组织详情', 3, 'system/Org/Get', 3, 'sys_org', '', '获取组织详情', '', 1);
INSERT INTO `sys_func` VALUES (23, 'role_add', '新增角色', 3, 'system/Role/Add', 8, 'sys_role', '', '新增角色', NULL, 1);
INSERT INTO `sys_func` VALUES (24, 'role_edit', '编辑角色', 3, 'system/Role/Edit', 8, 'sys_role', '', '编辑角色', '', 1);
INSERT INTO `sys_func` VALUES (25, 'role_get', '获取角色详情', 3, 'system/Role/GetRoleDetail', 8, 'sys_role', '', '获取角色详情', '', 1);
INSERT INTO `sys_func` VALUES (26, 'role_enable', '启用角色', 3, 'system/Role/Enable', 8, 'sys_role', '', '启用角色', '', 1);
INSERT INTO `sys_func` VALUES (27, 'role_disable', '停用角色', 3, 'system/Role/Disable', 8, 'sys_role', '', '停用角色', '', 1);
INSERT INTO `sys_func` VALUES (28, 'role_discard', '作废角色', 3, 'system/Role/Discard', 8, 'sys_role', '', '作废角色', '', 1);
INSERT INTO `sys_func` VALUES (29, 'user_add', '新增用户', 3, 'system/User/Add', 9, 'sys_user', '', '新增用户', NULL, 1);
INSERT INTO `sys_func` VALUES (30, 'user_edit', '编辑用户', 3, 'system/User/Edit', 9, 'sys_user', '', '编辑用户', '', 1);
INSERT INTO `sys_func` VALUES (31, 'user_get', '获取用户详情', 3, 'system/User/GetUserDetail', 9, 'sys_user', '', '获取用户详情', '', 1);
INSERT INTO `sys_func` VALUES (32, 'user_enable', '启用用户', 3, 'system/User/Enable', 9, 'sys_user', '', '启用用户', '', 1);
INSERT INTO `sys_func` VALUES (33, 'user_disable', '停用用户', 3, 'system/User/Disable', 9, 'sys_user', '', '停用用户', '', 1);
INSERT INTO `sys_func` VALUES (34, 'user_discard', '作废用户', 3, 'system/User/Discard', 9, 'sys_user', '', '作废用户', '', 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job` (
  `job_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '职务ID',
  `company_code` char(5) NOT NULL DEFAULT '' COMMENT '账套',
  `job_name` varchar(45) NOT NULL COMMENT '职务名称',
  `job_desc` varchar(255) NOT NULL DEFAULT '' COMMENT '职务描述',
  `job_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '职务状态 1正常 2停用 3作废',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COMMENT='职务表';

-- ----------------------------
-- Records of sys_job
-- ----------------------------
BEGIN;
INSERT INTO `sys_job` VALUES (1, '1', '牛志伟测试专用职务', '请勿删改', 1, '', 0, '', 0);
INSERT INTO `sys_job` VALUES (2, '1', '牛志伟测试专用职务2', '请勿删改', 1, '', 0, '', 0);
INSERT INTO `sys_job` VALUES (7, '1', '牛志伟测试职务2', '牛志伟测试职务3', 1, 'nzw', 1526870091, 'nzw', 1526870382);
INSERT INTO `sys_job` VALUES (8, '1', '牛志伟测试职务1', '牛志伟测试职务1', 1, 'nzw', 1526871130, '', 0);
INSERT INTO `sys_job` VALUES (9, 'tiger', '大堂经理', '压岁啦', 1, 'apidev1234', 1527148969, 'apidev1234', 1527577318);
INSERT INTO `sys_job` VALUES (10, 'tiger', '扫地', '', 1, 'apidev1234', 1527149292, 'apidev1234', 1527577206);
INSERT INTO `sys_job` VALUES (11, 'tiger', '奥术大师多', '', 1, 'apidev1234', 1527149897, 'apidev1234', 1527234263);
INSERT INTO `sys_job` VALUES (12, 'tiger', '测试', '两个职务都选了', 1, 'apidev1234', 1527154846, 'apidev1234', 1527578432);
INSERT INTO `sys_job` VALUES (13, 'tiger', '11111111', '', 1, 'apidev1234', 1527155177, 'apidev1234', 1527234278);
INSERT INTO `sys_job` VALUES (14, 'tiger', '111-》222', '哈哈', 1, 'apidev1234', 1527157794, 'apidev1234', 1527236310);
INSERT INTO `sys_job` VALUES (15, 'tiger', '铲屎官', '', 1, 'apidev1234', 1527157983, '', 0);
INSERT INTO `sys_job` VALUES (16, 'tiger', '哈哈啊区', '去去去', 1, 'apidev1234', 1527159097, 'apidev1234', 1527234078);
INSERT INTO `sys_job` VALUES (17, 'tiger', 'new', 'xinzeng ', 1, 'apidev1234', 1527235521, '', 0);
INSERT INTO `sys_job` VALUES (18, 'tiger', 'qqq', '', 1, 'apidev1234', 1527236839, 'apidev1234', 1527577340);
INSERT INTO `sys_job` VALUES (19, 'tiger', 'q', '', 1, 'apidev1234', 1527236901, 'apidev1234', 1527236915);
INSERT INTO `sys_job` VALUES (20, 'tiger', 't', '', 2, 'apidev1234', 1527237708, '', 0);
INSERT INTO `sys_job` VALUES (21, 'tiger', '大触', 'lalala', 2, 'apidev1234', 1527475805, '', 0);
INSERT INTO `sys_job` VALUES (22, 'tiger', '啦啦', '', 2, 'apidev1234', 1527475927, '', 0);
INSERT INTO `sys_job` VALUES (23, 'tiger', '号外', '', 2, 'apidev1234', 1527476004, '', 0);
INSERT INTO `sys_job` VALUES (24, 'tiger', '客服', '', 2, 'apidev1234', 1527476114, '', 0);
INSERT INTO `sys_job` VALUES (25, 'tiger', '1', 'dwqdwq', 2, 'apidev1234', 1527574740, 'apidev1234', 1527574761);
COMMIT;

-- ----------------------------
-- Table structure for sys_job_duty
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_duty`;
CREATE TABLE `sys_job_duty` (
  `duty_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '职责ID',
  `duty_name` varchar(45) NOT NULL COMMENT '职责名称',
  `duty_desc` varchar(64) NOT NULL DEFAULT '' COMMENT '职责描述',
  PRIMARY KEY (`duty_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='职务职责表';

-- ----------------------------
-- Records of sys_job_duty
-- ----------------------------
BEGIN;
INSERT INTO `sys_job_duty` VALUES (1, '牛志伟测试专用职责', '请勿删改');
INSERT INTO `sys_job_duty` VALUES (2, '牛志伟测试专用职责2', '请勿删改');
COMMIT;

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
  `notice_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `notice_content` text NOT NULL COMMENT '通知内容',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='通知消息表';

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
BEGIN;
INSERT INTO `sys_notice` VALUES (1, 'tiger', 'testate', 'tiger', 1526435249);
COMMIT;

-- ----------------------------
-- Table structure for sys_order_entity
-- ----------------------------
DROP TABLE IF EXISTS `sys_order_entity`;
CREATE TABLE `sys_order_entity` (
  `order_entity_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '实体单据ID',
  `order_entity_code` varchar(32) NOT NULL COMMENT '实体单据编号-表英文名称',
  `order_entity_name` varchar(32) NOT NULL COMMENT '实体单据名称-表中文名称',
  `order_entity_mark` varchar(255) NOT NULL COMMENT '实体单据描述-用途说明',
  PRIMARY KEY (`order_entity_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='实体单据(系统维护)';

-- ----------------------------
-- Records of sys_order_entity
-- ----------------------------
BEGIN;
INSERT INTO `sys_order_entity` VALUES (1, 'comm_remittance', '打款表', '承载：打款单');
INSERT INTO `sys_order_entity` VALUES (2, 'comm_receipt', '收款表', '承载：收款单');
INSERT INTO `sys_order_entity` VALUES (3, 'comm_sells', '销售订单', '承载：销售订单');
INSERT INTO `sys_order_entity` VALUES (4, 'comm_deliver', '出库单', '承载：出库单');
INSERT INTO `sys_order_entity` VALUES (6, 'comm_output', '其他出入库-出库单', '承载：其他出入库-出库单');
INSERT INTO `sys_order_entity` VALUES (7, 'comm_input', '其他出入库-入库单', '承载：其他出入库-入库单');
INSERT INTO `sys_order_entity` VALUES (8, 'comm_stocking', '备货单', '承载：备货单');
COMMIT;

-- ----------------------------
-- Table structure for sys_order_entity_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_order_entity_type`;
CREATE TABLE `sys_order_entity_type` (
  `order_entity_type_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '单据实体类型ID',
  `order_entity_type_code` varchar(20) NOT NULL COMMENT '单据实体类型编号',
  `order_entity_id` int(11) unsigned NOT NULL COMMENT '单据实体ID',
  `order_entity_type_name` varchar(32) NOT NULL COMMENT '单据实体类型名称',
  `order_entity_type_mark` varchar(255) NOT NULL COMMENT '单据实体类型描述',
  `order_entity_type_support_ext` tinyint(1) unsigned NOT NULL COMMENT '是否支持扩展',
  PRIMARY KEY (`order_entity_type_id`) USING BTREE,
  UNIQUE KEY `idx_order_entity_type_code` (`order_entity_type_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='实体单据类型(系统维护)';

-- ----------------------------
-- Records of sys_order_entity_type
-- ----------------------------
BEGIN;
INSERT INTO `sys_order_entity_type` VALUES (1, 'dealer_remittance', 1, '付款单', '经销商付款给销售公司', 1);
INSERT INTO `sys_order_entity_type` VALUES (2, 'factory_receipt', 1, '收款单', '销售公司收经销商的付款', 1);
INSERT INTO `sys_order_entity_type` VALUES (3, 'dealer_factory', 3, '销售订单', '销售订单', 1);
INSERT INTO `sys_order_entity_type` VALUES (4, 'comm_deliver', 4, '出库单', '出库单', 1);
INSERT INTO `sys_order_entity_type` VALUES (10, 'input_purchase', 7, '采购入库单', '其他出入库-采购入库', 1);
INSERT INTO `sys_order_entity_type` VALUES (11, 'factory_dealer', 8, '备货单', '备货单', 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_org
-- ----------------------------
DROP TABLE IF EXISTS `sys_org`;
CREATE TABLE `sys_org` (
  `org_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '组织ID',
  `company_code` char(5) NOT NULL DEFAULT '' COMMENT '账套',
  `org_pid` int(10) unsigned NOT NULL COMMENT '组织父ID',
  `org_name` varchar(45) NOT NULL DEFAULT '' COMMENT '组织名称',
  `org_simplify_name` varchar(45) NOT NULL DEFAULT '' COMMENT '组织简称',
  `org_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '组织状态 1正常 2停用 3作废',
  `org_describe` varchar(100) NOT NULL DEFAULT '' COMMENT '组织描述',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`org_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='组织';

-- ----------------------------
-- Records of sys_org
-- ----------------------------
BEGIN;
INSERT INTO `sys_org` VALUES (1, 'tiger', 0, '业务部门', '业务', 1, '', 'tiger', 1525856083);
INSERT INTO `sys_org` VALUES (2, 'tiger', 1, '销售部门', '销售', 1, '这不是描述哈哈哈哈', 'tiger', 1525856108);
INSERT INTO `sys_org` VALUES (3, 'tiger', 2, '后期部门', '后期', 1, '这是描述', 'tiger', 1525860489);
INSERT INTO `sys_org` VALUES (4, 'tiger', 3, '维修部门', '维修', 1, '这是描述', 'tiger', 1525860541);
INSERT INTO `sys_org` VALUES (5, 'tiger', 4, '保养部门', '保养', 1, '这是描述', 'tiger', 1525860610);
INSERT INTO `sys_org` VALUES (6, 'tiger', 4, '财务部门', '会计', 1, '这不是描述哈哈哈哈', 'tiger', 1525860668);
INSERT INTO `sys_org` VALUES (7, 'tiger', 1, '建材部门', '建材', 1, '这是描述', 'tiger', 1525860668);
INSERT INTO `sys_org` VALUES (8, 'tiger', 3, '上门部门', '上门', 1, '这是描述', 'tiger', 1525936419);
INSERT INTO `sys_org` VALUES (9, 'tiger', 3, '上门部门', '', 3, '这是描述', '12345', 1526031599);
COMMIT;

-- ----------------------------
-- Table structure for sys_rel_company
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_company`;
CREATE TABLE `sys_rel_company` (
  `company_code_down` char(5) DEFAULT NULL,
  `company_code_up` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公司关系(暂时不用)';

-- ----------------------------
-- Table structure for sys_rel_company_customer
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_company_customer`;
CREATE TABLE `sys_rel_company_customer` (
  `company_code` char(5) NOT NULL COMMENT '账套(销售公司)',
  `customer_code` char(10) NOT NULL COMMENT '客户编号（4s店)',
  PRIMARY KEY (`company_code`,`customer_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='销售公司-客户(4s店)关系表';

-- ----------------------------
-- Table structure for sys_rel_company_func
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_company_func`;
CREATE TABLE `sys_rel_company_func` (
  `company_code` char(5) NOT NULL COMMENT '账套',
  `func_id` int(10) unsigned NOT NULL COMMENT '功能id（sys_func表主键）',
  PRIMARY KEY (`company_code`,`func_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公司-功能关系表（暂时不用）';

-- ----------------------------
-- Table structure for sys_rel_company_sellregion
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_company_sellregion`;
CREATE TABLE `sys_rel_company_sellregion` (
  `company_region_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '公司-销售区域关系id',
  `sell_region_id` int(10) unsigned NOT NULL COMMENT '销售区域id',
  `company_code` char(5) NOT NULL DEFAULT '' COMMENT '账套',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(11) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(11) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`company_region_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公司-销售区域关系表';

-- ----------------------------
-- Table structure for sys_rel_customer_address
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_customer_address`;
CREATE TABLE `sys_rel_customer_address` (
  `customer_id` int(10) unsigned NOT NULL COMMENT '客户ID',
  `address_id` int(10) unsigned NOT NULL COMMENT '地址ID',
  PRIMARY KEY (`customer_id`,`address_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户-地址关系';

-- ----------------------------
-- Records of sys_rel_customer_address
-- ----------------------------
BEGIN;
INSERT INTO `sys_rel_customer_address` VALUES (1234, 7);
INSERT INTO `sys_rel_customer_address` VALUES (1234, 8);
INSERT INTO `sys_rel_customer_address` VALUES (1234, 9);
INSERT INTO `sys_rel_customer_address` VALUES (1234, 14);
COMMIT;

-- ----------------------------
-- Table structure for sys_rel_job_duty
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_job_duty`;
CREATE TABLE `sys_rel_job_duty` (
  `job_id` int(11) unsigned NOT NULL COMMENT '职务id',
  `duty_id` int(11) NOT NULL COMMENT '职责id',
  `company_code` char(5) NOT NULL COMMENT '账套',
  PRIMARY KEY (`job_id`,`duty_id`,`company_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='职务-职责关系表';

-- ----------------------------
-- Records of sys_rel_job_duty
-- ----------------------------
BEGIN;
INSERT INTO `sys_rel_job_duty` VALUES (1, 1, '1');
INSERT INTO `sys_rel_job_duty` VALUES (1, 2, '1');
INSERT INTO `sys_rel_job_duty` VALUES (2, 1, '1');
INSERT INTO `sys_rel_job_duty` VALUES (2, 2, '1');
INSERT INTO `sys_rel_job_duty` VALUES (7, 1, '1');
INSERT INTO `sys_rel_job_duty` VALUES (7, 2, '1');
INSERT INTO `sys_rel_job_duty` VALUES (7, 3, '1');
INSERT INTO `sys_rel_job_duty` VALUES (8, 1, '1');
INSERT INTO `sys_rel_job_duty` VALUES (8, 2, '1');
INSERT INTO `sys_rel_job_duty` VALUES (9, 0, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (9, 2, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (10, 12, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (11, 1, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (12, 1, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (12, 2, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (13, 1, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (14, 1, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (14, 2, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (15, 2, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (16, 1, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (17, 1, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (21, 2, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (22, 2, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (23, 2, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (24, 2, 'tiger');
INSERT INTO `sys_rel_job_duty` VALUES (25, 1, 'tiger');
COMMIT;

-- ----------------------------
-- Table structure for sys_rel_notice_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_notice_user`;
CREATE TABLE `sys_rel_notice_user` (
  `rel_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `notice_id` int(10) unsigned NOT NULL COMMENT '通知消息表主键id（sys_notice）',
  `accpeter_user_code` char(10) NOT NULL COMMENT '接收方用户编号',
  `accpeter_company_code` char(5) NOT NULL COMMENT '接收方账套',
  `read_status` tinyint(2) unsigned NOT NULL DEFAULT '10' COMMENT '通知阅读状态（10未读 20已读）',
  `create_user` char(10) NOT NULL COMMENT '创建者|发送者用户编号',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`rel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='通知消息与用户关系表';

-- ----------------------------
-- Records of sys_rel_notice_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_rel_notice_user` VALUES (2, 1, 'tiger', 'tiger', 10, 'tiger', 1526435677);
COMMIT;

-- ----------------------------
-- Table structure for sys_rel_notice_user_company
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_notice_user_company`;
CREATE TABLE `sys_rel_notice_user_company` (
  `rel_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `notice_id` int(10) unsigned NOT NULL COMMENT '通知消息表主键id（sys_notice）',
  `accpeter_user_code` char(10) NOT NULL COMMENT '接收方用户编号',
  `accpeter_company_code` char(5) NOT NULL COMMENT '接收方账套',
  `read_status` tinyint(2) unsigned NOT NULL DEFAULT '10' COMMENT '通知阅读状态（10未读 20已读）',
  `create_user` char(10) NOT NULL COMMENT '创建者|发送者用户编号',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`rel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='通知消息与用户关系表，该表与（sys_rel_notice_user）相同，原因此表数据量较大未来可维护。';

-- ----------------------------
-- Records of sys_rel_notice_user_company
-- ----------------------------
BEGIN;
INSERT INTO `sys_rel_notice_user_company` VALUES (1, 1, 'tiger', '', 20, 'tiger', 1526435139);
INSERT INTO `sys_rel_notice_user_company` VALUES (2, 1, 'tiger', 'tiger', 10, 'tiger', 1526435709);
COMMIT;

-- ----------------------------
-- Table structure for sys_rel_role_func
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_role_func`;
CREATE TABLE `sys_rel_role_func` (
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  `func_code` varchar(20) NOT NULL COMMENT '功能编号',
  `func_configed_params` text NOT NULL COMMENT '字段权限配置（无权限的字段不记录） 1可读可写  2只读，形式为json{"field1":1,"field2":2}',
  PRIMARY KEY (`role_id`,`func_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-功能关系表';

-- ----------------------------
-- Records of sys_rel_role_func
-- ----------------------------
BEGIN;
INSERT INTO `sys_rel_role_func` VALUES (1, 'job_add', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'job_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'job_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'job_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'job_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'job_get', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'job_list', '{\"job_id\":1,\"company_code\":1,\"job_name\":1,\"job_status\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (1, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'org_delete', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'org_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'org_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'org_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'org_get', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'org_list', '{\"org_id\":1,\"company_code\":1,\"org_pid\":1,\"org_name\":1,\"org_simplify_name\":1,\"org_status\":1,\"create_user\":1,\"create_time\":1,\"org_describe\":1}');
INSERT INTO `sys_rel_role_func` VALUES (1, 'role_add', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'role_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'role_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'role_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'role_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'role_get', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'role_list', '{\"role_id\":1,\"company_code\":1,\"role_name\":1,\"role_status\":1,\"role_desc\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (1, 'user_add', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'user_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'user_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'user_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'user_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'user_get', '');
INSERT INTO `sys_rel_role_func` VALUES (1, 'user_list', '{\"user_id\":1,\"user_code\":1,\"def_company_code\":1,\"user_password\":1,\"user_status\":1,\"user_job_id\":1,\"user_job_name\":1,\"user_org_id\":1,\"user_org_name\":1,\"user_realname\":1,\"user_gender\":1,\"user_phone\":1,\"user_tel\":1,\"user_email\":1,\"user_last_time\":1,\"is_super\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1,\"user_remark\":1}');
INSERT INTO `sys_rel_role_func` VALUES (2, 'org_list', '{\"org_id\":1,\"company_code\":1,\"org_pid\":1,\"org_name\":1,\"org_simplify_name\":1,\"org_status\":1,\"create_user\":1,\"create_time\":1,\"org_describe\":1}');
INSERT INTO `sys_rel_role_func` VALUES (2, 'org_update', '');
INSERT INTO `sys_rel_role_func` VALUES (2, 'system_config', '');
INSERT INTO `sys_rel_role_func` VALUES (2, 'system_manage', '');
INSERT INTO `sys_rel_role_func` VALUES (3, 'job_add', '');
INSERT INTO `sys_rel_role_func` VALUES (3, 'job_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (3, 'job_get', '');
INSERT INTO `sys_rel_role_func` VALUES (3, 'job_list', '{\"job_id\":1,\"company_code\":1,\"job_name\":1}');
INSERT INTO `sys_rel_role_func` VALUES (3, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (3, 'org_delete', '');
INSERT INTO `sys_rel_role_func` VALUES (3, 'org_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (3, 'org_list', '{\"org_id\":1,\"company_code\":1,\"org_pid\":1,\"org_name\":1,\"org_simplify_name\":1,\"org_status\":1,\"create_user\":1,\"create_time\":1,\"org_describe\":1}');
INSERT INTO `sys_rel_role_func` VALUES (3, 'role_add', '');
INSERT INTO `sys_rel_role_func` VALUES (3, 'role_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (3, 'role_list', '{\"company_code\":1,\"role_id\":1}');
INSERT INTO `sys_rel_role_func` VALUES (4, 'job_add', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'job_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'job_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'job_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'job_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'job_get', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'job_list', '{\"job_id\":1,\"company_code\":1,\"job_name\":1,\"job_status\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (4, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'org_delete', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'org_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'org_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'org_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'org_get', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'org_list', '{\"org_id\":1,\"company_code\":1,\"org_pid\":1,\"org_name\":1,\"org_simplify_name\":1,\"org_status\":1,\"org_describe\":1,\"create_user\":1,\"create_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (4, 'role_add', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'role_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'role_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'role_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'role_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'role_get', '');
INSERT INTO `sys_rel_role_func` VALUES (4, 'role_list', '{\"role_id\":1,\"company_code\":1,\"role_name\":1,\"role_status\":1,\"role_desc\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (5, 'job_add', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'job_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'job_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'job_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'job_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'job_get', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'job_list', '{\"job_id\":1,\"company_code\":1,\"job_name\":1,\"job_status\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (5, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'org_delete', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'org_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'org_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'org_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'org_get', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'org_list', '{\"org_id\":1,\"company_code\":1,\"org_pid\":1,\"org_name\":1,\"org_simplify_name\":1,\"org_status\":1,\"org_describe\":1,\"create_user\":1,\"create_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (5, 'role_add', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'role_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'role_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'role_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'role_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'role_get', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'role_list', '{\"role_id\":1,\"company_code\":1,\"role_name\":1,\"role_status\":1,\"role_desc\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (5, 'user_add', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'user_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'user_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'user_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'user_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'user_get', '');
INSERT INTO `sys_rel_role_func` VALUES (5, 'user_list', '{\"user_id\":1,\"user_code\":1,\"def_company_code\":1,\"user_password\":1,\"user_status\":1,\"user_job_id\":1,\"user_job_name\":1,\"user_org_id\":1,\"user_org_name\":1,\"user_realname\":1,\"user_gender\":1,\"user_phone\":1,\"user_tel\":1,\"user_email\":1,\"user_last_time\":1,\"is_super\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1,\"user_remark\":1}');
INSERT INTO `sys_rel_role_func` VALUES (6, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (6, 'org_list', '{\"org_id\":1}');
INSERT INTO `sys_rel_role_func` VALUES (7, 'job_add', '');
INSERT INTO `sys_rel_role_func` VALUES (7, 'job_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (7, 'job_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (7, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (7, 'org_list', '{\"org_id\":1}');
INSERT INTO `sys_rel_role_func` VALUES (7, 'role_add', '');
INSERT INTO `sys_rel_role_func` VALUES (7, 'role_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'job_add', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'job_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'job_list', '{\"job_id\":1,\"company_code\":1}');
INSERT INTO `sys_rel_role_func` VALUES (8, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'org_list', '{\"org_id\":1}');
INSERT INTO `sys_rel_role_func` VALUES (8, 'role_add', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'role_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'role_get', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'role_list', '{\"role_id\":1,\"company_code\":1,\"role_name\":1}');
INSERT INTO `sys_rel_role_func` VALUES (8, 'user_add', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'user_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'user_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'user_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'user_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'user_get', '');
INSERT INTO `sys_rel_role_func` VALUES (8, 'user_list', '{\"user_id\":1,\"user_code\":1,\"def_company_code\":1,\"user_password\":1,\"user_status\":1,\"user_job_id\":1,\"user_job_name\":1,\"user_org_id\":1,\"user_org_name\":1,\"user_realname\":1,\"user_gender\":1,\"user_phone\":1,\"user_tel\":1,\"user_email\":1,\"user_last_time\":1,\"is_super\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1,\"user_remark\":1}');
INSERT INTO `sys_rel_role_func` VALUES (9, 'job_add', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'job_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'job_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'job_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'job_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'job_get', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'job_list', '{\"job_id\":1,\"company_code\":1,\"job_name\":1,\"job_status\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (9, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'org_list', '[]');
INSERT INTO `sys_rel_role_func` VALUES (9, 'role_add', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'role_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'role_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'role_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'role_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'role_get', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'role_list', '{\"role_id\":1,\"company_code\":1,\"role_name\":1,\"role_status\":1,\"role_desc\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (9, 'user_add', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'user_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'user_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'user_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'user_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'user_get', '');
INSERT INTO `sys_rel_role_func` VALUES (9, 'user_list', '{\"user_id\":1,\"user_code\":1,\"def_company_code\":1,\"user_password\":1,\"user_status\":1,\"user_job_id\":1,\"user_job_name\":1,\"user_org_id\":1,\"user_org_name\":1,\"user_realname\":1,\"user_gender\":1,\"user_phone\":1,\"user_tel\":1,\"user_email\":1,\"user_last_time\":1,\"is_super\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1,\"user_remark\":1}');
INSERT INTO `sys_rel_role_func` VALUES (10, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (10, 'org_delete', '');
INSERT INTO `sys_rel_role_func` VALUES (10, 'org_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (10, 'org_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (10, 'org_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (10, 'org_get', '');
INSERT INTO `sys_rel_role_func` VALUES (10, 'org_list', '{\"org_id\":1,\"company_code\":1,\"org_pid\":1,\"org_name\":1,\"org_simplify_name\":1,\"org_status\":1,\"org_describe\":1,\"create_user\":1,\"create_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (12, 'job_add', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'job_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'job_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'job_list', '{\"company_code\":1,\"job_name\":1,\"job_status\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (12, 'org_add', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'org_delete', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'org_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'org_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'org_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'org_get', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'org_list', '{\"org_id\":1,\"company_code\":1,\"org_pid\":1,\"org_name\":1,\"org_simplify_name\":1,\"org_status\":1,\"org_describe\":1,\"create_user\":1,\"create_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (12, 'role_add', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'role_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'role_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'role_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'role_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'role_get', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'role_list', '{\"role_id\":1,\"company_code\":1,\"role_name\":1,\"role_status\":1,\"role_desc\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1}');
INSERT INTO `sys_rel_role_func` VALUES (12, 'user_add', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'user_disable', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'user_discard', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'user_edit', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'user_enable', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'user_get', '');
INSERT INTO `sys_rel_role_func` VALUES (12, 'user_list', '{\"user_id\":1,\"user_code\":1,\"def_company_code\":1,\"user_password\":1,\"user_status\":1,\"user_job_id\":1,\"user_job_name\":1,\"user_org_id\":1,\"user_org_name\":1,\"user_realname\":1,\"user_gender\":1,\"user_phone\":1,\"user_tel\":1,\"user_email\":1,\"user_last_time\":1,\"is_super\":1,\"create_user\":1,\"create_time\":1,\"modify_user\":1,\"modify_time\":1,\"user_remark\":1}');
COMMIT;

-- ----------------------------
-- Table structure for sys_rel_user_company
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_user_company`;
CREATE TABLE `sys_rel_user_company` (
  `company_code` char(5) NOT NULL DEFAULT '' COMMENT '账套',
  `user_code` char(10) NOT NULL DEFAULT '' COMMENT '用户编号',
  PRIMARY KEY (`company_code`,`user_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-公司关系表';

-- ----------------------------
-- Table structure for sys_rel_user_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_user_group`;
CREATE TABLE `sys_rel_user_group` (
  `user_code` char(10) NOT NULL COMMENT '用户编号',
  `user_group_id` int(11) unsigned NOT NULL COMMENT '组ID',
  PRIMARY KEY (`user_code`,`user_group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-组关系';

-- ----------------------------
-- Table structure for sys_rel_user_org
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_user_org`;
CREATE TABLE `sys_rel_user_org` (
  `org_id` int(11) unsigned NOT NULL COMMENT '组织ID',
  `user_code` char(10) NOT NULL COMMENT '用户编号',
  PRIMARY KEY (`org_id`,`user_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-组织机构关系';

-- ----------------------------
-- Records of sys_rel_user_org
-- ----------------------------
BEGIN;
INSERT INTO `sys_rel_user_org` VALUES (2, 'nzw');
COMMIT;

-- ----------------------------
-- Table structure for sys_rel_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_rel_user_role`;
CREATE TABLE `sys_rel_user_role` (
  `user_code` char(10) NOT NULL COMMENT '用户编号',
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_code`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户-角色关系表';

-- ----------------------------
-- Records of sys_rel_user_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_rel_user_role` VALUES ('4s001caiwu', 6);
INSERT INTO `sys_rel_user_role` VALUES ('apidev', 1);
INSERT INTO `sys_rel_user_role` VALUES ('apidev', 2);
INSERT INTO `sys_rel_user_role` VALUES ('apidev1234', 1);
INSERT INTO `sys_rel_user_role` VALUES ('even123456', 1);
INSERT INTO `sys_rel_user_role` VALUES ('gs001caiwu', 11);
INSERT INTO `sys_rel_user_role` VALUES ('nzw1111111', 1);
INSERT INTO `sys_rel_user_role` VALUES ('nzw1111111', 2);
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `role_name` varchar(45) NOT NULL COMMENT '角色名称',
  `role_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '角色状态 1正常 2停用 3作废',
  `role_desc` varchar(255) NOT NULL DEFAULT '' COMMENT '角色描述',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='角色';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` VALUES (1, '1', '牛志伟测试专用角色', 1, '请勿删改', '1', 1500000000, '1', 150000020);
INSERT INTO `sys_role` VALUES (2, '1', '牛志伟测试专用角色2', 1, '请勿删改', '1', 1500000000, '1', 150000020);
INSERT INTO `sys_role` VALUES (3, '1', 'even_role', 1, '请勿删改', '1', 1500000000, '1', 150000020);
INSERT INTO `sys_role` VALUES (4, '1', '牛志伟测试角色1', 3, '牛志伟测试角色123', 'nzw', 1526093780, 'nzw', 1526105213);
INSERT INTO `sys_role` VALUES (5, '1', '牛志伟测试角色1', 1, '牛志伟测试角色123', 'nzw', 1526885790, 'nzw', 1526887147);
INSERT INTO `sys_role` VALUES (6, '4s001', '4s财务', 1, '', 'liquan0001', 1527062269, 'liquan', 1527062269);
INSERT INTO `sys_role` VALUES (7, 'tiger', 'esccse请求', 3, 'esccse113344', 'apidev1234', 1527072488, 'apidev1234', 1527244858);
INSERT INTO `sys_role` VALUES (8, 'tiger', 'esccse2', 3, '', 'apidev1234', 1527213392, 'apidev1234', 1527244807);
INSERT INTO `sys_role` VALUES (9, 'tiger', 'esccse3', 3, '', 'apidev1234', 1527214358, 'apidev1234', 1527244796);
INSERT INTO `sys_role` VALUES (10, 'tiger', 'esccse4', 3, '', 'apidev1234', 1527245213, 'apidev1234', 1527474441);
INSERT INTO `sys_role` VALUES (11, 'gs001', '4s财务', 1, '', 'liquan0001', 1527245213, 'liquan0001', 1527245213);
INSERT INTO `sys_role` VALUES (12, 'tiger', 'esccse6', 1, 'zzzzz', 'apidev1234', 1527560566, 'apidev1234', 1527560768);
COMMIT;

-- ----------------------------
-- Table structure for sys_seq_rule
-- ----------------------------
DROP TABLE IF EXISTS `sys_seq_rule`;
CREATE TABLE `sys_seq_rule` (
  `seq_rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '生成规则ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `seq_rule_name` varchar(45) NOT NULL COMMENT '规则名称',
  `seq_rule_type` tinyint(1) unsigned NOT NULL COMMENT '配置类型 0-常规,1-年月,2-年',
  `seq_rule_min` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '序号起始值',
  `seq_rule_max` int(10) unsigned NOT NULL COMMENT '序号终止值',
  `seq_rule_next` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '下一个序号值',
  `seq_rule_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '序号状态 1正常 2停用 3作废',
  `seq_rule_prefix` char(2) NOT NULL COMMENT '序号前缀 2位',
  `seq_type_id` int(10) unsigned DEFAULT '0' COMMENT '绑定的类型id（sys_seq_type表主键，为0时表示未绑定）',
  `seq_type_name` varchar(32) DEFAULT '' COMMENT '绑定的类型名称（未绑定时为空）',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`seq_rule_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='单据序列号生成规则表, 所有字段(除status, next)一经创建不允许修改， 长度10位';

-- ----------------------------
-- Records of sys_seq_rule
-- ----------------------------
BEGIN;
INSERT INTO `sys_seq_rule` VALUES (1, '1', '测试规则1', 1, 50, 100, 23, 1, 'CS', 1, '', '', 0, 'nzw', 1527234537);
INSERT INTO `sys_seq_rule` VALUES (2, 'sy001', '销售订单生成规则', 2, 10, 100, 29, 1, 'XS', 3, '', 'sy', 1527219944, 'sy', 1527327558);
INSERT INTO `sys_seq_rule` VALUES (3, '1', '出库单生成规则', 2, 1, 1000, 0, 1, 'CH', 4, '', 'kh', 1527221544, '', 0);
INSERT INTO `sys_seq_rule` VALUES (5, 'ljx', '其他出入库-采购入库规则', 2, 1, 1000, 83, 1, 'CR', 6, '', 'ljx', 1527221544, 'ljx', 1527326985);
INSERT INTO `sys_seq_rule` VALUES (6, 'sy001', '备货单生成规则', 2, 1, 1000, 9, 1, 'BH', 7, '', 'sy', 1527470245, 'sy', 1527472768);
COMMIT;

-- ----------------------------
-- Table structure for sys_seq_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_seq_type`;
CREATE TABLE `sys_seq_type` (
  `seq_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '单据类型ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `seq_rule_id` int(10) unsigned DEFAULT '0' COMMENT '绑定的规则id（sys_seq_rule表主键，为0时表示未绑定）',
  `order_entity_code` varchar(32) NOT NULL COMMENT '单据实体标识',
  `order_entity_type_code` varchar(20) NOT NULL COMMENT '单据实体类型编号',
  `order_entity_type_name` varchar(32) NOT NULL COMMENT '单据实体类型名称',
  `seq_type_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '单据类型状态 1正常 2停用 3作废',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`seq_type_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='单据业务类型表(前1000个系统保留， 用户定义类型从1000开始)';

-- ----------------------------
-- Records of sys_seq_type
-- ----------------------------
BEGIN;
INSERT INTO `sys_seq_type` VALUES (1, '1', 1, '', '', '', 1, '', 0, '', 0);
INSERT INTO `sys_seq_type` VALUES (2, '1', 1, 'comm_remittance', 'dealer_remittance', '付款单', 1, 'nzw1111111', 1526896037, '', 0);
INSERT INTO `sys_seq_type` VALUES (3, '1', 2, 'comm_sells', 'dealer_factory', '销售订单', 1, 'sy', 1527219944, '', 0);
INSERT INTO `sys_seq_type` VALUES (4, 'sy001', 3, 'comm_deliver', 'comm_deliver', '出库单', 1, 'kh', 1527229166, '', 0);
INSERT INTO `sys_seq_type` VALUES (6, 'ljx', 5, 'inv_io_bills', 'inv_io_bills', '出入库单-主表单据类型', 1, '', 1527229166, '', 0);
INSERT INTO `sys_seq_type` VALUES (7, 'sy001', 6, 'comm_stocking', 'factory_dealer', '备货单', 1, 'sy', 1527470245, '', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_code` char(10) NOT NULL COMMENT '用户编号(用于登陆)',
  `def_company_code` char(5) NOT NULL COMMENT '默认账套',
  `user_password` char(32) NOT NULL COMMENT '密码',
  `user_salt` char(6) NOT NULL COMMENT '密码盐',
  `user_status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '用户状态 1正常 2停用 3作废',
  `user_job_id` int(10) unsigned DEFAULT '0' COMMENT '用户职务id',
  `user_job_name` varchar(45) DEFAULT '' COMMENT '职务名称',
  `user_org_id` int(10) unsigned DEFAULT '0' COMMENT '用户所属组织id',
  `user_org_name` varchar(45) DEFAULT '' COMMENT '组织名称',
  `user_realname` varchar(45) DEFAULT '' COMMENT '用户真实姓名',
  `user_gender` tinyint(1) unsigned DEFAULT '0' COMMENT '用户性别 0未知 1男 2女',
  `user_phone` varchar(14) DEFAULT '' COMMENT '手机号',
  `user_tel` varchar(14) DEFAULT '' COMMENT '固定电话',
  `user_email` varchar(60) DEFAULT '' COMMENT '邮箱',
  `user_remark` varchar(64) DEFAULT '' COMMENT '备注',
  `user_last_time` int(10) unsigned DEFAULT '0' COMMENT '最后登陆时间',
  `is_super` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否超级管理员  0-否 1-是',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='用户';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` VALUES (1, 'nzw1111111', '1', '5f1d7a84db00d2fce00b31a7fc73224f', '123456', 1, 0, '', 7, '', '牛志伟', 0, '', '', '', '', 1527490101, 0, '', 0, 'nzw', 1526884370);
INSERT INTO `sys_user` VALUES (2, 'even123456', '1', '5f1d7a84db00d2fce00b31a7fc73224f', '123456', 1, 0, '', 7, '', 'even', 0, '', '', '', '', 1527233535, 0, '', 0, '', 0);
INSERT INTO `sys_user` VALUES (3, 'tiger11111', 'tiger', '5f1d7a84db00d2fce00b31a7fc73224f', '123456', 1, 0, '', 7, '', '李大虎', 0, '', '', '', '', 1527643897, 0, '', 0, '', 0);
INSERT INTO `sys_user` VALUES (6, 'nzw2222222', '1', '6cff632f861c4d1c26e05592f8f0d112', 'fmebpe', 1, 0, '', 0, '', '牛志伟1', 1, '18092346333', '029-89898899', 'nzw@163.com', '  我是备注哦', 1526871548, 0, 'nzw', 1526004222, '1527499585', 0);
INSERT INTO `sys_user` VALUES (8, 'nzw1', '1', '97599421df3ebeb6fc6bb67116c60651', '0qmu6u', 1, 0, '', 0, '', '牛志伟', 1, '18092346333', '029-89898899', 'nzw@163.com', '  我是备注哦', 0, 0, 'nzw', 1526115366, '', 0);
INSERT INTO `sys_user` VALUES (9, 'apidev1234', 'tiger', 'd868415f2d273904cfa4f46af5732a03', 'nyxbil', 1, 0, '', 0, '', 'api测试', 1, '18088888888', '029-88888888', 'apidev@163.com', 'api测试专用，请勿删改', 1527589598, 1, 'nzw', 1526396891, '', 0);
INSERT INTO `sys_user` VALUES (10, 'lihu', 'ldh', 'e11180c1f91c31355892ff8355eea639', 'pgoj52', 1, 0, '', 0, '', '', 0, '', '', '', '', 0, 0, '', 0, '', 0);
INSERT INTO `sys_user` VALUES (11, '4s001caiwu', '4s001', '5f1d7a84db00d2fce00b31a7fc73224f', '123456', 1, 0, '', 0, '', '王财务', 0, '', '', '', '', 1527487588, 0, 'liquan0001', 1527061266, 'liquan0001', 1527061266);
INSERT INTO `sys_user` VALUES (12, '4s001caiw1', 'tiger', 'd4a578338f4b4ebd52f1214c02b47fef', '52o4uz', 3, 0, '', 0, '', 'zp', 2, '13333333334', '13333333331', 'dwqd@dwqdwq', 'dqwdwqdwq?\n?????', 0, 0, 'apidev1234', 1527234085, 'apidev1234', 1527238023);
INSERT INTO `sys_user` VALUES (13, 'gs001caiwu', 'gs001', '5f1d7a84db00d2fce00b31a7fc73224f', '123456', 1, 0, '', 0, '财务部', '李财务', 0, '', '', '', '', 1527328745, 0, '', 1527234085, 'liquan0001', 1527234085);
INSERT INTO `sys_user` VALUES (14, '4s001caiw3', 'tiger', '75b22ebc755f1373f00f94fdd287fbbe', 'j9eoq7', 3, 0, '', 0, '', 'zp2', 1, '', '', '', '', 0, 0, 'apidev1234', 1527474545, 'apidev1234', 1527474765);
INSERT INTO `sys_user` VALUES (15, '4s001caiw8', 'tiger', '9780624995c745957f78001ca79cc300', 'xvmn85', 1, 0, '', 0, '', '111', 2, '333', '', ' ', ' ', 0, 0, 'apidev1234', 1527489655, 'apidev1234', 1527578335);
INSERT INTO `sys_user` VALUES (16, '4s001caiw9', 'tiger', '312884b2ee9c24c0aefd6bff825b02ad', '0krown', 1, 0, '', 0, '', 'dddd', 0, 'dddddddddddddd', '', '', '', 0, 0, 'apidev1234', 1527578761, '', 0);
INSERT INTO `sys_user` VALUES (17, '4s001caiw0', 'tiger', '36431dc5499fa840db5fd48134677869', 'jj7dpl', 1, 0, '', 0, '', 'zp110', 2, 'dwqdwq', 'dwqdqw', 'dqwdq', 'dwqdqwdqw', 0, 0, 'apidev1234', 1527578916, '', 0);
INSERT INTO `sys_user` VALUES (18, '4s001cai11', 'tiger', '0356c38e4750e0ab9e1dfdf0ffb6dc45', '58op9y', 1, 0, '', 0, '', 'zp007', 0, '', '', '', '', 0, 0, 'apidev1234', 1527579080, '', 0);
INSERT INTO `sys_user` VALUES (19, '4s001cai12', 'tiger', 'aa072f3f4d1aba571c2dae2941169bac', 'qegktz', 1, 0, '', 0, '', 'zp008', 0, '', '', '', '', 0, 0, 'apidev1234', 1527579221, '', 0);
INSERT INTO `sys_user` VALUES (20, '4s001cai13', 'tiger', 'fcb80b7cd14b47aa370060aa3e9d05a2', 'y0a84y', 1, 0, '', 0, '', 'zp009', 0, '', '', '', '', 0, 0, 'apidev1234', 1527579297, '', 0);
INSERT INTO `sys_user` VALUES (21, '4s001cai14', 'tiger', '25e8b118014878c025bd504bc0e88aaf', 'g6bpcr', 1, 0, '', 0, '', 'esccse11', 0, '', '', '', '', 0, 0, 'apidev1234', 1527579424, '1527579661', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_favorite_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_favorite_menu`;
CREATE TABLE `sys_user_favorite_menu` (
  `fav_menu_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户收藏菜单id',
  `user_code` char(10) NOT NULL DEFAULT '' COMMENT '用户编号',
  `func_code` varchar(20) NOT NULL DEFAULT '' COMMENT 'sys_func表功能编号，用于标识对应功能和页面',
  PRIMARY KEY (`fav_menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8 COMMENT='用户菜单收藏表';

-- ----------------------------
-- Records of sys_user_favorite_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_favorite_menu` VALUES (3, 'even123456', 'org_list');
INSERT INTO `sys_user_favorite_menu` VALUES (109, 'apidev1234', 'org_list');
INSERT INTO `sys_user_favorite_menu` VALUES (111, 'apidev1234', 'role_list');
COMMIT;

-- ----------------------------
-- Table structure for sys_user_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_group`;
CREATE TABLE `sys_user_group` (
  `company_code` char(5) NOT NULL COMMENT '账套',
  `user_group_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户组ID',
  `user_group_pid` varchar(45) NOT NULL DEFAULT '0' COMMENT '父级ID',
  `user_group_name` varchar(45) NOT NULL COMMENT '用户组名',
  `user_group_mark` varchar(45) NOT NULL DEFAULT '' COMMENT '备注',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`user_group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户组';

-- ----------------------------
-- Table structure for sys_user_preference_list
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_preference_list`;
CREATE TABLE `sys_user_preference_list` (
  `prefer_list_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户列表字段展示偏好设置id',
  `user_code` char(10) NOT NULL DEFAULT '' COMMENT '用户编号',
  `func_code` varchar(20) NOT NULL DEFAULT '' COMMENT 'sys_func表功能编号，用于标识对应功能和页面',
  `list_params` text NOT NULL COMMENT '用户列表字段展示偏好设置（json串形式且只保存权限所属的字段）\r\n形如[{"field":"name","align":2,"is_show":1,"width":20},{"field":"sex","align":2,"is_show":1,"width":20}]\r\nis_show是否显示 1-显示 2-不显示；\r\nalign对齐方式 1-左对齐 2-居中 3-右对齐；\r\nwidth展示宽度\r\n顺序即json中元素顺序。',
  PRIMARY KEY (`prefer_list_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='用户列表字段偏好设置表';

-- ----------------------------
-- Records of sys_user_preference_list
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_preference_list` VALUES (8, 'apidev1234', 'user_list', '[{\"field\":\"user_id\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":1},{\"field\":\"user_code\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":2},{\"field\":\"def_company_code\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":3},{\"field\":\"user_password\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":4},{\"field\":\"user_status\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":5},{\"field\":\"user_job_id\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":6},{\"field\":\"user_job_name\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":7},{\"field\":\"user_org_id\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":8},{\"field\":\"user_org_name\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":9},{\"field\":\"user_realname\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":10},{\"field\":\"user_gender\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":11},{\"field\":\"user_phone\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":12},{\"field\":\"user_tel\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":13},{\"field\":\"user_email\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":14},{\"field\":\"user_last_time\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":15},{\"field\":\"is_super\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":16},{\"field\":\"create_user\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":17},{\"field\":\"create_time\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":18},{\"field\":\"modify_user\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":19},{\"field\":\"modify_time\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":20},{\"field\":\"user_remark\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":21}]');
INSERT INTO `sys_user_preference_list` VALUES (9, 'apidev1234', 'user_list', '[{\"field\":\"user_code\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":1},{\"field\":\"user_status\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":2},{\"field\":\"user_job_name\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":3},{\"field\":\"user_org_name\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":4},{\"field\":\"user_realname\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":5},{\"field\":\"user_gender\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":6},{\"field\":\"user_phone\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":7},{\"field\":\"user_tel\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":8},{\"field\":\"user_email\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":9},{\"field\":\"user_last_time\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":10},{\"field\":\"create_user\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":11},{\"field\":\"create_time\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":12},{\"field\":\"modify_user\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":13},{\"field\":\"modify_time\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":14},{\"field\":\"user_remark\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":15}]');
INSERT INTO `sys_user_preference_list` VALUES (10, 'apidev1234', 'job_list', '[{\"field\":\"job_name\",\"align\":1,\"is_show\":1,\"width\":0,\"order_num\":1},{\"field\":\"job_status\",\"align\":1,\"is_show\":2,\"width\":0,\"order_num\":2},{\"field\":\"create_user\",\"align\":1,\"is_show\":2,\"width\":0,\"order_num\":3},{\"field\":\"create_time\",\"align\":1,\"is_show\":2,\"width\":0,\"order_num\":4},{\"field\":\"modify_user\",\"align\":1,\"is_show\":2,\"width\":0,\"order_num\":5},{\"field\":\"modify_time\",\"align\":1,\"is_show\":2,\"width\":0,\"order_num\":6}]');
INSERT INTO `sys_user_preference_list` VALUES (11, 'apidev1234', 'role_list', '[{\"field\":\"role_name\",\"align\":\"2\",\"is_show\":1,\"width\":200,\"order_num\":1},{\"field\":\"role_status\",\"align\":1,\"is_show\":1,\"width\":200,\"order_num\":2},{\"field\":\"role_desc\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":3},{\"field\":\"create_user\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":4},{\"field\":\"create_time\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":5},{\"field\":\"modify_user\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":6},{\"field\":\"modify_time\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":7}]');
INSERT INTO `sys_user_preference_list` VALUES (12, 'apidev1234', 'role_list', '[{\"field\":\"role_name\",\"align\":\"2\",\"is_show\":1,\"width\":200,\"order_num\":1},{\"field\":\"role_status\",\"align\":1,\"is_show\":1,\"width\":200,\"order_num\":2},{\"field\":\"role_desc\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":3},{\"field\":\"create_user\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":4},{\"field\":\"create_time\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":5},{\"field\":\"modify_user\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":6},{\"field\":\"modify_time\",\"align\":1,\"is_show\":1,\"width\":70,\"order_num\":7}]');
COMMIT;

-- ----------------------------
-- Table structure for sys_user_preference_search
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_preference_search`;
CREATE TABLE `sys_user_preference_search` (
  `prefer_search_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户列表筛选偏好设置id',
  `user_code` char(10) NOT NULL DEFAULT '' COMMENT '用户编号',
  `func_code` varchar(20) NOT NULL DEFAULT '' COMMENT 'sys_func表功能编号，用于标识对应功能和页面',
  `search_params` text NOT NULL COMMENT '用户列表筛选偏好设置（json串形式且只保存已设置字段）\r\n形如：[{"field":"company_code","search_type":"eq"}]',
  PRIMARY KEY (`prefer_search_id`),
  KEY `user_code` (`user_code`),
  KEY `func_code` (`func_code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='用户列表筛选偏好设置表';

-- ----------------------------
-- Records of sys_user_preference_search
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_preference_search` VALUES (2, 'apidev1234', 'job_list', '[{\"field\":\"job_name\",\"search_type\":\"include\"}]');
COMMIT;

-- ----------------------------
-- Table structure for vehicle_inventory
-- ----------------------------
DROP TABLE IF EXISTS `vehicle_inventory`;
CREATE TABLE `vehicle_inventory` (
  `inventory_id` char(30) NOT NULL COMMENT '自增ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `meterial_prod_code` char(45) NOT NULL COMMENT '生产物料编号 SAP编号',
  `inventory_vin` char(17) NOT NULL COMMENT '车架号',
  `inventory_engine` char(50) NOT NULL COMMENT '发动机号',
  `inventory_qualified` char(20) NOT NULL COMMENT '合格编号',
  `inventory_series` varchar(45) NOT NULL COMMENT '车系',
  `inventory_model` varchar(45) NOT NULL COMMENT '车型',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`inventory_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='整车基础数据(MES-DMS-SAP)';

-- ----------------------------
-- Table structure for vehicle_plan_month
-- ----------------------------
DROP TABLE IF EXISTS `vehicle_plan_month`;
CREATE TABLE `vehicle_plan_month` (
  `plan_month_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '月度计划ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `sell_region_id` int(10) unsigned NOT NULL COMMENT '销售区域ID',
  `plan_year_id` int(10) unsigned NOT NULL COMMENT '年计划ID(备用)',
  `plan_month_number` int(10) unsigned NOT NULL COMMENT '月计划数量',
  `plan_month_number_sub` int(10) unsigned NOT NULL COMMENT '月计划提报数量',
  `plan_month_status` tinyint(1) unsigned NOT NULL COMMENT '月计划状态：0已创建，1已提交，2已审核',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`plan_month_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='月度计划';

-- ----------------------------
-- Table structure for vehicle_plan_year
-- ----------------------------
DROP TABLE IF EXISTS `vehicle_plan_year`;
CREATE TABLE `vehicle_plan_year` (
  `plan_year_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '年度计划ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `sell_region_id` int(10) unsigned NOT NULL COMMENT '销售区域ID',
  `plan_year_number` int(10) unsigned NOT NULL COMMENT '计划数量',
  `plan_year_status` tinyint(1) unsigned NOT NULL COMMENT '状态：0已计划，1已分配',
  `plan_limit_offset` int(10) unsigned NOT NULL COMMENT '计划可调整百分比*1000',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`plan_year_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='年度计划';

-- ----------------------------
-- Table structure for vehicle_user
-- ----------------------------
DROP TABLE IF EXISTS `vehicle_user`;
CREATE TABLE `vehicle_user` (
  `vehicle_user_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '潜在客户ID',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `owner_company_code` char(5) NOT NULL COMMENT '经销商编号',
  `vehicle_user_origin` tinyint(1) unsigned NOT NULL COMMENT '客户来源：0-360,1DMS',
  `vehicle_user_name` varchar(40) NOT NULL COMMENT '客户名称',
  `vehicle_user_contact_person` char(10) NOT NULL COMMENT '联系人',
  `vehicle_user_contact_phone` varchar(20) NOT NULL COMMENT '联系电话',
  `vehicle_user_series` varchar(100) NOT NULL COMMENT '车系(需与S360对应)',
  `vehicle_user_model` varchar(100) NOT NULL COMMENT '车型',
  `vehicle_user_color` varchar(100) NOT NULL COMMENT '颜色',
  `vehicle_user_vin` varchar(20) NOT NULL COMMENT '底盘号(车架号)',
  `vehicle_user_sell_name` char(10) NOT NULL COMMENT '销售员名称',
  `vehicle_user_contact_date` int(10) unsigned NOT NULL COMMENT '接洽日期',
  `vehicle_user_consult_time` varchar(45) NOT NULL,
  `vehicle_user_level` varchar(10) NOT NULL COMMENT '客户类别：O级-现场成交，H级-7天成交，A级-15天成交，B级-1月成交，C级-3月成交',
  `vehicle_user_buy` varchar(10) NOT NULL COMMENT '购车方式',
  `vehicle_user_testdrive` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '是否试驾：0是，1否',
  `vehicle_user_age` tinyint(2) unsigned NOT NULL COMMENT '客户年龄(在Smart360不是必须字段)',
  `vehicle_user_profession` varchar(20) NOT NULL COMMENT '职业(在Smart360不是必须字段)',
  `vehicle_user_pro` varchar(20) NOT NULL COMMENT '省份(选填)',
  `vehicle_user_city` varchar(20) NOT NULL COMMENT '城市(选填)',
  `vehicle_user_area` varchar(20) NOT NULL COMMENT '县区(选填)',
  `vehicle_user_area_code` char(4) NOT NULL COMMENT '区号',
  `vehicle_user_phone` varchar(20) NOT NULL COMMENT '电话',
  `vehicle_user_address` varchar(50) NOT NULL COMMENT '地址',
  `vehicle_user_fax` varchar(20) NOT NULL COMMENT '传真',
  `vehicle_user_zipcode` char(6) NOT NULL COMMENT '邮编',
  `vehicle_user_email` varchar(40) NOT NULL,
  `vehicle_user_card` char(18) NOT NULL COMMENT '身份证',
  `user_sex` tinyint(1) NOT NULL COMMENT '性别:0保密,1男,2女',
  `user_expect` varchar(4) NOT NULL COMMENT '购车预期',
  `user_use` varchar(10) NOT NULL COMMENT '购车用途',
  `user_info_ source` varchar(10) NOT NULL COMMENT '信息来源',
  `user_buy_nature` varchar(50) NOT NULL COMMENT '购车性质',
  `user_impress` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '原始印象',
  `user_evaluate` text NOT NULL COMMENT '评价要求',
  `user_remark` varchar(100) NOT NULL COMMENT '备注',
  `user_attention` varchar(100) NOT NULL COMMENT '客户关注点',
  `user_famliy` varchar(20) NOT NULL COMMENT '家庭成员',
  `user_license_address` char(10) NOT NULL COMMENT '车辆上牌地',
  `user_company_code` char(10) NOT NULL COMMENT '分公司号',
  `user_follow_num` int(4) unsigned NOT NULL COMMENT '跟进次数',
  `user_marriage` varchar(10) NOT NULL COMMENT '婚姻情况',
  `user_dress` varchar(10) NOT NULL COMMENT '着装打扮',
  `user_follow_p` varchar(10) NOT NULL COMMENT '跟随人员',
  `user_follow_p_num` int(4) unsigned NOT NULL,
  `user_traffic` varchar(10) NOT NULL COMMENT '交通方式',
  `user_says` varchar(10) NOT NULL COMMENT '言谈举止',
  `user_drive_years` int(4) unsigned NOT NULL COMMENT '驾龄',
  `user_call_num` int(4) unsigned NOT NULL COMMENT '来访次数',
  `user_replacement` varchar(10) NOT NULL COMMENT '置换意向',
  `user_years_income` varchar(10) NOT NULL COMMENT '年收入水平',
  `user_culture` varchar(50) NOT NULL COMMENT '文化水平',
  `user_type` tinyint(1) NOT NULL COMMENT '档案类型：0潜在客户，1客户档案',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`vehicle_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='潜在客户表';

-- ----------------------------
-- Table structure for vehicle_user_change
-- ----------------------------
DROP TABLE IF EXISTS `vehicle_user_change`;
CREATE TABLE `vehicle_user_change` (
  `user_change_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `vehicle_user_id` int(10) unsigned NOT NULL COMMENT '潜在客户ID',
  `customer_code` char(8) NOT NULL COMMENT '客户编号',
  `company_code` char(5) NOT NULL COMMENT '账套',
  `user_change_before` text NOT NULL COMMENT '变更前值',
  `user_change_after` text NOT NULL COMMENT '变更后值',
  `create_user` char(10) NOT NULL COMMENT '创建用户编号',
  `create_time` int(10) unsigned NOT NULL COMMENT '创建时间',
  `modify_user` char(10) DEFAULT '' COMMENT '修改用户编号',
  `modify_time` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`user_change_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='整车客户档案变更';

SET FOREIGN_KEY_CHECKS = 1;
