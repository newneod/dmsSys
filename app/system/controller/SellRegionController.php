<?php
namespace app\system\controller;

use app\system\service\CompanyService;
use app\system\service\SellRegionService;
use frame\ChelerApi;
use app\helper\Code;
use app\helper\BaseController;
/**
 * 销售区域业务
 * @author tiger.li
 * @date: 2018年5月9日
 */
class SellRegionController extends BaseController
{
    /**
     * 销售区域主页面结构树
     * @author:tiger.li
     * @date:2018-05-09 14:41:23
     */
    public function Tree()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = ["user_code" => "tiger", "company_code" => "tiger"];

        $result = $this->_getSellRegionService()->getSellRegionTree( );

        if($result){
            $this->apiSuccess( $result );
        }else{
            $this->apiError( Code::SYS_SELECT_ERROR, "获取树结构失败" );
        }
    }

    /**
     * 添加销售区域
     * @author:tiger.li
     * @date:2018-05-09 14:41:23
     */
    public function Add()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $insert = $this->controller->get_gp( ['sell_region_name', 'sell_region_pid'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[销售区域名称]（非空、全表唯一）
        if( empty( $insert["sell_region_name"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '销售区域名称不能为空' );
        }
        $sell_region = $this->_getSellRegionService()->getOneSellRegionByField( ["sell_region_name" => $insert["sell_region_name"]] );
        if( !empty($sell_region) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '销售区域名称已存在' );
        }
        //  校验[销售区域父ID]（是否存在）
        if( !empty( $insert["sell_region_pid"] ) )
        {
            $sell_region = $this->_getSellRegionService()->getOneSellRegionByField( ["sell_region_pid" => $insert["sell_region_pid"]] );
            if (empty($sell_region)){
                $this->apiError( Code::SYS_PARAM_ERROR, '销售区域父ID不存在' );
            }

        }

        //补充必要数据
        $insert["create_user"] = $user_info["user_code"];//创建用户编号
        $insert["create_time"] = time();//创建时间

        $result = $this->_getSellRegionService()->add( $insert );

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "添加销售区域失败" );
        }
    }

    /**
     * 修改销售区域
     * @author:tiger.li
     * @date:2018-05-09 15:06:42
     */
    public function Edit()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['sell_region_id'], 'P', true );
        $data = $this->controller->get_gp( ['sell_region_name', 'sell_region_pid'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[销售区域ID]主键（非空、存在下级区域不予修改）
        if( empty( $field["sell_region_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '销售区域ID不能为空' );
        }
        $sell_region = $this->_getSellRegionService()->getOneSellRegionByField( ["sell_region_pid" => $data["sell_region_id"]] );
        if(!empty($sell_region))
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '无法修改存在下级的销售区域' );
        }
        //  校验[销售区域名称]（非空、全表唯一）
        if( empty( $data["sell_region_name"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '销售区域名称不能为空' );
        }
        $sell_region = $this->_getSellRegionService()->getOneSellRegionByField( ["sell_region_name" => $data["sell_region_name"]] );
        if( !empty($sell_region) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '销售区域名称已存在' );
        }
        //  校验[销售区域父ID]（是否存在）
        if( !empty( $data["sell_region_pid"] ) )
        {
            $sell_region = $this->_getSellRegionService()->getOneSellRegionByField( ["sell_region_id" => $data["sell_region_pid"]] );
            if (empty($sell_region)){
                $this->apiError( Code::SYS_PARAM_ERROR, '销售区域父ID不存在' );
            }

        }

        //补充条件
        $data["modify_user"] = $user_info["user_code"];//修改用户编号
        $data["modify_time"] = time();//修改时间

        $result = $this->_getSellRegionService()->edit( $data,  $field);

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_EDIT_ERROR, "修改销售区域失败" );
        }
    }

    /**
     * 添加公司-销售区域关系
     * @author:tiger.li
     * @date:2018-05-09 14:41:23
     */
    public function AddCompany()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $insert = $this->controller->get_gp( ['sell_region_id', 'company_code'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[账套]（非空、是否存在）
        if( empty( $insert["company_code"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '账套不能为空' );
        }
        $company = $this->_getCompanyService()->getOneCompanyByField( ["company_code" => $insert["company_code"]] );
        if( empty($company) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '不存在该公司' );
        }
        //  校验[销售区域id]（非空、是否存在）
        if( empty( $insert["sell_region_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '销售区域id不能为空' );
        }
        $sell_region = $this->_getSellRegionService()->getOneSellRegionByField( ["sell_region_id" => $insert["sell_region_id"]] );
        if (empty($sell_region)){
            $this->apiError( Code::SYS_PARAM_ERROR, '不存在该销售区域' );
        }

        //补充必要数据
        $insert["create_user"] = $user_info["user_code"];//创建用户编号
        $insert["create_time"] = time();//创建时间

        $result = $this->_getSellRegionService()->addCompanySellRegion( $insert );

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "添加公司-销售区域关系失败" );
        }
    }

    /**
     * 编辑公司-销售区域关系
     * @author:tiger.li
     * @date:2018-05-09 14:41:23
     */
    public function EditCompany()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['company_region_id'], 'P', true );
        $data = $this->controller->get_gp( ['sell_region_id', 'company_code'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[账套]（非空）
        if( empty( $field["company_region_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '公司-销售区域关系主键id不能为空' );
        }
        //  校验[账套]（非空、是否存在）
        if( empty( $data["company_code"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '账套不能为空' );
        }
        $company = $this->_getCompanyService()->getOneCompanyByField( ["company_code" => $data["company_code"]] );
        if( empty($company) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '不存在该公司' );
        }
        //  校验[销售区域id]（非空、是否存在）
        if( empty( $data["sell_region_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '销售区域id不能为空' );
        }
        $sell_region = $this->_getSellRegionService()->getOneSellRegionByField( ["sell_region_id" => $data["sell_region_id"]] );
        if (empty($sell_region)){
            $this->apiError( Code::SYS_PARAM_ERROR, '不存在该销售区域' );
        }

        //补充必要数据
        $insert["modify_user"] = $user_info["user_code"];//修改用户编号
        $insert["modify_time"] = time();//修改时间

        $result = $this->_getSellRegionService()->editCompanySellRegion( $data, $field );

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "编辑公司-销售区域关系失败" );
        }
    }

    /**
     * @return SellRegionService
     */
    private function _getSellRegionService()
    {
        return ChelerApi::getService('system\service\SellRegion');
    }

    /**
     * @return CompanyService
     */
    private function _getCompanyService()
    {
        return ChelerApi::getService('system\service\Company');
    }
}
