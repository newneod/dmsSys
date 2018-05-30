<?php
namespace app\helper;

/**
 * 服务端错误码
 * 规则： 4（错误类型）01（模块）01（子模块错误编码）
 * 错误类型：
 *      1   系统级
 *      2   服务级
 *      4   入参校验
 *      5   出参校验
 * 模块划分（后期可根据需要自主扩充及修改注释）：
 *      00 ~ 09     公共模块
 *      10 ~ 19     系统模块
 *      20 ~ 29     （预留）
 *      30 ~ 39     财务模块
 *      40 ~ 49     （预留）
 *      50 ~ xxx    订单模块及其他
 *      90 ~ 99     （预留）
 * @author even
 * @date: 2018年5月8日
 */
class Code
{
    /**
     * 成功
     */
    const CODE_SUCCESS = 0;
    
    /************************************ common公共模块 ***************************************/
    /**
     * token为空
     */
    const COMM_TOKEN_REQUIRED = 40001;
    
    /**
     * token错误
     */
    const COMM_TOKEN_ERROR = 40002;
    
    /**
     * token过期
     */
    const COMM_TOKEN_EXPIRED = 40003;
    
    /**
     * 无权访问
     */
    const COMM_ACCESS_DENY = 40004;
    
    /**
     * 参数为空
     */
    const COMM_PARAM_REQUIRED = 40005;
    
    /**
     * 参数错误
     */
    const COMM_PARAM_ERROR = 40006;
    
    /**
     * 功能不存在
     */
    const COMM_FUNC_INEXIS = 50001;
    
    /**
     * 功能权限类型错误
     */
    const COMM_FUNC_TYPE_ERROR = 50002;
    
    /**
     * 初始化列表偏好设置错误
     */
    const COMM_INIT_PREFERENCE_ERROR = 50003;
    
    /**
     * 功能配置错误
     */
    const COMM_FUNC_CONFIG_ERROR = 50004;
    
    /**
     * 字段枚举数据获取失败
     */
    const COMM_FIELD_OPTION_ERROR = 50005;
    
    /**
     * 根据偏好设置排序字段
     */
    const COMM_FIELD_ORDER_ERROR = 50006;
    
    /**
     * 车型字典数据获取失败
     */
    const COMM_VEHICLE_TYPE_DIC_ERROR = 50007;
    
    /**
     * 车型数据解析失败
     */
    const COMM_VEHICLE_TYPE_PARSE_ERROR = 50008;
    
    /**
     * 省市区字典数据获取失败
     */
    const COMM_COMMON_AREA_DIC_ERROR = 50009;
    
    /**
     * 省市区数据解析失败
     */
    const COMM_COMMON_AREA_PARSE_ERROR = 50010;
    
    /**
     * 搜索类型非法
     */
    const COMMON_SEARCH_TYPE_ERROR = 50011;

    /**
     * 获取数据失败
     */
    const COMM_SELECT_ERROR = 50012;

    /**
     * 新增数据失败
     */
    const COMM_ADD_ERROR = 50013;

    /**
     * 编辑/修改数据失败
     */
    const COMM_EDIT_ERROR = 50014;

    /**
     * 删除数据失败
     */
    const COMM_DELETE_ERROR = 50015;
    
    /**
     * 列表偏好设置删除失败
     */
    const COMM_DEL_PRE_LIST_ERROR = 50016;
    
    /**
     * 搜索偏好设置删除失败
     */
    const COMM_DEL_PRE_SEARCH_ERROR = 50017;

    /**
     * 单据号已用尽
     */
    const COMM_SEQ_UESD_UP = 50018;
    
    /**
     * 无权设置当前列表字段
     */
    const COMM_EDIT_PREFERENCE_DENY = 50019;
    
    /**
     * 重复收藏菜单
     */
    const COMM_REPEAT_COLLECT_MENU = 50020;
    
    /**
     * 当前菜单不在收藏夹中
     */
    const COMM_FAVORITE_MENU_INEXIS = 50021;
    
    /**
     * 搜索规则非法
     */
    const COMM_SEARCH_RULE_ILLEGAL = 50022;
    
    /**
     * 验权字段数据有误
     */
    const COMM_VALIDATE_FIELD_ERROR = 50023;
    
    /**
     * 自定义验权参数错误
     */
    const COMM_CUSTOM_VALIDATE_FIELD_ERROR = 50024;
    
    /************************************ system系统模块 **************************************/
    /**
     * 参数为空
     */
    const SYS_PARAM_REQUIRED = 41001;
    
    /**
     * 参数错误
     */
    const SYS_PARAM_ERROR = 41002;

    /**
     * 获取数据失败
     */
    const SYS_SELECT_ERROR = 51001;

    /**
     * 新增数据失败
     */
    const SYS_ADD_ERROR = 51002;

    /**
     * 编辑/修改数据失败
     */
    const SYS_EDIT_ERROR = 51003;

    /**
     * 删除数据失败
     */
    const SYS_DELETE_ERROR = 51004;

    /**
     * 用户不存在
     */
    const SYS_USER_INEXIS = 51005;
    
    /**
     * 用户密码错误
     */
    const SYS_PWD_ERROR = 51006;
    
    /**
     * 验证码错误
     */
    const SYS_VERIFY_CODE_ERROR = 51007;
    
    /**
     * 用户被冻结
     */
    const SYS_USER_FREEZE = 51008;

}
