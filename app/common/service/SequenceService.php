<?php
namespace app\common\service;

use app\helper\cache\RedisCache;
use app\helper\Code;
use app\helper\BaseService;
use app\helper\enum\CommonEnum;
use GPBMetadata\Common;

/**
 * 单据号业务service
 * @author: nzw
 * @date: 2018-05-12
 */
class SequenceService extends BaseService
{
    /**
     * 新增单据号规则（默认为停用状态）
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrData 单据号规则信息数组
     * @return: int
     */
    public function insertSeqRule(array $arrData)
    {
        if (empty($arrData)) {
            return 0;
        }
        return $this->init_db()->insert($arrData, 'sys_seq_rule');
    }

    /**
     * 编辑单据号规则（默认为停用状态）
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrData 单据号规则信息数组
     * @param array $arrField 字段数组
     * @return: int
     */
    public function updateSeqRule(array $arrData, array $arrField)
    {
        if (empty($arrData) || empty($arrField)) {
            return 0;
        }
        return $this->init_db()->update_by_field($arrData, $arrField, 'sys_seq_rule');
    }

    /**
     * 通过条件获取单个订单号生成规则
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrField
     * @return: array
     */
    public function getOneSeqRuleByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrRule = $this->init_db()->get_one_by_field($arrField, 'sys_seq_rule');
        if (empty($arrRule)) {
            return array();
        }
        return $this->_transferRules(array($arrRule))[0];
    }

    /**
     * 通过条件获取多个订单号生成规则
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrField
     * @return: array
     */
    public function getAllSeqRulesByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrRules = $this->init_db()->get_all_by_field($arrField, 'sys_seq_rule');
        return $this->_transferRules($arrRules);
    }

    /**
     * 通过sql获取单据号生成规则数据
     * @author: nzw
     * @date: 2018-05-15
     * @param string $strSql
     * @return: array
     */
    public function getAllSeqRulesBySql(string $strSql)
    {
        if ($strSql === '') {
            return array();
        }

        $arrRules = $this->init_db()->get_all_sql($strSql);
        return $this->_transferRules($arrRules);
    }

    /**
     * 强制类型转化多条规则数组
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrRules 多条规则数组
     * @return: array
     */
    private function _transferRules(array $arrRules)
    {
        if (empty($arrRules)) {
            return array();
        }

        foreach ($arrRules AS $iKey => $arrRule) {
            $arrRules[$iKey]['seq_rule_id'] = (int) $arrRule['seq_rule_id'];
            $arrRules[$iKey]['seq_rule_type'] = (int) $arrRule['seq_rule_type'];
            $arrRules[$iKey]['seq_rule_min'] = (int) $arrRule['seq_rule_min'];
            $arrRules[$iKey]['seq_rule_max'] = (int) $arrRule['seq_rule_max'];
            $arrRules[$iKey]['seq_rule_next'] = (int) $arrRule['seq_rule_next'];
            $arrRules[$iKey]['seq_rule_status'] = (int) $arrRule['seq_rule_status'];
            $arrRules[$iKey]['seq_type_id'] = (int) $arrRule['seq_type_id'];
            $arrRules[$iKey]['create_time'] = (int) $arrRule['create_time'];
            $arrRules[$iKey]['modify_time'] = (int) $arrRule['modify_time'];
        }
        return $arrRules;
    }

    /**
     * 新增单据号类型
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrData 单据号类型信息数组
     * @return: int
     */
    public function insertSeqType(array $arrData)
    {
        if (empty($arrData)) {
            return 0;
        }
        return $this->init_db()->insert($arrData, 'sys_seq_type');
    }

    /**
     * 编辑单据号类型
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrData 单据号类型信息数组
     * @param array $arrField 字段数组
     * @return: int
     */
    public function updateSeqType(array $arrData, array $arrField)
    {
        if (empty($arrData) || empty($arrField)) {
            return 0;
        }
        return $this->init_db()->update_by_field($arrData, $arrField, 'sys_seq_type');
    }

    /**
     * 通过条件获取单个订单号类型
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrField
     * @return: array
     */
    public function getOneSeqTypeByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrType = $this->init_db()->get_one_by_field($arrField, 'sys_seq_type');
        if (empty($arrType)) {
            return array();
        }
        return $this->_transferTypes(array($arrType))[0];
    }

    /**
     * 通过条件获取多个订单号类型
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrField
     * @return: array
     */
    public function getAllSeqTypesByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrTypes = $this->init_db()->get_all_by_field($arrField, 'sys_seq_type');
        return $this->_transferTypes($arrTypes);
    }

    /**
     * 强制类型转化多条单据号类型数组
     * @author: nzw
     * @date: 2018-05-15
     * @param array $arrTypes 多条单据号类型数组
     * @return: array
     */
    private function _transferTypes(array $arrTypes)
    {
        if (empty($arrTypes)) {
            return array();
        }

        foreach ($arrTypes AS $iKey => $arrType) {
            $arrTypes[$iKey]['seq_type_id'] = (int) $arrType['seq_type_id'];
            $arrTypes[$iKey]['seq_rule_id'] = (int) $arrType['seq_rule_id'];
            $arrTypes[$iKey]['seq_type_status'] = (int) $arrType['seq_type_status'];
            $arrTypes[$iKey]['create_time'] = (int) $arrType['create_time'];
            $arrTypes[$iKey]['modify_time'] = (int) $arrType['modify_time'];
        }
        return $arrTypes;
    }

    /**
     * 新增单据号类型
     * @author: nzw
     * @date: 2018-05-21
     * @param string $strCompanyCode 所属公司账套
     * @param string $strUserCode 操作人用户编号
     * @param string $strEntityCode 单据实体编号
     * @param string $strEntityTypeCode 单据实体类型编号
     * @return: array 成功code为0 失败code非0
     */
    public function addSeqType(string $strCompanyCode, string $strUserCode, string $strEntityCode, string $strEntityTypeCode)
    {
        //入参校验
        $arrCheckRes = self::_checkSeqTypeParams($strCompanyCode, $strUserCode, $strEntityCode, $strEntityTypeCode);
        if ($arrCheckRes['code'] != Code::CODE_SUCCESS) {
            return $arrCheckRes;
        }

        //单据实体存在性校验
        $arrEntity = $this->init_db()->get_one_by_field(array('order_entity_code' => $strEntityCode),
            'sys_order_entity');
        if (empty($arrEntity)) {
            return parent::ret(Code::COMM_ADD_ERROR, '单据实体不存在');
        }

        //单据实体类型存在性校验
        $arrEntityType = $this->init_db()->get_one_by_field(array('order_entity_type_code' => $strEntityTypeCode),
            'sys_order_entity_type');
        if (empty($arrEntityType)) {
            return parent::ret(Code::COMM_ADD_ERROR, '单据实体类型不存在');
        }

        //组织插入数据并入库
        $arrData = array();
        $arrData['company_code'] = $strCompanyCode;
        $arrData['order_entity_code'] = $strEntityCode;
        $arrData['order_entity_type_code'] = $strEntityTypeCode;
        $arrData['order_entity_type_name'] = $arrEntityType['order_entity_type_name'] ?? '';
        $arrData['seq_type_status'] = CommonEnum::SEQ_RULE_STATUS_NORMAL;
        $arrData['create_user'] = $strUserCode;
        $arrData['create_time'] = time();

        $iRes = self::insertSeqType($arrData);
        if (empty($iRes)) {
            return parent::ret(Code::COMM_ADD_ERROR, '单据号类型新增失败');
        }
        return parent::ret(Code::CODE_SUCCESS, '', array('id' => $iRes));
    }

    /**
     * 检查新增和插入
     * @author: nzw
     * @date: 2018-05-21
     * @param string $strCompanyCode 所属公司账套
     * @param string $strUserCode 操作人用户编号
     * @param string $strEntityCode 单据实体编号
     * @param string $strEntityTypeCode 单据实体类型编号
     * @return: array
     */
    private function _checkSeqTypeParams(string $strCompanyCode, string $strUserCode, string $strEntityCode, string $strEntityTypeCode)
    {
        if ($strCompanyCode === '') {
            return parent::ret(Code::COMM_PARAM_REQUIRED, '公司账套参数为空');
        }
        if (mb_strlen($strCompanyCode, 'utf-8') != 5) {
            return parent::ret(Code::COMM_PARAM_ERROR, '公司账套参数长度有误');
        }
        if ($strUserCode === '') {
            return parent::ret(Code::COMM_PARAM_REQUIRED, '操作人用户编号参数为空');
        }
        if (mb_strlen($strUserCode, 'utf-8') != 10) {
            return parent::ret(Code::COMM_PARAM_ERROR, '操作人用户编号参数长度有误');
        }
        if ($strEntityCode === '') {
            return parent::ret(Code::COMM_PARAM_REQUIRED, '单据实体编号参数为空');
        }
        if ($strEntityTypeCode === '') {
            return parent::ret(Code::COMM_PARAM_REQUIRED, '单据实体类型编号参数为空');
        }
        return parent::ret(Code::CODE_SUCCESS);
    }

    /**
     * 根据seq_type_id生成单据号
     * 用户只能使用自己公司下的单据号规则来生成，这部在调用该方法处自行校验
     * @author: nzw
     * @date: 2018-05-15
     * @param int $iSeqTypeId 单据号类型id
     * @param string $strUserCode 用户编号
     * @return: array('code' => 0, 'msg' => '', 'data' => '')
     */
    public function generate(int $iSeqTypeId, string $strUserCode)
    {
        if ($iSeqTypeId <= 0) {
            return parent::ret(Code::COMM_PARAM_ERROR, '单据号类型id参数有误');
        }
        if ($strUserCode === '') {
            return parent::ret(Code::COMM_PARAM_ERROR, '用户编号参数有误');
        }

        //读取单据号类型
        $arrType = $this->getOneSeqTypeByField(array('seq_type_id' => $iSeqTypeId));
        if (empty($arrType)) {
            return parent::ret(Code::COMM_SELECT_ERROR, '单据号类型不存在');
        }
        if (empty($arrType['seq_rule_id'])) {
            return parent::ret(Code::COMM_SELECT_ERROR, '单据号类型未绑定规则');
        }

        //读取关联的单据号规则
        $arrRule = $this->getOneSeqRuleByField(array(
            'seq_rule_id' => $arrType['seq_rule_id'],
            'seq_type_id' => $iSeqTypeId,
            'seq_rule_status' => CommonEnum::SEQ_RULE_STATUS_NORMAL,
        ));
        if (empty($arrRule)) {
            return parent::ret(Code::COMM_SELECT_ERROR, '单据号类型绑定的规则不存在或无法使用');
        }
        if (empty($arrRule['seq_rule_prefix']) || mb_strlen($arrRule['seq_rule_prefix'], 'utf-8') != 2) {
            return parent::ret(Code::COMM_SELECT_ERROR, '单据号规则前缀有误');
        }

        //读取缓存中的单据号，若缓存不存在或缓存中的值小于数据库的下一个序号值，则将数据库中的下一个序号值存入缓存
        $strSeq = $this->getRedis('default')->get(RedisCache::R_common_sequence($iSeqTypeId));
        if ($strSeq === false || $strSeq < $arrRule['seq_rule_next']) {
            $strSeq = $arrRule['seq_rule_next'];
            $this->getRedis('default')->set(RedisCache::R_common_sequence($iSeqTypeId), $strSeq);
        }

        //单据号已用尽
        $iSeq = (int) ($this->getRedis('default')->increment(RedisCache::R_common_sequence($iSeqTypeId)) - 1);
        if ($arrRule['seq_rule_max'] < $iSeq) {
            //删除相关缓存
            $this->getRedis('default')->delete(RedisCache::R_common_sequence($iSeqTypeId));

            //作废单据号规则
            $iDiscardRes = $this->_discardSeqRule($arrType['seq_rule_id'], $strUserCode);
            if (empty($iDiscardRes)) {
                return parent::ret(Code::COMM_EDIT_ERROR, '单据号规则作废失败');
            }
            return parent::ret(Code::COMM_SEQ_UESD_UP, '单据号已用尽，该单据号规则已作废');
        }

        $strSeqNum = '';
        switch ((int) $arrRule['seq_rule_type']) {
            case CommonEnum::SEQ_RULE_TYPE_CUSTOM:
                $strSeqNum = sprintf('%08d', $iSeq);
                break;
            case CommonEnum::SEQ_RULE_TYPE_YEARMONTH:
                $strSeqNum = sprintf('%s%04d', date('ym', time()), $iSeq);
                break;
            case CommonEnum::SEQ_RULE_TYPE_YEAR:
                $strSeqNum = sprintf('%s%06d', date('y', time()), $iSeq);
                break;
            default:
                return parent::ret(Code::COMM_SELECT_ERROR, '单据号类型有误');
                break;
        }

        //单据号入库落地
        $arrData = array(
            'seq_rule_next' => $iSeq + 1,
            'modify_user' => $strUserCode,
            'modify_time' => time(),
        );
        $iUpdateRes = $this->updateSeqRule($arrData, array('seq_rule_id' => $arrRule['seq_rule_id']));
        if (empty($iUpdateRes)) {
            return parent::ret(Code::COMM_EDIT_ERROR, '单据号规则更新失败');
        }
        return parent::ret(Code::CODE_SUCCESS, '', $arrRule['seq_rule_prefix'] . $strSeqNum);
    }

    /**
     * 通过单据号规则id，作废单据号规则
     * @author: nzw
     * @date: 2018-05-16
     * @param int $iSeqRuleId
     * @return: void
     */
    private function _discardSeqRule(int $iSeqRuleId, string $strUserCode)
    {
        $arrData = array(
            'seq_rule_status' => CommonEnum::SEQ_TYPE_STATUS_INVALID,
            'modify_user' => $strUserCode,
            'modify_time' => time(),
        );
        return $this->updateSeqRule($arrData, array('seq_rule_id' => $iSeqRuleId));
    }
}
