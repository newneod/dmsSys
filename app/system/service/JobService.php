<?php
namespace app\system\service;

use frame\ChelerApi;
use app\helper\Code;
use app\helper\BaseService;
use app\helper\enum\SystemEnum;

/**
 * 职务service
 * @package app\system\service
 */
class JobService extends BaseService
{
    /**
     * 通过条件获取单个职务信息
     * @author: nzw
     * @date: 2018-05-18
     * @param: array $arrField
     * @return: array
     */
    public function getOneJobByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrJob = $this->init_db()->get_one_by_field($arrField, 'sys_job');
        if (empty($arrJob)) {
            return array();
        }
        return $this->_transferJobs(array($arrJob))[0];
    }

    /**
     * 通过sql获取职务
     * @author: nzw
     * @date: 2018-05-18
     * @param string $strSql
     * @return: array
     */
    public function getAllJobsBySql(string $strSql)
    {
        if ($strSql === '') {
            return array();
        }

        $arrJobs = $this->init_db()->get_all_sql($strSql);
        return $this->_transferJobs($arrJobs);
    }

    /**
     * 通过条件获取多个职务信息
     * @author: nzw
     * @date: 2018-05-18
     * @param: array $arrField
     * @return: array
     */
    public function getAllJobsByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }
        $arrJobs = $this->init_db()->get_all_by_field($arrField, 'sys_job');
        return $this->_transferJobs($arrJobs);
    }

    /**
     * 改变职务状态
     * @author: nzw
     * @date: 2018-05-12
     * @param int $iJobId 职务id
     * @param string $strCompanyCode 公司账套
     * @param int $iJobStatus 待变更的状态
     * @param string $strUserCode 操作者用户编号
     * @return: array code：0成功 非0失败
     */
    public function resetJobStatus(int $iJobId, string $strCompanyCode, int $iJobStatus, string $strUserCode)
    {
        //查询职务
        $arrJob = self::getOneJobByField(array(
            'job_id' => $iJobId,
            'company_code' => $strCompanyCode,
            'job_status' => array(SystemEnum::JOB_STATUS_NORMAL, SystemEnum::JOB_STATUS_FORBIDDEN),
        ));
        if (empty($arrJob)) {
            return parent::ret(Code::SYS_EDIT_ERROR, '职务信息不存在');
        }

        //根据待变更的状态，决定执行什么操作
        if ($iJobStatus == SystemEnum::JOB_STATUS_NORMAL) {//启用操作
            //当前状态已是启用，则直接返回成功
            if ($arrJob['job_status'] == SystemEnum::JOB_STATUS_NORMAL) {
                return parent::ret(Code::CODE_SUCCESS);
            }
        } else {//停用和删除操作
            //判断当前是否有人在使用该职务
            $iCanChange = $this->_checkCanChangeJobStatus($iJobId);
            if ($iCanChange == 0) {
                return parent::ret(Code::SYS_EDIT_ERROR, '职务中包含有效客户，无法停用或删除');
            }
        }

        //执行更新操作
        $arrData = array(
            'job_status' => $iJobStatus,
            'modify_user' => $strUserCode,
            'modify_time' => time(),
        );
        $arrField = array('job_id' => $iJobId);
        $iRes = $this->init_db()->update_by_field($arrData, $arrField, 'sys_job');
        if ($iRes == 0) {
            return parent::ret(Code::SYS_EDIT_ERROR, '数据库操作失败');
        }
        return parent::ret(Code::CODE_SUCCESS);
    }

    /**
     * 检查是否具备变更职务状态的条件
     * @author: nzw
     * @date: 2018-05-12
     * @return: int 0不具备 1具备
     */
    private function _checkCanChangeJobStatus(int $iJobId)
    {
        //判断当前是否有人在使用该职务，并且状态是正常或停用的用户（如果有则不能变更对应职务信息）
        $arrUsers = $this->_getUserService(array(
            'user_job_id' => $iJobId,
            'user_status' => array(SystemEnum::USER_STATUS_NORMAL, SystemEnum::USER_STATUS_FORBIDDEN),
        ));
        if (!empty($arrUsers)) {
            return 0;
        }
        return 1;
    }

    /**
     * 通过条件获取所有 职务-职位关系表 数据
     * @author: nzw
     * @date: 2018-05-20
     * @param array $arrField
     * @return: array
     */
    public function getRelJobDutyByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrRelUserRoles = $this->init_db()->get_all_by_field($arrField, 'sys_rel_job_duty');
        return $this->_transferRelJobDuties($arrRelUserRoles);
    }

    /**
     * 通过公司编号获取所有职务信息
     * @author: nzw
     * @date: 2018-05-09
     * @param: string $strCompanyCode
     * @return: array
     */
    public function getJobsByCompanyCode(string $strCompanyCode)
    {
        if ($strCompanyCode === '') {
            return array();
        }

        //获取该公司下所有职务-职责关系数据
        $arrJobDutyRels = $this->init_db()->get_all_by_field(array('company_code' => $strCompanyCode), 'sys_rel_job_duty');
        if (empty($arrJobDutyRels)) {
            return array();
        }

        //将关系数据组织成 job_id => arrDutyIds 的形式
        $arrJobId2DutyIds = array();
        foreach ($arrJobDutyRels AS $arrJobDutyRel) {
            $arrJobId2DutyIds[$arrJobDutyRel['job_id']][] = (int) $arrJobDutyRel['duty_id'];
        }

        //获取该公司下所有职务信息
        $arrJobIds = array_column($arrJobDutyRels, 'job_id');
        $arrJobs = $this->init_db()->get_all_by_field(array('job_id' => $arrJobIds), 'sys_job');
        if (empty($arrJobs)) {
            return array();
        }
        $arrJobs = $this->_transferJobs($arrJobs);

        //获取全部涉及的职责信息
        $arrDutyIds = array_column($arrJobDutyRels, 'duty_id');
        $arrDuties = $this->init_db()->get_all_by_field(array('duty_id' => $arrDutyIds), 'sys_job_duty');
        if (empty($arrDuties)) {
            return array();
        }
        $arrDuties = $this->_transferDuties($arrDuties);

        //将职责数据组织成 duty_id => arrDuty 的形式
        $arrId2Duty = $this->_originzeId2Duty($arrDuties);

        //将职责信息放到职务中，组织成最终结果数组
        foreach ($arrJobs AS $iKey => $arrJob) {
            if (!empty($arrJobId2DutyIds[$arrJob['job_id']])) {
                foreach ($arrJobId2DutyIds[$arrJob['job_id']] AS $iDutyId) {
                    if (!empty($arrId2Duty[$iDutyId])) {
                        $arrJobs[$iKey]['duties'][] = $arrId2Duty[$iDutyId];
                    }
                }
            }
        }

        return $arrJobs;
    }

    /**
     * 将职责数组组织成 id => arrDuties 形式
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrDuties
     * @return: array
     */
    private function _originzeId2Duty(array $arrDuties)
    {
        if (empty($arrDuties)) {
            return array();
        }

        $arrRes = array();
        foreach ($arrDuties AS $arrDuty) {
            if (empty($arrDuty)) {
                continue;
            }
            $arrRes[$arrDuty['duty_id']] = $arrDuty;
        }
        return $arrRes;
    }

    /**
     * 强制类型转化多条职务数据
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrJobs 多条职务数据数组
     * @return array $arrJobs 强制类型转换过的职务数据数组
     */
    private function _transferJobs(array $arrJobs)
    {
        if (empty($arrJobs)) {
            return array();
        }

        foreach($arrJobs AS $iKey => $arrJob) {
            $arrJobs[$iKey]['job_id'] = (int) $arrJob['job_id'];
            $arrJobs[$iKey]['job_status'] = (int) $arrJob['job_status'];
            $arrJobs[$iKey]['create_time'] = (int) $arrJob['create_time'];
            $arrJobs[$iKey]['modify_time'] = (int) $arrJob['modify_time'];
        }
        return $arrJobs;
    }

    /**
     * 通过条件获取单个职位信息
     * @author: nzw
     * @date: 2018-05-18
     * @param: array $arrField
     * @return: array
     */
    public function getOneDutyByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrDuty = $this->init_db()->get_one_by_field($arrField, 'sys_job_duty');
        if (empty($arrDuty)) {
            return array();
        }
        return $this->_transferDuties(array($arrDuty))[0];
    }

    /**
     * 通过sql获取职位
     * @author: nzw
     * @date: 2018-05-18
     * @param string $strSql
     * @return: array
     */
    public function getAllDutiesBySql(string $strSql)
    {
        if ($strSql === '') {
            return array();
        }

        $arrDuties = $this->init_db()->get_all_sql($strSql);
        return $this->_transferDuties($arrDuties);
    }

    /**
     * 通过条件获取多个职位信息
     * @author: nzw
     * @date: 2018-05-18
     * @param: array $arrField
     * @return: array
     */
    public function getAllDutiesByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }
        $arrDuties = $this->init_db()->get_all_by_field($arrField, 'sys_job_duty');
        return $this->_transferDuties($arrDuties);
    }

    /**
     * 强制类型转化多条职责数据
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrDuties 多条职责数据数组
     * @return array $arrDuties 强制类型转换过的职责数据数组
     */
    private function _transferDuties(array $arrDuties)
    {
        if (empty($arrDuties)) {
            return array();
        }

        foreach($arrDuties AS $iKey => $arrDuty) {
            $arrDuties[$iKey]['duty_id'] = (int) $arrDuty['duty_id'];
        }
        return $arrDuties;
    }

    /**
     * 通过条件获取单个 职务-职位关系表 信息
     * @author: nzw
     * @date: 2018-05-18
     * @param: array $arrField
     * @return: array
     */
    public function getOneRelByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrRel = $this->init_db()->get_one_by_field($arrField, 'sys_rel_job_duty');
        if (empty($arrRel)) {
            return array();
        }
        return $this->_transferRelJobDuties(array($arrRel))[0];
    }

    /**
     * 通过sql获取 职务-职位关系表 数据
     * @author: nzw
     * @date: 2018-05-18
     * @param string $strSql
     * @return: array
     */
    public function getAllRelsBySql(string $strSql)
    {
        if ($strSql === '') {
            return array();
        }

        $arrRels = $this->init_db()->get_all_sql($strSql);
        return $this->_transferRelJobDuties($arrRels);
    }

    /**
     * 通过条件获取多个 职务-职位关系表 信息
     * @author: nzw
     * @date: 2018-05-18
     * @param: array $arrField
     * @return: array
     */
    public function getAllRelsByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }
        $arrRels = $this->init_db()->get_all_by_field($arrField, 'sys_rel_job_duty');
        return $this->_transferRelJobDuties($arrRels);
    }

    /**
     * 强制类型转化多条 职务-职责关系表 数据
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrRelJobDuties 多条 职务-职责关系表 数据数组
     * @return array $arrRelJobDuties 强制类型转换过的 职务-职责关系表 数据数组
     */
    private function _transferRelJobDuties(array $arrRelJobDuties)
    {
        if (empty($arrRelJobDuties)) {
            return array();
        }

        foreach($arrRelJobDuties AS $iKey => $arrRelJobDuty) {
            $arrRelJobDuties[$iKey]['job_id'] = (int) $arrRelJobDuty['job_id'];
            $arrRelJobDuties[$iKey]['duty_id'] = (int) $arrRelJobDuty['duty_id'];
        }
        return $arrRelJobDuties;
    }

    /**
     * @return UserService
     */
    private function _getUserService()
    {
        return ChelerApi::getService('system\service\User');
    }
}