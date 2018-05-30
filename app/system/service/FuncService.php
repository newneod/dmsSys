<?php
namespace app\system\service;

use frame\ChelerApi;
use app\common\service\PreferenceService;
use app\helper\BaseService;
use app\helper\Code;
use app\helper\enum\SystemEnum;

/**
 * 功能（权限）service
 * @package app\system\service
 */
class FuncService extends BaseService
{
    /**
     * 通过条件获取单个权限
     * @author: nzw
     * @date: 2018-05-11
     * @param array $arrField
     * @return: array
     */
    public function getOneFuncByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrFunc = $this->init_db()->get_one_by_field($arrField, 'sys_func');
        if (empty($arrFunc)) {
            return array();
        }
        return $this->_transferFuncs(array($arrFunc))[0];
    }

    /**
     * 通过条件获取多个权限
     * @author: nzw
     * @date: 2018-05-11
     * @param array $arrField
     * @return: array
     */
    public function getAllFuncsByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrFuncs = $this->init_db()->get_all_by_field($arrField, 'sys_func');
        if (empty($arrFuncs)) {
            return array();
        }
        return $this->_transferFuncs($arrFuncs);
    }

    /**
     * 通过条件获取所有 角色-功能关系表 数据
     * @author: nzw
     * @date: 2018-05-11
     * @param array $arrField
     * @return: array
     */
    public function getAllRelRoleFuncsByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrRelRoleFuncs = $this->init_db()->get_all_by_field($arrField, 'sys_rel_role_func');
        return $this->_transferRelRoleFuncs($arrRelRoleFuncs);
    }

    /**
     * 通过条件获取单条 角色-功能关系表 数据
     * @author: nzw
     * @date: 2018-05-11
     * @param array $arrField
     * @return: array
     */
    public function getOneRelRoleFuncByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrRelRoleFunc = $this->init_db()->get_one_by_field($arrField, 'sys_rel_role_func');
        return $this->_transferRelRoleFuncs(array($arrRelRoleFunc))[0];
    }

    /**
     * 强制类型转化多条 角色-功能关系表 数据
     * @author: nzw
     * @date: 2018-05-11
     * @param array $arrRoles 多条 角色-功能关系表 数组
     * @return array $arrRoles 强制类型转换过的 角色-功能关系表 数组
     */
    private function _transferRelRoleFuncs(array $arrRelRoleFuncs)
    {
        if (empty($arrRelRoleFuncs)) {
            return array();
        }

        foreach($arrRelRoleFuncs AS $iKey => $arrRelRoleFunc) {
            $arrRelRoleFuncs[$iKey]['role_id'] = (int) $arrRelRoleFunc['role_id'];
        }
        return $arrRelRoleFuncs;
    }

    /**
     * 通过上级权限id获取树形结构
     * @author: nzw
     * @date: 2018-05-11
     * @param int $iFucPid 上级权限id
     * @param int $iFuncOwner 权限归属 1-主机厂 2-4s店
     * @return: array
     */
    public function getTreeFuncsByPid(int $iFucPid, int $iFuncOwner)
    {
        //获取所有权限数组（不包括操作权限）
        $arrFuncs = $this->init_db()->get_all_by_field(array(
            'func_type' => array(SystemEnum::FUNC_TYPE_MENU, SystemEnum::FUNC_TYPE_VIEW),
            'func_owner' => $iFuncOwner,
        ), 'sys_func');
        if (empty($arrFuncs)) {
            return array();
        }
        $arrFuncs = $this->_transferFuncs($arrFuncs, true);

        //将所有功能一维数组组织成 func_id => arrSubFuncs(子权限) 的三维数组
        $arrId2SubFuncs = $this->_getId2SubFuncs($arrFuncs);

        //将视图权限组织成树形结构
        $arrFuncsTree = array();
        return $this->_originzeViewFuncsTrees($arrId2SubFuncs, $iFucPid, $arrFuncsTree);
    }

    /**
     * 通过用户编号获取用户权限树
     * @author: nzw
     * @date: 2018-05-09
     * @param: string $strUserCode 用户编号
     * @return: array
     */
    public function getUserFuncsTree(string $strUserCode)
    {
        //通过用户编号获取该用户所有角色id
        if ($strUserCode === '') {
            return array();
        }
        $arrUserRoleRels = $this->init_db()->get_all_by_field(array('user_code' => $strUserCode), 'sys_rel_user_role');
        if (empty($arrUserRoleRels)) {
            return array();
        }
        $arrRoleIds = array_column($arrUserRoleRels, 'role_id');
        if (empty($arrRoleIds)) {
            return array();
        }

        //通过角色id获取所有权限id
        $arrRoleFuncRels = $this->init_db()->get_all_by_field(array('role_id' => $arrRoleIds), 'sys_rel_role_func');
        if (empty($arrRoleFuncRels)) {
            return array();
        }

        //通过所有权限编号获取所有权限数组
        $arrFuncCodes = array_values(array_unique(array_column($arrRoleFuncRels, 'func_code')));
        $arrFuncs = $this->init_db()->get_all_by_field(array('func_code' => $arrFuncCodes), 'sys_func');
        if (empty($arrFuncs)) {
            return array();
        }
        $arrFuncs = $this->_transferFuncs($arrFuncs, true);
        
        //初始化最终结果数组
        $arrRes = array();
        //获取收藏夹菜单
        $arrRes['user_favorite_funcs'] = $this->_getPreferenceService()->getFavoriteMenu( $strUserCode, $arrFuncs );

        //将所有功能一维数组组织成 func_id => arrSubFuncs(子权限) 的三维数组
        $arrId2SubFuncs = $this->_getId2SubFuncs($arrFuncs);

        //将视图权限组织成树形结构
        $arrFuncsTree = array();//初始化树形结构结果数组
        $arrRes['tree'] = $this->_originzeViewFuncsTrees($arrId2SubFuncs, 0, $arrFuncsTree);

        //组织用于鉴权的结果数组
        foreach ($arrFuncs AS $iKey => $arrFunc) {
            if ($arrFunc['func_router'] !== '') {
                $arrRes['routers'][] = $arrFunc['func_router'];
            }
        }
        return $arrRes;
    }

    /**
     * 强制类型转化多条功能数据
     * @author: nzw
     * @date: 2018-05-09
     * @param: array $arrFuncs func_id => arrSubFuncs(子权限) 形式的三维数组
     * @param: bool $bDel 是否删除无用字段 默认为false不删 true删
     * @return: array $arrFuncs
     */
    private function _transferFuncs($arrFuncs, bool $bDel = false)
    {
        if (empty($arrFuncs)) {
            return array();
        }

        foreach($arrFuncs AS $iKey => $arrFunc) {
            $arrFuncs[$iKey]['func_id'] = (int) $arrFunc['func_id'];
            $arrFuncs[$iKey]['func_type'] = (int) $arrFunc['func_type'];
            $arrFuncs[$iKey]['func_parent'] = (int) $arrFunc['func_parent'];
            $arrFuncs[$iKey]['func_extra'] = ($arrFunc['func_extra'] === null ? '' : $arrFunc['func_extra']);

            if ($bDel) {
                unset($arrFuncs[$iKey]['func_remark'], $arrFuncs[$iKey]['func_extra']);
            }
        }
        return $arrFuncs;
    }

    /**
     * 将所有功能一维数组组织成 func_id => arrSubFuncs 的二维数组
     * @author: nzw
     * @date: 2018-05-09
     * @param array $arrFuncs
     * @return: array $arrId2SubFuncs
     */
    private function _getId2SubFuncs(array $arrFuncs)
    {
        if (empty($arrFuncs)) {
            return array();
        }

        foreach ($arrFuncs AS $arrFunc) {
            $arrId2SubFuncs[$arrFunc['func_parent']][] = $arrFunc;
        }
        return $arrId2SubFuncs;
    }

    /**
     * 递归将所有功能一维数组组织成树形结构
     * @author: nzw
     * @date: 2018-05-09
     * @param: array $arrId2Funcs 形式为 func_id => arrSubFuncs的三维数组
     * @return: array
     */
    private function _originzeViewFuncsTrees(array $arrId2SubFuncs, int $iTopId, &$arrRes)
    {
        if (!empty($arrId2SubFuncs[$iTopId])) {
            $arrRes['sub'] = $arrId2SubFuncs[$iTopId];
            foreach ($arrRes['sub'] AS $iKey => $arrSubFunc) {
                $this->_originzeViewFuncsTrees($arrId2SubFuncs, $arrSubFunc['func_id'], $arrRes['sub'][$iKey]);
            }
        } else {
            $arrRes['sub'] = array();
        }
        return $arrRes['sub'] ?? array();
    }

    /**
     * 为某个角色添加功能
     * 先删除该角色下的所有功能，再插入
     * @author: nzw
     * @date: 2018-05-12
     * @param int $iRoleId 角色id
     * @param array $arrFuncs 待添加的所有功能（包括菜单）
     * @return: array [iRes, strMsg] iRes:0成功 非0失败
     */
    public function addFuncsForRole(int $iRoleId, array $arrFuncs)
    {
        if ($iRoleId <= 0) {
            return parent::ret(Code::SYS_PARAM_ERROR, '角色id参数有误');
        }
        if (empty($arrFuncs)) {
            return parent::ret(Code::SYS_PARAM_ERROR, '功能数组参数有误');
        }

        //删除原角色所有功能
        $bDelRes = $this->init_db()->delete_by_field(array('role_id' => $iRoleId), 'sys_rel_role_func');
        if (!$bDelRes) {
            return parent::ret(Code::SYS_DELETE_ERROR, '角色删除失败');
        }

        //组织新插入的功能数据
        foreach ($arrFuncs AS $iKey => $arrFunc) {
            $arrFuncs[$iKey]['role_id'] = (int) $iRoleId;
            if ($arrFunc['func_configed_params'] === '') {
                $arrFuncs[$iKey]['func_configed_params'] = '';
            } else {
                $arrFuncs[$iKey]['func_configed_params'] = json_encode($arrFunc['func_configed_params'], JSON_UNESCAPED_UNICODE);
            }
        }

        //插入新增的所有功能
        $arrField = array_keys($arrFuncs[0]);
        $iInsertRes = $this->init_db()->insert_more($arrField, $arrFuncs, 'sys_rel_role_func');
        if (!$iInsertRes) {
            return parent::ret(Code::SYS_ADD_ERROR, '角色插入失败');
        }

        //通过user_code数组，删除该角色相关的所有用户的列表偏好设置和搜索偏好设置
        $arrRelUserRoles = $this->_getRoleService()->getRelUserRolesByField(array('role_id' => $iRoleId));
        if (!empty($arrRelUserRoles)) {
            $arrUserCodes = array_unique(array_column($arrRelUserRoles, 'user_code'));
            if (!empty($arrUserCodes)) {
                $arrDelRes = $this->_getPreferenceService()->deleteAllPreference($arrUserCodes);
                if ($arrDelRes[0] != Code::CODE_SUCCESS) {
                    return parent::ret($arrDelRes[0], $arrDelRes[1]);
                }
            }
        }

        return parent::ret(Code::CODE_SUCCESS);
    }

    /**
     * @return RoleService
     */
    private function _getRoleService()
    {
        return ChelerApi::getService('system\service\Role');
    }

    /**
     * @return PreferenceService
     */
    private function _getPreferenceService()
    {
        return ChelerApi::getService('common\service\Preference');
    }
}