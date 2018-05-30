<?php
namespace app\system\service;

use frame\runtime\CService;
/**
 * 系统业务
 * @author tiger.li
 * @date: 2018年5月9日
 */
class SystemService extends CService
{
    /**
     * 添加系统配置
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function add( array $insert ):int
    {
        if( empty( $insert ) ){ return 0; }
        $result = $this->init_db()->insert( $insert, 'sys_config' );
        return $result;
    }

    /**
     * 编辑系统配置
     * @param array $data 编辑数据
     * @param array $field 编辑条件
     * @author:tiger.li
     * @date:2018-05-09 15:26:40
     * @return int
     */
    public function edit( array $data, array $field ):int
    {
        if( empty( $data ) || empty( $field )){ return 0; }
        $result = $this->init_db()->update_by_field( $data, $field, 'sys_config' );
        return $result;
    }

    /**
     * 通过条件获取单个系统配置
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:14:57
     * @return array
     */
    public function getOneConfigByField( array $field ):array
    {
        if( empty( $field ) ){ return []; }
        $result = $this->init_db()->get_one_by_field( $field, 'sys_config' );
        if (!empty($result)){
            $result = self::_transferConfig([$result])[0];
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
    private function _transferConfig(array $arrConfigs)
    {
        $result = [];
        if (empty($arrConfigs)) {
            return $result;
        }
        foreach($arrConfigs AS $iKey => $arrConfig) {
            $result[$iKey]['config_id'] = (int) $arrConfig['config_id'];
            $result[$iKey]['company_code'] = (string) $arrConfig['company_code'];
            $result[$iKey]['config_key'] = (string) $arrConfig['config_key'];
            $result[$iKey]['config_value'] = (string) $arrConfig['config_value'];
        }
        return $result;
    }
}
