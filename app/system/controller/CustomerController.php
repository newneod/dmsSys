<?php
namespace app\system\controller;

use app\system\service\CompanyService;
use frame\ChelerApi;
use app\helper\Code;
use app\helper\BaseController;
use app\helper\enum\SystemEnum;
use app\system\service\CustomerService;
/**
 * 客户业务
 * @author tiger.li
 * @date: 2018年5月11日
 */
class CustomerController extends BaseController
{
    /**
     * 添加客户
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function Add()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $insert = $this->controller->get_gp( ['customer_code', 'customer_name', 'customer_nickname', 'customer_type', 'customer_level', 'customer_ref_company_code'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[客户类型]（类型是否包括{普通客户, 经销商, 其他}）
        if( !in_array($insert["customer_type"], [SystemEnum::CUSTOMER_TYPE_COMMON, SystemEnum::CUSTOMER_TYPE_DEALER, SystemEnum::CUSTOMER_TYPE_OTHER]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '客户类型错误' );
        }
        //  校验[关联账套]（客户类型为[1经销商]必传该参数,字符最大5位）
        if($insert["customer_type"] == SystemEnum::CUSTOMER_TYPE_DEALER){
            if(empty($insert["customer_ref_company_code"])){
                $this->apiError( Code::SYS_PARAM_ERROR, '经销商客户类型,关联账套不能为空' );
            }
        }
        if(!empty($insert["customer_ref_company_code"])){
            if(mb_strlen($insert["customer_ref_company_code"])>5){
                $this->apiError( Code::SYS_PARAM_ERROR, '关联账套大于5位字符' );
            }
        }
        //  校验[客户编号]（非空,全表唯一）
        if( empty($insert["customer_code"]) )
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '客户编号不能为空' );
        }
        if( mb_strlen($insert["customer_code"])>8){
            $this->apiError( Code::SYS_PARAM_ERROR, '客户编号大于8位字符' );
        }
        $customer = $this->_getCustomerService()->getOneCustomerByField(["customer_code" => $insert["customer_code"]]);
        if(!empty($customer)){
            $this->apiError( Code::SYS_PARAM_ERROR, '客户编号重复' );
        }

        //补充数据
        $insert['create_user'] = $user_info["user_code"];//创建用户编号
        $insert['create_time'] = time();//创建时间
        $insert['company_code'] = $user_info["company_code"];//账套
        //添加客户信息（sys_customer）
        $result = $this->_getCustomerService()->add($insert);

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "添加客户失败" );
        }
    }

    /**
     * 编辑客户
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function Edit()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['customer_id'], 'P', true );
        $data = $this->controller->get_gp( ['company_code', 'customer_code', 'customer_name', 'customer_nickname', 'customer_type', 'customer_level', 'customer_ref_company_code'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[客户ID]（非空）
        if( empty($field["customer_id"]) )
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '客户ID不能为空' );
        }
        //  校验[客户类型]（类型是否包括{普通客户, 经销商, 其他}）
        if( !in_array($data["customer_type"], [SystemEnum::CUSTOMER_TYPE_COMMON, SystemEnum::CUSTOMER_TYPE_DEALER, SystemEnum::CUSTOMER_TYPE_OTHER]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '客户类型错误' );
        }
        //  校验[关联账套]（客户类型为[1经销商]必传该参数,字符最大5位）
        if($data["customer_type"] == SystemEnum::CUSTOMER_TYPE_DEALER){
            if(empty($insert["customer_ref_company_code"])){
                $this->apiError( Code::SYS_PARAM_ERROR, '经销商客户类型,关联账套不能为空' );
            }
        }
        if(!empty($data["customer_ref_company_code"])){
            if(mb_strlen($data["customer_ref_company_code"])>5){
                $this->apiError( Code::SYS_PARAM_ERROR, '关联账套大于5位字符' );
            }
        }
        //  校验[客户编号]（非空,全表唯一）
        if( empty($insert["customer_code"]) )
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '客户编号不能为空' );
        }
        if( mb_strlen($insert["customer_code"])>8){
            $this->apiError( Code::SYS_PARAM_ERROR, '客户编号大于8位字符' );
        }
        $customer = $this->_getCustomerService()->getOneCustomerByField(['customer_code' => $insert["customer_code"]]);
        if(!empty($customer) && $customer["customer_id"] != $field['customer_id']){
            $this->apiError( Code::SYS_PARAM_ERROR, '客户编号重复' );
        }

        //补充数据
        $data['modify_user'] = $user_info["user_code"];//修改用户编号
        $data['modify_time'] = time();//创建时间

        //添加客户信息（sys_customer）
        $result = $this->_getCustomerService()->edit($data, $field);

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "更新客户失败" );
        }
    }

    /**
     * 获取客户
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function Get()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['customer_id'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[客户ID]（非空）
        if( empty($field["customer_id"]) )
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '客户ID不能为空' );
        }

        //获取客户信息（sys_customer）
        $result = $this->_getCustomerService()->getOneCustomerByField($field);

        if($result){
            $this->apiSuccess( $result );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "获取客户失败" );
        }
    }

    /**
     * 添加客户地址
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function AddAddress()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $customer_address = $this->controller->get_gp( ['customer_id'], 'P', true );
        $insert = $this->controller->get_gp( ['address_type', 'address_zip_code', 'province_id', 'city_id', 'district_id', 'address_detail'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[客户ID]（非空）
        if( empty($customer_address["customer_id"]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '客户ID错误' );
        }
        //  校验[地址类型]（类型是否包括{普通, 收货}）
        if( !in_array($insert["address_type"], [SystemEnum::CUSTOMER_ADDRESS_TYPE_COMMON, SystemEnum::CUSTOMER_ADDRESS_TYPE_RECEIVE]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '地址类型错误' );
        }
        //  校验[邮政编号]（非空）
        if( empty( $insert["address_zip_code"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '邮政编号不能为空' );
        }
        //  校验[省id]（非空）
        if( empty( $insert["province_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '省不能为空' );
        }
        //  校验[市id]（非空）
        if( empty( $insert["city_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '市不能为空' );
        }
        //  校验[区Id]（非空）
        if( empty( $insert["district_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '区不能为空' );
        }

        //补充数据
        $insert['company_code'] = $user_info["company_code"];//账套
        $insert['create_user'] = $user_info["user_code"];//创建用户编号
        $insert['create_time'] = time();//创建时间

        //添加客户地址（comm_address）
        $address = $this->_getCustomerService()->addAddress($insert);

        $customer_address["address_id"] = $address;//补充地址主键ID

        //添加客户-地址关系（sys_rel_customer_address）//由于该表没有自增id，无法获取到上条自增值,无法使用事务
        $this->_getCustomerService()->addCustomerAddress($customer_address);

        if($address){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "添加客户地址失败" );
        }
    }

    /**
     * 编辑客户地址
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function EditAddress()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['address_id'], 'P', true );
        $data = $this->controller->get_gp( ['address_type', 'address_zip_code', 'province_id', 'city_id', 'district_id', 'address_detail'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[地址ID]（非空）
        if( empty($field["address_id"]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '地址ID错误' );
        }
        //  校验[地址类型]（类型是否包括{普通, 收货}）
        if( !in_array($data["address_type"], [SystemEnum::CUSTOMER_ADDRESS_TYPE_COMMON, SystemEnum::CUSTOMER_ADDRESS_TYPE_RECEIVE]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '地址类型错误' );
        }
        //  校验[邮政编号]（非空）
        if( empty( $data["address_zip_code"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '邮政编号不能为空' );
        }
        //  校验[省id]（非空）
        if( empty( $data["province_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '省不能为空' );
        }
        //  校验[市id]（非空）
        if( empty( $data["city_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '市不能为空' );
        }
        //  校验[区Id]（非空）
        if( empty( $data["district_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '区不能为空' );
        }

        //补充数据
        $data['modify_user'] = $user_info["user_code"];//修改用户编号
        $data['modify_time'] = time();//创建时间

        //修改客户地址（comm_address）
        $address = $this->_getCustomerService()->editAddress($data, $field);

        if($address){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "更新客户地址失败" );
        }
    }

    /**
     * 获取客户地址
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function GetAddress()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['address_id'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[地址ID]（非空）
        if( empty($field["address_id"]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '地址ID错误' );
        }

        //获取客户地址（comm_address）
        $address = $this->_getCustomerService()->getOneAddressByField($field);

        if($address){
            $this->apiSuccess( $address );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "获取客户地址失败" );
        }
    }

    /**
     * @return CustomerService
     */
    private function _getCustomerService()
    {
        return ChelerApi::getService('system\service\Customer');
    }

    /**
     * @return CompanyService
     */
    private function _getCompanyService()
    {
        return ChelerApi::getService('system\service\Company');
    }
}
