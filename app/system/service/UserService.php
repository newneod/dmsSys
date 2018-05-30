<?php
namespace app\system\service;

use app\helper\BaseService;
use app\helper\Code;
use app\helper\enum\SystemEnum;

/**
 * 用户service
 * @package app\system\service
 */
class UserService extends BaseService
{
    /**
     * 通过条件获取单个用户信息
     * @author: nzw
     * @date: 2018-05-09
     * @param: array $arrField
     * @return: array
     */
    public function getOneUserByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrUser = $this->init_db()->get_one_by_field($arrField, 'sys_user');
        if (empty($arrUser)) {
            return array();
        }
        return $this->_transferUsers(array($arrUser))[0];
    }

    /**
     * 通过条件获取所有用户信息
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:18:12
     * @return array
     */
    public function getAllUserByField( array $field, $line = "*", $sort="user_id ASC" ):array
    {
        if ( empty($field) ) {
            return [];
        }
        $where = $this->init_db()->makeWhere($field);
        $sql = \sprintf('SELECT %s FROM %s %s ORDER BY %s', $line, 'sys_user', $where, $sort);
        $result = $this->init_db()->query($sql, false);
        if (!$result) {
            return [];
        }
        $temp = array();
        while ($row = $this->init_db()->fetch_assoc($result)) {
            $temp[] = $row;
        }
        return $temp;
    }

    /**
     * 改变用户状态
     * @author: nzw
     * @date: 2018-05-12
     * @param string $strUserCode 用户编号
     * @param string $strCompanyCode 公司账套
     * @param int $iUserStatus 待变更的状态
     * @param string $strOperatorCode 操作者用户编号
     * @return: array code：0成功 非0失败
     */
    public function resetUserStatus(string $strUserCode, string $strCompanyCode, int $iUserStatus, string $strOperatorCode)
    {
        //用户存在性校验
        $arrUser = self::getOneUserByField(array(
            'user_code' => $strUserCode,
            'def_company_code' => $strCompanyCode,
            'user_status' => array(SystemEnum::USER_STATUS_NORMAL, SystemEnum::USER_STATUS_FORBIDDEN),
        ));
        if (empty($arrUser)) {
            return parent::ret(Code::SYS_EDIT_ERROR, '用户信息不存在');
        }

        //根据待变更的状态，决定执行什么操作
        if ($iUserStatus == SystemEnum::USER_STATUS_NORMAL) {//启用操作
            //当前状态已是启用，则直接返回成功
            if ($arrUser['user_status'] == SystemEnum::USER_STATUS_NORMAL) {
                return parent::ret(Code::CODE_SUCCESS);
            }
        }

        //执行更新操作
        $arrData = array(
            'user_status' => $iUserStatus,
            'modify_user' => $strOperatorCode,
            'modify_time' => time(),
        );
        $arrField = array('user_code' => $strUserCode, 'def_company_code' => $strCompanyCode);
        $iRes = $this->init_db()->update_by_field($arrData, $arrField, 'sys_user');
        if ($iRes == 0) {
            return parent::ret(Code::SYS_EDIT_ERROR, '数据库操作失败');
        }
        return parent::ret(Code::CODE_SUCCESS);
    }

    /**
     * 插入单条用户数据
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrData
     * @return: int
     */
    public function insertUser(array $arrData)
    {
        if (empty($arrData)) {
            return 0;
        }
        return $this->init_db()->insert($arrData, 'sys_user');
    }

    /**
     * 更新单条用户数据
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrData
     * @param array $arrField
     * @return: int
     */
    public function updateUser(array $arrData, array $arrField)
    {
        if (empty($arrData)) {
            return 0;
        }
        return $this->init_db()->update_by_field($arrData, $arrField, 'sys_user');
    }

    /**
     * 强制类型转化多条用户数据
     * @author: nzw
     * @date: 2018-05-09
     * @param array $arrUsers 多条用户数据数组
     * @return array $arrUsers 强制类型转换过的用户数据数组
     */
    private function _transferUsers(array $arrUsers)
    {
        if (empty($arrUsers)) {
            return array();
        }

        foreach($arrUsers AS $iKey => $arrUser) {
            $arrUsers[$iKey]['user_id'] = (int) $arrUser['user_id'];
            $arrUsers[$iKey]['user_status'] = (int) $arrUser['user_status'];
            $arrUsers[$iKey]['user_job_id'] = (int) $arrUser['user_job_id'];
            $arrUsers[$iKey]['user_org_id'] = (int) $arrUser['user_org_id'];
            $arrUsers[$iKey]['user_gender'] = (int) $arrUser['user_gender'];
            $arrUsers[$iKey]['user_last_time'] = (int) $arrUser['user_last_time'];
            $arrUsers[$iKey]['is_super'] = (int) $arrUser['is_super'];
            $arrUsers[$iKey]['create_time'] = (int) $arrUser['create_time'];
            $arrUsers[$iKey]['modify_user'] = $arrUser['modify_user'] ?? '';
        }
        return $arrUsers;
    }
}