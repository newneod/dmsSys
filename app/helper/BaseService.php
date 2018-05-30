<?php
namespace app\helper;

use frame\runtime\CService;

/**
 * BaseService.php
 * User: nzw
 * Date: 2018/5/14
 */
class BaseService extends CService
{
    /**
     * 返回状态，提示信息与数据
     * @author: nzw
     * @date: 2018-05-14
     * @param int $iCode
     * @param string $strMsg
     * @param mix $mixData
     * @return: array
     */
    protected function ret(int $iCode = 0, string $strMsg = '', $mixData = '')
    {
        $arrRes = array();
        $arrRes['code'] = $iCode;
        $arrRes['msg'] = $strMsg;
        $arrRes['data'] = $mixData;
        return $arrRes;
    }
    
}
