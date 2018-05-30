<?php
namespace app\helper\util;

use app\helper\enum\CommonEnum;
use app\helper\Code;

/**
 * 公共方法类
 * @author even
 * @date: 2018年5月11日
 */
class CommonUtil
{
    /**
     * 多维数组排序
     * @param array $arrays 需要排序的数组
     * @param string $sort_key 需要排序的key
     * @param string $sort_order 排序的顺序
     * @param string $sort_type 排序类型
     * @author even
     * @date: 2018年5月11日
     */
    public static function selfMultisort($arrays,$sort_key,$sort_order=SORT_ASC,$sort_type=SORT_NUMERIC )
    {
        if(is_array($arrays))
        {
            foreach ($arrays as $array)
            {
                if(is_array($array))
                {
                    $key_arrays[] = $array[$sort_key];
                }
                else
                {
                    return false;
                }
            }
        }
        else
        {
            return false;
        }
        array_multisort($key_arrays,$sort_order,$sort_type,$arrays);
        return $arrays;
    }
    
    /**
     * 拼接limit语句
     * @param array $search_data 前端传输过来的搜索数据
     * @return string 拼接好的limit语句
     * @author even
     * @date: 2018年5月15日
     */
    public static function jointLimit( $search_data = [] )
    {
        $search_data['limit'] = isset( $search_data['limit'] ) ? $search_data['limit'] : CommonEnum::DEFAULT_PAGING_LIMIT;
        $search_data['offset'] = isset( $search_data['offset'] ) ? $search_data['offset'] : CommonEnum::DEFAULT_PAGINF_OFFSET;
        
        return sprintf(' limit %u,%u', $search_data['offset'], $search_data['limit']);
    }
    
    /**
     * 拼接排序语句
     * @param array $sort_filed 需要排序的字段
     * @return string 拼接好的ORDER BY语句
     * @author even
     * @date: 2018年5月15日
     */
    public static function jointOrderBy( $search = [] )
    {
        //默认排序create_time desc
        $sort_filed = [
            'field' => CommonEnum::DEFAULT_ORDER_BY_FIELD, 
            'rule' => CommonEnum::DEFAULT_ORDER_BY_RULE
        ];
        
        if( $search )
        {
            foreach( $search as $val )
            {
                //处理排序字段
                if( isset( $val['order_by'] ) )
                {
                    //过滤数据
                    $val['order_by'] = self::_filterSql( $val['order_by'] );
                    
                    //目前规定只能通过单字段排序
                    $sort_filed['field'] = $val['field'];
                    $sort_filed['rule'] = strtoupper( $val['order_by'] );
                }
            }
        }
        
        return sprintf(' order by %s %s', $sort_filed['field'], $sort_filed['rule']);
    }
    
    /**
     * 拼接SQL条件语句
     * @param array $search 前端传输过来的搜索字段
     * @return string 拼接好的WHERE条件语句
     * @author even
     * @date: 2018年5月15日
     */
    public static function jointFilter( $search = [] )
    {
        if( !$search )
        {
            return [Code::CODE_SUCCESS, ''];
        }
        
        //条件语句
        $sql_where = '';
        foreach( $search as $key => &$val )
        {
            //处理查询条件
            if( isset( $val['search'] ) )
            {
                //校验字段查询规则
                list( $code, $message ) = self::checkSearchRule( $val['search_type'], $val['type'] );
                if( $code )
                {
                    return [$code, $message];
                }
                
                foreach( $val['search'] as &$v )
                {
                    //过滤数据，且添加引号
                    $v = '"' . self::_filterSql( $v ) . '"';
                }
                
                switch( $val['search_type'] )
                {
                    case CommonEnum::SEARCH_TYPE_DIC['JUST']:       //正好是
                    case CommonEnum::SEARCH_TYPE_DIC['ONEOF']:      //之一
                    case CommonEnum::SEARCH_TYPE_DIC['EQUAL']:      //等于
                        $sql_where .= " AND {$val['field']} in (". implode(',', $val['search']) .")";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['NOT']:        //不是
                        $sql_where .= " AND {$val['field']} not in (". implode(',', $val['search']) .")";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['INCLUDE']:    //包含
                        $sql_where .= " AND {$val['field']} like '%{$val['search'][0]}%'";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['EXCEPT']:     //不包含
                        $sql_where .= " AND {$val['field']} not like '%{$val['search'][0]}%'";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['START']:      //开头是
                        $sql_where .= " AND {$val['field']} like '{$val['search'][0]}%'";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['END']:        //结尾是
                        $sql_where .= " AND {$val['field']} like '%{$val['search'][0]}'";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['LT']:         //小于
                        $sql_where .= " AND {$val['field']} < {$val['search'][0]}";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['LTE']:        //小于等于
                        $sql_where .= " AND {$val['field']} <= {$val['search'][0]}";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['GT']:         //大于
                        $sql_where .= " AND {$val['field']} > {$val['search'][0]}";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['GTE']:        //大于等于
                        $sql_where .= " AND {$val['field']} >= {$val['search'][0]}";
                        break;
                    case CommonEnum::SEARCH_TYPE_DIC['BETWEEN']:    //介于（包括边界值）
                        $sql_where .= " AND {$val['field']} BETWEEN {$val['search'][0]} AND {$val['search'][1]}";
                        break;
                    default:
                        return [Code::COMMON_SEARCH_TYPE_ERROR, '搜索类型非法'];
                }
            }
        }
        
        return [Code::CODE_SUCCESS, $sql_where ? ' WHERE ' . substr( $sql_where, 4 ) : ''];
    }
    
    /**
     * 校验字段查询规则
     * 每一个字段类型，对应一组查询规则
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月17日
     */
    public static function checkSearchRule( $search_type, $field_type )
    {
        if( !$search_type || !$field_type )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        if( isset( CommonEnum::SEARCH_RULE_DIC[$field_type] ) 
            && in_array( $search_type, CommonEnum::SEARCH_RULE_DIC[$field_type] ) )
        {
            return [Code::CODE_SUCCESS, ''];
        }
        else 
        {
            return [Code::COMM_SEARCH_RULE_ILLEGAL, '搜索规则非法'];
        }
    }
    
    /**
     * SQL过滤，包括：
     *  过滤多余符号
     *  转义引号
     * @param mixed $val 需要过滤的数据
     * @return mixed 过滤之后的数据
     * @author even
     * @date: 2018年5月15日
     */
    private function _filterSql( $val )
    {
        $val = str_replace(['`', ' '], '', trim( $val ));
        return addslashes(stripslashes($val));
    }
    
    
}

