<?php

namespace app\system\Controller;

use app\common\service\TransactionService;
use frame\ChelerApi;
use app\helper\BaseController;
use app\helper\Code;
use app\helper\enum\SystemEnum;
use app\system\service\FuncService;
use app\system\service\RoleService;

/**
 * 角色业务
 * @author nzw
 * @date: 2018-05-09
 */
class RoleController extends BaseController
{
    /**
     * 新增角色（仅限基础数据）
     * @author: nzw
     * @date: 2018-05-11
     * @return: void
     */
    public function Add()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $strRoleName = $this->controller->get_gp('role_name', 'P');
        parent::checkParam($strRoleName, true, false, '角色名称', 45);
        $iRoleStatus = $this->controller->get_gp('role_status', 'P');
        parent::isNumber($iRoleStatus, true, true, '角色状态');
        if (!in_array($iRoleStatus, array(SystemEnum::ROLE_STATUS_NORMAL, SystemEnum::ROLE_STATUS_FORBIDDEN))) {
            $this->apiError(Code::SYS_PARAM_ERROR, '角色状态参数错误');
        }
        $strRoleDesc = $this->controller->get_gp('role_desc', 'P');
        if (isset($strRoleDesc) && $strRoleDesc !== '') {
            parent::checkParam($strRoleDesc, true, false, '角色描述', 255);
        }

        //同公司下角色名称唯一性校验（已作废的角色名可以复用）
        $arrRoleTemp = $this->_getRoleService()->getOneRoleByField(array(
            'company_code' => $arrUser['company_code'],
            'role_name' => $strRoleName,
            'role_status' => array(SystemEnum::ROLE_STATUS_NORMAL, SystemEnum::ROLE_STATUS_FORBIDDEN),
        ));
        if (!empty($arrRoleTemp)) {
            $this->apiError(Code::SYS_PARAM_ERROR, '角色名称已存在');
        }

        //插入数据
        $iTimeNow = time();
        $arrData = array();
        $arrData['company_code'] = $arrUser['company_code'];
        $arrData['role_name'] = $strRoleName;
        $arrData['role_desc'] = $strRoleDesc ?? '';
        $arrData['role_status'] = $iRoleStatus;
        $arrData['create_user'] = $arrUser['user_code'];
        $arrData['create_time'] = $iTimeNow;
        $iRes = $this->_getRoleService()->init_db()->insert($arrData, 'sys_role');
        if ($iRes <= 0) {
            $this->apiError(Code::SYS_ADD_ERROR, '角色新增失败');
        }
        $this->apiSuccess();
    }

    /**
     * 编辑角色（仅限基础数据）
     * @author: nzw
     * @date: 2018-05-11
     * @return: void
     */
    public function Edit()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRoleId = $this->controller->get_gp('role_id', 'P');//角色id
        parent::isNumber($iRoleId, true, true, '角色ID');
        $strRoleName = $this->controller->get_gp('role_name', 'P');
        parent::checkParam($strRoleName, true, false, '角色名称', 45);
        $iRoleStatus = $this->controller->get_gp('role_status', 'P');
        parent::isNumber($iRoleStatus, true, true, '角色状态');
        if (!in_array($iRoleStatus, array(SystemEnum::ROLE_STATUS_NORMAL, SystemEnum::ROLE_STATUS_FORBIDDEN))) {
            $this->apiError(Code::SYS_PARAM_ERROR, '角色状态参数错误');
        }
        $strRoleDesc = $this->controller->get_gp('role_desc', 'P');
        if (isset($strRoleDesc) && $strRoleDesc !== '') {
            parent::checkParam($strRoleDesc, true, false, '角色描述', 255);
        }

        //角色信息存在性校验
        $arrRole = $this->_getRoleService()->getOneRoleByField(array(
            'role_id' => $iRoleId,
            'company_code' => $arrUser['company_code'],
            'role_status' => array(SystemEnum::ROLE_STATUS_NORMAL, SystemEnum::ROLE_STATUS_FORBIDDEN),
        ));
        if (empty($arrRole)) {
            $this->apiError(Code::SYS_EDIT_ERROR, '角色信息不存在');
        }

        //同公司下角色名称唯一性校验（已作废的角色名可以复用，不包括自身）
        $strSqlTemp = "SELECT `role_id` FROM `sys_role` WHERE `company_code`='" . $arrUser['company_code'] .
                      "' AND `role_name`='" . $strRoleName .
                      "' AND `role_id`!='" . $iRoleId .
                      "' AND `role_status`!='" . SystemEnum::ROLE_STATUS_INVALID . "'";
        $arrRoleTemp = $this->_getRoleService()->getAllRolesBySql($strSqlTemp);
        if (!empty($arrRoleTemp)) {
            $this->apiError(Code::SYS_EDIT_ERROR, '角色名称已存在');
        }

        //编辑数据
        $iTimeNow = time();
        $arrData = array();
        $arrData['role_name'] = $strRoleName;
        $arrData['role_desc'] = $strRoleDesc ?? '';
        $arrData['role_status'] = $iRoleStatus;
        $arrData['modify_user'] = $arrUser['user_code'];
        $arrData['modify_time'] = $iTimeNow;
        $iRes = $this->_getRoleService()->init_db()->update_by_field($arrData,
            array('role_id' => $iRoleId, 'company_code' => $arrUser['company_code']), 'sys_role');
        if ($iRes <= 0) {
            $this->apiError(Code::SYS_EDIT_ERROR, '角色编辑失败');
        }
        $this->apiSuccess();
    }

    /**
     * 获取角色详情（用于编辑操作）
     * @author: nzw
     * @date: 2018-05-21
     * @return: array
     */
    public function GetRoleDetail()
    {
        //token校验
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRoleId = $this->controller->get_gp('role_id', 'P');//角色id
        parent::isNumber($iRoleId, true, true, '角色ID');

        //获取详情
        $arrField = array(
            'role_id' => $iRoleId,
            'company_code' => $arrUser['company_code'],
            'role_status' => array(SystemEnum::ROLE_STATUS_NORMAL, SystemEnum::ROLE_STATUS_FORBIDDEN)
        );
//        if ($arrUser['is_super'] != SystemEnum::USER_IS_SUPER_YES) {
//            unset($arrField['company_code']);
//        }
        $arrRole = $this->_getRoleService()->getOneRoleByField($arrField);
        $this->apiSuccess($arrRole);
    }

    /**
     * 启用角色
     * @author: nzw
     * @date: 2018-05-12
     * @return: void
     */
    public function Enable()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRoleId = $this->controller->get_gp('role_id', 'P');
        parent::isNumber($iRoleId, true, true, '角色ID');

        //具体操作
        $arrRes = $this->_getRoleService()->resetRoleStatus($iRoleId, $arrUser['company_code'],
            SystemEnum::ROLE_STATUS_NORMAL, $arrUser['user_code']);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->apiSuccess();
    }

    /**
     * 停用角色
     * @author: nzw
     * @date: 2018-05-12
     * @return: void
     */
    public function Disable()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRoleId = $this->controller->get_gp('role_id', 'P');
        parent::isNumber($iRoleId, true, true, '角色ID');

        //具体操作
        $arrRes = $this->_getRoleService()->resetRoleStatus($iRoleId, $arrUser['company_code'],
            SystemEnum::ROLE_STATUS_FORBIDDEN, $arrUser['user_code']);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->apiSuccess();
    }

    /**
     * 作废角色（即删除按钮）
     * @author: nzw
     * @date: 2018-05-12
     * @return: void
     */
    public function Discard()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRoleId = $this->controller->get_gp('role_id', 'P');
        parent::isNumber($iRoleId, true, true, '角色ID');

        //具体操作
        $arrRes = $this->_getRoleService()->resetRoleStatus($iRoleId, $arrUser['company_code'],
            SystemEnum::ROLE_STATUS_INVALID, $arrUser['user_code']);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->apiSuccess();
    }

    /**
     * 基础功能列表（树根）
     * @author: nzw
     * @date: 2018-05-11
     * @return: void
     */
    public function FuncsListBase()
    {
        //token校验
        $arrUser = $this->authorizeToken();

        //组织筛选条件
        $arrField = array(
            'func_parent' => 0,
            'func_type' => array(SystemEnum::FUNC_TYPE_MENU, SystemEnum::FUNC_TYPE_VIEW),
        );
        if ($arrUser['customer_code'] === '') {
            //如果用户所在公司是主机厂，则能看到所有主机厂的权限（主机厂不是客户，所以客户编号为空）
            $arrField['func_owner'] = SystemEnum::FUNC_OWNER_FACTORY;
        } else {
            //如果用户所在公司是4S店，则能看到所有4S店类型的权限
            $arrField['func_owner'] = SystemEnum::FUNC_OWNER_4S;
        }

        //获取数据
        $arrFucs = $this->_getFuncService()->getAllFuncsByField($arrField);
        $this->apiSuccess($arrFucs);
    }

    /**
     * 某棵树的功能列表（不包括操作功能权限）
     * @author: nzw
     * @date: 2018-05-11
     * @return: void
     */
    public function FuncsListTree()
    {
        //token校验
        $arrUser = $this->authorizeToken();

        //入参校验
        $iFuncPid = $this->controller->get_gp('pid', 'P');
        parent::isNumber($iFuncPid, true, true, '父级功能ID');

        //获取数据
        $iFuncOwner = $arrUser['customer_code'] === '' ? SystemEnum::FUNC_OWNER_FACTORY : SystemEnum::FUNC_OWNER_4S;
        $arrFucs = $this->_getFuncService()->getTreeFuncsByPid($iFuncPid, $iFuncOwner);
        $this->apiSuccess($arrFucs[0] ?? array());
    }

    /**
     * 某个视图功能的操作功能和字段功能列表（用于给角色授权时的弹出框数据展示）
     * @author: nzw
     * @date: 2018-05-11
     * @return: array
     */
    public function FuncsListView()
    {
        //token校验
        $arrUser = $this->authorizeToken();

        //入参校验
        $strFuncCode = $this->controller->get_gp('func_code', 'P');//视图权限编号
        parent::checkParam($strFuncCode, false, 'false', '视图功能编号');
        $iRoleId = $this->controller->get_gp('role_id', 'P');//角色id
        parent::isNumber($iRoleId, true, true, '角色ID');

        //获取该视图权限数据（同时即可获取该视图权限下的所有字段权限）
        $arrFuncView = $this->_getFuncService()->getOneFuncByField(array('func_code' => $strFuncCode,
            'func_type' => SystemEnum::FUNC_TYPE_VIEW));
        if (empty($arrFuncView)) {
            $this->apiError(Code::SYS_SELECT_ERROR, "该视图功能不存在");
        }
        $arrAllParams = json_decode($arrFuncView['func_extra']);
        if (empty($arrFuncView['func_extra']) || empty($arrAllParams)) {
            $this->apiError(Code::SYS_SELECT_ERROR, "该视图功能没有需要展示的字段");
        }

        //获取该视图权限下的所有操作权限
        $arrAllOpes = $this->_getFuncService()->getAllFuncsByField(array(
            'func_parent' => $arrFuncView['func_id'],
            'func_type' => SystemEnum::FUNC_TYPE_OPERATION,
        ));

        //获取该角色已有的该视图权限下的操作权限
        if (!empty($arrAllOpes)) {
            $arrExistOpes = $this->_getFuncService()->getAllRelRoleFuncsByField(array(
                'func_code' => array_values(array_column($arrAllOpes, 'func_code'))
            ));
        }

        //获取该角色已有的该视图权限下的字段权限
        $arrRelRoleFunc = $this->_getFuncService()->getOneRelRoleFuncByField(array(
            'func_code' => $strFuncCode,
            'role_id' => $iRoleId,
        ));
        if (!empty($arrRelRoleFunc) && !empty($arrRelRoleFunc['func_configed_params'])) {
            $arrExistParams = json_decode($arrRelRoleFunc['func_configed_params']);
        }

        //返回结果数组
        $arrRes = array();
        $arrRes['funcs_params_all'] = $arrAllParams;
        $arrRes['funcs_opes_all'] = $arrAllOpes;
        $arrRes['funcs_params_exist'] = $arrExistParams ?? array();//如果为空则默认全选
        $arrRes['funcs_opes_exist'] = $arrExistOpes ?? array();//如果为空则默认全选
        $this->apiSuccess($arrRes);
    }

    /**
     * 获取所有已选视图权限，并依次列出其上级菜单名称
     * @author: nzw
     * @date: 2018-05-11
     * @return: void
     */
    public function FuncsViewSel()
    {
        //token校验
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRoleId = $this->controller->get_gp('role_id', 'P');//角色id
        parent::isNumber($iRoleId, true, true, '角色ID');

        //获取该角色所有已选权限
        $arrRelRoleFuncs = $this->_getFuncService()->getAllRelRoleFuncsByField(array('role_id' => $iRoleId));
        if (empty($arrRelRoleFuncs)) {
            $this->apiSuccess();
        }

        //获取该角色所有已选的视图权限
        $arrViewFuncs = $this->_getFuncService()->getAllFuncsByField(array(
            'func_type' => SystemEnum::FUNC_TYPE_VIEW,
            'func_code' => array_column($arrRelRoleFuncs, 'func_code')
        ));
        if (empty($arrViewFuncs)) {
            $this->apiSuccess();
        }

        //获取该角色所有已选的视图功能编号
        $arrViewFuncCodes = array_column($arrViewFuncs, 'func_code');
        if (empty($arrViewFuncCodes)) {
            $this->apiSuccess();
        }

        //将关系数据转化为 func_code => $arrRel 的形式
        //并筛选该角色所有已选的操作权限
        $arrFuncCode2Rel = array();
        $arrOpeFuncCodes = array();
        foreach ($arrRelRoleFuncs AS $iKey => $arrRel) {
            $arrFuncCode2Rel[$arrRel['func_code']] = $arrRel;
            if (!in_array($arrRel['func_code'], $arrViewFuncCodes)) {
                $arrOpeFuncCodes[] = $arrRel['func_code'];
            }
        }

        //获取所有菜单和视图权限数据
        $arrFuncs = $this->_getFuncService()->getAllFuncsByField(array(
            'func_type' => array(SystemEnum::FUNC_TYPE_MENU, SystemEnum::FUNC_TYPE_VIEW),
        ));
        if (empty($arrFuncs)) {
            $this->apiSuccess();
        }

        //将所有菜单数据组织成 func_code => arrFunc 的形式和 func_id => arrFunc 的形式
        $arrCode2Func = array();
        $arrId2Func = array();
        foreach ($arrFuncs AS $arrFunc) {
            $arrCode2Func[$arrFunc['func_code']] = $arrFunc;
            $arrId2Func[$arrFunc['func_id']] = $arrFunc;
        }

        //获取所有操作权限，并将其组织成 viewFuncId => arrFunc 的形式
        $arrOpeFuncField = array('func_type' => SystemEnum::FUNC_TYPE_OPERATION);
        if (!empty($arrOpeFuncCodes)) {
            $arrOpeFuncField['func_code'] = $arrOpeFuncCodes;
        }
        $arrOpeFuncs = $this->_getFuncService()->getAllFuncsByField($arrOpeFuncField);
        $arrPid2OpeFuncs = array();
        if (!empty($arrOpeFuncs)) {
            foreach ($arrOpeFuncs AS $arrOpeFunc) {
                $arrPid2OpeFuncs[$arrOpeFunc['func_parent']][] = $arrOpeFunc['func_code'];
            }
        }

        //根据所有已选的视图权限编号，获取权限名称和其上级菜单名称数组
        $arrRes = array();
        foreach ($arrViewFuncs AS $iKey => $arrViewFunc) {
            $arrFuncNames = array();
            $arrRes[$iKey]['name'][] = self::_getFuncNames($arrCode2Func, $arrId2Func,
                $arrViewFunc['func_code'], $arrFuncNames);
            $arrRes[$iKey]['func_code'] = $arrViewFunc['func_code'];
            $arrRes[$iKey]['funcs_params_exist'] = array();//已选字段权限
            if (!empty($arrFuncCode2Rel[$arrViewFunc['func_code']]['func_configed_params'])) {
                $arrRes[$iKey]['funcs_params_exist'] = json_decode($arrFuncCode2Rel[$arrViewFunc['func_code']]['func_configed_params'], true);
            }
            $arrRes[$iKey]['funcs_opes_exist'] = $arrPid2OpeFuncs[$arrViewFunc['func_id']] ?? array();//已选操作权限func_code
        }
        $this->apiSuccess($arrRes);
    }

    /**
     * 按层级顺序，获取权限名称数组
     * @author: nzw
     * @date: 2018-05-11
     * @param array $arrCode2Func
     * @param array $arrId2Func
     * @param string $strFuncCode
     * @param array $arrFuncNames 结果数组（引用）
     * @return: array $arrFuncNames 结果数组
     */
    private function _getFuncNames(array $arrCode2Func, array $arrId2Func, string $strFuncCode, array &$arrFuncNames)
    {
        if (!empty($arrCode2Func[$strFuncCode])) {
            $arrFuncNames[] = $arrCode2Func[$strFuncCode]['func_name'];
            $arrFuncParent = $arrId2Func[$arrCode2Func[$strFuncCode]['func_parent']];
            if (!empty($arrFuncParent)) {
                $this->_getFuncNames($arrCode2Func, $arrId2Func, $arrFuncParent['func_code'], $arrFuncNames);
            }
        }
        return array_reverse($arrFuncNames);
    }

    /**
     * 授权操作
     * 一次性添加所有视图权限（包括字段权限）、操作权限
     * 如果之前有值，则删除原值
     * @author: nzw
     * @date: 2018-05-11
     * @return: void
     */
    public function Authorize()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRoleId = $this->controller->get_gp('role_id', 'P');//角色id
        parent::isNumber($iRoleId, true, true, '角色ID');
        $strFuncs = $this->controller->get_gp('funcs', 'P');//新增的功能json数组（包括菜单和操作功能）
        $arrFuncs = json_decode(str_replace('\\', '', $strFuncs), true);
        if (empty($arrFuncs)) {
            $this->apiError(Code::SYS_PARAM_REQUIRED, "新增功能为空");
        }

        //插入新功能（先删除原功能再插入）
        $this->_getTransactionService()->start();
        $arrRes = $this->_getFuncService()->addFuncsForRole($iRoleId, $arrFuncs);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->_getTransactionService()->rollback();
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->_getTransactionService()->commit();
        $this->apiSuccess();
    }

    /**
     * 获取角色相关下拉菜单列表
     * @author: nzw
     * @date: 2018-05-21
     * @return: array
     */
    public function RolesList()
    {
        //鉴权
        $arrUser = $this->authorizeToken();

        //具体操作
        $arrRoles = $this->_getRoleService()->getAllRolesByField(array(
            'company_code' => $arrUser['company_code'],
            'role_status' => SystemEnum::ROLE_STATUS_NORMAL,
        ));
        $this->apiSuccess($arrRoles);
    }

    /**
     * @return RoleService
     */
    private function _getRoleService()
    {
        return ChelerApi::getService('system\service\Role');
    }

    /**
     * @return FuncService
     */
    private function _getFuncService()
    {
        return ChelerApi::getService('system\service\Func');
    }

    /**
     * @return TransactionService
     */
    private function _getTransactionService()
    {
        return ChelerApi::getService('common\service\Transaction');
    }
}