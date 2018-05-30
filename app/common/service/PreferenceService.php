<?php
namespace app\common\service;

use frame\ChelerApi;
use app\helper\Code;
use app\helper\enum\CommonEnum;
use app\helper\BaseService;
use app\helper\cache\RedisCache;
use app\helper\util\CommonUtil;
use app\helper\enum\SystemEnum;

/**
 * 偏好设置相关
 * 包括列表偏好设置、列表搜索偏好设置、菜单收藏夹
 * @author even
 * @date: 2018年5月15日
 */
class PreferenceService extends BaseService
{
    /**
     * 获取用户列表偏好设置
     * @param string $func_code 功能编码
     * @param array $user_info 登录后用户信息集合
     * @return array 列表偏好设置信息
     * @author even
     * @date: 2018年5月15日
     */ 
    public function getPreferenceList( $func_code, $user_info )
    {
        if( !$func_code || !$user_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        $user_code = $user_info['user_code'];
        $role_id = $this->_getTableService()->parseUserRole( $user_info );
        
        //获取列表偏好设置合法字段
        list( $code, $func_field_info ) = $this->_getListLegalField( $func_code, $role_id );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //获取列表偏好设置
        list( $code, $preference_list_params ) = $this->_getTableService()->getPreferenceList( $func_code, $user_code, $func_field_info );
        if( $code )
        {
            return [$code, $preference_list_params];
        }
        
        //拼接偏好设置
        list( $code, $func_field_info ) = $this->_getTableService()->jointPreference( $func_field_info, $preference_list_params );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //根据偏好设置排序字段
        list( $code, $func_field_info ) = $this->_getTableService()->orderFieldByPreference( $func_field_info );
        
        return [$code, $func_field_info];
    }
    
    /**
     * 编辑列表偏好设置
     * @param string $func_code 功能编码
     * @param array $user_info 登录后用户信息集合
     * @param array $preference_data 新列表偏好设置数据
     * @return array
     * @author even
     * @date: 2018年5月16日
     */ 
    public function editPreferenceList( $func_code, $user_info, $preference_data )
    {
        if( !$func_code || !$user_info || !$preference_data )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        $user_code = $user_info['user_code'];
        $role_id = $this->_getTableService()->parseUserRole( $user_info );
        
        //获取列表偏好设置合法字段
        list( $code, $func_field_info ) = $this->_getListLegalField( $func_code, $role_id );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //过滤并重新组织新列表偏好设置数据
        $preference_list_params = [];
        foreach( $preference_data as $key => $val )
        {
            foreach( $func_field_info as $v )
            {
                if( $val['field'] == $v['field'] )
                {
                    $preference_list_params[] = [
                        'field' => $val['field'],
                        'align' => $val['align'],
                        'is_show' => $val['is_show'],
                        'width' => $val['width'],
                        'order_num' => $key+1,
                    ];
                }
            }
        }
        
        if( !$preference_list_params )
        {
            return [Code::COMM_EDIT_PREFERENCE_DENY, '无权设置当前列表字段'];
        }
        
        //更新库
        $res = $this->init_db()->update_by_field( [
            'list_params' => json_encode( $preference_list_params, JSON_UNESCAPED_UNICODE )
        ], [
            'user_code' => $user_code,
            'func_code' => $func_code
        ], 'sys_user_preference_list' );
        
        return [Code::CODE_SUCCESS, ''];
    }
    
    /**
     * 还原偏好设置
     * @param string $func_code 功能编码
     * @param array $user_info 登录后用户信息集合
     * @return array 列表偏好设置信息
     * @author even
     * @date: 2018年5月15日
     */ 
    public function restorePreferenceList( $func_code, $user_info )
    {
        if( !$func_code || !$user_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        $user_code = $user_info['user_code'];
        $role_id = $this->_getTableService()->parseUserRole( $user_info );
        
        //获取列表偏好设置合法字段
        list( $code, $func_field_info ) = $this->_getListLegalField( $func_code, $role_id );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //组织初始化列表筛选数据
        $preference_list_params = [];
        foreach( $func_field_info as $key => $val )
        {
            $preference_list_params[] = [
                'field' => $val['field'],
                'align' => CommonEnum::FIELD_ALIGN_DIC['LEFT'],
                'is_show' => CommonEnum::FIELD_SHOW_DIC['SHOW'],
                'width' => CommonEnum::FIELD_WIDTH_DEFAULT,
                'order_num' => $key+1
            ];
        }
        
        //入库数据
        $data = [
            'list_params' => json_encode( $preference_list_params, JSON_UNESCAPED_UNICODE )
        ];
        
        //更新库
        $res = $this->init_db()->update_by_field( $data, [
            'user_code' => $user_code,
            'func_code' => $func_code
        ], 'sys_user_preference_list' );
        
        //拼接偏好设置
        list( $code, $func_field_info ) = $this->_getTableService()->jointPreference( $func_field_info, $preference_list_params );
            
        return [$code, $func_field_info];
    }
    
    /**
     * 删除用户对应的所有偏好设置
     * 包括列表偏好设置、搜索偏好设置
     * @param array $arr_user_code 所有涉及到的用户编号
     * @return array
     * @author even
     * @date: 2018年5月15日
     */ 
    public function deleteAllPreference( $arr_user_code = [] )
    {
        if( !$arr_user_code )
        {
            return [Code::CODE_SUCCESS, ''];
        }
        
        //删除列表偏好设置
        $res = $this->init_db()->delete_by_field( [
            'user_code' => $arr_user_code
        ], 'sys_user_preference_list' );
        if( !$res )
        {
            return [Code::COMM_DEL_PRE_LIST_ERROR, '列表偏好设置删除失败'];
        }
        
        //删除搜索偏好设置
        $res = $this->init_db()->delete_by_field( [
            'user_code' => $arr_user_code
        ], 'sys_user_preference_search' );
        if( !$res )
        {
            return [Code::COMM_DEL_PRE_SEARCH_ERROR, '搜索偏好设置删除失败'];
        }
        
        return [Code::CODE_SUCCESS, ''];
    }
    
    /**
     * 获取列表偏好设置合法字段
     * （根据权限及基础属性设置，屏蔽不必要的字段）
     * @param string $func_code 功能编码
     * @param array $role_id 用户角色id集合
     * @param int $is_super 是否是超管 0-否 1-是
     * @return array 用户权限所属的字段集合
     * @author even
     * @date: 2018年5月16日
     */
    private function _getListLegalField( $func_code, $role_id, $is_super = 0 )
    {
        if( !$func_code || !$role_id )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        //获取功能集合信息
        list( $code, $func_info ) = $this->_getTableService()->getFuncInfo( $func_code );
        if( $code )
        {
            return [$code, $func_info];
        }
        //获取功能全字段信息
        $func_field_info = json_decode( $func_info['func_extra'], true );
        
//         if( !$is_super )
//         {
            //过滤表头不展示字段
            foreach( $func_field_info as $key => $val )
            {
                if( CommonEnum::FIELD_HEADER_SHOW_DIC['NOT_SHOW'] == $val['is_header_show'] )
                {
                    unset( $func_field_info[$key] );
                }
            }
//         }
        
        //获取角色所拥有的字段
        list( $code, $role_params ) = $this->_getTableService()->getRoleFields($func_code, $role_id);
        if( $code )
        {
            return [$code, $role_params];
        }
        
        //获得字段交集
        list( $code, $func_field_info ) = $this->_getTableService()->fieldIntersect($func_field_info, $role_params);
        
        return [$code, $func_field_info];
    }
    
    /**
     * 获取收藏夹菜单信息
     * @param string $user_code 用户编码
     * @param array $func_info 功能集合信息
     * @return array 收藏夹菜单信息
     * @author even
     * @date: 2018年5月16日
     */ 
    public function getFavoriteMenu( $user_code, $func_info )
    {
        if( !$user_code || !$func_info )
        {
            return [];
        }
        
        //获取收藏夹菜单信息
        $favorite_menu_info = $this->init_db()->get_all_by_field([
            'user_code' => $user_code
        ], 'sys_user_favorite_menu');
        if( !$favorite_menu_info )
        {
            return [];
        }
        
        $res = [];
        foreach( $favorite_menu_info as $val )
        {
            foreach( $func_info as $v )
            {
                if( $val['func_code'] == $v['func_code'] )
                {
                    $res[] = $v;
                }
            }
        }
        
        return $res;
    }
    
    /**
     * 新增菜单至收藏夹
     * @param string $func_code 功能编码
     * @param array $user_info 用户集合信息
     * @return array 
     * @author even
     * @date: 2018年5月16日
     */ 
    public function addFavoriteMenu( $func_code, $user_info )
    {
        if( !$func_code || !$user_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        if( empty( $user_info['user_funcs_tree'] ) )
        {
            return [Code::COMM_ACCESS_DENY, '无权收藏菜单'];
        }
        
        //判重
        if( !empty( $user_info['user_favorite_funcs'] ) )
        {
            foreach( $user_info['user_favorite_funcs'] as $val )
            {
                if( $val['func_code'] == $func_code )
                {
                    return [Code::COMM_REPEAT_COLLECT_MENU, '请勿重复收藏菜单'];
                }
            }
        }
        
        //校验菜单权限，并返回匹配项的菜单信息
        list( $code, $func_info ) = $this->_checkMenuPermession( $func_code, $user_info['user_funcs_tree'] );
        if( $code )
        {
            return [$code, $func_info];
        }
        
        //组织数据
        $data = [
            'user_code' => $user_info['user_code'],
            'func_code' => $func_code
        ];
        
        //入库
        $insert_id = $this->init_db()->insert($data, 'sys_user_favorite_menu');
        if( !$insert_id )
        {
            return [Code::COMM_ADD_ERROR, '菜单收藏失败'];
        }
        
        //更新缓存
        $user_info['user_favorite_funcs'][] = $func_info; 
        $this->_updateUserCache( $user_info );
        
        return [Code::CODE_SUCCESS, ''];
    }
    
    /**
     * 从收藏夹中删除菜单
     * @param string $func_code 功能编码
     * @param array $user_info 用户集合信息
     * @return array 
     * @author even
     * @date: 2018年5月16日
     */ 
    public function deleteFavoriteMenu( $func_code, $user_info )
    {
        if( !$func_code || !$user_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        if( empty( $user_info['user_funcs_tree'] ) )
        {
            return [Code::COMM_ACCESS_DENY, '无权操作菜单'];
        }
        
        //判断是否收藏当前菜单
        if( empty( $user_info['user_favorite_funcs'] ) )
        {
            return [Code::COMM_FAVORITE_MENU_INEXIS, '您还未收藏该菜单'];
        }
        else
        {
            $is_exist = false;
            foreach( $user_info['user_favorite_funcs'] as $val )
            {
                if( $val['func_code'] == $func_code )
                {
                    $is_exist = true;
                }
            }
            if( !$is_exist )
            {
                return [Code::COMM_FAVORITE_MENU_INEXIS, '您还未收藏该菜单'];
            }
        }
        
        //删除数据
        $res = $this->init_db()->delete_by_field([
            'user_code' => $user_info['user_code'],
            'func_code' => $func_code
        ], 'sys_user_favorite_menu');
        if( false === $res )
        {
            return [Code::COMM_DELETE_ERROR, '取消收藏失败'];
        }
        
        //更新缓存
        foreach( $user_info['user_favorite_funcs'] as $key => $val )
        {
            if( $val['func_code'] == $func_code )
            {
                unset( $user_info['user_favorite_funcs'][$key] );
            }
        }
        $this->_updateUserCache( $user_info );
        
        return [Code::CODE_SUCCESS, ''];
    }
    
    /**
     * 校验菜单权限
     * 递归调用
     * @param string $func_code 功能编码
     * @param array $func_tree 菜单集合信息
     * @return array 当前要收藏的菜单信息
     * @author even
     * @date: 2018年5月16日
     */ 
    private function _checkMenuPermession( $func_code, $func_tree )
    {
        if( !$func_code || !$func_tree )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        
        foreach( $func_tree as $val )
        {
            //功能编码匹配 且 为视图权限 则通过
            if( $val['func_code'] == $func_code && CommonEnum::FUNC_TYPE_VIEW == $val['func_type'] )
            {
                if( isset( $val['sub'] ) )
                {
                    unset( $val['sub'] );
                }
                return [Code::CODE_SUCCESS, $val];
            }
            
            if( !empty( $val['sub'] ) )
            {
                list( $code, $func_info ) = $this->_checkMenuPermession( $func_code, $val['sub'] );
                if( $code )
                {
                    continue;
                }
                else 
                {
                    return [Code::CODE_SUCCESS, $func_info];
                }
            }
        }
        
        return [Code::COMM_ACCESS_DENY, '无权收藏菜单'];
    }
    
    /**
     * 更新用户信息集合缓存
     * @param array $user_info 用户信息集合
     * @return void
     * @author even
     * @date: 2018年5月16日
     */ 
    private function _updateUserCache( $user_info )
    {
        $cache_key = RedisCache::R_system_login_data($user_info['user_code']);
        $this->getRedis('default')->set($cache_key,
            json_encode($user_info, JSON_UNESCAPED_UNICODE),
            $this->getRedis('default')->redis()->ttl($cache_key));
    }
    
    /**
     * 获取可进行搜索偏好设置的字段
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月18日
     */ 
    public function GetPreferenceSearch( $func_code, $user_info )
    {
        if( !$func_code || !$user_info )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        $user_code = $user_info['user_code'];
        $role_id = $this->_getTableService()->parseUserRole( $user_info );
        
        //获取偏好设置合法字段
        list( $code, $func_field_info ) = $this->_getListLegalField( $func_code, $role_id );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        if( SystemEnum::USER_IS_SUPER_NO == $user_info['is_super'] )
        {
            //过滤权限校验字段
            foreach( $func_field_info as $key => $val )
            {
                if( CommonEnum::NEED_VALIDATE_DIC['YES'] == $val['need_validate'] )
                {
                    unset( $func_field_info[$key] );
                }
            }
        }
        
        //获取列表偏好设置
        list( $code, $preference_list_params ) = $this->_getTableService()->getPreferenceList( $func_code, $user_code, $func_field_info );
        if( $code )
        {
            return [$code, $preference_list_params];
        }
        
        //拼接偏好设置
        list( $code, $func_field_info ) = $this->_getTableService()->jointPreference( $func_field_info, $preference_list_params );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //根据偏好设置过滤字段
        list( $code, $func_field_info ) = $this->_getTableService()->filterFieldByPreference( $func_field_info );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        return [Code::CODE_SUCCESS, $func_field_info];
    }
    
    /**
     * 更新用户搜索偏好设置
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月17日
     */ 
    public function editPreferenceSearch( $func_code, $user_info, $preference_data )
    {
        if( !$func_code || !$user_info || !$preference_data )
        {
            return [Code::COMM_PARAM_ERROR, '参数错误'];
        }
        $user_code = $user_info['user_code'];
        $role_id = $this->_getTableService()->parseUserRole( $user_info );
        
        //获取列表偏好设置合法字段
        list( $code, $func_field_info ) = $this->_getListLegalField( $func_code, $role_id, $user_info['is_super'] );
        if( $code )
        {
            return [$code, $func_field_info];
        }
        
        //过滤并重新组织搜索偏好设置数据
        $preference_search_params = [];
        foreach( $preference_data as $key => $val )
        {
            foreach( $func_field_info as $v )
            {
                //权限校验字段，不计入搜索偏好设置（超管除外）
                if( $val['field'] == $v['field'] )
                {
                    if( CommonEnum::NEED_VALIDATE_DIC['YES'] == $v['need_validate'] 
                        && SystemEnum::USER_IS_SUPER_NO == $user_info['is_super'] )
                    {
                          break;
                    }
                    
                    //校验字段查询规则
                    list( $code, $message ) = CommonUtil::checkSearchRule( $val['search_type'], $v['type'] );
                    if( $code )
                    {
                        return [$code, $message];
                    }
                    
                    //组织数据
                    $preference_search_params[] = [
                        'field' => $val['field'],
                        'search_type' => $val['search_type']
                    ];
                    
                    break;
                }
            }
        }
        
        if( !$preference_search_params )
        {
            return [Code::COMM_EDIT_PREFERENCE_DENY, '无权设置当前字段'];
        }
        $preference_search_params = json_encode( $preference_search_params, JSON_UNESCAPED_UNICODE );
        
        //查询
        $res = $this->init_db()->get_one_by_field([
            'user_code' => $user_code,
            'func_code' => $func_code
        ], 'sys_user_preference_search');
        if( $res )
        {
            //比较字符串，判断是否有修改
            if( !strcmp( $res['search_params'], $preference_search_params ) )
            {
                //用户未作出修改直接返回true
                return [Code::CODE_SUCCESS, ''];
            }
            
            //更新
            $affected_row = $this->init_db()->update_by_field( [
                'search_params' => $preference_search_params
            ], [
                'user_code' => $user_code,
                'func_code' => $func_code
            ], 'sys_user_preference_search' );
        }
        else 
        {
            //添加
            $affected_row = $this->init_db()->insert( [
                'user_code' => $user_code,
                'func_code' => $func_code,
                'search_params' => $preference_search_params
            ], 'sys_user_preference_search' );
        }
        
        if( $affected_row )
        {
            return [Code::CODE_SUCCESS, ''];
        }
        else
        {
            return [Code::COMM_EDIT_ERROR, '更新用户搜索偏好设置失败'];
        }
    }
    
    /**
     * @return TableService
     */
    private function _getTableService()
    {
        return ChelerApi::getService('common\service\Table');
    }
}