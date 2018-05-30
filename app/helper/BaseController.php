<?php
namespace app\helper;

use app\helper\cache\RedisCache;
use frame\ChelerApi;
use frame\runtime\Controller;
use app\helper\enum\SystemEnum;
use app\system\service\FuncService;
use app\common\service\TableService;

/**
 * Controller基类
 * User: nzw
 * Date: 2018/5/8
 */
class BaseController extends Controller
{
    /**
     * DMS加密字符
     */
    CONST HASH_KEY = 'DMS';

    /**
     * DMS加密前缀
     */
    CONST PREFIX = self::HASH_KEY . '_';

    /**
     * token过期时间（单位：s）
     */
    CONST TOKEN_EXPIRE_SECONDS = 86400;

    /**
     * 用户原始密码
     */
    CONST PWD_USER_ORIGINAL = '123456';

    /**
     * 密码salt长度
     */
    CONST PWD_SALT_LEN = 6;

    /**
     * token校验
     * @author: nzw
     * @date: 2018-05-10
     * @return array $arrUser
     */
    protected function authorizeToken()
    {
        //token参数校验
        $token = $this->controller->get_gp('token', 'G');
        if (empty($token)) {
            $this->apiError( Code::COMM_TOKEN_REQUIRED, 'token不能为空');
        }

        //解密登录token，原数据格式为：Self::PREFIX . $strUserCode . '_' . $iLoginTime
        $strToken = hashCode($token, 'DECODE', self::HASH_KEY);
        $arrToken = explode('_', $strToken);
        if (!is_array($arrToken) || count($arrToken) != 3 || $arrToken[0] != rtrim(Self::PREFIX, '_')) {
            $this->apiError(Code::COMM_TOKEN_ERROR, 'token有误');
        }
        if (Self::TOKEN_EXPIRE_SECONDS < (time() - $arrToken[2])) {
            $this->apiError( Code::COMM_TOKEN_EXPIRED, 'token已过期，请重新登录');
        }

        //获取用户信息
        $arrUser = $this->getRedis('default')->get(RedisCache::R_system_login_data($arrToken[1]));
        $arrUser = json_decode($arrUser, true);
        if (empty($arrUser)) {
            $this->apiError(Code::COMM_TOKEN_ERROR, 'token有误');
        }

        return $arrUser;
    }

    /**
     * action功能权限校验
     * @author: nzw
     * @date: 2018-05-10
     * @param array $arrUser
     * @return array $arrUser
     */
    protected function authorizeFunc()
    {
        $arrUser = self::authorizeToken();
        //如果是超管则无需鉴权
        if ($arrUser['is_super'] == SystemEnum::USER_IS_SUPER_YES) {
            return $arrUser;
        }

        if (empty($arrUser) || empty($arrUser['user_funcs_router'])) {
            $this->apiError( Code::COMM_ACCESS_DENY, '无权访问');
        }

        //对当前路由的方法是否有权限访问进行校验
        $strRouter = $_GET['m'] . '/' . $_GET['c'] . '/' . $_GET['a'];
        if (!in_array($strRouter, $arrUser['user_funcs_router'])) {
            $this->apiError( Code::COMM_ACCESS_DENY, '无权访问');
        }

//        //对所有新增和编辑操作进行字段权限校验
//        $this->_checkParamsIn(array_values(array_column($arrUser['user_roles'], 'role_id')));
        return $arrUser;
    }

    /**
     * 用于对所有编辑、新增操作进行的入参进行筛选
     * @author: nzw
     * @date: 2018-05-14
     * @param int $iRoleId 角色id
     * @return: void
     */
    private function _checkParamsIn(array $arrRoleIds)
    {
        if (empty($_POST)) {
            return;
        }

        //对所有方法名中包含edit，add的操作进行筛选
        if (!preg_match('/^((Add)|(Edit))\w*$/', $_GET['a'])) {
            return;
        }

        //获取func_router，并查找相应func_parent
        $strRouter = $_GET['m'] . '/' . $_GET['c'] . '/' . $_GET['a'];
//        $strRouter = 'system/organization/add';//测试代码
        $arrFunc = $this->_getFuncService()->getOneFuncByField(array('func_router' => $strRouter));
        if (empty($arrFunc)) {
            $this->apiError(Code::COMM_FUNC_INEXIS, '操作功能不存在，字段权限校验失败');
        }

        //通过func_parent（func_parent存的是func_id）查找对应视图权限的func_code
        $arrFuncView = $this->_getFuncService()->getOneFuncByField(array('func_id' => $arrFunc['func_parent']));
        if (empty($arrFuncView)) {
            $this->apiError(Code::COMM_FUNC_INEXIS, '视图功能不存在，字段权限校验失败');
        }
        $strFuncCode = $arrFuncView['func_code'];

        //如果是复杂业务，则调用该类中的写死的方法进行校验（存在则校验，不存在则什么也不做）
        if (false) {
            $strClass = 'app\\' . $_GET['m'] . '\\Controller\\' . $_GET['c'] . 'Controller';
            if (!class_exists($strClass)) {
                $this->apiError(Code::COMM_FUNC_INEXIS, '该类不存在');
            }
            $objClass = new $strClass();
            $strAction = $_GET['a'] . 'ParamsCheck';
            if (method_exists($objClass, $strAction)) {
                $objClass->$strAction();
            }
            return;
        }

        //通过视图func_code，查找功能全字段
        $arrParamsAllRes = $this->_getTableService()->GetFuncInfo($strFuncCode);
        if ($arrParamsAllRes[0] != Code::CODE_SUCCESS) {
            $this->apiError($arrParamsAllRes[0], $arrParamsAllRes[1]);
        }
        $strParamsAllJson = $arrParamsAllRes[1]['func_extra'] ?? '';
        $arrParamsAll = json_decode($strParamsAllJson, true) ?? array();

        //通过视图func_code和角色id，查找角色拥有字段
        $arrParamsRoleRes = $this->_getTableService()->getRoleFields($strFuncCode, $arrRoleIds);
        if ($arrParamsRoleRes[0] != Code::CODE_SUCCESS) {
            $this->apiError($arrParamsRoleRes[0], $arrParamsRoleRes[1]);
        }
        $arrParamsRole = $arrParamsRoleRes[1];

        //获取所有拥有"写权限"的字段（只读权限2不能操作）
        $arrParamsAdmit = array();//允许操作的所有字段信息数组
        foreach ($arrParamsAll AS $iKey => $arrParam) {
            if ($arrParamsRole[$arrParam['field']] == SystemEnum::FUNC_PARAM_TYPE_ALL) {
                $arrParamsAdmit[$iKey] = $arrParam;
            }
        }
        if (empty($arrParamsAdmit)) {
            $this->apiError(Code::COMM_ACCESS_DENY, '您无权操作任何字段');
        }

        //校验每个入参是否有权限操作
        $arrParamsKeysAdmit = array_column($arrParamsAdmit, 'field');//所有能查看的字段的key
        $arrParamsKeysIn = array_keys($_POST);//所有入参字段的key
        foreach ($arrParamsKeysIn AS $strParamIn) {
            if (!in_array($strParamIn, $arrParamsKeysAdmit)) {
                $this->apiError(Code::COMM_ACCESS_DENY, $strParamIn . '字段您无权操作');
            }
        }

        //将所有允许操作的字段数组，改为 field_name => arrParam 的形式
        $arrField2Param = array();
        foreach ($arrParamsAdmit AS $arrParam) {
            $arrField2Param[$arrParam['field']] = $arrParam;
        }

        //对每个入参进行正则校验
        foreach ($_POST AS $strKey => $strValue) {
            if ($strKey === '' || $arrField2Param[$strKey]['match'] === '') {
                continue;
            }

            if (!preg_match($arrField2Param[$strKey]['match'], $strValue)) {
                $this->apiError(Code::COMM_ACCESS_DENY, $strParamIn . '字段格式有误');
            }
        }
    }

    /**
     * 检查详情页所有出参中的字段是否具备权限，若有权限则标明是什么权限
     * @author: nzw
     * @date: 2018-05-14
     * @param array $arrParamsOut 出参数组（key => value形式的一维数组）
     * @param string $strRouter 该详情页对应（列表页）的视图权限的路由（形如：system/User/Index）
     * @return: array 最终详情结果数组
     */
    protected function checkParamsOut(array $arrParamsOut, string $strRouter, array $arrRoleIds)
    {
        if (empty($arrParamsOut) || empty($arrRoleIds)) {
            return array();
        }
        if ($strRouter === '') {
            $this->apiError(Code::COMM_PARAM_REQUIRED, '视图功能路由为空');
        }

        //获取视图权限信息
        $arrFunc = $this->_getFuncService()->getOneFuncByField(array('func_router' => $strRouter,
            'func_type' => SystemEnum::FUNC_TYPE_VIEW));
        if (empty($arrFunc)) {
            $this->apiError(Code::COMM_PARAM_ERROR, '视图功能路由有误');
        }

        //通过视图func_code和角色id，查找角色拥有的可操作字段（或是全部权限，或是只有可读权限）
        $arrParamsRoleRes = $this->_getTableService()->getRoleFields($arrFunc['func_code'], $arrRoleIds);
        if ($arrParamsRoleRes[0] != Code::CODE_SUCCESS) {
            $this->apiError($arrParamsRoleRes[0], $arrParamsRoleRes[1]);
        }
        $arrParamsAdmit = $arrParamsRoleRes[1];
        if (empty($arrParamsAdmit)) {
            return array();
        }

        //循环判断出参是否有权限，删除没有权限的数据并返回
        $arrRes = array();
        $arrParamsAdmitKeys = array_keys($arrParamsAdmit);
        foreach ($arrParamsOut AS $strKey => $strValue) {
            if (in_array($strKey, $arrParamsAdmitKeys)) {
                $arrRes[$strKey]['auth'] = (int) $arrParamsAdmit[$strKey];
                $arrRes[$strKey]['value'] = $strValue;
            }
        }
        return $arrRes;
    }

    /**
     * 判断$number是否为数字
     * @author: nzw
     * @date: 2018-05-10
     * @param $number 数字
     * @param bool $isUnsigned 必须为无符号数字（必须>=0） 默认false不判断
     * @param bool $isInt 必须为整型 默认false不判断
     * @return $number 失败直接退出，成功返回原值
     */
    public function isNumber($number, bool $isUnsigned = false, bool $isInt = false, string $fieldName = '')
    {
        $alertInfo = ($fieldName === '') ? $number : $fieldName;

        //判断$number是否为数字
        if (!is_numeric($number)) {
            $this->apiError(Code::COMM_PARAM_ERROR, $alertInfo . '字段应为数字类型');
        }

        //判断$number是否为无符号数字
        if ($isUnsigned && $number < 0) {
            $this->apiError( Code::COMM_PARAM_ERROR, $alertInfo . '字段应为无符号类型');
        }

        //判断$number是否为整型数字
        if ($isInt) {
            //如果是字符串，那么字符串也必须是数字
            if (is_string($number) && (intval($number) == $number)) {
                return $number;
            }
            //如果不是字符串则必须为整型
            if (!is_int($number)) {
                $this->apiError(Code::COMM_PARAM_ERROR, $alertInfo . '字段应为整型');
            }
        }

        return $number;
    }

    /**
     * 获得截取$decimalNum位小数的float型数字
     * @author: nzw
     * @date: 2018-05-10
     * @param $number 数字
     * @param int $decimalNum 小数位数（若$isInt = true时，$decimalNum填写0即可，填其他任意数字也可以，此时该参数已没有用了）
     * @param bool $isUnsigned 必须为无符号数字（必须>=0） 默认false不判断
     * @param bool $isInt 必须为整型 默认false不判断
     * @return $number 失败直接退出，成功返回截取后的float类型的数字
     */
    public function getNumber($number, int $decimalNum = 2, bool $isUnsigned = false, bool $isInt = false)
    {
        //判断是否是数字
        $number = self::isNumber($number, $isUnsigned, $isInt);

        //判断$decimalNum是否为整型数字，如果是字符串，那么字符串也必须是整型
        if (!is_int($decimalNum) || (is_string($decimalNum) && (intval($decimalNum) != $decimalNum))) {
            $this->apiError(Code::COMM_PARAM_ERROR, '字段应为整型');
        }

        //判断小数位数$decimalNum，其必须大于0
        if ($decimalNum < 0) {
            $this->apiError(Code::COMM_PARAM_ERROR, '字段应为无符号类型');
        }

        //返回最终结果
        return round($number, $decimalNum);
    }

    /**
     * 入参非空检验
     * @author nzw
     * @date: 2018-05-10
     * @param mix $param 待验证参数
     * @param bool $isCheckLen 是否检验长度，默认false为不检查
     * @param bool $isFixedLen 是否为固定长度，默认false为非固定
     * @param string $fieldName 错误字段名称
     * @param int $length 要求最大长度
     * @return $param 检验失败直接返回错误信息 通过返回空void继续执行
     */
    public function checkParam($param, bool $isCheckLen = false, bool $isFixedLen = false, string $fieldName = '', int $length = 20)
    {
        //检验非空
        if (empty($param) && $param != '0') {
            $this->apiError(Code::COMM_PARAM_ERROR, $fieldName . '参数不能为空');
        }

        if ($isCheckLen) {
            self::checkLength($param, $isFixedLen, $fieldName, $length);
        }
    }

    /**
     * 入参长度检验
     * @author nzw
     * @date: 2018-05-10
     * @param mix $param 待验证参数
     * @param bool $isFixedLen 是否为固定长度，默认false为非固定
     * @param string $fieldName 错误字段名称
     * @param int $length 要求最大长度
     * @return $param 检验失败直接返回错误信息 通过返回空void继续执行
     */
    public function checkLength($param, bool $isFixedLen = false, string $fieldName = '', int $length = 20)
    {
        //$param必须为1.数字；2.字符串；3.数字字符串
        if ((!is_string($param) && !is_numeric($param)) && !empty($param)) {
            $this->apiError(Code::COMM_PARAM_ERROR, $fieldName . '参数应该数字类型');
        }

        if ($isFixedLen) {//校验固定长度
            if ($length != mb_strlen($param, 'UTF8')) {
                $this->apiError( Code::COMM_PARAM_ERROR, $fieldName . '参数长度有误');
            }
        } else {//检验最大长度
            if ($length < mb_strlen($param, 'UTF8')) {
                $this->apiError(Code::COMM_PARAM_ERROR, $fieldName . '参数超过超限');
            }
        }
    }

    /**
     * 判断数字的整数和小数部分位数
     * @author: nzw
     * @date: 2018-05-10
     * @param $number 数字
     * @param unsigned int $iIntNum 数字整数位数
     * @param unsigned int $iDecimalNum 数字小数位数
     * @param bool $isFixedLen 是否为固定长度，默认false为非固定
     * @param string $fieldName 错误字段名称
     */
    public function checkFloat($number, int $iIntNum, int $iDecimalNum, bool $isFixedLen = false, string $fieldName = '')
    {
        if ($iIntNum < 0 || $iDecimalNum < 0) {
            $this->apiError(Code::COMM_PARAM_ERROR, $fieldName . '参数应为浮点类型');
        }

        self::isNumber($number, false, false, $fieldName);

        $arrNumber = explode('.', $number);
        if ($isFixedLen) {//固定长度
            if (mb_strlen($arrNumber[0]) != $iIntNum) {
                $this->apiError(Code::COMM_PARAM_ERROR, $fieldName . '参数整数位长度有误');
            }
            if (mb_strlen($arrNumber[ 1 ] ) != $iDecimalNum) {
                $this->apiError(Code::COMM_PARAM_ERROR, $fieldName . '参数小数位长度有误');
            }
        } else {//非固定长度
            if ($iIntNum < mb_strlen($arrNumber[0])) {
                $this->apiError(Code::COMM_PARAM_ERROR, $fieldName . '参数整数位长度超限');
            }
            if ($iDecimalNum < mb_strlen($arrNumber[1])) {
                $this->apiError(Code::COMM_PARAM_ERROR, $fieldName . '参数小数位长度超限');
            }
        }
    }

    /**
     * html实体和字符串之间相互转化
     * @author: nzw
     * @date: 2018-05-10
     * @param string $str | 待处理的字符串
     * @param bool $boolStrToHtml | 为true时是将字符串转化为html实体，为false时是将html实体转化为字符串
     * @return $str 返回转化后的字符串
     */
    public function strTransfer($str, bool $boolStrToHtml = true)
    {
        $arrHtml = ['&amp;', '&quot;', '&#39;', '&lt;', '&gt;', '&lt;', '&gt;', '&nbsp;'];
        $arrStr = ['&', '"', "'", '<', '>', '%3C', '%3E', ' '];

        if ($boolStrToHtml) {//由字符串转换为html实体
            $str = str_replace($arrStr, $arrHtml, $str);
        } else {//由html实体转换为字符串
            $str = str_replace($arrHtml, $arrStr, $str);
        }
        return $str;
    }

    /**
     * @return FuncService
     */
    private function _getFuncService()
    {
        return ChelerApi::getService('system\service\Func');
    }

    /**
     * @return TableService
     */
    private function _getTableService()
    {
        return ChelerApi::getService('common\service\Table');
    }
}