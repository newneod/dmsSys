<?php
namespace app\system\service;

use frame\runtime\CService;
/**
 * 客户业务
 * @author tiger.li
 * @date: 2018年5月11日
 */
class CustomerService extends CService
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
        $result = $this->init_db()->insert( $insert, 'sys_customer' );
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
        $result = $this->init_db()->update_by_field( $data, $field, 'sys_customer' );
        return $result;
    }

    /**
     * 通过条件获取单个客户信息
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:14:57
     * @return array
     */
    public function getOneCustomerByField( array $field ):array
    {
        if( empty( $field ) ){ return []; }
        $result = $this->init_db()->get_one_by_field( $field, 'sys_customer' );
        if (!empty($result)){
            $result = self::_transferCustomers([$result])[0];
        }
        return $result;
    }

    /**
     * 通过条件获取多个客户信息
     * @author: nzw
     * @date: 2018-05-15
     * @param array $field 查询条件
     * @return array
     */
    public function getAllCustomersByField(array $field)
    {
        if (empty($field)) {
            return array();
        }
        $result = $this->init_db()->get_all_by_field($field, 'sys_customer');
        if (!empty($result)){
            $result = self::_transferCustomers($result);
        }
        return $result;
    }

    /**
     * 添加客户-地址关系
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function addCustomerAddress( array $insert )
    {
        if( empty( $insert ) ){ return 0; }
        $result = $this->init_db()->insert( $insert, 'sys_rel_customer_address' );
        return $result;
    }

    /**
     * 添加客户地址
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function addAddress( array $insert ):int
    {
        if( empty( $insert ) ){ return 0; }
        $result = $this->init_db()->insert( $insert, 'comm_address' );
        return $result;
    }

    /**
     * 编辑客户地址
     * @param array $data 编辑数据
     * @param array $field 编辑条件
     * @author:tiger.li
     * @date:2018-05-09 15:26:40
     * @return int
     */
    public function editAddress( array $data, array $field ):int
    {
        if( empty( $data ) || empty( $field )){ return 0; }
        $result = $this->init_db()->update_by_field( $data, $field, 'comm_address' );
        return $result;
    }

    /**
     * 通过条件获取单个客户地址信息
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:14:57
     * @return array
     */
    public function getOneAddressByField( array $field ):array
    {
        if( empty( $field ) ){ return []; }
        $result = $this->init_db()->get_one_by_field( $field, 'comm_address' );
        if (!empty($result)){
            $result = self::_transferAddress([$result])[0];
        }
        return $result;
    }

    /**
     * 强制类型转化多条客户地址数据
     * @author: tiger.li
     * @date: 2018-05-09
     * @param array $arrUsers 多条客户数据地址数组
     * @return array $arrUsers 强制类型转换过的客户地址数据数组
     */
    private function _transferAddress(array $arrCustomersAddress)
    {
        $result = [];
        if (empty($arrCustomersAddress)) {
            return $result;
        }
        foreach($arrCustomersAddress AS $iKey => $arrAddress) {
            $result[$iKey]['address_id'] = (int) $arrAddress['address_id'];
            $result[$iKey]['company_code'] = (string) $arrAddress['company_code'];
            $result[$iKey]['address_type'] = (int) $arrAddress['address_type'];
            $result[$iKey]['address_zip_code'] = (string) $arrAddress['address_zip_code'];
            $result[$iKey]['province_id'] = (int) $arrAddress['province_id'];
            $result[$iKey]['city_id'] = (int) $arrAddress['city_id'];
            $result[$iKey]['district_id'] = (int) $arrAddress['district_id'];
            $result[$iKey]['address_detail'] = (string) $arrAddress['address_detail'];
            $result[$iKey]['create_user'] = (string) $arrAddress['create_user'];
            $result[$iKey]['create_time'] = (int) $arrAddress['create_time'];
            $result[$iKey]['modify_user'] = (string) $arrAddress['modify_user'];
            $result[$iKey]['modify_time'] = (int) $arrAddress['modify_time'];
        }
        return $result;
    }

    /**
     * 强制类型转化多条客户数据
     * @author: tiger.li
     * @date: 2018-05-09
     * @param array $arrUsers 多条客户数据数组
     * @return array $arrUsers 强制类型转换过的客户数据数组
     */
    private function _transferCustomers(array $arrCustomers)
    {
        $result = [];
        if (empty($arrCustomers)) {
            return $result;
        }
        foreach($arrCustomers AS $iKey => $arrCustomer) {
            $result[$iKey]['customer_id'] = (int) $arrCustomer['customer_id'];
            $result[$iKey]['company_code'] = (string) $arrCustomer['company_code'];
            $result[$iKey]['customer_name'] = (string) $arrCustomer['customer_name'];
            $result[$iKey]['customer_nickname'] = (string) $arrCustomer['customer_nickname'];
            $result[$iKey]['customer_type'] = (int) $arrCustomer['customer_type'];
            $result[$iKey]['customer_level'] = (int) $arrCustomer['customer_level'];
            $result[$iKey]['customer_ref_company_code'] = (string) $arrCustomer['customer_ref_company_code'];
            $result[$iKey]['create_user'] = (string) $arrCustomer['create_user'];
            $result[$iKey]['create_time'] = (int) $arrCustomer['create_time'];
            $result[$iKey]['modify_user'] = (string) $arrCustomer['modify_user'];
            $result[$iKey]['modify_time'] = (int) $arrCustomer['modify_time'];
        }
        return $result;
    }

    /**
     * 开启事务
     * @author:tiger.li
     * @date:2018-05-11 11:55:46
     * @return bool
     */
    public function transaction_start(){
        return $this->init_db()->transaction_start( );
    }

    /**
     * 提交事务
     * @author:tiger.li
     * @date:2018-05-11 11:55:46
     * @return bool
     */
    public function transaction_commit(){
        return $this->init_db()->transaction_commit( );
    }

    /**
     * 回滚事务
     * @author:tiger.li
     * @date:2018-05-11 11:55:46
     * @return bool
     */
    public function transaction_rollback(){
        return $this->init_db()->transaction_rollback( );
    }
}
