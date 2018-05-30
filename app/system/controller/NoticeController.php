<?php
namespace app\system\controller;

use app\system\service\NoticeService;
use app\system\service\UserService;
use frame\ChelerApi;
use app\helper\Code;
use app\helper\BaseController;
use app\helper\enum\SystemEnum;

/**
 * 通知业务
 * @author tiger.li
 * @date: 2018年5月11日
 */
class NoticeController extends BaseController
{

    /**
     * 添加通知
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function Add()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $insert = $this->controller->get_gp( ['notice_content'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[通知内容]（非空）
        if( empty($insert["notice_content"]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '通知内容不能为空' );
        }

        //补充数据
        $insert['company_code'] = $user_info["company_code"];//账套
        $insert['create_user'] = $user_info["user_code"];//创建用户编号
        $insert['create_time'] = time();//创建时间

        //过滤掉插入数组中为空的值
        $insert = filter_value($insert);

        //添加通知（sys_notice）
        $result = $this->_getNoticeService()->add($insert);

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "添加通知失败" );
        }
    }

    /**
     * 发送通知
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function Send()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $post = $this->controller->get_gp( ['notice_id', 'user_code', 'company_code', 'span'], 'P', true );

        //校验参数（分开校验，以便根据业务不同后期自由删除/修改）
        //  校验[通知内容]（非空）
        if( empty($post["notice_id"]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '通知消息主键id不能为空' );
        }
        //  校验[用户编号]（非空）
        $post['user_code'] = filter_value(explode(",", $post["user_code"]));
        if( empty($post['user_code']) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '发送用户编号不能为空' );
        }
        //  校验[发送公司账套]（非空）
        $post['company_code'] = filter_value(explode(",", $post["company_code"]));
        if( empty($post['company_code']) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '发送方用户账套不能为空' );
        }
        //  校验[是否跨公司]（非空）注：该字段仅为业务所用，并非数据表中真实字段，故不使用常量
        if( !in_array($post["span"], [0, 1]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '是否跨公司不能为空' );
        }
        //获取发送方用户信息
        $users = $this->_getUserService()->getAllUserByField(["user_code" => $post['user_code'], 'def_company_code'=>$post['company_code']]);
        if(empty($users)){
            $this->apiError( Code::SYS_PARAM_ERROR, '发送方用户账套未找到' );
        }
        $insert = [];
        $time = time();
        //处理发送用户数据
        foreach ($users as $key => $user){
            //补充数据
            $insert[$key]['notice_id'] = $post["notice_id"];//通知消息主键id（sys_notice）
            $insert[$key]['accpeter_user_code'] = $user["user_code"];//接收方用户编号
            $insert[$key]['accpeter_company_code'] = $user["def_company_code"];//接收方账套
            $insert[$key]['create_user'] = $user_info["user_code"];//创建者|发送者用户编号
            $insert[$key]['create_time'] = $time;//创建时间
        }
        $field = ['notice_id', 'accpeter_user_code', 'accpeter_company_code', 'create_user', 'create_time'];

        if($post["span"] == 0){
            $result = $this->_getNoticeService()->addRelNoticeUser($field, $insert);
        }else{
            $result = $this->_getNoticeService()->addRelNoticeUserCompany($field, $insert);
        }

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "发送通知失败" );
        }
    }

    /**
     * 已读通知
     * @author:tiger.li
     * @date:2018-05-11 14:41:23
     */
    public function Read()
    {
        //权限&获取当前登陆者信息
        //$user_info = $this->authorizeFunc();
        $user_info = $this->authorizeToken();

        //接收post值
        $post = $this->controller->get_gp( ['rel_id', 'span'], 'P', true );
        //  校验[是否跨公司]（非空）注：该字段仅为业务所用，并非数据表中真实字段，故不使用常量
        if( !in_array($post["span"], [0, 1]) )
        {
            $this->apiError( Code::SYS_PARAM_ERROR, '是否跨公司不能为空' );
        }
        if($post["span"] == 0){
            $result = $this->_getNoticeService()->EditRelNoticeUser(['read_status'=>SystemEnum::READ_STATE_READ], ["rel_id"=>$post['rel_id']]);
        }else{
            $result = $this->_getNoticeService()->EditRelNoticeUserCompany(['read_status'=>SystemEnum::READ_STATE_READ], ["rel_id"=>$post['rel_id']]);
        }

        if($result){
            $this->apiSuccess( [] );
        }else{
            $this->apiError( Code::SYS_ADD_ERROR, "已读失败" );
        }
    }

    /**
     * @return NoticeService
     */
    private function _getNoticeService()
    {
        return ChelerApi::getService('system\service\Notice');
    }

    /**
     * @return UserService
     */
    private function _getUserService()
    {
        return ChelerApi::getService('system\service\User');
    }
}
