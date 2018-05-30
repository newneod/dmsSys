<?php
namespace app\system\service;

use frame\runtime\CService;

/**
 * 通知业务service
 * @package app\system\service
 */
class NoticeService extends CService
{
    /**
     * 添加通知
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function add( array $insert ):int
    {
        if( empty( $insert ) ){ return 0; }
        $result = $this->init_db('dms')->insert( $insert, 'sys_notice' );
        return $result;
    }

    /**
     * 添加通知与用户关系
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function addRelNoticeUser( array $field, array $data )
    {
        if( empty( $field ) || empty( $data )){ return 0; }
        $result = $this->init_db('dms')->insert_more( $field, $data, 'sys_rel_notice_user' );
        return $result;
    }

    /**
     * 修改通知与用户关系
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function EditRelNoticeUser( array $data, array $field)
    {
        if( empty( $field ) || empty( $data )){ return 0; }
        $result = $this->init_db('dms')->update_by_field( $data, $field, 'sys_rel_notice_user' );
        return $result;
    }

    /**
     * 添加跨公司通知与用户关系
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function addRelNoticeUserCompany( array $field, array $data ):int
    {
        if( empty( $field ) || empty( $data )){ return 0; }
        $result = $this->init_db('dms')->insert_more( $field, $data, 'sys_rel_notice_user_company' );
        return $result;
    }

    /**
     * 添加跨公司通知与用户关系
     * @param array $insert 添加数据
     * @author:tiger.li
     * @date:2018-05-09 15:09:50
     * @return int
     */
    public function EditRelNoticeUserCompany( array $data, array $field):int
    {
        if( empty( $field ) || empty( $data )){ return 0; }
        $result = $this->init_db('dms')->update_by_field( $data, $field, 'sys_rel_notice_user_company' );
        return $result;
    }

}