<?php
namespace app\helper\enum;

/**
 * 公共模块预定义常量
 * @author even
 * @date: 2018年5月9日
 */
class CommonEnum
{
    /**
     * 缺省值展示符号 
     */
    const SHOW_DEFAULT_VALUE = '-';
    
    /**
     * 默认分页展示记录数
     */
    const DEFAULT_PAGING_LIMIT = 10;
    
    /**
     * 默认分页偏移量
     */
    const DEFAULT_PAGINF_OFFSET = 0;
    
    /**
     * 默认排序字段
     */
    const DEFAULT_ORDER_BY_FIELD = 'create_time';
    
    /**
     * 默认排序规则
     */
    const DEFAULT_ORDER_BY_RULE = 'DESC';
    
    /**
     * 功能权限-菜单权限
     */
    const FUNC_TYPE_MENU = 1;
    
    /**
     * 功能权限-视图权限
     */
    const FUNC_TYPE_VIEW = 2;
    
    /**
     * 功能权限-操作权限
     */
    const FUNC_TYPE_OPT = 3;
    
    /**
     * 字段对齐方式 1-左对齐 2-居中 3-右对齐
     */
    const FIELD_ALIGN_DIC = [
        'LEFT' => 1,
        'CENTER' => 2,
        'RIGHT' => 3
    ];
    
    /**
     * 当前字段是否在表头展示 1-展示 2-不展示 （系统级别设置）
     */
    const FIELD_HEADER_SHOW_DIC = [
        'SHOW' => 1,
        'NOT_SHOW' => 2
    ];
    
    /**
     * 字段展示类型 1-显示 2-不显示  （用户自定义）
     */
    const FIELD_SHOW_DIC = [
        'SHOW' => 1,
        'NOT_SHOW' => 2
    ];
    
    /**
     * 是否为验权字段  1-是 2-否
     */
    const NEED_VALIDATE_DIC = [
        'YES' => 1,
        'NO' => 2
    ];
    
    /**
     * 字段默认展示宽度 单位px
     */
    const FIELD_WIDTH_DEFAULT = 0;
    
    /**
     * 字段类型（重要）
     */
    const FIELD_TYPE_DIC = [
        'TEXT'          => 'text',               //文本
        'SELECT'        => 'select',            //枚举
        'NUMBER'        => 'number',            //数字
        'DATE'          => 'date',              //日期
        'DATETIME'      => 'datetime',          //日期时间
        'BRAND'         => 'brand',             //车系车型车款
        'ADDRESS'       => 'address',           //省市区
        'WAREHOUSE'     => 'warehouse',         //仓库库位
        'ORGANIZATION'  => 'organization',      //组织架构
    ];
    
    /**
     * 搜索类型 （重要）
     */ 
    const SEARCH_TYPE_DIC = [
        'JUST' => 'just',               //正好是
        'ONEOF' => 'oneOf',             //之一
        'NOT' => 'not',                 //不是
        'INCLUDE' => 'include',         //包含
        'EXCEPT' => 'except',           //不包含
        'START' => 'start',             //开头是
        'END' => 'end',                 //结尾是
        'EQUAL' => 'equal',             //等于
        'LT' => 'lt',                   //小于
        'LTE' => 'lte',                 //小于等于
        'GT' => 'gt',                   //大于
        'GTE' => 'gte',                 //大于等于
        'BETWEEN' => 'between'          //介于（包括边界值）
    ];
    
    /**
     * 字段类型与搜索类型规则（重要）
     */
    const SEARCH_RULE_DIC = [
        'text'          => ['equal','include','just','except','not','oneOf','start','end'],
        'select'        => ['equal','just','oneOf','not'],
        'number'        => ['equal','lt','lte','gt','gte','between','oneOf'],
        'date'          => ['equal','lt','lte','gt','gte','between','oneOf'],
        'datetime'      => ['equal','lt','lte','gt','gte','between','oneOf'],
        'brand'         => ['equal'],
        'address'       => ['equal'],
        'warehouse'     => ['equal'],
        'organization'  => ['equal'],
    ];
    
    /**
     * 自定义验权（重要！）
     * 形式 func_code => [router（完全限定名称形式）, action]
     * 复杂业务 需要单独对列表数据 组织验权条件的填写到下方（针对数据越权访问）
     */
    const CUSTOM_VALIDATION = [
        //示例 
        //'org_list' => ['\app\system\service\OrgService', 'add']
    ];

    /************************************ 单据号相关 **************************************/
    /**
     * 单据号规则类型-自定义
     */
    CONST SEQ_RULE_TYPE_CUSTOM = 1;
    /**
     * 单据号规则类型-年月
     */
    CONST SEQ_RULE_TYPE_YEARMONTH = 2;
    /**
     * 单据号规则类型-年
     */
    CONST SEQ_RULE_TYPE_YEAR = 3;
    
    /**
     * 单据号规则状态-正常
     */
    CONST SEQ_RULE_STATUS_NORMAL = 1;
    /**
     * 单据号规则状态-停用
     */
    CONST SEQ_RULE_STATUS_FORBIDDEN = 2;
    /**
     * 单据号规则状态-作废
     */
    CONST SEQ_RULE_STATUS_INVALID = 3;

    /**
     * 单据号类型状态-正常
     */
    CONST SEQ_TYPE_STATUS_NORMAL = 1;
    /**
     * 单据号类型状态-停用
     */
    CONST SEQ_TYPE_STATUS_FORBIDDEN = 2;
    /**
     * 单据号类型状态-作废
     */
    CONST SEQ_TYPE_STATUS_INVALID = 3;

}
