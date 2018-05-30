<?php

namespace app\system\Controller;

use frame\ChelerApi;
use app\helper\BaseController;
use app\helper\Code;
use app\helper\enum\SystemEnum;
use app\system\service\JobService;
use app\common\service\TransactionService;

/**
 * 职务业务
 * @author nzw
 * @date: 2018-05-09
 */
class JobController extends BaseController
{
    /**
     * 职务列表
     * @author: nzw
     * @date: 2018-05-22
     * @return: void
     */
    public function Index()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //获取职务基本数据
        $arrJobs = $this->_getJobService()->getAllJobsByField(array('company_code' => $arrUser['company_code']));
        if (empty($arrJobs)) {
            $this->apiSuccess(array());
        }

        //获取职务职责数据
        $arrJobIds = array_values(array_column($arrJobs, 'job_id'));
        $arrRels = $this->_getJobService()->getAllRelsByField(array(
            'job_id' => $arrJobIds,
            'company_code' => $arrUser['company_code'],
        ));
        $arrJobId2DudyId = array();
        if (!empty($arrRels)) {
            foreach ($arrRels AS $arrRel) {
                $arrJobId2DudyId[$arrRel['job_id']][] = (int) $arrRel['duty_id'];
            }
        }
        foreach ($arrJobs AS $iKey => $arrJob) {
            $arrJobs[$iKey]['duty_ids'] = $arrJobId2DudyId[$arrJob['job_id']] ?? array();
        }
        $this->apiSuccess($arrJobs);
    }

    /**
     * 新增职务
     * @author: nzw
     * @date: 2018-05-19
     * @return: void
     */
    public function Add()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $strJobName = $this->controller->get_gp('job_name', 'P');
        parent::checkParam($strJobName, true, false, '职务名称', 45);
        $iJobStatus = $this->controller->get_gp('job_status', 'P');
        parent::isNumber($iJobStatus, true, true, '职务状态');
        if (!in_array($iJobStatus, array(SystemEnum::JOB_STATUS_NORMAL, SystemEnum::JOB_STATUS_FORBIDDEN))) {
            $this->apiError(Code::SYS_PARAM_ERROR, '职务状态参数错误');
        }
        $strJobDesc = $this->controller->get_gp('job_desc', 'P');
        if (isset($strJobDesc) && $strJobDesc !== '') {
            parent::checkParam($strJobDesc, true, false, '职务描述', 255);
        }
        $strDutyIds = $this->controller->get_gp('job_duty_ids', 'P');

        //同公司下职务名称唯一性校验（已作废的职务名可以复用）
        $arrJobTemp = $this->_getJobService()->getOneJobByField(array(
            'company_code' => $arrUser['company_code'],
            'job_name' => $strJobName,
            'job_status' => array(SystemEnum::JOB_STATUS_NORMAL, SystemEnum::JOB_STATUS_FORBIDDEN),
        ));
        if (!empty($arrJobTemp)) {
            $this->apiError(Code::SYS_PARAM_ERROR, '职务名称已存在');
        }

        //组织插入job表数据
        $iTimeNow = time();
        $arrDataJob = array();
        $arrDataJob['company_code'] = $arrUser['company_code'];
        $arrDataJob['job_name'] = $strJobName;
        $arrDataJob['job_desc'] = $strJobDesc ?? '';
        $arrDataJob['job_status'] = $iJobStatus;
        $arrDataJob['create_user'] = $arrUser['user_code'];
        $arrDataJob['create_time'] = $iTimeNow;

        $this->_getTransactionService()->start();

        //插入job表
        $iJobId = $this->_getJobService()->init_db()->insert($arrDataJob, 'sys_job');
        if ($iJobId <= 0) {
            $this->_getTransactionService()->rollback();
            $this->apiError(Code::SYS_ADD_ERROR, '职务新增失败（职务表插入失败）');
        }

        //插入rel_job_duty表
        if (isset($strDutyIds) && $strDutyIds !== '') {
            $arrDutyIds = explode(',', $strDutyIds);
            if (!empty($arrDutyIds)) {
                $arrRelJobDuties = array();
                foreach ($arrDutyIds AS $iKey => $strDutyId) {
                    $arrRelJobDuties[$iKey]['job_id'] = $iJobId;
                    $arrRelJobDuties[$iKey]['duty_id'] = $strDutyId;
                    $arrRelJobDuties[$iKey]['company_code'] = $arrUser['company_code'];
                }
                $iDutyRes = $this->_getJobService()->init_db()->insert_more(array('job_id', 'duty_id', 'company_code'),
                    $arrRelJobDuties, 'sys_rel_job_duty');
                if ($iDutyRes <= 0) {
                    $this->_getTransactionService()->rollback();
                    $this->apiError(Code::SYS_ADD_ERROR, '职务新增失败（职务-职责关系表插入失败）');
                }
            }
        }

        $this->_getTransactionService()->commit();
        $this->apiSuccess();
    }

    /**
     * 编辑职务
     * @author: nzw
     * @date: 2018-05-19
     * @return: void
     */
    public function Edit()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //必填项参数校验
        $iJobId = $this->controller->get_gp('job_id', 'P');
        parent::isNumber($iJobId, true, true, '职务id');
        $strJobName = $this->controller->get_gp('job_name', 'P');
        parent::checkParam($strJobName, true, false, '职务名称', 45);
        $iJobStatus = $this->controller->get_gp('job_status', 'P');
        parent::isNumber($iJobStatus, true, true, '职务状态');
        if (!in_array($iJobStatus, array(SystemEnum::JOB_STATUS_NORMAL,
            SystemEnum::JOB_STATUS_FORBIDDEN))) {
            $this->apiError(Code::SYS_PARAM_ERROR, '职务状态参数错误');
        }

        //非必填项参数校验
        $strJobDesc = $this->controller->get_gp('job_desc', 'P');
        if (isset($strJobDesc) && $strJobDesc !== '') {
            parent::checkParam($strJobDesc, true, false, '职务描述', 255);
        }
        $strDutyIds = $this->controller->get_gp('job_duty_ids', 'P');

        //职务存在性校验，状态校验
        $arrJob = $this->_getJobService()->getOneJobByField(array(
            'job_id' => $iJobId,
            'company_code' => $arrUser['company_code'],
            'job_status' => array(SystemEnum::JOB_STATUS_NORMAL, SystemEnum::JOB_STATUS_FORBIDDEN),
        ));
        if (empty($arrJob)) {
            $this->apiError(Code::SYS_EDIT_ERROR, '职务信息不存在');
        }

        //同公司下职务名称唯一性校验（已作废的职务名可以复用，判重时不包括自己）
        $strSqlTemp = "SELECT job_id FROM sys_job WHERE job_name='$strJobName' AND job_status!='" .
            SystemEnum::JOB_STATUS_INVALID . "' AND job_id!='$iJobId'";
        $arrJobTemp = $this->_getJobService()->getAllJobsBySql($strSqlTemp);
        if (!empty($arrJobTemp)) {
            $this->apiError(Code::SYS_PARAM_ERROR, '职务名称已存在');
        }

        //组织更新job表数据
        $iTimeNow = time();
        $arrDataJob = array();
        $arrDataJob['company_code'] = $arrUser['company_code'];
        $arrDataJob['job_name'] = $strJobName;
        $arrDataJob['job_desc'] = $strJobDesc ?? '';
        $arrDataJob['job_status'] = $iJobStatus;
        $arrDataJob['modify_user'] = $arrUser['user_code'];
        $arrDataJob['modify_time'] = $iTimeNow;

        $this->_getTransactionService()->start();

        //组织更新rel_job_duty表数据
        if (isset($strDutyIds) && $strDutyIds !== '') {
            $arrDutyIds = explode(',', $strDutyIds);
            if (!empty($arrDutyIds)) {
                $arrRelJobDuties = array();
                foreach ($arrDutyIds AS $iKey => $strDutyId) {
                    $arrRelJobDuties[$iKey]['job_id'] = $iJobId;
                    $arrRelJobDuties[$iKey]['duty_id'] = $strDutyId;
                    $arrRelJobDuties[$iKey]['company_code'] = $arrUser['company_code'];
                }

                //删除旧 职务-职位关系表 数据
                $bRelDelRes = $this->_getJobService()->init_db()->delete_by_field(array('job_id' => $iJobId),
                    'sys_rel_job_duty');
                if (!$bRelDelRes) {
                    $this->_getTransactionService()->rollback();
                    $this->apiError(Code::SYS_ADD_ERROR, '职务新增失败（职务-职位数据删除失败）');
                }

                //插入 职务-职责关系表
                $iDutyRes = $this->_getJobService()->init_db()->insert_more(array('job_id', 'duty_id', 'company_code'),
                    $arrRelJobDuties, 'sys_rel_job_duty');
                if ($iDutyRes <= 0) {
                    $this->_getTransactionService()->rollback();
                    $this->apiError(Code::SYS_ADD_ERROR, '职务新增失败（职务-职责关系表插入失败）');
                }
            }
        }

        //插入job表
        $arrFieldJob = array('job_id' => $iJobId);
        $iJobId = $this->_getJobService()->init_db()->update_by_field($arrDataJob, $arrFieldJob, 'sys_job');
        if ($iJobId <= 0) {
            $this->_getTransactionService()->rollback();
            $this->apiError(Code::SYS_ADD_ERROR, '职务新增失败');
        }

        $this->_getTransactionService()->commit();
        $this->apiSuccess();
    }

    /**
     * 获取职务详情（用于编辑操作）
     * @author: nzw
     * @date: 2018-05-21
     * @return: array
     */
    public function GetJobDetail()
    {
        //token校验
        $arrUser = $this->authorizeToken();

        //入参校验
        $iJobId = $this->controller->get_gp('job_id', 'P');
        parent::isNumber($iJobId, true, true, '职务id');

        //获取详情
        $arrFieldJob = array(
            'job_id' => $iJobId,
            'company_code' => $arrUser['company_code'],
            'job_status' => array(SystemEnum::JOB_STATUS_NORMAL, SystemEnum::JOB_STATUS_FORBIDDEN)
        );
//        if ($arrUser['is_super'] != SystemEnum::USER_IS_SUPER_YES) {
//            unset($arrFieldJob['company_code']);
//        }
        $arrJob = $this->_getJobService()->getOneJobByField($arrFieldJob);
        if (empty($arrJob)) {
            $this->apiSuccess($arrJob);
        }

        //获取所有职务对应的职位id
        $arrFieldRel = array(
            'job_id' => $iJobId,
            'company_code' => $arrUser['company_code'],
        );
//        if ($arrUser['is_super'] != SystemEnum::USER_IS_SUPER_YES) {
//            unset($arrFieldRel['company_code']);
//        }
        $arrRels = $this->_getJobService()->getAllRelsByField($arrFieldRel);
        $arrJob['job_duties'] = $arrRels ?? array();
//        if (!empty($arrRels)) {
//            foreach ($arrRels AS $arrRel) {
//                $arrJob['duty_ids'][] = $arrRel['duty_id'];
//            }
//        }
        $this->apiSuccess($arrJob);
    }

    /**
     * 启用职务
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
        $iJobId = $this->controller->get_gp('job_id', 'P');
        parent::isNumber($iJobId, true, true, '职务ID');

        //具体操作
        $arrRes = $this->_getJobService()->resetJobStatus($iJobId, $arrUser['company_code'],
            SystemEnum::JOB_STATUS_NORMAL, $arrUser['user_code']);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->apiSuccess();
    }

    /**
     * 停用职务
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
        $iJobId = $this->controller->get_gp('job_id', 'P');
        parent::isNumber($iJobId, true, true, '职务ID');

        //具体操作
        $arrRes = $this->_getJobService()->resetJobStatus($iJobId, $arrUser['company_code'],
            SystemEnum::JOB_STATUS_FORBIDDEN, $arrUser['user_code']);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->apiSuccess();
    }

    /**
     * 作废职务（即删除按钮）
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
        $iJobId = $this->controller->get_gp('job_id', 'P');
        parent::isNumber($iJobId, true, true, '职务ID');

        //具体操作
        $arrRes = $this->_getJobService()->resetJobStatus($iJobId, $arrUser['company_code'],
            SystemEnum::JOB_STATUS_INVALID, $arrUser['user_code']);
        if ($arrRes['code'] != Code::CODE_SUCCESS) {
            $this->apiError($arrRes['code'], $arrRes['msg']);
        }
        $this->apiSuccess();
    }

    /**
     * 获取职务相关下拉菜单列表
     * @author: nzw
     * @date: 2018-05-21
     * @return: array
     */
    public function JobsList()
    {
        //鉴权
        $arrUser = $this->authorizeToken();

        //具体操作
        $arrJobs = $this->_getJobService()->getAllJobsByField(array(
            'company_code' => $arrUser['company_code'],
            'job_status' => SystemEnum::JOB_STATUS_NORMAL,
        ));
        $this->apiSuccess($arrJobs);
    }

    /**
     * 获取职位相关下拉菜单列表
     * @author: nzw
     * @date: 2018-05-21
     * @return: array
     */
    public function DutiesList()
    {
        //鉴权
        $arrUser = $this->authorizeToken();

        //具体操作
        $arrDuties = $this->_getJobService()->getAllDutiesBySql('SELECT * FROM `sys_job_duty`');
        $this->apiSuccess($arrDuties);
    }

    /**
     * @return JobService
     */
    public function _getJobService()
    {
        return ChelerApi::getService('system\service\Job');
    }

    /**
     * @return TransactionService
     */
    public function _getTransactionService()
    {
        return ChelerApi::getService('common\service\Transaction');
    }
}