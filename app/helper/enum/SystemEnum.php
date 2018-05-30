<?php
namespace app\helper\enum;

/**
 * System.php
 * User: tiger.li
 * Date: 2018/5/9
 */
class SystemEnum
{
    /************************************ 组织相关 **************************************/
    /**
     * 组织状态-正常
     */
    CONST ORG_STATUS_NORMAL = 1;
    /**
     * 组织状态-停用
     */
    CONST ORG_STATUS_FORBIDDEN = 2;
    /**
     * 组织状态-作废
     */
    CONST ORG_STATUS_INVALID = 3;

    /************************************ 客户相关 **************************************/
    /**
     * 客户类型-普通客户
     */
    const CUSTOMER_TYPE_COMMON = 1;
    /**
     * 客户类型-经销商
     */
    const CUSTOMER_TYPE_DEALER = 2;
    /**
     * 客户类型-其他
     */
    const CUSTOMER_TYPE_OTHER = 3;

    /**
     * 客户地址类型-普通
     */
    const CUSTOMER_ADDRESS_TYPE_COMMON = 0;
    /**
     * 客户地址类型-收货
     */
    const CUSTOMER_ADDRESS_TYPE_RECEIVE = 1;

    /************************************ 用户相关 **************************************/
    /**
     * 用户状态-正常
     */
    CONST USER_STATUS_NORMAL = 1;
    /**
     * 用户状态-停用
     */
    CONST USER_STATUS_FORBIDDEN = 2;
    /**
     * 用户状态-作废
     */
    CONST USER_STATUS_INVALID = 3;

    /**
     * 用户是否是超级管理员-否
     */
    CONST USER_IS_SUPER_NO = 0;
    /**
     * 用户是否是超级管理员-是
     */
    CONST USER_IS_SUPER_YES = 1;

    /************************************ 角色相关 **************************************/
    /**
     * 角色状态-正常
     */
    CONST ROLE_STATUS_NORMAL = 1;
    /**
     * 角色状态-停用
     */
    CONST ROLE_STATUS_FORBIDDEN = 2;
    /**
     * 角色状态-作废
     */
    CONST ROLE_STATUS_INVALID = 3;

    /************************************ 功能（权限）相关 **************************************/
    /**
     * 功能（权限）类型-菜单
     */
    CONST FUNC_TYPE_MENU = 1;
    /**
     * 功能（权限）类型-视图
     */
    CONST FUNC_TYPE_VIEW = 2;
    /**
     * 功能（权限）类型-操作
     */
    CONST FUNC_TYPE_OPERATION = 3;

    /**
     * 功能（权限）归属-主机厂
     */
    CONST FUNC_OWNER_FACTORY = 1;
    /**
     * 功能（权限）归属-4S店
     */
    CONST FUNC_OWNER_4S = 2;

    /**
     * 字段权限类型-所有权限（如果不是1也不是2，则证明什么权限都没有）
     */
    CONST FUNC_PARAM_TYPE_ALL = 1;
    /**
     * 字段权限类型-只读权限
     */
    CONST FUNC_PARAM_TYPE_READ = 2;

    /************************************ 公司相关 **************************************/
    /**
     * 公司状态-正常
     */
    CONST COMPANY_STATUS_NORMAL = 1;
    /**
     * 公司状态-停用
     */
    CONST COMPANY_STATUS_FORBIDDEN = 2;
    /**
     * 公司状态-作废
     */
    CONST COMPANY_STATUS_INVALID = 3;

    /**
     * 公司类型-4s
     */
    CONST COMPANY_TYPE_4S = 0;
    /**
     * 公司类型-整车厂
     */
    CONST COMPANY_TYPE_FACTORY = 1;
    /**
     * 公司类型-服务站
     */
    CONST COMPANY_TYPE_SERVICE = 2;
    /**
     * 公司类型-虚拟公司
     */
    CONST COMPANY_TYPE_COMPANY = 4;

    /************************************ 通知消息相关 **************************************/
    /**
     * 阅读状态-未读
     */
    CONST READ_STATE_UNREAD = 10;
    /**
     * 阅读状态-已读
     */
    CONST READ_STATE_READ = 20;

    /************************************ 职务相关 **************************************/
    /**
     * 职务状态-正常
     */
    CONST JOB_STATUS_NORMAL = 1;
    /**
     * 职务状态-停用
     */
    CONST JOB_STATUS_FORBIDDEN = 2;
    /**
     * 职务状态-作废
     */
    CONST JOB_STATUS_INVALID = 3;

}
