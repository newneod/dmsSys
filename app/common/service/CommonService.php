<?php
namespace app\common\service;

use frame\runtime\CService;

/**
 * 公共业务
 * @author even
 * @date: 2018年5月9日
 */
class CommonService extends CService
{
    /**
     * 获取全部车型数据
     * @param void
     * @return void
     */ 
    public function GetAllVehicleType()
    {
        //后期可以考虑添加缓存
        $sql = sprintf('SELECT * FROM base_vehicle_type');
        $res = $this->init_db()->get_all_sql( $sql );
        
        return $res;
    }
    
    /**
     * 获取全部省市区
     * @param void
     * @return void
     */ 
    public function GetAllCommonArea()
    {
        //后期可以考虑添加缓存
        $sql = sprintf('SELECT * FROM comm_address_area');
        $res = $this->init_db()->get_all_sql( $sql );
        
        return $res;
    }
    
    
    
    
}
