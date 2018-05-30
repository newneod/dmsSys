<?php

namespace app\system\Controller;

use app\common\service\PreferenceService;
use app\helper\cache\RedisCache;
use app\system\service\CustomerService;
use frame\ChelerApi;
use app\helper\Code;
use app\helper\BaseController;
use app\helper\enum\SystemEnum;
use app\system\service\FuncService;
use app\system\service\JobService;
use app\system\service\OrgService;
use app\system\service\RoleService;
use app\system\service\UserService;
use app\system\service\CompanyService;
use app\common\service\TransactionService;

/**
 * 用户业务
 * @author nzw
 * @date: 2018-05-09
 */
class UserController extends BaseController
{
    /**
     * 登录
     * @author: nzw
     * @date: 2018-05-09
     */
    public function Login()
    {
        //验证账号密码
        $arrUser = $this->_checkLoginData();

        //生成登录token，原数据格式为：Self::PREFIX . $strUserCode . '_' . $iLoginTime
        $arrUser['token'] = hashCode(parent::PREFIX . $arrUser['user_code'] . '_' . $arrUser['user_last_time'], 'ENCODE', parent::HASH_KEY);

        //缓存用户信息
        $arrUser = $this->_cacheLoginData($arrUser);

        ChelerApi::info($this->getMCA(), "Login succeed,user_code is " . $arrUser['user_code']);
        $this->apiSuccess($arrUser);
    }

    /**
     * 验证账号密码
     * @author: nzw
     * @date: 2018-05-09
     */
    private function _checkLoginData()
    {
        //入参校验
        $strUserCode = trim($this->controller->get_gp('user_code', 'P'));
        parent::checkParam($strUserCode, true, true, '用户编号', 10);
        $strPwd = trim($this->controller->get_gp('user_password', 'P'));
        parent::checkParam($strPwd, true, false, '用户密码', 16);

        //账号存在性校验
        $arrUser = $this->_getUserService()->getOneUserByField(array(
            'user_code' => $strUserCode,
            'user_status' => SystemEnum::USER_STATUS_NORMAL,
        ));
        if(empty($arrUser)) {//用户不存在，或已停用，或已废弃
            $this->apiError(Code::SYS_USER_INEXIS, "用户不存在");
        }

        //密码正确性校验
        if ($arrUser['user_password'] != $this->_password($strPwd, $arrUser['user_salt'])) {
            $this->apiError(Code::SYS_PWD_ERROR, "密码有误");
        }

        //删除密码相关信息，记录登录时间，更新数据库
        $arrUser['user_last_time'] = $arrData['user_last_time'] = time();
        $this->_getUserService()->updateUser($arrData, array('user_code' => $strUserCode));
        unset($arrUser['user_password'], $arrUser['user_salt']);
        return $arrUser;
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
     * 缓存登录信息
     * @author: nzw
     * @date: 2018-05-09
     * @param array $arrUser 用户数据数组
     * @return array $arrUser 增加部门信息的用户数据数组
     */
    private function _cacheLoginData(array $arrUser)
    {
        //增加公司信息
        $arrUser['company_code'] = $arrUser['def_company_code'];
        $arrCompany = $this->_getCompanyService()->getOneCompanyByField(array(
            'company_code' => $arrUser['company_code']
        ));
        if (!empty($arrCompany)) {
            $arrUser['company_name'] = $arrCompany['company_name'] ?? '';
        }

        //增加用户权限信息
        $arrFuncs = $this->_getFuncService()->getUserFuncsTree($arrUser['user_code']);
        $arrUser['user_funcs_tree'] = $arrFuncs['tree'] ?? array();//树形结构
        $arrUser['user_funcs_router'] = $arrFuncs['routers'] ?? array();//所有权限路由（用于action鉴权）
        $arrUser['user_favorite_funcs'] = $arrFuncs['user_favorite_funcs']??array();//收藏夹菜单信息

        //增加用户角色信息
        $arrUser['user_roles'] = $this->_getRoleService()->getRolesByUserCode($arrUser['user_code']);

        //增加所属组织信息（一个用户只能属于一个组织）
        $arrUser['company_orgs'] = $this->_getOrgService()->getOneOrgByField(array(
            'company_code' => $arrUser['company_code']
        ));

        //增加所属职务信息
        $arrUser['user_jobs'] = $this->_getJobService()->getJobsByCompanyCode($arrUser['company_code']);

        //增加所属公司的客户信息（若所在公司是4S店，则有客户编号和上级公司（即主机厂）账套；
        //若所在公司是主机厂，则没有对应信息，因为主机厂不是客户）
        $arrCustomer = $this->_getCustomerService()->getOneCustomerByField(array(
            'customer_ref_company_code' => $arrUser['company_code']
        ));
        $arrUser['customer_code'] = $arrCustomer['customer_code'] ?? '';//用户所在公司的客户编号
        $arrUser['customer_higher_company_code'] = $arrCustomer['company_code'] ?? '';//用户所在公司的上级公司编号

        //缓存用户信息数据
        $this->getRedis('default')->set(RedisCache::R_system_login_data($arrUser['user_code']),
            json_encode($arrUser, JSON_UNESCAPED_UNICODE), self::TOKEN_EXPIRE_SECONDS);
        return $arrUser;
    }

    /**
     * 新增用户
     * @author: nzw
     * @date: 2018-05-11
     * @return: void
     */
    public function Add()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //检查入参必填项
        $strUserCode = $this->controller->get_gp('user_code', 'P');
        parent::checkParam($strUserCode, true, true, '用户编号', 10);
        $strPwd = $this->controller->get_gp('user_password', 'P');
        parent::checkParam($strPwd, true, false, '用户密码', 16);
        $strUsername = $this->controller->get_gp('user_realname', 'P');
        parent::checkParam($strUsername, true, false, '用户真实姓名', 45);

        //检查user_code唯一性
        $arrUserTemp = $this->_getUserService()->getOneUserByField(array('user_code' => $strUserCode));
        if (!empty($arrUserTemp)) {
            $this->apiError(Code::SYS_ADD_ERROR, "用户编号已存在");
        }

        //检查入参非必填项，并返回组织好的field数组
        $arrData = $this->_checkUserParams($strUserCode);
        $arrData['user']['user_code'] = $strUserCode;
        $arrData['user']['user_salt'] = $this->_hash(parent::PWD_SALT_LEN);
        $arrData['user']['user_password'] = $this->_password($strPwd, $arrData['user']['user_salt']);
        $arrData['user']['user_realname'] = $strUsername;
        $arrData['user']['create_time'] = time();
        $arrData['user']['create_user'] = $arrUser['user_code'];
        $arrData['user']['def_company_code'] = $arrUser['company_code'];

        $this->_getTransactionService()->start();

        //插入用户表数据
        $iUserRes = $this->_getUserService()->insertUser($arrData['user']);
        if ($iUserRes <= 0) {
            $this->_getTransactionService()->rollback();
            $this->apiError(Code::SYS_ADD_ERROR, "用户新增失败（用户表插入失败）");
        }

        //插入用户-角色关系表数据
        if (!empty($arrData['role'])) {
            $iRoleInsertRes = $this->_getRoleService()->insertMoreRelUserRoles(array_keys($arrData['role'][0]),
                $arrData['role']);
            if ($iRoleInsertRes <= 0) {
                $this->_getTransactionService()->rollback();
                $this->apiError(Code::SYS_ADD_ERROR, "用户新增失败（用户-角色关系插入失败）");
            }
        }

        //提交事务并返回
        $this->_getTransactionService()->commit();
        $this->apiSuccess();
    }

    /**
     * 编辑用户
     * @author: nzw
     * @date: 2018-05-11
     * @return: void
     */
    public function Edit()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //检查入参必填项
        $strUserCode = $this->controller->get_gp('user_code', 'P');
        parent::checkParam($strUserCode, true, true, '用户编号', 10);
        if ($arrUser['user_code'] == $strUserCode) {
            $this->apiError(Code::SYS_EDIT_ERROR, "用户更新失败（用户不能修改自身信息，启/停用，作废以及重置密码）");
        }

        //用户存在性校验、状态校验
        $arrUserTemp = $this->_getUserService()->getOneUserByField(array(
            'user_code' => $strUserCode,
            'def_company_code' => $arrUser['company_code'],
            'user_status' => array(SystemEnum::USER_STATUS_NORMAL, SystemEnum::USER_STATUS_FORBIDDEN),
        ));
        if (empty($arrUserTemp)) {
            $this->apiError(Code::SYS_EDIT_ERROR, "用户更新失败（用户不存在或已作废）");
        }

        //检查入参非必填项，并返回组织好的field数组
        $arrData = $this->_checkUserParams($strUserCode);
        $strPwd = $this->controller->get_gp('user_password', 'P');
        if (isset($strPwd) && $strPwd !== '') {
            parent::checkParam($strPwd, true, false, '用户密码', 16);
            $arrData['user']['user_salt'] = $this->_hash(parent::PWD_SALT_LEN);
            $arrData['user']['user_password'] = $this->_password($strPwd, $arrData['user']['user_salt']);
        }
        $arrData['user']['modify_user'] = time();
        $arrData['user']['modify_time'] = $arrUser['user_code'];

        $this->_getTransactionService()->start();

        //更新用户表数据
        if (!empty($arrData['user'])) {
            $iUserRes = $this->_getUserService()->updateUser($arrData['user'],
                array('user_code' => $strUserCode, 'def_company_code' => $arrUser['company_code']));
            if (!is_numeric($iUserRes) || $iUserRes < 0) {
                $this->_getTransactionService()->rollback();
                $this->apiError(Code::SYS_EDIT_ERROR, "用户更新失败（用户表更新失败）");
            }
        }

        //更新用户-角色关系表数据
        if (!empty($arrData['role'])) {
            //查询当前角色，如果新插入的和原数据相同，则不进行数据库操作
            $arrRelUserRoles = $this->_getRoleService()->getRelUserRolesByField(array('user_code' => $strUserCode));
            if (!empty(array_diff($arrRelUserRoles, $arrData['role']))) {
                //删除原用户-角色关系表数据
                $iRoleDelRes = $this->_getRoleService()->deleteRelUserRole(array('user_code' => $strUserCode));
                if ($iRoleDelRes <= 0) {
                    $this->_getTransactionService()->rollback();
                    $this->apiError(Code::SYS_ADD_ERROR, "用户新增失败（用户-角色关系删除失败）");
                }

                //插入用户-角色关系表数据
                $iRoleInsertRes = $this->_getRoleService()->insertMoreRelUserRoles(array_keys($arrData['role'][0]),
                    $arrData['role']);
                if ($iRoleInsertRes <= 0) {
                    $this->_getTransactionService()->rollback();
                    $this->apiError(Code::SYS_ADD_ERROR, "用户新增失败（用户-角色关系插入失败）");
                }

                //通过user_code，删除该用户的列表偏好设置和搜索偏好设置
                $arrDelRes = $this->_getPreferenceService()->deleteAllPreference(array($arrUser['user_code']));
                if ($arrDelRes[0] != Code::CODE_SUCCESS) {
                    $this->_getTransactionService()->rollback();
                    $this->apiError($arrDelRes[0], $arrDelRes[1]);
                }
            }
        }

        //提交事务并返回
        $this->_getTransactionService()->commit();
        $this->apiSuccess();
    }

    /**
     * 获取用户详情（用于编辑操作）
     * @author: nzw
     * @date: 2018-05-21
     * @return: array
     */
    public function GetUserDetail()
    {
        //token校验
        $arrUser = $this->authorizeToken();

        //入参校验
        $strUserCode = $this->controller->get_gp('user_code', 'P');
        parent::checkParam($strUserCode, true, true, '用户编号', 10);

        //获取详情
        $arrField = array(
            'user_code' => $strUserCode,
            'def_company_code' => $arrUser['company_code'],
            'user_status' => array(SystemEnum::USER_STATUS_NORMAL, SystemEnum::USER_STATUS_FORBIDDEN)
        );
//        if ($arrUser['is_super'] != SystemEnum::USER_IS_SUPER_YES) {
//            unset($arrField['def_company_code']);
//        }
        $arrUser = $this->_getUserService()->getOneUserByField($arrField);
        if (!empty($arrUser)) {
            unset($arrUser['user_password'], $arrUser['user_salt']);
        }
        $this->apiSuccess($arrUser);
    }

    /**
     * 启用用户
     * @author: nzw
     * @date: 2018-05-20
     * @return: void
     */
    public function Enable()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $strUserCode = $this->controller->get_gp('user_code', 'P');
        parent::checkParam($strUserCode, true, true, '用户编号', 10);
        if ($arrUser['user_code'] == $strUserCode) {
            $this->apiError(Code::SYS_EDIT_ERROR, "用户启用失败（用户不能修改自身信息，启/停用，作废以及重置密码）");
        }

        //具体操作
        $arrRes = $this->_getUserService()->resetUserStatus($strUserCode, $arrUser['company_code'],
            SystemEnum::USER_STATUS_NORMAL, $arrUser['user_code']);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->apiSuccess();
    }

    /**
     * 停用用户
     * @author: nzw
     * @date: 2018-05-20
     * @return: void
     */
    public function Disable()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $strUserCode = $this->controller->get_gp('user_code', 'P');
        parent::checkParam($strUserCode, true, true, '用户编号', 10);
        if ($arrUser['user_code'] == $strUserCode) {
            $this->apiError(Code::SYS_EDIT_ERROR, "用户更新失败（用户不能修改自身信息，启/停用，作废以及重置密码）");
        }

        //具体操作
        $arrRes = $this->_getUserService()->resetUserStatus($strUserCode, $arrUser['company_code'],
            SystemEnum::USER_STATUS_FORBIDDEN, $arrUser['user_code']);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->apiSuccess();
    }

    /**
     * 作废用户（即删除按钮）
     * @author: nzw
     * @date: 2018-05-20
     * @return: void
     */
    public function Discard()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $strUserCode = $this->controller->get_gp('user_code', 'P');
        parent::checkParam($strUserCode, true, true, '用户编号', 10);
        if ($arrUser['user_code'] == $strUserCode) {
            $this->apiError(Code::SYS_EDIT_ERROR, "用户更新失败（用户不能修改自身信息，启/停用，作废以及重置密码）");
        }

        //具体操作
        $arrRes = $this->_getUserService()->resetUserStatus($strUserCode, $arrUser['company_code'],
            SystemEnum::USER_STATUS_INVALID, $arrUser['user_code']);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->apiSuccess();
    }

    /**
     * 检查新增操作和编辑操作用户入参，并返回组织好的field数组
     * @author: nzw
     * @date: 2018-05-10
     * @return: array
     */
    private function _checkUserParams(string $strUserCode)
    {
        //初始化条件数组
        $arrData = array(
            'user' => array(),
            'role' => array(),
        );
        if ($strUserCode === '') {
            return $arrData;
        }

        //组织用户条件
        $strUsername = $this->controller->get_gp('user_realname', 'P');
        if (isset($strUsername) && $strUsername !== '') {
            parent::checkParam($strUsername, true, false, '用户真实姓名', 45);
            $arrData['user']['user_realname'] = $strUsername;
        }
        $iGender = $this->controller->get_gp('user_gender', 'P');
        if (isset($iGender)) {
            $iGender = $this->isNumber($iGender, true, true, '用户性别');
            $arrData['user']['user_gender'] = (int) $iGender;
        }
        $strTel = $this->controller->get_gp('user_tel', 'P');
        if (isset($strTel) && $strTel !== '') {
            $arrData['user']['user_tel'] = $strTel;
        }
        $strPhone = $this->controller->get_gp('user_phone', 'P');
        if (isset($strPhone) && $strPhone !== '') {
            $arrData['user']['user_phone'] = $strPhone;
        }
        $strUserEmail = $this->controller->get_gp('user_email', 'P');
        if (isset($strUserEmail) && $strUserEmail !== '') {
            $arrData['user']['user_email'] = $strUserEmail;
        }
        $iUserStatus = $this->controller->get_gp('user_status', 'P');
        if (isset($iUserStatus)) {
            $iUserStatus = $this->isNumber($iUserStatus, true, true, '用户状态');
            $arrData['user']['user_status'] = $iUserStatus;
        }
        $strUserRemark = $this->controller->get_gp('user_remark', 'P');
        if (isset($strUserRemark) && $strUserRemark !== '') {
            $arrData['user']['user_remark'] = $strUserRemark;
        }
        $iJobId = $this->controller->get_gp('job_id', 'P');
        if (isset($iJobId)) {
            $iJobId = $this->isNumber($iJobId, true, true, '用户职务id');
            //通过job_id，查询job_name
            $arrJob = $this->_getJobService()->getOneJobByField(array(
                'job_id' => $iJobId,
                'job_status' => array(SystemEnum::JOB_STATUS_NORMAL),
            ));
            if (empty($arrJob)) {
                $this->apiError(Code::SYS_PARAM_ERROR, '该职务不能选择');
            }
            $arrData['user']['user_job_id'] = (int) $iJobId;
            $arrData['user']['user_job_name'] = $arrJob['job_name'] ?? '';
        }
        $iOrgId = $this->controller->get_gp('org_id', 'P');
        if (isset($iOrgId)) {
            $iOrgId = $this->isNumber($iOrgId, true, true, '用户所属组织id');
            //通过job_id，查询job_name
            $arrOrg = $this->_getOrgService()->getOneOrgByField(array(
                'org_id' => $iOrgId,
                'org_status' => array(SystemEnum::ORG_STATUS_NORMAL),
            ));
            if (empty($arrOrg)) {
                $this->apiError(Code::SYS_PARAM_ERROR, '该组织不能选择');
            }
            $arrData['user']['user_org_id'] = (int) $iOrgId;
            $arrData['user']['user_org_name'] = $arrOrg['org_name'] ?? '';
        }

        //组织role条件
        $strRoleIds = $this->controller->get_gp('role_ids', 'P');
        if (isset($strRoleIds) && $strRoleIds !== '') {
            $arrRoleIds = explode(',', $strRoleIds);
            if (!empty($arrRoleIds)) {
                foreach ($arrRoleIds AS $iRoleId) {
                    $arrData['role'][] = array('user_code' => $strUserCode, 'role_id' => (int) $iRoleId);
                }
            }
        }

        return $arrData;
    }

    /**
     * @return UserService
     */
    private function _getUserService()
    {
        return ChelerApi::getService('system\service\User');
    }

    /**
     * @return FuncService
     */
    private function _getFuncService()
    {
        return ChelerApi::getService('system\service\Func');
    }

    /**
     * @return RoleService
     */
    private function _getRoleService()
    {
        return ChelerApi::getService('system\service\Role');
    }

    /**
     * @return CompanyService
     */
    private function _getCompanyService()
    {
        return ChelerApi::getService('system\service\Company');
    }

    /**
     * @return OrgService
     */
    private function _getOrgService()
    {
        return ChelerApi::getService('system\service\Org');
    }

    /**
     * @return JobService
     */
    private function _getJobService()
    {
        return ChelerApi::getService('system\service\Job');
    }

    /**
     * @return TransactionService
     */
    private function _getTransactionService()
    {
        return ChelerApi::getService('common\service\Transaction');
    }

    /**
     * @return CustomerService
     */
    private function _getCustomerService()
    {
        return ChelerApi::getService('system\service\Customer');
    }

    /**
     * @return PreferenceService
     */
    private function _getPreferenceService()
    {
        return ChelerApi::getService('common\service\Preference');
    }
}