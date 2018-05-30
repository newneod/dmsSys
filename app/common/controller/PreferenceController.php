<?php
namespace app\common\controller;

use frame\ChelerApi;
use app\helper\Code;
use app\helper\BaseController;
use app\common\service\PreferenceService;

/**
 * 偏好设置类
 * 包括列表偏好设置、列表搜索偏好设置、菜单收藏夹
 * @author even
 * @date: 2018年5月15日
 */
class PreferenceController extends BaseController
{
    /**
     * 获取用户列表偏好设置
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月15日
     */ 
    public function GetPreferenceList()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        
        //获取偏好设置
        list( $code, $preference_list ) = $this->_getPreferenceService()->getPreferenceList( $func_code, $user_info );
        if( $code )
        {
            $this->apiError( $code, $preference_list );
            
        }
        
        $this->apiSuccess( $preference_list );
    }
    
    /**
     * 更新用户列表偏好设置
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月15日
     */ 
    public function EditPreferenceList()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        $preference_data = $this->controller->get_gp('preference_data', null, true);
        $preference_data = $this->_parseData( $preference_data );
        if( !$preference_data )
        {
            $this->apiError( Code::COMM_PARAM_REQUIRED, '偏好设置数据不能为空' );
        }
        
        //编辑偏好设置
        list( $code, $message ) = $this->_getPreferenceService()->editPreferenceList( $func_code, $user_info, $preference_data );
        if( $code )
        {
            $this->apiError( $code, $message );
            
        }
        
        $this->apiSuccess( [] );
    }
    
    /**
     * 还原用户列表偏好设置至初始化状态
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月15日
     */ 
    public function RestorePreferenceList()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        
        //还原偏好设置
        list( $code, $preference_list ) = $this->_getPreferenceService()->restorePreferenceList( $func_code, $user_info );
        if( $code )
        {
            $this->apiError( $code, $preference_list );
        }
        
        $this->apiSuccess( $preference_list );
    }
    
    /**
     * 获取收藏夹菜单
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月23日
     */ 
    public function GetFavoriteMenu()
    {
        $user_info = $this->authorizeToken();
        $this->apiSuccess( empty( $user_info['user_favorite_funcs'] ) ? [] : array_values( $user_info['user_favorite_funcs'] ) );
    }
    
    /**
     * 新增菜单至收藏夹
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月16日
     */ 
    public function AddFavoriteMenu()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        
        //收藏菜单
        list( $code, $message ) = $this->_getPreferenceService()->addFavoriteMenu( $func_code, $user_info );
        if( $code )
        {
            $this->apiError( $code, $message );
        }
        
        $this->apiSuccess( [] );
    }
    
    /**
     * 从收藏夹中删除菜单
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月16日
     */ 
    public function DeleteFavoriteMenu()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        
        //取消收藏菜单
        list( $code, $message ) = $this->_getPreferenceService()->deleteFavoriteMenu( $func_code, $user_info );
        if( $code )
        {
            $this->apiError( $code, $message );
        }
        
        $this->apiSuccess( [] );
    }
    
    /**
     * 获取可进行搜索偏好设置的字段
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月18日
     */ 
    public function GetPreferenceSearch()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        
        //获取可设置字段
        list( $code, $res ) = $this->_getPreferenceService()->GetPreferenceSearch( $func_code, $user_info );
        if( $code )
        {
            $this->apiError( $code, $res );
            
        }
        
        $this->apiSuccess( $res );
    }
    
    /**
     * 更新用户搜索偏好设置
     * @param void
     * @return void
     * @author even
     * @date: 2018年5月17日
     */ 
    public function EditPreferenceSearch()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        $preference_data = $this->controller->get_gp('preference_data', null, true);
        $preference_data = $this->_parseData( $preference_data );
        if( !$preference_data )
        {
            $this->apiError( Code::COMM_PARAM_REQUIRED, '偏好设置数据不能为空' );
        }

        //编辑偏好设置
        list( $code, $message ) = $this->_getPreferenceService()->editPreferenceSearch( $func_code, $user_info, $preference_data );
        if( $code )
        {
            $this->apiError( $code, $message );
            
        }
        
        $this->apiSuccess( [] );
    }
    
    /**
     * 解析请求数据
     * @param string $data 经过json编码的字符串（前端传递过来）
     * @return array 解析后的数组形式数据
     * @author even
     * @date: 2018年5月28日
     */ 
    private function _parseData( $data )
    {
        $data = str_replace('\\', '', $data);
        $data = $this->strTransfer( $data, false );
        return json_decode($data, true );
    }
    
    /**
     * @return PreferenceService
     */
    private function _getPreferenceService()
    {
        return ChelerApi::getService('common\service\Preference');
    }
}
