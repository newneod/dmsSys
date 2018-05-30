<?php
namespace app\system\service;

use frame\runtime\CService;

/**
 * 公司service
 * @package app\system\service
 */
class CompanyService extends CService
{
    /**
     * 添加公司
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function add( array $insert ):int
    {
        if( empty( $insert ) ){ return 0; }
        $result = $this->init_db()->insert( $insert, 'sys_company' );
        return $result;
    }

    /**
     * 编辑公司
     * @param array $data 编辑数据
     * @param array $field 编辑条件
     * @author:tiger.li
     * @date:2018-05-09 15:26:40
     * @return int
     */
    public function edit( array $data, array $field ):int
    {
        if( empty( $data ) || empty( $field )){ return 0; }
        $result = $this->init_db()->update_by_field( $data, $field, 'sys_company' );
        return $result;
    }

    /**
     * 通过条件获取单个公司信息
     * @author: nzw
     * @date: 2018-05-09
     * @param: array $arrField
     * @return: array
     */
    public function getOneCompanyByField(array $arrField)
    {
        if (empty($arrField)) {
            return array();
        }

        $arrCompany = $this->init_db()->get_one_by_field($arrField, 'sys_company');
        if (empty($arrCompany)) {
            return array();
        }
        return $this->_transferCompanies(array($arrCompany))[0];
    }

    /**
     * 强制类型转化多条用户数据
     * @author: nzw
     * @date: 2018-05-09
     * @param array $arrUsers 多条用户数据数组
     * @return array $arrUsers 强制类型转换过的用户数据数组
     */
    private function _transferCompanies(array $arrCompanies)
    {
        if (empty($arrCompanies)) {
            return array();
        }

        foreach($arrCompanies AS $iKey => $arrCompany) {
            $arrCompanies[$iKey]['company_id'] = (int) $arrCompany['company_id'];
            $arrCompanies[$iKey]['company_type'] = (int) $arrCompany['company_type'];
            $arrCompanies[$iKey]['company_status'] = (int) $arrCompany['company_status'];
            $arrCompanies[$iKey]['create_time'] = (int) $arrCompany['create_time'];
            $arrCompanies[$iKey]['modify_time'] = (int) $arrCompany['modify_time'];
        }
        return $arrCompanies;
    }
}