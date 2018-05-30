<?php
namespace app\demo\controller;

use frame\ChelerApi;
use app\helper\BaseController;
use app\demo\service\DemoService;

/**
 * Index.php
 * 描述
 * Date: 18-2-5
 */
class IndexController extends BaseController
{
    function index()
    {
//            $this->getRedis("demo")->set("hardy",123);
//            echo $this->getRedis("demo")->get("hardy");

//        $this->getMemcache("demo")->set("hardy_m",12222223);
//        echo $this->getMemcache("demo")->get("hardy_m");exit;
//        echo "hello world<br/>";
//        echo "<hr/>";
//
//        // service
        $this->init_db()->transaction_rollback();
        
        $res = $this->_getDemoService()->getUserInfo();
        $this->apiSuccess($res);
        
       echo "<hr/>";

//        echo $this->_getDemoService()->protoTest("1101","15109269355","test",1);

//         $this->apiError(40142, 'xxyy');
        $this->apiSuccess(['213 world']);
    }

    /**
     * @return DemoService
     */
    private function _getDemoService()
    {
        return ChelerApi::getService('demo\service\Demo');
    }

}