<?php
namespace app\system\controller;

use app\system\service\CompanyService;
use app\system\service\OrgService;
use app\system\service\UserService;
use frame\ChelerApi;
use app\helper\Code;
use app\helper\enum\SystemEnum;
use app\helper\BaseController;

/**
 * 组织业务
 * @author tiger.li
 * @date: 2018年5月9日
 */
class OrgController extends BaseController
{
    /**
     * 组织主页面结构树
     * @author:tiger.li
     * @date:2018-05-09 14:41:23
     */
    public function Tree()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();
        $status = $this->controller->get_gp( 'status', 'P', true );
        //补充条件
        $field["company_code"] = $user_info["def_company_code"];//账套

        if(empty($status['status'])){
            $field["org_status"] = [SystemEnum::ORG_STATUS_NORMAL,SystemEnum::ORG_STATUS_FORBIDDEN];//组织状态 正常 停用
        }else{
            $field["org_status"] = [SystemEnum::ORG_STATUS_NORMAL];//组织状态 正常
        }

        $result = $this->_getOrgService()->getOrgTree( $field );

        if($result){
            $this->apiSuccess( $result );
        }else{
            $this->apiError( Code::SYS_SELECT_ERROR, "公司数据为空" );
        }
    }

    /**
     * 添加组织
     * @author:tiger.li
     * @date:2018-05-09 14:41:23
     */
    public function Add()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $insert = $this->controller->get_gp( ['org_pid', 'org_name', 'org_status', 'org_describe', 'org_simplify_name'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后Add期自由删除/修改）
        //  校验[组织名称]（非空）
        if( empty( $insert["org_name"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '组织名称不能为空' );
        }
        //  校验[组织状态]（是否包含在[正常、停用、作废]状态中）
        if(!in_array($insert["org_status"], [SystemEnum::ORG_STATUS_NORMAL, SystemEnum::ORG_STATUS_FORBIDDEN]))
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '组织状态错误' );
        }
        $field['org_name'] = $insert["org_name"];
        $field['org_simplify_name'] = $insert["org_simplify_name"];
        $field['company_code'] = $user_info["def_company_code"];
        // 校验[组织名称、组织简称]（同一账套下，组织名称、组织简称唯一）
        $check_org = $this->_getOrgService()->getCheckOrgByField($field);
        if(!empty($check_org))
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '组织名称或组织简称重复' );
        }

        //补充必要数据
        $insert["company_code"] = $user_info["company_code"];//账套
        $insert["create_user"] = $user_info["create_user"];//创建用户编号
        $insert["create_time"] = time();//创建时间

        $result = $this->_getOrgService()->add( $insert );

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "添加系统配置失败" );
        }
    }

    /**
     * 修改组织
     * @author:tiger.li
     * @date:2018-05-09 15:06:42
     */
    public function Edit()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['org_id'], 'P', true );
        $data = $this->controller->get_gp( ['org_pid', 'org_name', 'org_status', 'org_describe', 'org_simplify_name'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[组织ID]主键（非空）
        if( empty( $field["org_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '组织ID不能为空' );
        }
        //  校验[组织名称]（非空）
        if( empty( $data["org_name"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '组织名称不能为空' );
        }
        //  校验[组织状态]（是否包含在[正常、停用、作废]状态中）
        if( !in_array($data["org_status"], [SystemEnum::ORG_STATUS_NORMAL, SystemEnum::ORG_STATUS_FORBIDDEN]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '组织状态错误' );
        }
        // 校验[组织名称、组织简称]（同一账套下，组织名称、组织简称唯一）
        $check_org = $this->_getOrgService()->getCheckOrgByField($field);
        if(count($check_org)>1 || $check_org[0]['org_id']!=$field['org_id'])
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '组织名称或组织简称重复' );
        }
        //如果修改组织状态为[停用]，校验当前组织下是否存在[正常]状态用户和组织
        if($data["org_status"] == SystemEnum::ORG_STATUS_FORBIDDEN){
            //  判断当前组织下是否存在用户状态[正常]的用户
            $user = $this->_getUserService()->getAllUserByField(["user_org_id" => $field["org_id"], "user_status"=>[SystemEnum::USER_STATUS_NORMAL]]);
            if(!empty($user)){
                $this->apiError( Code::SYS_SELECT_ERROR, "该组织下存在[正常]状态用户" );
            }

            //  获取该组织下所有其他组织
            $org_all = [];
            self::_recursionGetOrgId(["org_pid" => $field["org_id"], "company_code" => $user_info["company_code"], "org_status" => SystemEnum::ORG_STATUS_NORMAL],$org_all);

            //  该组织下存在[正常]状态的组织
            if(!empty($org_all)){

                $this->apiError( Code::SYS_EDIT_ERROR, "该组织下存在[正常]状态的组织" );
            }
        }

        //补充条件
        $field["company_code"] = $user_info["company_code"];//账套

        $result = $this->_getOrgService()->edit( $data,  $field);

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_EDIT_ERROR, "修改组织失败" );
        }
    }

    /**
     * 获取组织
     * @author:tiger.li
     * @date:2018-05-09 15:06:42
     */
    public function Get()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['org_id'], 'P', true );


        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[组织ID]主键（非空）
        if( empty( $field["org_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '组织ID不能为空' );
        }

        $result = $this->_getOrgService()->getOneOrgByField( $field);

        if($result){
            $this->apiSuccess( $result );
        }else{
            $this->apiError( Code::SYS_EDIT_ERROR, "获取组织失败" );
        }
    }

    /**
     * 启用组织
     * @author:tiger.li
     * @date:2018-05-10 15:28:35
     */
    public function Enable()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['org_id'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[组织ID]主键（非空）
        if( empty( $field["org_id"] ))
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '组织ID不能为空' );
        }

        //补充条件
        $field["company_code"] = $user_info["company_code"];//账套
        $field["org_status"] = SystemEnum::ORG_STATUS_FORBIDDEN;//组织状态 正常 停用

        //只允许状态为[停用],才可启用
        $org_once = $this->_getOrgService()->getOneOrgByField( $field );

        if(!empty($org_once)){
            //查看上级状态,[正常]才可启用,父id为0,不考虑
            if(!empty($org_once["org_pid"])){
                $p_org = $this->_getOrgService()->getOneOrgByField( ['org_id' => $org_once['org_pid'], 'org_status' => SystemEnum::ORG_STATUS_NORMAL] );
                if(empty($p_org)){
                    $this->apiError( Code::SYS_EDIT_ERROR, "该父组织状态异常" );
                }
            }
            $result = $this->_getOrgService()->edit(["org_status"=>SystemEnum::ORG_STATUS_NORMAL], ["org_id"=>$field["org_id"]]);
            if($result){
                $this->apiSuccess( [] );
            }else{
                $this->apiError( Code::SYS_EDIT_ERROR, "删除失败" );
            }
        }else{
            $this->apiError( Code::SYS_SELECT_ERROR, "该组织无法启用" );
        }
    }

    /**
     * 停用组织
     * @author:tiger.li
     * @date:2018-05-10 15:28:35
     */
    public function Disable()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['org_id'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[组织ID]主键（小于0）
        if(intval($field["org_id"])<0)
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '组织ID不能为空' );
        }

        //补充条件
        $field["company_code"] = $user_info["company_code"];//账套
        $field["org_status"] = [SystemEnum::ORG_STATUS_NORMAL];//组织状态 正常 停用

        //查看是否存在该组织
        $org_once = $this->_getOrgService()->getOneOrgByField( $field );
        if(empty($org_once)){
            $this->apiError( Code::SYS_SELECT_ERROR, "不存在该组织" );
        }

        //判断当前组织下是否存在用户状态[正常]的用户
        $user = $this->_getUserService()->getAllUserByField(["user_org_id" => $field["org_id"], "user_status"=>[SystemEnum::USER_STATUS_NORMAL]]);
        if(!empty($user)){
            $this->apiError( Code::SYS_SELECT_ERROR, "该组织下存在[正常]状态用户" );
        }

        //获取该组织下所有其他组织
        $org_all = [];
        self::_recursionGetOrgId(["org_pid" => $field["org_id"], "company_code" => $field["company_code"], "org_status" => $field["org_status"]],$org_all);

        //该组织不下存在[正常]状态的组织，更改状态为[停用]
        if(empty($org_all)){
            $result = $this->_getOrgService()->edit(["org_status" => SystemEnum::ORG_STATUS_FORBIDDEN], ["org_id" => $field["org_id"]]);
            if($result){
                $this->apiSuccess( [] );
            }else{
                $this->apiError( Code::SYS_EDIT_ERROR, "停用失败" );
            }
        }else{
            //该组织下存在[正常、停用]状态的组织
            $this->apiError( Code::SYS_EDIT_ERROR, "该组织下存在[正常]状态的组织" );
        }
    }

    /**
     * 删除组织
     * @author:tiger.li
     * @date:2018-05-09 15:06:42
     */
    public function Delete()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $field = $this->controller->get_gp( ['org_id'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[组织ID]主键（小于0）
        if(intval($field["org_id"])<0)
        {
            $this->apiError( Code::SYS_PARAM_REQUIRED, '组织ID不能为空' );
        }

        //补充条件
        $field["company_code"] = $user_info["company_code"];//账套
        $field["org_status"] = [SystemEnum::ORG_STATUS_NORMAL, SystemEnum::ORG_STATUS_FORBIDDEN];//组织状态 正常 停用

        //查看是否存在该组织
        $org_once = $this->_getOrgService()->getOneOrgByField( $field );
        if(empty($org_once)){
            $this->apiError( Code::SYS_SELECT_ERROR, "不存在该组织" );
        }

        //判断当前组织下是否存在用户状态[正常、停用]的用户
        $user = $this->_getUserService()->getAllUserByField(["user_org_id" => $field["org_id"], "user_status"=>[SystemEnum::USER_STATUS_NORMAL,SystemEnum::USER_STATUS_FORBIDDEN]]);
        if(!empty($user)){
            $this->apiError( Code::SYS_SELECT_ERROR, "该组织下存在[正常、停用]状态用户" );
        }

        //获取该组织下所有其他组织
        $org_all = [];
        self::_recursionGetOrgId(["org_pid" => $field["org_id"], "company_code" => $field["company_code"], "org_status" => $field["org_status"]],$org_all);

        //该组织不下存在[正常、停用]状态的组织，更改状态为[作废]
        if(empty($org_all)){
            $result = $this->_getOrgService()->edit(["org_status" => SystemEnum::ORG_STATUS_INVALID], ["org_id" => $field["org_id"]]);
            if($result){
                $this->apiSuccess( [] );
            }else{
                $this->apiError( Code::SYS_EDIT_ERROR, "删除失败" );
            }
        }else{
            //该组织下存在[正常、停用]状态的组织
            $this->apiError( Code::SYS_EDIT_ERROR, "该组织下存在[正常、停用]状态的组织" );
        }
    }

    /**
     * 递归获取某组织下所有组织id
     * @param array $field
     * @author:tiger.li
     * @date:2018-05-09 18:06:08
     * @return array
     */
    private function _recursionGetOrgId(array $field, &$result):array{
        $allOrg = $this->_getOrgService()->getAllOrgByField( $field );
        if(!empty($allOrg)){
            array_push($result, $allOrg);
            $org_id = array_column($allOrg, "org_id");
            self::_recursionGetOrgId(["org_pid"=>$org_id, "company_code"=>$field["company_code"], "org_status"=>$field["org_status"]], $result);
        }
        return $result;
    }

    /**
     * @return OrgService
     */
    private function _getOrgService()
    {
        return ChelerApi::getService('system\service\Org');
    }

    /**
     * @return CompanyService
     */
    private function _getCompanyService()
    {
        return ChelerApi::getService('system\service\Company');
    }

    /**
     * @return UserService
     */
    private function _getUserService()
    {
        return ChelerApi::getService('system\service\User');
    }
}
