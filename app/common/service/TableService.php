<?php
namespace app\common\service;

use frame\ChelerApi;
use app\helper\Code;
use app\helper\enum\CommonEnum;
use app\helper\enum\SystemEnum;
use app\helper\util\CommonUtil;
use app\helper\BaseService;

/**
 * 公共列表
 * @author even
 * @date: 2018年5月9日
 */
class TableService extends BaseService
{
    /**
     * 获取表头
     * @param array $user_info 登录后用户集合信息
     * @param array $func_info 功能集合信息
     * @return array 表头字段信息
     */ 
    public function getHeader( $user_info, $func_info )
    {
        if( !$user_info || !$func_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        $role_id = $this->parseUserRole( $user_info );
        $user_code = $user_info['user_code'];
        $func_code = $func_info['func_code'];
        
        //获取功能全字段信息
        $func_field_info = json_decode( $func_info['func_extra'], true );
        //过滤表头不展示字段
        foreach( $func_field_info as $key => $val )
        {
            if( CommonEnum::FIELD_HEADER_SHOW_DIC['NOT_SHOW'] == $val['is_header_show'] )
            {
                unset( $func_field_info[$key] );
            }
        }
        
        //获取角色所拥有的字段
        list( $code, $func_configed_params ) = $this->getRoleFields($func_code, $role_id);
        if( $code )
        {
            return [$code, $func_configed_params];
        }
        
        //获得字段交集
        list( $code, $func_field_info ) = $this->fieldIntersect($func_field_info, $func_configed_params);
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //获取列表筛选偏好设置
        list( $code, $preference_list_params ) = $this->getPreferenceList($func_code, $user_code, $func_field_info);
        if( $code )
        {
            return [$code, $preference_list_params];
        }
        
        //拼接偏好设置
        list( $code, $func_field_info ) = $this->jointPreference( $func_field_info, $preference_list_params );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //根据偏好设置过滤字段
        list( $code, $func_field_info ) = $this->filterFieldByPreference( $func_field_info );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //根据偏好设置排序字段
        list( $code, $func_field_info ) = $this->orderFieldByPreference( $func_field_info );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //组织字段枚举数据
        list( $code, $func_field_info ) = $this->_organizeFieldOptions( $func_code, $func_field_info );
        
        return [$code, $func_field_info];
    }
    
    /**
     * 获取列表数据
     * @param array $user_info 登录后用户集合信息
     * @param array $func_info 功能集合信息
     * @param array $search_data 前端提交的列表筛选数据
     * @return array 列表数据
     */ 
    public function getListData( $user_info, $func_info, $search_data = [] )
    {
        if( !$user_info || !$func_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        $role_id = $this->parseUserRole( $user_info );
        $user_code = $user_info['user_code'];
        $company_code = $user_info['company_code'];
        $func_code = $func_info['func_code'];
        
        //获取功能全字段信息
        $func_field_info = json_decode( $func_info['func_extra'], true );
        
        //获取角色所拥有的字段
        list( $code, $func_configed_params ) = $this->getRoleFields($func_code, $role_id);
        if( $code )
        {
            return [$code, $func_configed_params];
        }
        
        /**
         * 获得字段交集
         * 不屏蔽主键及pid、category_id等字段
         */
        list( $code, $func_field_info ) = $this->fieldIntersect($func_field_info, $func_configed_params);
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //获取列表偏好设置
        list( $code, $preference_list_params ) = $this->getPreferenceList($func_code, $user_code, $func_field_info);
        if( $code )
        {
            return [$code, $preference_list_params];
        }
        
        //拼接偏好设置
        list( $code, $preference_list_params ) = $this->jointPreference( $func_field_info, $preference_list_params );
        if( $code )
        {
            return [$code, $preference_list_params];
        }
        
        //根据偏好设置过滤字段
        list( $code, $preference_list_params ) = $this->filterFieldByPreference( $preference_list_params );
        if( $code )
        {
            return [$code, $preference_list_params];
        }
        
        //组织查询字段信息
        $search_fields = '';
        foreach( $preference_list_params as $key => $val )
        {
            $search_fields .= ',' . $val['field'];
        }
        $search_fields = $search_fields ? substr( $search_fields, 1 ) : '*';
        
        //处理 用户数据越权访问验证参数
        list( $code, $search_data ) = $this->_handleValidateFields( $user_info, $func_code, $func_field_info, $search_data );
        if( $code )
        {
            return [$code, $search_data];
        }
        
        //过滤查询条件字段
        $sql_where = '';
        if( !empty( $search_data['search'] ) )
        {
            //获取搜索偏好设置
            list( $code, $preference_filter_params ) = $this->_getPreferenceFilter($func_code, $user_code );
            if( $code )
            {
                return [$code, $preference_filter_params];
            }
            
            //拼接偏好设置
            list( $code, $search_data['search'] ) = $this->jointPreference( $search_data['search'], $preference_filter_params );
            if( $code )
            {
                return [$code, $search_data['search']];
            }
            
            //拼接基础属性
            //传输进来的字段类型不可信，需要用原始类型覆盖一次
            list( $code, $search_data['search'] ) = $this->jointPreference( $func_field_info, $search_data['search'], 1 );
            if( $code )
            {
                return [$code, $search_data['search']];
            }
        }
        
        //组织查询条件语句
        list( $code, $sql_where ) = CommonUtil::jointFilter( $search_data['search'] );
        if( $code )
        {
            return [$code, $sql_where];
        }
        
        //组织order by语句
        $sql_order_by = CommonUtil::jointOrderBy( $search_data['search'] );
        
        //组织limit语句
        $sql_limit = CommonUtil::jointLimit( $search_data );
        
        //获取总条数
        $sql = sprintf('SELECT count(*) as count FROM %s %s', $func_info['func_db'], $sql_where);
        $res = $this->init_db()->get_all_sql( $sql );
        $count = $res[0]['count'];
        
        //获取数据
        $sql = sprintf('SELECT %s FROM %s %s %s %s', $search_fields, $func_info['func_db'], $sql_where, $sql_order_by, $sql_limit);
        //DB类已进行过异常处理，故不再重复
        //这里要么返回数据，要么返回空数组
        $res = $this->init_db()->get_all_sql( $sql );
        
        return [Code::CODE_SUCCESS, [
            'list' => $res,
            'count' => $count
        ]];
    }
    
    /**
     * 获取列表筛选项
     * @param array $user_info 登录后用户集合信息
     * @param array $func_info 功能集合信息
     * @return array 列表筛选字段信息
     */
    public function getFilter( $user_info, $func_info )
    {
        if( !$user_info || !$func_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        $role_id = $this->parseUserRole( $user_info );
        $user_code = $user_info['user_code'];
        $func_code = $func_info['func_code'];
        
        //获取功能全字段信息
        $func_field_info = json_decode( $func_info['func_extra'], true );
        
        //获取角色权限所属字段
        list( $code, $func_configed_params ) = $this->getRoleFields($func_code, $role_id);
        if( $code )
        {
            return [$code, $func_configed_params];
        }
        
        //获取列表筛选偏好设置
        list( $code, $preference_filter_params ) = $this->_getPreferenceFilter($func_code, $user_code );
        if( $code )
        {
            return [$code, $preference_filter_params];
        }
        
        //获得字段交集
        list( $code, $preference_filter_params ) = $this->fieldIntersect($preference_filter_params, $func_configed_params);
        if( $code )
        {
            return [$code, $preference_filter_params];
        }
        
        //拼接偏好设置
        list( $code, $preference_filter_params ) = $this->jointPreference( $preference_filter_params, $func_field_info );
        if( $code )
        {
            return [$code, $preference_filter_params];
        }
        
        //组织字段枚举数据
        list( $code, $preference_filter_params ) = $this->_organizeFieldOptions( $func_code, $preference_filter_params );
        
        return [$code, $preference_filter_params];
    }
    
    /**
     * 获取功能全字段
     * @param string $func_code 功能编号
     * @return array 功能集合信息
     */ 
    public function getFuncInfo( $func_code )
    {
        if( !$func_code )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        $func_info = $this->init_db()->get_one_by_field(['func_code' => $func_code], 'sys_func');
        if( !$func_info )
        {
            return [Code::COMM_FUNC_INEXIS, '访问功能不存在'];
        }
        elseif( CommonEnum::FUNC_TYPE_VIEW != $func_info['func_type'] )
        {
            return [Code::COMM_FUNC_TYPE_ERROR, '功能权限类型错误'];
        }
        elseif( empty( $func_info['func_extra'] ) )
        {
            return [Code::COMM_FUNC_CONFIG_ERROR, '功能配置错误'];
        }
        
        return [Code::CODE_SUCCESS, $func_info];
    }
    
    /**
     * 获取角色拥有字段
     * @param string $func_code 功能编号
     * @param array $role_id 角色id，同一用户可隶属于不同角色，故是数组形式
     * @return array 角色字段信息
     */ 
    public function getRoleFields( $func_code, $role_id )
    {
        if( !$func_code || !$role_id )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        $func_role_info = $this->init_db()->get_all_by_field([
            'role_id' => $role_id,
            'func_code' => $func_code
        ], 'sys_rel_role_func');
        if( !$func_role_info )
        {
            return [Code::COMM_ACCESS_DENY, '无权访问'];
        }
        
        //不同角色所拥有的权限字段
        $role_fields = [];
        //解析字段
        foreach( $func_role_info as $val )
        {
            if( empty( $val['func_configed_params'] ) )
            {
                return [Code::COMM_ACCESS_DENY, '无权访问'];
            }
            $role_fields[] = json_decode( $val['func_configed_params'], true );
        }
        
        $res = [];
        foreach( $role_fields as $role_field )
        {
            //同一用户隶属于不同角色，而不同角色可能对同一func_code有不同的字段权限，在这里兼容至最高权限
            //1可读可写  2只读
            foreach( $role_field as $key => $field )
            {
                if( isset( $res[$key] ) )
                {
                    if( $field < $res[$key] )
                    {
                        //高权限覆盖低权限
                        $res[$key] = $field;
                    }
                }
                else
                {
                    $res[$key] = $field;
                }
            }
        }

        return [Code::CODE_SUCCESS, $res];
    }
    
    /**
     * 解析用户角色id
     * 组织成['role_id1'=>1,'role_id2'=>2]
     * @param array $user_info 登录后的用户信息集合
     * @return array 组织后的用户角色数据
     */
    public function parseUserRole( $user_info )
    {
        $arr_role_id = [];
        
        if( !$user_info || empty( $user_info['user_roles'] ) )
        {
            return [];
        }
        
        foreach( $user_info['user_roles'] as $val )
        {
            $arr_role_id = $val['role_id'];
        }
        
        return $arr_role_id;
    }
    
    /**
     * 获取字段交集
     * 涉及到：1.功能全字段与角色所属字段交集
     *         2.列表筛选字段与角色所属字段交集
     * @param array $basics_arr 基础数组
     * @param array $reference_arr 参考数组
     * @return array 取交集后字段数组
     */
    public function fieldIntersect( $basics_arr, $reference_arr )
    {
        if( !$basics_arr )
        {
            return [Code::CODE_SUCCESS, []];
        }
        elseif( !$reference_arr )
        {
            return [Code::CODE_SUCCESS, $basics_arr];
        }
        
        $res = [];
        foreach( $basics_arr as $val )
        {
            foreach( $reference_arr as $k => $v )
            {
               //sys_rel_role_func表中只存放有权限的字段，因此这里只需要判断字段是否存在
               if( $val['field'] == $k )
               {
                   $res[] = $val;
               }
            }
        }
        
        return [Code::CODE_SUCCESS, $res];
    }
    
    /**
     * 获取列表偏好设置
     * @param string $func_code 功能编号
     * @param string $user_code 用户编号
     * @param array $func_field_info 功能字段信息
     * @return array 列表偏好设置信息
     */ 
    public function getPreferenceList( $func_code, $user_code, $func_field_info )
    {
        if( !$func_code || !$user_code || !$func_field_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        $preference_list = $this->init_db()->get_one_by_field([
            'user_code' => $user_code,
            'func_code' => $func_code
        ], 'sys_user_preference_list');
        if( !$preference_list )
        {
            //初始化列表筛选偏好设置
            $preference_list = $this->_initPreferenceList( $user_code, $func_code, $func_field_info );
            if( !$preference_list )
            {
                return [Code::COMM_INIT_PREFERENCE_ERROR, '初始化列表偏好设置错误'];
            }
        }
        
        return [Code::CODE_SUCCESS, json_decode( $preference_list['list_params'], true )];
    }
    
    /**
     * 初始化列表偏好设置
     * @param string $user_code 用户编号
     * @param string $func_code 功能编号
     * @param array $func_field_info 功能字段信息
     * @return array 列表偏好设置信息
     */
    private function _initPreferenceList( $user_code, $func_code, $func_field )
    {
        if( !$user_code || !$func_code || !$func_field )
        {
            return false;
        }
        
        //偏好设置字段
        $list_params = [];
        foreach( $func_field as $key => $val )
        {
            $list_params[] = [
                'field' => $val['field'],
                'align' => CommonEnum::FIELD_ALIGN_DIC['LEFT'],
                'is_show' => CommonEnum::FIELD_SHOW_DIC['SHOW'],
                'width' => CommonEnum::FIELD_WIDTH_DEFAULT,
                'order_num' => $key+1
            ];
        }
        
        //入库数据
        $data = [
            'user_code' => $user_code,
            'func_code' => $func_code,
            'list_params' => json_encode( $list_params, JSON_UNESCAPED_UNICODE )
        ];
        if( !$insert_id = $this->init_db()->insert( $data, 'sys_user_preference_list' ) )
        {
            return false;
        }
        
        $data['prefer_list_id'] = $insert_id;
        return $data;
    }
    
    /**
     * 获取列表筛选偏好设置
     * @param string $func_code 功能编号
     * @param string $user_code 用户编号
     * @return array 列表筛选偏好设置信息
     */
    private function _getPreferenceFilter( $func_code, $user_code )
    {
        if( !$func_code || !$user_code )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        $preference_filter = $this->init_db()->get_one_by_field([
            'user_code' => $user_code,
            'func_code' => $func_code
        ], 'sys_user_preference_search');
        if( $preference_filter && !empty( $preference_filter['search_params'] ) )
        {
            $preference_filter_params = json_decode( $preference_filter['search_params'], true );
        }
        else 
        {
            $preference_filter_params = [];
        }
        
        return [Code::CODE_SUCCESS, $preference_filter_params];
    }
    
    /**
     * 拼接偏好设置
     * 将字段偏好属性拼接至字段基础属性之后，涉及到：
     *  1.拼接列表展示偏好设置
     *  2.拼接列表筛选偏好设置
     * 以basics_arr为准，保留basics_arr主体
     * @param array $basics_arr 基础数组
     * @param array $reference_arr 参考数组
     * @param int $joint_type 拼接类型（重要）
     *   0-基础数组属性 覆盖 参考数组属性
     *   1-参考数组属性 覆盖 基础数组属性
     * @return array 拼接后的字段信息
     */
    public function jointPreference( $basics_arr, $reference_arr, $joint_type = 0 )
    {
        if( !$basics_arr )
        {
            return [Code::CODE_SUCCESS, []];
        }
        elseif( !$reference_arr )
        {
            return [Code::CODE_SUCCESS, $basics_arr];
        }
        
        foreach( $basics_arr as &$val )
        {
            foreach( $reference_arr as $v )
            {
                if( $val['field'] == $v['field'] )
                {
                    if( $joint_type )
                    {
                        //参考覆盖基础
                        $val = array_merge( $val, $v );
                    }
                    else
                    {
                        //基础覆盖参考
                        $val = array_merge( $v, $val );
                    }
                }
            }
        }
        
        return [Code::CODE_SUCCESS, $basics_arr];
    }
    
    /**
     * 组织字段枚举数据
     * @param string $func_code 功能编号
     * @param array $func_field_info 功能字段信息
     * @return array 拼接枚举值后的字段信息
     */
    private function _organizeFieldOptions( $func_code, $func_field )
    {
        if( !$func_code )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        elseif( !$func_field )
        {
            return [Code::CODE_SUCCESS, []];
        }
        
        //筛选需要枚举数据的字段
        $field = [];
        foreach( $func_field as $val )
        {
            if( CommonEnum::FIELD_TYPE_DIC['SELECT'] === $val['type'] 
                && empty( $val['now_data_url'] ) )
            {
                $field[] = $val['field'];
            }
        }
        if( !$field )
        {
            //无枚举类型，原样返回
            return [Code::CODE_SUCCESS, $func_field];
        }
        
        //获取所需字段的所有枚举值
        $optionData = $this->init_db()->get_all_by_field( [
            'func_code' => $func_code,
            'field_name' => $field
        ], 'sys_field_option_dic' );
        if( !$optionData )
        {
            return [Code::COMM_FIELD_OPTION_ERROR, '字段枚举值获取失败'];
        }
        
        //拼接枚举值
        foreach( $func_field as &$val )
        {
            foreach( $optionData as $v )
            {
                if( $val['field'] == $v['field_name'] )
                {
                    $val['option'] = json_decode( $v['option'], true );
                }
            }
        }
        
        return [Code::CODE_SUCCESS, $func_field];
    }
    
    /**
     * 根据偏好设置过滤字段
     * @param array $func_field_info 功能字段信息
     * @return array 过滤后的字段信息
     */ 
    public function filterFieldByPreference( $func_field_info )
    {
        if( !$func_field_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        foreach( $func_field_info as $key => $val )
        {  
            if( isset( $val['is_show'] ) && CommonEnum::FIELD_SHOW_DIC['NOT_SHOW'] == $val['is_show'] )
            {
                unset( $func_field_info[$key] );
            }
        }
        
        return [Code::CODE_SUCCESS, $func_field_info];
    }
    
    /**
     * 根据偏好设置排序字段
     * @param array $func_field_info 功能字段信息
     * @return array 排序后的字段信息
     */ 
    public function orderFieldByPreference( $func_field_info )
    {
        if( !$func_field_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        //根据order_num属性，进行二维数组排序
        $func_field_info = CommonUtil::selfMultisort( $func_field_info, 'order_num' );
        if( false === $func_field_info )
        {
            return [Code::COMM_FIELD_ORDER_ERROR, '字段排序错误'];
        }
        else 
        {
            return [Code::CODE_SUCCESS, $func_field_info];
        }
    }
    
    /**
     * 替换联动类型字段的数据值（暂不使用）
     * @param array $func_field_info 功能字段信息
     * @param array $res 列表数据
     * @param string $company_code 账套
     * @return array 替换后的列表数据
     */ 
    private function _parseListData( $func_field_info, $res, $company_code )
    {
        if( !$func_field_info || !$company_code )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        elseif( !$res )
        {
            return [Code::CODE_SUCCESS, []];
        }
        
        /**
         * 联动字段数据字典
         * [
         *      'select' => [field1,field2,field3]
         * ]
         */
        $link_field_dic = [];
        
        //筛选联动字段并获取联动字典数据
        //考虑到后期将联动数据全部做成缓存，故这里一次性获取全部联动数据
        //不采用先筛选列表数据联动字段id值，再去查询对应联动数据，最后再替换的方案
        foreach( $func_field_info as $val )
        {
            if( CommonEnum::FIELD_TYPE_DIC['BRAND'] === $val['type'] )
            {
                $link_field_dic[$val['type']][] = $val['field'];

                //获取车系车款全部数据
                list( $code, $vehicle_type_info ) = $this->_ParseVehicleType( $company_code );
                if( $code )
                {
                    return [$code, $vehicle_type_info];
                }
            }
            elseif( CommonEnum::FIELD_TYPE_DIC['ADDRESS'] === $val['type'] )
            {
                $link_field_dic[$val['type']][] = $val['field'];
                
                //获取省市区全部数据
                list( $code, $common_area_info ) = $this->_ParseCommonArea();
                if( $code )
                {
                    return [$code, $common_area_info];
                }
            }
        }
        
        if( $link_field_dic )
        {
            //替换数据
            foreach( $res as &$val )
            {
                //替换车系车款
                if( isset( $link_field_dic[CommonEnum::FIELD_TYPE_DIC['BRAND']] ) )
                {
                    foreach( $link_field_dic[CommonEnum::FIELD_TYPE_DIC['BRAND']] as $v )
                    {
                        $val[$v] = isset( $vehicle_type_info[$val[$v]] ) ? $vehicle_type_info[$val[$v]] 
                        : CommonEnum::SHOW_DEFAULT_VALUE;
                    }
                }
                //替换省市区
                if( isset( $link_field_dic[CommonEnum::FIELD_TYPE_DIC['ADDRESS']] ) )
                {
                    foreach( $link_field_dic[CommonEnum::FIELD_TYPE_DIC['ADDRESS']] as $v )
                    {
                        $val[$v] = isset( $common_area_info[$val[$v]] ) ? $common_area_info[$val[$v]] 
                        : CommonEnum::SHOW_DEFAULT_VALUE;
                    }
                }
            }
        }
        
        return [Code::CODE_SUCCESS, $res];
    }
    
    /**
     * 解析车型车款数据
     * 业务数据存储的是vehicle_type_code，因此company_code+vehicle_type_code才能全局唯一确定一款车型
     * 故这里全部组织为一位数组，剔除非该company_code下的数据，最终形如 'vehicle_type_code' => '对应中文名'
     * @param string $company_code 账套
     * @return array 经过组织的车型车款数据
     */ 
    private function _parseVehicleType( $company_code )
    {
        if( !$company_code )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        if( !$vehicle_type_data = $this->_getCommonService()->GetAllVehicleType() )
        {
            return [Code::COMM_VEHICLE_TYPE_DIC_ERROR, '车型字典数据获取失败'];
        }
        
        $res = [];
        foreach( $vehicle_type_data as $val )
        {
            if( $company_code == $val['company_code'] )
            {
                $res[$val['vehicle_type_code']] = $val['vehicle_type_name'];
            }
        }
        if( !$res )
        {
            return [Code::COMM_VEHICLE_TYPE_PARSE_ERROR, '车型数据解析失败'];
        }
        
        return [Code::CODE_SUCCESS, $res];
    }
    
    /**
     * 解析省市区数据
     * 这里全部组织为一位数组，且形如 'id' => '对应中文名'
     * @return array 经过组织的省市区数据
     */ 
    private function _parseCommonArea()
    {
        if( !$common_area_data = $this->_getCommonService()->GetAllCommonArea() )
        {
            return [Code::COMM_COMMON_AREA_DIC_ERROR, '省市区字典数据获取失败'];
        }
        
        $res = [];
        foreach( $common_area_data as $val )
        {
            $res[$val['id']] = $val['name'];
        }
        if( !$res )
        {
            return [Code::COMM_COMMON_AREA_PARSE_ERROR, '省市区数据解析失败'];
        }
        
        return [Code::CODE_SUCCESS, $res];
    }
    
    /**
     * 处理 用户数据越权访问验证参数
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月18日
     */ 
    private function _handleValidateFields( $user_info, $func_code, $func_field_info, $search_data = [] )
    {
        if( !$user_info || !$func_code || !$func_field_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        //如果是超级管理员，不做验权，直接通过
        if( SystemEnum::USER_IS_SUPER_YES == $user_info['is_super'] )
        {
            return [Code::CODE_SUCCESS, $search_data];
        }
        
        if( isset( CommonEnum::CUSTOM_VALIDATION[$func_code] ) )
        {
            //针对复杂业务特殊处理
            $model = ChelerApi::loadClass(CommonEnum::CUSTOM_VALIDATION[$func_code][0]);
            $res = $model->{CommonEnum::CUSTOM_VALIDATION[$func_code][1]}();
            if( !$res )
            {
                return [Code::COMM_CUSTOM_VALIDATE_FIELD_ERROR, '自定义验权参数错误'];
            }
            
            foreach( $res as $val )
            {
                if( empty( $user_info[$val['field']] ) )
                {
                    return [Code::COMM_VALIDATE_FIELD_ERROR, '验权字段数据有误'];
                }
                
                //组织越权访问验证参数
                $search_data = $this->_organizeValidateFields( $user_info, $val, $search_data );
            }
        }
        else 
        {
            //若存在验权字段，则将验权字段强制组织为搜索项
            foreach( $func_field_info as $val )
            {
                if( CommonEnum::NEED_VALIDATE_DIC['YES'] == $val['need_validate'] )
                {
                    if( empty( $user_info[$val['field']] ) )
                    {
                        return [Code::COMM_VALIDATE_FIELD_ERROR, '验权字段数据有误'];
                    }
                    
                    //组织越权访问验证参数
                    $search_data = $this->_organizeValidateFields( $user_info, $val, $search_data );
                }
            }
        }
        
        return [Code::CODE_SUCCESS, $search_data];
    }
    
    /**
     * 组织越权访问验证参数
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月18日
     */ 
    private function _organizeValidateFields( $user_info, $field_info, $search_data = [] )
    {
        if( $search_data && !empty( $search_data['search'] ) )
        {
            //当前存在搜索项
            foreach( $search_data['search'] as &$v )
            {
                if( $field_info['field'] == $v['field'] )
                {
                    //将验权字段组织成的搜索数据强制覆盖用户传入的搜索数据
                    $v['search_type'] = CommonEnum::SEARCH_TYPE_DIC['EQUAL'];
                    $v['search'] = [$user_info[$field_info['field']]];
                }
            }
        }
        else
        {
            //当前不存在搜索项，则将验权字段强制组织成搜索项
            $search_data['search'][] = [
                'field' => $field_info['field'],
                'search_type' => CommonEnum::SEARCH_TYPE_DIC['EQUAL'],
                'search' => [$user_info[$field_info['field']]]
            ];
        }
        
        return $search_data;
    }
    
    /**
     * @return CommonService
     */
    private function _getCommonService()
    {
        return ChelerApi::getService('common\service\Common');
    }
    
}
