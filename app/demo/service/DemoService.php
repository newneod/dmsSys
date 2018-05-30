<?php
namespace app\demo\service;

use Protocol\SmsTask;
use frame\runtime\CService;


/**
* DemoService
* @author hanliqiang
* @date 2018年5月3日
*/
class DemoService extends CService
{
    /**
     * 项目配置名
     * @var string
     */
    public $project = 'sms';

    public function getUserInfo()
    {
        return $this->init_db()->get_one_by_field(['id' => 1], 'car_member_car');
    }

    public function protoTest(string $templateId, string $phone, string $content, int $time)
    {
        $smsTask = new SmsTask();
        $smsTask->setTime($time);
        $smsTask->setTemplateId($templateId);
        $smsTask->setPhone($phone);
        $smsTask->setContent($content);
        $str = $this->getRequestStr($smsTask);
        $client = $this->getQueue($this->_conf[$this->project]['queue']['smsTasks']);
        $client->enQueue($this->_conf[$this->project]['queue']['smsTasks']['name'], $str);
        $this->close($client->getConnectOption());
    }

}