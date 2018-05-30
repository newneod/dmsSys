<?php
namespace app\common\controller;

use frame\ChelerApi;
use app\helper\Code;
use app\helper\BaseController;
use app\common\service\TableService;

/**
 * 公共列表
 * @author even
 * @date: 2018年5月9日
 */
class TableController extends BaseController
{
    /**
     * 获取公共列表表头
     * @param void
     * @return void
     */ 
    public function GetHeader()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        
        //获取功能集合信息
        list( $code, $func_info ) = $this->_getTableService()->getFuncInfo( $func_code );
        if( $code )
        {
            $this->apiError( $code, $func_info );
        }
        
        if( 0 )
        {
            //分流复杂查询
        }
        else
        {
            //获取表头数据
            list( $code, $res ) = $this->_getTableService()->getHeader( $user_info, $func_info );
            if( $code )
            {
                $this->apiError( $code, $res );
            }
        }
        
        $this->apiSuccess( $res );
    }
    
    /**
     * 获取列表数据
     * @param void
     * @return void
     */ 
    public function GetData()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        
        //获取功能集合信息
        list( $code, $func_info ) = $this->_getTableService()->getFuncInfo( $func_code );
        if( $code )
        {
            $this->apiError( $code, $func_info );
        }
        
        if( 0 )
        {
            //分流复杂查询
        }
        else
        {
            $search_data = $this->controller->get_gp('search_data');
            $search_data = $this->_parseData( $search_data );
            
            //获取列表数据
            list( $code, $res ) = $this->_getTableService()->getListData( $user_info, $func_info, $search_data );
            if( $code )
            {
                $this->apiError( $code, $res );
            }
        }
        
        $this->apiSuccess( $res );
    }
    
    /**
     * 获取列表筛选项
     * @param void
     * @return void
     */ 
    public function GetFilter()
    {
        $user_info = $this->authorizeToken();
        $func_code = $this->controller->get_gp('func_code', null, true);
        parent::checkParam($func_code, false, false, '功能编号');
        
        //获取功能集合信息
        list( $code, $func_info ) = $this->_getTableService()->getFuncInfo( $func_code );
        if( $code )
        {
            $this->apiError( $code, $func_info );
        }
        
        if( 0 )
        {
            //分流复杂查询
        }
        else
        {
            //获取列表筛选项
            list( $code, $res ) = $this->_getTableService()->getFilter( $user_info, $func_info );
            if( $code )
            {
                $this->apiError( $code, $res );
            }
        }
        
        $this->apiSuccess( $res );
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
     * @return TableService
     */
    private function _getTableService()
    {
        return ChelerApi::getService('common\service\Table');
    }
 
}
