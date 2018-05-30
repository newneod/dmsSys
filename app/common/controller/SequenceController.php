<?php
namespace app\common\controller;

use app\common\service\SequenceService;
use app\common\service\TransactionService;
use app\helper\BaseController;
use app\helper\Code;
use app\helper\enum\CommonEnum;
use frame\ChelerApi;

/**
 * 单据号类
 * User: nzw
 * Date: 2018/5/12
 */
class SequenceController extends BaseController
{
    public function TestGenerate()
    {
        $a = $this->_getSequenceService()->generate(1, 'nzw');
        var_dump($a);exit;
    }

    public function TestAddType()
    {
        $a = $this->_getSequenceService()->addSeqType('1', 'nzw1111111', 'comm_remittance', 'dealer_remittance');
        var_dump($a);exit;
    }

    /**
     * 新增单据号规则（默认为停用状态）
     * @author: nzw
     * @date: 2018-05-12
     * @return: void
     */
    public function Add()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $arrParams = $this->_checkSeqRuleParams();

        //组织剩余参数
        $arrParams['company_code'] = $arrUser['company_code'];
        $arrParams['seq_rule_next'] = $arrParams['seq_rule_min'];
        $arrParams['create_user'] = $arrUser['user_code'];
        $arrParams['create_time'] = time();
        $arrParams['seq_rule_status'] = CommonEnum::SEQ_RULE_STATUS_FORBIDDEN;//新增的规则默认为禁用状态

        //名称唯一性校验
        $arrRuleTemp = $this->_getSequenceService()->getOneSeqRuleByField(array(
            'company_code' => $arrUser['company_code'], 'seq_rule_name' => $arrParams['seq_rule_name']));
        if (!empty($arrRuleTemp)) {
            $this->apiError(Code::COMM_ADD_ERROR, '序号规则名称重复');
        }

        //内容唯一性校验
        $arrRuleTemp = $this->_getSequenceService()->getOneSeqRuleByField(array(
            'company_code' => $arrUser['company_code'],
            'seq_rule_type' => $arrParams['seq_rule_type'],
            'seq_rule_prefix' => $arrParams['seq_rule_prefix']));
        if (!empty($arrRuleTemp)) {
            $this->apiError(Code::COMM_ADD_ERROR, '序号规则内容重复');
        }

        //数据入库
        $iRes = $this->_getSequenceService()->insertSeqRule($arrParams);
        if ($iRes == 0) {
            $this->apiError(Code::COMM_ADD_ERROR, '序号规则新增失败');
        }
        $this->apiSuccess();
    }

    /**
     * 编辑单据号规则
     * 只能编辑停用状态的规则
     * @author: nzw
     * @date: 2018-05-12
     * @return: void
     */
    public function Edit()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $arrParams = $this->_checkSeqRuleParams();
        $iRuleId = $this->controller->get_gp('seq_rule_id');
        parent::isNumber($iRuleId, true, true, '单据号规则id');

        //原数据存在性与状态正确性校验
        $arrRule = $this->_getSequenceService()->getOneSeqRuleByField(array(
            'seq_rule_id' => $iRuleId,
            'seq_rule_status' => array(CommonEnum::SEQ_RULE_STATUS_NORMAL, CommonEnum::SEQ_RULE_STATUS_FORBIDDEN),
            'company_code' => $arrUser['company_code'],
        ));
        if (empty($arrRule)) {
            $this->apiError(Code::COMM_EDIT_ERROR, '原序号规则不存在');
        }
        if ($arrRule['seq_rule_status'] == CommonEnum::SEQ_RULE_STATUS_NORMAL) {
            $this->apiError(Code::COMM_EDIT_ERROR, '原序号规则已在使用，不能编辑');
        }

        //如果新设置的序号最小值比数据库中的下一个序号值大，则将数据库中的下一个序号值设置为新的最小值
        if ($arrRule['seq_rule_next'] < $arrParams['seq_rule_min']) {
            $arrParams['seq_rule_next'] = $arrParams['seq_rule_min'];
        }

        //组织剩余参数
        $arrParams['modify_user'] = $arrUser['user_code'];
        $arrParams['modify_time'] = time();

        //名称唯一性校验
        $strSql = "SELECT COUNT(*) AS count FROM `sys_seq_rule` WHERE company_code='" . $arrUser['company_code'] .
            "' AND `seq_rule_name`='" . $arrParams['seq_rule_name'] .
            "' AND `seq_rule_id`!='" . $iRuleId . "'";
        $arrRuleTemp = $this->_getSequenceService()->getAllSeqRulesBySql($strSql);
        if ($arrRuleTemp[0]['count'] != '0') {
            $this->apiError(Code::COMM_ADD_ERROR, '序号规则名称重复');
        }

        //内容唯一性校验
        $strSql = "SELECT COUNT(*) AS count FROM `sys_seq_rule` WHERE `company_code`='" . $arrUser['company_code'] .
            "' AND `seq_rule_type`='" . $arrParams['seq_rule_type'] .
            "' AND `seq_rule_prefix`='" . $arrParams['seq_rule_prefix'] .
            "' AND `seq_rule_id`!='" . $iRuleId . "'";
        if ($arrRuleTemp[0]['count'] != '0') {
            $this->apiError(Code::COMM_ADD_ERROR, '序号规则内容重复');
        }

        //数据更新
        $arrField = array('seq_rule_id' => $iRuleId);
        $iRes = $this->_getSequenceService()->updateSeqRule($arrParams, $arrField);
        if ($iRes == 0) {
            $this->apiError(Code::COMM_ADD_ERROR, '序号规则更新失败');
        }
        $this->apiSuccess();
    }

    /**
     * 单据号规则状态激活
     * 即将单据号规则状态由“停用”变为“正常”
     * 状态变为“正常”后才可以绑定类型并使用
     * @author: nzw
     * @date: 2018-05-15
     * @return: void
     */
    public function Activate()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRuleId = $this->controller->get_gp('seq_rule_id');
        parent::isNumber($iRuleId, true, true, '单据号规则id');

        //获取数据
        $arrRule = $this->_getSequenceService()->getOneSeqRuleByField(array(
            'seq_rule_id' => $iRuleId,
            'company_code' => $arrUser['company_code']));
        if (empty($arrRule)) {
            $this->apiError(Code::COMM_EDIT_ERROR, '序号规则不存在');
        }
        if ($arrRule['seq_rule_status'] != CommonEnum::SEQ_RULE_STATUS_FORBIDDEN) {
            $this->apiError(Code::COMM_EDIT_ERROR, '序号规则已在使用或已作废，无法激活');
        }

        //组织激活数据
        $arrParams = array();
        $arrParams['seq_rule_status'] = CommonEnum::SEQ_RULE_STATUS_NORMAL;
        $arrParams['modify_user'] = $arrUser['user_code'];
        $arrParams['modify_time'] = time();

        //激活
        $arrField = array('seq_rule_id' => $iRuleId);
        $iRes = $this->_getSequenceService()->updateSeqRule($arrParams, $arrField);
        if ($iRes == 0) {
            $this->apiError(Code::COMM_ADD_ERROR, '序号规则激活失败');
        }
        $this->apiSuccess();
    }

    /**
     * 单据号规则新增/编辑入参校验
     * @author: nzw
     * @date: 2018-05-15
     * @return: array
     */
    private function _checkSeqRuleParams()
    {
        $arrRes = array();

        $arrRes['seq_rule_name'] = $this->controller->get_gp('seq_rule_name', 'P');
        parent::checkParam($arrRes['seq_rule_name'], false, false, '序号规则名称');

        $arrRes['seq_rule_type'] = $this->controller->get_gp('seq_rule_type', 'P');
        parent::isNumber($arrRes['seq_rule_type'], true, true, '序号规则类型');
        if (!in_array($arrRes['seq_rule_type'], array(CommonEnum::SEQ_RULE_TYPE_CUSTOM,
            CommonEnum::SEQ_RULE_TYPE_YEARMONTH, CommonEnum::SEQ_RULE_TYPE_YEAR))) {
            $this->apiError(Code::COMM_PARAM_ERROR, '序号规则类型参数有误');
        }

        $arrRes['seq_rule_min'] = $this->controller->get_gp('seq_rule_min', 'P');
        parent::isNumber($arrRes['seq_rule_min'], true, true, '序号起始值');

        $arrRes['seq_rule_max'] = $this->controller->get_gp('seq_rule_max', 'P');
        parent::isNumber($arrRes['seq_rule_max'], true, true, '序号终止值');
        if (($arrRes['seq_rule_type'] == CommonEnum::SEQ_RULE_TYPE_CUSTOM && 99999999 < $arrRes['seq_rule_max']) ||
            ($arrRes['seq_rule_type'] == CommonEnum::SEQ_RULE_TYPE_YEARMONTH && 9999 < $arrRes['seq_rule_max']) ||
            $arrRes['seq_rule_type'] == CommonEnum::SEQ_RULE_TYPE_YEAR && 999999 < $arrRes['seq_rule_max'] ) {
            $this->apiError(Code::COMM_PARAM_ERROR, '序号终止值参数有误');
        }

        if ($arrRes['seq_rule_max'] <= $arrRes['seq_rule_min']) {
            $this->apiError(Code::COMM_PARAM_ERROR, '序号终止值应大于序号起始值');
        }

        $arrRes['seq_rule_prefix'] = $this->controller->get_gp('seq_rule_prefix', 'P');
        parent::checkLength($arrRes['seq_rule_prefix'], true, '序号规则前缀', 2);

        return $arrRes;
    }

    /**
     * 获取单据号规则详情
     * 用于单据号规则编辑时展示（只有停用状态的规则才能编辑，但这里不对状态做校验，在编辑的时候再做）
     * @author: nzw
     * @date: 2018-05-15
     * @return: void
     */
    public function SeqRuleDetail()
    {
        //token校验
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRuleId = $this->controller->get_gp('seq_rule_id');
        parent::isNumber($iRuleId, true, true, '单据号规则id');

        //获取数据
        $arrRule = $this->_getSequenceService()->getOneSeqRuleByField(array(
            'seq_rule_id' => $iRuleId,
            'company_code' => $arrUser['company_code']));
        if (empty($arrRule)) {
            $this->apiError(Code::COMM_EDIT_ERROR, '序号规则不存在');
        }
        $this->apiSuccess($arrRule);
    }

    /**
     * 某个公司下所有单据号规则，供用户在单据号类型和规则的关联时进行选择
     * 筛选条件为：
     * 1.正常状态的
     * 2.未被绑定的（绑定id为0）
     * @author: nzw
     * @date: 2018-05-12
     * @return: void
     */
    public function SeqRulesList()
    {
        //token校验
        $arrUser = $this->authorizeToken();

        //获取数据
        $arrRules = $this->_getSequenceService()->getAllSeqRulesByField(array(
            'seq_rule_status' => CommonEnum::SEQ_RULE_STATUS_NORMAL,
            'seq_type_id' => 0,
            'company_code' => $arrUser['company_code'],
        ));
        $this->apiSuccess($arrRules);
    }

    /**
     * 绑定单据号类型和规则
     * 绑定条件：
     * 1.单据号规则状态必须是“正常”
     * 2.单据号类型目前还未被绑定（一个类型只能绑定一个规则）
     * @author: nzw
     * @date: 2018-05-15
     * @return: void
     */
    public function Bind()
    {
        //鉴权
//        $arrUser = $this->authorizeFunc();
        $arrUser = $this->authorizeToken();

        //入参校验
        $iRuleId = $this->controller->get_gp('seq_rule_id');
        parent::isNumber($iRuleId, true, true, '单据号规则id');
        $iTypeId = $this->controller->get_gp('seq_type_id');
        parent::isNumber($iTypeId, true, true, '单据号类型id');

        //获取原规则数据并校验
        $arrRule = $this->_getSequenceService()->getOneSeqRuleByField(array(
            'seq_rule_id' => $iRuleId,
            'company_code' => $arrUser['company_code']));
        if (empty($arrRule)) {
            $this->apiError(Code::COMM_EDIT_ERROR, '序号规则不存在');
        }
        if ($arrRule['seq_rule_status'] != CommonEnum::SEQ_RULE_STATUS_NORMAL) {
            $this->apiError(Code::COMM_EDIT_ERROR, '序号规则状态有误，无法绑定');
        }
        if ($arrRule['seq_type_id'] != 0) {
            $this->apiError(Code::COMM_EDIT_ERROR, '该序号规则已绑定');
        }

        //获取原类型数据并校验
        $arrType = $this->_getSequenceService()->getOneSeqTypeByField(array(
            'seq_type_id' => $iTypeId,
            'company_code' => $arrUser['company_code']));
        if (empty($arrType)) {
            $this->apiError(Code::COMM_EDIT_ERROR, '序号类型不存在');
        }
        if ($arrType['seq_type_status'] != CommonEnum::SEQ_TYPE_STATUS_NORMAL) {
            $this->apiError(Code::COMM_EDIT_ERROR, '序号类型状态有误，无法绑定');
        }

        //如果该类型已绑定规则，并且绑定的规则不是作废状态，那么说明该类型已绑定，不能重新绑定
        //只有该类型原来未绑定规则，或绑定的规则是“作废”状态时，才可以绑定新的规则
        if ($arrType['seq_rule_id'] != 0) {
            $arrRuleOld = $this->_getSequenceService()->getOneSeqTypeByField(array(
                'seq_type_id' => $arrType['seq_rule_id'],
                'company_code' => $arrUser['company_code']));
            if (!empty($arrRuleOld) && $arrRuleOld['seq_rule_status'] != CommonEnum::SEQ_TYPE_STATUS_INVALID) {
                $this->apiError(Code::COMM_EDIT_ERROR, '该序号类型已绑定');
            }
        }

        //组织规则表数据
        $arrParamsRule = array();
        $iTimeNow = time();
        $arrParamsRule['seq_type_id'] = $arrType['seq_type_id'];
        $arrParamsRule['seq_type_name'] = $arrType['seq_type_name'];
        $arrParamsRule['modify_user'] = $arrUser['user_code'];
        $arrParamsRule['modify_time'] = $iTimeNow;

        //组织类型表数据
        $arrParamsType = array();
        $arrParamsType['seq_rule_id'] = $arrType['seq_type_id'];
        $arrParamsType['modify_user'] = $arrUser['user_code'];
        $arrParamsType['modify_time'] = $iTimeNow;

        $this->_getTransactionService()->start();

        //插入规则表
        $iRuleRes = $this->_getSequenceService()->updateSeqRule($arrParamsRule, array('seq_rule_id' => $iRuleId));
        if ($iRuleRes == 0) {
            $this->_getTransactionService()->rollback();
            $this->apiError(Code::COMM_ADD_ERROR, '序号规则编辑失败');
        }

        //插入类型表
        $arrField = array('seq_rule_id' => $iRuleId);
        $iTypeRes = $this->_getSequenceService()->updateSeqType($arrParamsType, array('seq_type_id' => $iTypeId));
        if ($iTypeRes == 0) {
            $this->_getTransactionService()->rollback();
            $this->apiError(Code::COMM_ADD_ERROR, '序号类型编辑失败');
        }

        $this->_getTransactionService()->commit();
        $this->apiSuccess();
    }

    /**
     * @return SequenceService
     */
    private function _getSequenceService()
    {
        return ChelerApi::getService('common\service\Sequence');
    }

    /**
     * @return TransactionService
     */
    private function _getTransactionService()
    {
        return ChelerApi::getService('common\service\Transaction');
    }
}
