<?php
namespace app\system\controller;

use app\common\service\TransactionService;
use app\system\service\CompanyService;
use app\system\service\CustomerService;
use app\system\service\UserService;
use frame\ChelerApi;
use app\helper\Code;
use app\helper\BaseController;
use app\helper\enum\SystemEnum;
use app\helper\util\CommonUtil;
/**
 * 公司业务
 * @author tiger.li
 * @date: 2018年5月11日
 */
class CompanyController extends BaseController
{
    /**
     * 添加公司
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function Add()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $company_date = $this->controller->get_gp( ['company_code', 'company_name', 'company_alias', 'company_type', 'company_logo', 'company_tax_code', 'company_address', 'company_tel', 'company_legal_person', 'company_status'], 'P', true );//公司数据
        $user_data = $this->controller->get_gp( ['user_code', 'user_password'], 'P', true );//用户数据
        $customer_data = $this->controller->get_gp( ['customer_code'], 'P', true );//客户数据

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[账套]（非空、长度不能大于5、全表唯一）
        if( empty($company_date["company_code"]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '账套不能为空' );
        }
        if( mb_strlen($company_date["company_code"]) > 5 )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '账套最大长度5位字符' );
        }
        $company = $this->_getCompanyService()->getOneCompanyByField(["company_code"=>$company_date["company_code"]]);
        if(!empty($company))
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '账套不能重复' );
        }
        //  校验[公司全称]（非空）
        if(empty( $company_date["company_name"]))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '公司全称不能为空' );
        }
        //  校验[公司类型]（类型是否包括{ 4s, 整车厂, 服务站, 虚拟公司}）
        if(!in_array($company_date["company_type"], [SystemEnum::COMPANY_TYPE_4S, SystemEnum::COMPANY_TYPE_FACTORY, SystemEnum::COMPANY_TYPE_SERVICE, SystemEnum::COMPANY_TYPE_COMPANY]))
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '公司类型错误' );
        }
        //  校验[公司状态]（类型是否包括{正常, 停用, 作废}）
        if(!empty($company_date["company_status"])){
            if( !in_array($company_date["company_type"], [SystemEnum::COMPANY_STATUS_NORMAL, SystemEnum::COMPANY_STATUS_FORBIDDEN, SystemEnum::COMPANY_STATUS_INVALID]) )
            {
                $this->apiError( Code::SYS_PARAM_ERROR, '公司状态错误' );
            }
        }
        //  校验[用户编号]（非空、最大长度10）
        if(empty($user_data["user_code"])){
            $this->apiError( Code::SYS_PARAM_ERROR, '用户编号不能为空' );
        }
        if(mb_strlen($user_data["user_code"])>10){
            $this->apiError( Code::SYS_PARAM_ERROR, '用户编号最小长度10' );
        }
        //  校验[用户密码]（非空）
        if(empty($user_data["user_password"])){
            $this->apiError( Code::SYS_PARAM_ERROR, '用户密码不能为空' );
        }
        //  校验[客户编号]（非空）
        if(empty($customer_data["customer_code"])){
            $this->apiError( Code::SYS_PARAM_ERROR, '客户编号不能为空' );
        }

        //补充数据
        $company_date['create_user'] = $user_info["user_code"];//创建用户编号
        $company_date['create_time'] = time();//创建时间
        $user_data['user_salt'] = $this->_hash(parent::PWD_SALT_LEN);//密码盐
        $user_data['user_password'] = $this->_password($user_data['user_password'], $user_data['user_salt']);//加密密码
        $user_data['def_company_code'] = $company_date['company_code'];//默认公司账套
        $user_data['is_super'] = SystemEnum::USER_IS_SUPER_YES;//标记为超级管理员
        $customer_data['customer_code'] = $company_date['company_code'];//账套（上级公司的账套）
        $customer_data['customer_type'] = SystemEnum::CUSTOMER_TYPE_COMMON;//普通客户类型

        //过滤掉插入数组中为空的值
        $company_date = filter_value($company_date);

        //开启事务
        $this->_getTransactionService()->start();

        //添加公司（sys_company）
        $company_result = $this->_getCompanyService()->add($company_date);
        //添加用户（sys_user）
        $user_result = $this->_getUserService()->insertUser($user_data);
        //添加客户（sys_customer）
        $customer_result = $this->_getCustomerService()->add($customer_data);

        if($company_result && $user_result && $customer_result){
            $this->_getTransactionService()->commit();//提交事务
            $this->apiSuccess( [] );
        }else{
            $this->_getTransactionService()->rollback();//回滚事务
            $this->apiError( Code::SYS_ADD_ERROR, "添加公司失败" );
        }
    }

    /**
     * 编辑公司
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function Edit()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['company_id'], 'P', true );
        $data = $this->controller->get_gp( ['company_name', 'company_alias', 'company_type', 'company_logo', 'company_tax_code', 'company_address', 'company_tel', 'company_legal_person', 'company_status'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[公司ID]（非空）
        if( empty($field["company_id"]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '公司主键ID不能为空' );
        }
        //  校验[公司全称]（非空）
        if( empty( $data["company_name"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '公司全称不能为空' );
        }
        //  校验[公司类型]（类型是否包括{ 4s, 整车厂, 服务站, 虚拟公司}）
        if( !in_array($data["company_type"], [SystemEnum::COMPANY_TYPE_4S, SystemEnum::COMPANY_TYPE_FACTORY, SystemEnum::COMPANY_TYPE_SERVICE, SystemEnum::COMPANY_TYPE_COMPANY]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '公司类型错误' );
        }
        //  校验[公司状态]（类型是否包括{正常, 停用, 作废}）
        if(!empty($data["company_status"])){
            if( !in_array($data["company_type"], [SystemEnum::COMPANY_STATUS_NORMAL, SystemEnum::COMPANY_STATUS_FORBIDDEN, SystemEnum::COMPANY_STATUS_INVALID]) )
            {
                $this->apiError( Code::SYS_PARAM_ERROR, '公司状态错误' );
            }
        }

        //补充数据
        $data['modify_user'] = $user_info["create_user"];//修改用户编号
        $data['modify_time'] = time();//创建时间

        //编辑公司（sys_company）
        $result = $this->_getCompanyService()->edit($data, $field);

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "更新客户地址失败" );
        }
    }

    /**
     * 获取公司
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function Get()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['company_id'], 'P', true );


        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[公司ID]（非空）
        if( empty($field["company_id"]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '公司主键ID不能为空' );
        }

        //获取公司（sys_company）
        $result = $this->_getCompanyService()->getOneCompanyByField($field);

        if($result){
            $this->apiSuccess( $result );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "获取公司失败" );
        }
    }

    /**
     * 后台密码加密
     * @author: nzw
     * @date: 2018-05-09
     * @param string $password 原密码
     * @param string $pwdSalt 密码盐
     * @return string 加密后的密码
     */
    private function _password($password, $pwdSalt)
    {
        return md5(md5($password) . $pwdSalt);
    }

    /**
     * 随机获取密码盐hash
     * @author: nzw
     * @date: 2018-05-09
     * @param int $hashLen hash长度
     * @return string
     */
    private function _hash(int $hashLen)
    {
        $function = $this->getLibrary('function');//共用类
        return $function->get_hash($hashLen);
    }

    /**
     * @return UserService
     */
    private function _getUserService()
    {
        return ChelerApi::getService('system\service\User');
    }

    /**
     * @return CompanyService
     */
    private function _getCompanyService()
    {
        return ChelerApi::getService('system\service\Company');
    }

    /**
     * @return CustomerService
     */
    private function _getCustomerService()
    {
        return ChelerApi::getService('system\service\Customer');
    }

    /**
     * @return TransactionService
     */
    private function _getTransactionService()
    {
        return ChelerApi::getService('common\service\Transaction');
    }
}