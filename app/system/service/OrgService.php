<?php
namespace app\system\service;

use frame\runtime\CService;
use frame\ChelerApi;
/**
 * 组织业务
 * @author tiger.li
 * @date: 2018年5月9日
 */
class OrgService extends CService
{

    /**
     * 添加组织
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function add( array $insert ):int
    {
        if( empty( $insert ) ){ return 0; }
        $result = $this->init_db()->insert( $insert, 'sys_org' );
        return $result;
    }

    /**
     * 编辑组织
     * @param array $data 编辑数据
     * @param array $field 编辑条件
     * @author:tiger.li
     * @date:2018-05-09 15:26:40
     * @return int
     */
    public function edit( array $data, array $field ):int
    {
        if( empty( $data ) || empty( $field )){ return 0; }
        $result = $this->init_db()->update_by_field( $data, $field, 'sys_org' );
        return $result;
    }

    /**
     * 获取单条组织
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:14:57
     * @return array
     */
    public function getOneOrgByField( array $field ):array
    {
        if( empty( $field ) ){ return []; }
        $result = $this->init_db()->get_one_by_field( $field, 'sys_org' );
        if(!empty($result)){
            $result = self::_transferOrgs([$result])[0];
        }
        return $result;
    }

    /**
     * 强制类型转化多条数据
     * @author: tiger.li
     * @date: 2018-05-09
     * @param array $arrUsers 多条数组
     * @return array $arrUsers 强制类型转换过的址数据数组
     */
    private function _transferOrgs(array $arrOrgs)
    {
        $result = [];
        if (empty($arrOrgs)) {
            return $result;
        }
        foreach($arrOrgs AS $iKey => $arrOrg) {
            $result[$iKey]['org_id'] = (int) $arrOrg['org_id'];
            $result[$iKey]['company_code'] = (string) $arrOrg['company_code'];
            $result[$iKey]['org_pid'] = (int) $arrOrg['org_pid'];
            $result[$iKey]['org_name'] = (string) $arrOrg['org_name'];
            $result[$iKey]['org_simplify_name'] = (string) $arrOrg['org_simplify_name'];
            $result[$iKey]['org_status'] = (int) $arrOrg['org_status'];
            $result[$iKey]['org_describe'] = (string) $arrOrg['org_describe'];
            $result[$iKey]['create_user'] = (string) $arrOrg['create_user'];
            $result[$iKey]['create_time'] = (string) $arrOrg['create_time'];
        }
        return $result;
    }

    /**
     * 获取所有组织
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:18:12
     * @return array
     */
    public function getAllOrgByField( array $field, $line = "*", $sort="org_id ASC" ):array
    {
        if ( empty($field) ) {
            return [];
        }
        $where = $this->init_db()->makeWhere($field);
        $sql = \sprintf('SELECT %s FROM %s %s ORDER BY %s', $line, 'sys_org', $where, $sort);
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
     * 检测组织新增或修改条件
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-09 17:18:12
     * @return array
     */
    public function getCheckOrgByField( array $field):array
    {
        if ( empty($field) ) {
            return [];
        }
        $sql = \sprintf('SELECT * FROM %s WHERE `org_name` = "%s" OR `org_simplify_name` = "%s" AND `company_code` = "%s"', 'sys_org', $field["org_name"], $field["org_simplify_name"], $field["company_code"]);

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
     * 组织主页面结构树
     * @param array $field 查询条件
     * @author:tiger.li
     * @date:2018-05-10 17:18:12
     * @return array
     */
    public function getOrgTree( array $field):array
    {
        $result = [];
        $users = [];
        //$tree = &[];
        $company = $this->_getCompanyService()->getOneCompanyByField(["company_code" => $field["company_code"]]);
        if(empty($company)){return $result;}
        //添加顶部公司信息
        $result["company_id"] = (int) $company["company_id"]??0;//公司ID
        $result["company_code"] = (string) $company["company_code"]??'';//账套
        $result["company_alias"] = (string) $company["company_alias"]??'';//公司全称
        $result["company_name"] = (string) $company["company_name"]??'';//公司名称
        $result["subcat"] = [];
        $all_org = self::getAllOrgByField($field, "*", "org_pid DESC");
        if(empty($all_org)){return $result;}
        $all_org =  self::_transferOrg($all_org);
        $user_code = array_values(filter_value(array_unique(array_column($all_org, "create_user"))));
        $user_arr = self::getAllUserByField(["user_code"=>$user_code], "user_code, user_realname");
        if(!empty($user_arr)){
            //处理用户数组为[用户编码对用户名称]的二位数组
            foreach ($user_arr as $userKay => $user_val){
                $users[$user_val["user_code"]] = $user_val["user_realname"]??"";
            }
        }
        $tree = self::_makeTree($all_org, $users);
        $result["subcat"] = $tree;
        return $result;
    }

    /**
     * 强制类型转换
     * @param array $org 组织数据
     * @author:tiger.li
     * @return array
     */
    private function _transferOrg(array $orgs):array {
        $result = [];
        if(empty($orgs)){return $result;}
        foreach ($orgs as $key => $org){
            $result[$key]['org_id'] = (int) $org['org_id'];//组织ID
            $result[$key]['company_code'] = (string) $org['company_code'];//账套
            $result[$key]['org_pid'] = (int) $org['org_pid'];//组织父ID
            $result[$key]['org_name'] = (string) $org['org_name'];//组织名称
            $result[$key]['org_simplify_name'] = (string) $org['org_simplify_name'];//组织简称
            $result[$key]['org_status'] = (string) $org['org_status'];//组织状态 1正常 2停用 3作废
            $result[$key]['org_describe'] = (string) $org['org_describe'];//组织描述
            $result[$key]['create_user'] = (string) $org['create_user']??'';//创建用户编号
            $result[$key]['create_time'] = (int) $org['create_time'];//创建时间
        }
        return $result;
    }

    /**
     * 生成无限极分类树
     * @param $arr
     * @param $users
     * @author:tiger.li
     * @date:2018-05-11 16:07:59
     * @return array
     */
    private function _makeTree($arr, $users):array
    {
        $refer = array();
        $tree = array();
        foreach($arr as $k => $v){
            $arr[$k]["create_user"] = $users[$arr[$k]["create_user"]];
            $refer[$v['org_id']] = &$arr[$k];
        }
        foreach($arr as $k => $v){
            $pid = $v['org_pid'];
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
    public function getAllUserOrgByField( array $field, $line = "*", $sort="org_id ASC" ):array
    {
        if ( empty($field) ) {
            return [];
        }
        $where = $this->init_db()->makeWhere($field);
        $sql = \sprintf('SELECT %s FROM %s %s ORDER BY %s', $line, 'sys_rel_user_org', $where, $sort);
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

    /**
     * @return CompanyService
     */
    private function _getCompanyService()
    {
        return ChelerApi::getService('system\service\Company');
    }

}
