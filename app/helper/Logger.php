<?php
namespace app\helper;

use frame\ChelerApi;
use app\dao\logger\LoggerDao;

/**
* 日志类
* 日志配置项：DEBUG < INFO < WARN < ERROR 
* @author hanliqiang
* @date 2018年4月25日
*/
class Logger {
    /**
    * debug日志，主要用于开发过程中打印一些运行信息
    * @param 
    * @author hanliqiang
    * @date 2018年4月26日
    */
    static function DebugLog(string $info){
        $module = $_GET['_v'] . '/' . $_GET['m'] . '/' . $_GET['c'] . '/' . $_GET['a'];
        $data = [
            'logger_api_type' => 'Debug',
            'logger_api_uri' => $module,
            'info' => $info,
        ];
        self::_getLoggerDao()->addlog($data);
    }
    
    /**
    * 级别上突出强调应用程序的运行过程,打印一些你感兴趣的或者重要的信息，
    * 这个可以用于生产环境中输出程序运行的一些重要信息，但是不能滥用，避免打印过多的日志。
    * @param 
    * @author hanliqiang
    * @return 
    * @date 2018年4月26日
    */
    static function InfoLog(string $info){
        $module = $_GET['_v'] . '/' . $_GET['m'] . '/' . $_GET['c'] . '/' . $_GET['a'];
        $data = [
            'logger_api_type' => 'Info',
            'logger_api_uri' => $module,
            'info' => $info,
        ];
        self::_getLoggerDao()->addlog($data);
    }
    
    /**
    * 表明会出现潜在错误的情形，有些信息不是错误信息，但是也要给程序员的一些提示
    * @param 
    * @author hanliqiang
    * @return 
    * @date 2018年4月26日
    */
    static function WarnLog(string $info){
        $module = $_GET['_v'] . '/' . $_GET['m'] . '/' . $_GET['c'] . '/' . $_GET['a'];
        $data = [
            'logger_api_type' => 'Warn',
            'logger_api_uri' => $module,
            'info' => $info,
        ];
        self::_getLoggerDao()->addlog($data);
    }
    /**
    * 出虽然发生错误事件，但仍然不影响系统的继续运行。
    * 打印错误和异常信息，如果不想输出太多的日志，可以使用这个级别。
    * @param 
    * @author hanliqiang
    * @return 
    * @date 2018年4月26日
    */
    static function ErrorLog(string $info){
        $module = $_GET['_v'] . '/' . $_GET['m'] . '/' . $_GET['c'] . '/' . $_GET['a'];
        $data = [
            'logger_api_type' => 'Error',
            'logger_api_uri' => $module,
            'info' => $info,
        ];
        self::_getLoggerDao()->addlog($data);
    }
    
    /**
     * @return LoggerDao
     */
    private static function _getLoggerDao() {
        return ChelerApi::getDao('logger\Logger');
    }
}

