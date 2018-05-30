<?php
namespace app\helper\cache;

/**
 * Redis缓存名称类
 *
 * 方法名称规则与规范：
 * 第一部分：Mem(memcache) R(redis) Mon(mongodb)
 * 第二部分：模块名称
 * 第三部分：业务描述
 *
 * 缓存名称规则与规范：
 * 第一部分：业务代号名称，如dms
 * 第二部分：模块与业务名称
 * 第三部分：自定义描述，如userId值
 * 部分之间用应分分号:分隔
 *
 * User: nzw
 * Date: 2018/5/16
 */
class RedisCache
{
    /**
     * 登陆缓存名称
     * @author: nzw
     * @date: 2018-05-16
     * @param string $strUserCode 用户编号
     */
    public static function R_system_login_data(string $strUserCode)
    {
        return 'dms:login:' . $strUserCode;
    }

    /**
     * 单据号缓存名称
     * @author: nzw
     * @date: 2018-05-16
     * @param int $iSeqTypeId 单据号类型id
     */
    public static function R_common_sequence(int $iSeqTypeId)
    {
        return 'dms:seq:' . $iSeqTypeId;
    }
}