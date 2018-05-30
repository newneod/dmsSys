<?php
namespace app\system\service;

use frame\runtime\CService;
/**
 * 销售区域业务
 * @author tiger.li
 * @date: 2018年5月9日
 */
class SellRegionService extends CService
{
    /**
     * 添加销售区域
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function add( array $insert ):int
    {
        if( empty( $insert ) ){ return 0; }
        $result = $this->init_db()->insert( $insert, 'base_sell_region' );
        return $result;
    }

    /**
     * 编辑销售区域
     * @param array $data 编辑数据
     * @param array $field 编辑条件
     * @author:tiger.li
     * @date:2018-05-09 15:26:40
     * @return int
     */
    public function edit( array $data, array $field ):int
    {
        if( empty( $data ) || empty( $field )){ return 0; }
        $result = $this->init_db()->update_by_field( $data, $field, 'base_sell_region' );
        return $result;
    }

    /**
     * 添加公司-销售区域关系
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function addCompanySellRegion( array $insert ):int
    {
        if( empty( $insert ) ){ return 0; }
        $result = $this->init_db()->insert( $insert, 'sys_rel_company_sellregion' );
        return $result;
    }

    /**
     * 编辑公司-销售区域关系
     * @param array $data 编辑数据
     * @param array $field 编辑条件
     * @author:tiger.li
     * @date:2018-05-09 15:26:40
     * @return int
     */
    public function editCompanySellRegion( array $data, array $field ):int
    {
        if( empty( $data ) || empty( $field )){ return 0; }
        $result = $this->init_db()->update_by_field( $data, $field, 'sys_rel_company_sellregion' );
        return $result;
    }

    /**
     * 获取单条销售区域
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:14:57
     * @return array
     */
    public function getOneSellRegionByField( array $field ):array
    {
        if( empty( $field ) ){ return []; }
        $result = $this->init_db()->get_one_by_field( $field, 'base_sell_region' );
        return $result;
    }

    /**
     * 获取所有销售区域
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:18:12
     * @return array
     */
    public function getAllSellRegionByField( array $field, $line = "*", $sort="sell_region_id ASC" ):array
    {
        if (!empty($field)){
            $where = $this->init_db()->makeWhere($field);
        }else{
            $where = '';
        }
        $sql = \sprintf('SELECT %s FROM %s %s ORDER BY %s', $line, 'base_sell_region', $where, $sort);
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
     * 销售区域主页面结构树
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-10 17:18:12
     * @return array
     */
    public function getSellRegionTree( array $field = []):array
    {
        $users = [];
        $all_sell_region = self::getAllSellRegionByField($field, "*", "sell_region_id DESC");

        if(empty($all_sell_region)){return [];}
        $user_code = array_unique(array_column($all_sell_region, "create_user"));
        $userArr = self::getAllUserByField(["user_code"=>$user_code], "user_code, user_realname");
        if(!empty($userArr)){
            //处理用户数组为[用户编码对用户名称]的二位数组
            foreach ($userArr as $userKay => $userVal){
                $users[$userVal["user_code"]] = $userVal["user_realname"]??"";
            }
        }
        $tree = self::_makeTree($all_sell_region, $users);
        return $tree;
    }

    /**
     * 生成无限极分类树
     * @param $arr
     * @param $users
     * @author:tiger.li
     * @date:2018-05-11 16:07:59
     * @return array
     */
    private function _makeTree($arr, $users)
    {
        $refer = array();
        $tree = array();
        foreach($arr as $k => $v){
            $arr[$k]["create_user"] = $users[$arr[$k]["create_user"]];
            $refer[$v['sell_region_id']] = &$arr[$k];
        }
        foreach($arr as $k => $v){
            $pid = $v['sell_region_pid'];
            if($pid == 0){
                $tree[] = &$arr[$k];
            }else{
                if(isset($refer[$pid])){
                    $refer[$pid]['subcat'][] = &$arr[$k];
                }
            }
        }
        return $tree;
    }

    /**
     * 获取所有组织用户关系
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:18:12
     * @return array
     */
    public function getAllUserOrgByField( array $field, $line = "*", $sort="company_region_id ASC" ):array
    {
        if ( empty($field) ) {
            return [];
        }
        $where = $this->init_db()->makeWhere($field);
        $sql = \sprintf('SELECT %s FROM %s %s ORDER BY %s', $line, 'sys_rel_company_sellregion', $where, $sort);
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
}
