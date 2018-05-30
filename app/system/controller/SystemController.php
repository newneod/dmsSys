<?php
namespace app\system\controller;


use frame\ChelerApi;
use app\helper\Code;
use app\helper\BaseController;
use app\system\service\SystemService;
/**
 * 系统业务
 * @author tiger.li
 * @date: 2018年5月9日
 */
class SystemController extends BaseController
{
    /**
     * 添加系统配置
     * @author:tiger.li
     * @date:2018-05-09 14:41:23
     */
    public function Add()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $insert = $this->controller->get_gp( ['config_key', 'config_value'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[配置名]（非空）
        if( empty( $insert["config_key"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '配置名不能为空' );
        }
        //  校验[配置值]（非空）
        if( empty( $insert["config_value"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '配置值不能为空' );
        }

        //补充必要数据
        $insert["company_code"] = $user_info["company_code"];//账套

        $result = $this->_getSystemService()->add( $insert );

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "添加系统配置失败" );
        }
    }

    /**
     * 修改系统配置
     * @author:tiger.li
     * @date:2018-05-09 15:06:42
     */
    public function Edit()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['config_id'], 'P', true );
        $data = $this->controller->get_gp( [ 'config_key', 'config_value' ], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[配置ID]主键（非空）
        if( empty( $field["config_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '配置ID不能为空' );
        }
        //  校验[配置名]（非空）
        if( empty( $data["config_key"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '配置名不能为空' );
        }
        //  校验[配置值]（非空）
        if( empty( $data["config_value"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '配置值不能为空' );
        }

        //补充条件
        $field["company_code"] = $user_info["company_code"];//账套

        $result = $this->_getSystemService()->edit( $data,  $field);

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_EDIT_ERROR, "修改系统配置失败" );
        }
    }

    /**
     * 获取系统配置
     * @author:tiger.li
     * @date:2018-05-09 15:06:42
     */
    public function Get()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['config_id'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[配置ID]主键（非空）
        if( empty( $field["config_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '配置ID不能为空' );
        }

        $result = $this->_getSystemService()->getOneConfigByField( $field);

        if($result){
            $this->apiSuccess( $result );
        }else{
            $this->apiError( Code::SYS_EDIT_ERROR, "获取系统配置失败" );
        }
    }

    /**
     * @return SystemService
     */
    private function _getSystemService()
    {
        return ChelerApi::getService('system\service\System');
    }
}
