<?php
namespace app\system\service;

use app\helper\Code;
use frame\ChelerApi;
use app\helper\BaseService;
use app\helper\enum\SystemEnum;

/**
 * 角色service
 * @package app\system\service
 */
class RoleService extends BaseService
{
    /**
     * 通过条件获取单个角色信息
     * @author: nzw
     * @date: 2018-05-09
     * @param: array $arrField
     * @return: array
     */
    public function getOneRoleByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrRole = $this->init_db()->get_one_by_field($arrField, 'sys_role');
        if (empty($arrRole)) {
            return array();
        }
        return $this->_transferRoles(array($arrRole))[0];
    }

    /**
     * 通过sql获取角色
     * @author: nzw
     * @date: 2018-05-18
     * @param string $strSql
     * @return: array
     */
    public function getAllRolesBySql(string $strSql)
    {
        if ($strSql === '') {
            return array();
        }

        $arrRoles = $this->init_db()->get_all_sql($strSql);
        return $this->_transferRoles($arrRoles);
    }

    /**
     * 通过条件获取多个角色信息
     * @author: nzw
     * @date: 2018-05-09
     * @param: array $arrField
     * @return: array
     */
    public function getAllRolesByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }
        $arrRoles = $this->init_db()->get_all_by_field($arrField, 'sys_role');
        return $this->_transferRoles($arrRoles);
    }

    /**
     * 更新角色信息
     * @author: nzw
     * @date: 2018-05-18
     * @param: array $arrData
     * @param: array $arrField
     * @return: int
     */
    public function updateRole(array $arrData, array $arrField)
    {
        if (empty($arrData)) {
            return 0;
        }
        return $this->init_db()->update_by_field($arrData, $arrField, 'sys_user');
    }

    /**
     * 通过user_code，获取某个用户的所有正常状态角色信息
     * @author: nzw
     * @date: 2018-05-09
     * @param: string $strUserCode
     * @return: void
     */
    public function getRolesByUserCode(string $strUserCode)
    {
        if ($strUserCode === '') {
            return array();
        }

        $arrUserRoleRels = $this->init_db()->get_all_by_field(array('user_code' => $strUserCode),
            'sys_rel_user_role');
        if (empty($arrUserRoleRels)) {
            return array();
        }

        $arrRoleIds = array_unique(array_column($arrUserRoleRels, 'role_id'));
        $arrRoles = $this->init_db()->get_all_by_field(array('role_id' => $arrRoleIds,
            'role_status' => SystemEnum::ROLE_STATUS_NORMAL), 'sys_role');
        if (empty($arrRoles)) {
            return array();
        }
        return self::_transferRoles($arrRoles);
    }

    /**
     * 通过条件获取所有 用户-角色关系表 数据
     * @author: nzw
     * @date: 2018-05-11
     * @param array $arrField
     * @return: array
     */
    public function getRelUserRolesByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrRelUserRoles = $this->init_db()->get_all_by_field($arrField, 'sys_rel_user_role');
        return $this->_transferRelUserRoles($arrRelUserRoles);
    }

    /**
     * 插入单条 用户-角色关系表 数据
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrData
     * @return: int
     */
    public function insertRelUserRole(array $arrData)
    {
        if (empty($arrData)) {
            return 0;
        }
        return $this->init_db()->insert($arrData, 'sys_rel_user_role');
    }

    /**
     * 插入单条 用户-角色关系表 数据
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrField 字段名数组
     * @param array $arrData 数据
     * @return: int
     */
    public function insertMoreRelUserRoles(array $arrField, array $arrData)
    {
        if (empty($arrField) || empty($arrData)) {
            return 0;
        }
        return $this->init_db()->insert_more($arrField, $arrData, 'sys_rel_user_role');
    }

    /**
     * 删除 用户-角色关系表 数据
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrField 字段名数组
     * @return: bool
     */
    public function deleteRelUserRole(array $arrField)
    {
        if (empty($arrField)) {
            return false;
        }
        return $this->init_db()->delete_by_field($arrField, 'sys_rel_user_role');
    }

    /**
     * 强制类型转化多条角色数据
     * @author: nzw
     * @date: 2018-05-09
     * @param array $arrRoles 多条用户角色数组
     * @return array $arrRoles 强制类型转换过的角色数组
     */
    private function _transferRoles(array $arrRoles)
    {
        if (empty($arrRoles)) {
            return array();
        }

        foreach($arrRoles AS $iKey => $arrRole) {
            $arrRoles[$iKey]['role_id'] = (int) $arrRole['role_id'];
            $arrRoles[$iKey]['create_time'] = (int) $arrRole['create_time'];
            $arrRoles[$iKey]['modify_time'] = (int) $arrRole['modify_time'];
        }
        return $arrRoles;
    }

    /**
     * 强制类型转化多条 用户-角色关系表 数据
     * @author: nzw
     * @date: 2018-05-09
     * @param array $arrRoles 多条用户角色数组
     * @return array $arrRoles 强制类型转换过的 用户-角色关系表 数据
     */
    private function _transferRelUserRoles(array $arrRelUserRoles)
    {
        if (empty($arrRelUserRoles)) {
            return array();
        }

        foreach($arrRelUserRoles AS $iKey => $arrRelUserRole) {
            $arrRelUserRoles[$iKey]['role_id'] = (int) $arrRelUserRole['role_id'];
        }
        return $arrRelUserRoles;
    }

    /**
     * 改变角色状态
     * @author: nzw
     * @date: 2018-05-12
     * @param int $iRoleId 角色id
     * @param string $strCompanyCode 公司账套
     * @param int $iRoleStatus 待变更的状态
     * @param string $strUserCode 操作者用户编号
     * @return: array code：0成功 非0失败
     */
    public function resetRoleStatus(int $iRoleId, string $strCompanyCode, int $iRoleStatus, string $strUserCode)
    {
        //查询角色
        $arrRole = self::getOneRoleByField(array(
            'role_id' => $iRoleId,
            'company_code' => $strCompanyCode,
            'role_status' => array(SystemEnum::ROLE_STATUS_NORMAL, SystemEnum::ROLE_STATUS_FORBIDDEN),
        ));
        if (empty($arrRole)) {
            return parent::ret(Code::SYS_EDIT_ERROR, '角色信息不存在');
        }

        //根据待变更的状态，决定执行什么操作
        if ($iRoleStatus == SystemEnum::ROLE_STATUS_NORMAL) {//启用操作
            //当前状态已是启用，则直接返回成功
            if ($arrRole['role_status'] == SystemEnum::ROLE_STATUS_NORMAL) {
                return parent::ret(Code::CODE_SUCCESS);
            }
        } else {//停用和删除操作
            //判断当前是否有人在使用该角色
            $iCanChange = $this->_checkCanChangeRoleStatus($iRoleId);
            if ($iCanChange == 0) {
                return parent::ret(Code::SYS_EDIT_ERROR, '角色中包含有效客户，无法停用或删除');
            }
        }

        //执行更新操作
        $arrData = array(
            'role_status' => $iRoleStatus,
            'modify_user' => $strUserCode,
            'modify_time' => time(),
        );
        $arrField = array('role_id' => $iRoleId);
        $iRes = $this->init_db()->update_by_field($arrData, $arrField, 'sys_role');
        if ($iRes == 0) {
            return parent::ret(Code::SYS_EDIT_ERROR, '数据库操作失败');
        }
        return parent::ret(Code::CODE_SUCCESS);
    }

    /**
     * 检查是否具备变更角色状态的条件
     * @author: nzw
     * @date: 2018-05-12
     * @return: int 0不具备 1具备
     */
    private function _checkCanChangeRoleStatus(int $iRoleId)
    {
        //判断当前是否有人在使用该角色
        $arrRelUserRoles = $this->getRelUserRolesByField(array('role_id' => $iRoleId));
        if (!empty($arrRelUserRoles)) {
            $arrUserCodes = array_column($arrRelUserRoles, 'user_code');

            //判断使用该角色的人中，如果还有正常或停用状态的用户，则不能作废该角色；若都是已作废的用户，则可以作废该角色
            $arrUsers = $this->_getUserService()->getAllUserByField(array('user_code' => $arrUserCodes,
                'user_status' => array(SystemEnum::USER_STATUS_NORMAL, SystemEnum::USER_STATUS_FORBIDDEN)));
            if (!empty($arrUsers)) {
                return 0;
            }
        }

        return 1;
    }

    /**
     * @return UserService
     */
    private function _getUserService()
    {
        return ChelerApi::getService('system\service\User');
    }
}