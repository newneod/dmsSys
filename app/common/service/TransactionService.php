<?php
namespace app\common\service;

use frame\runtime\CService;

/**
 * 事务服务类
 * @author: nzw
 * @date: 2018-05-14
 */
class TransactionService extends CService
{
    /**
     * transaction_start
     * @author: nzw
     * @date: 2018-05-14
     */
    public function start()
    {
        $this->init_db()->transaction_start();
    }

    /**
     * transaction_rollback
     * @author: nzw
     * @date: 2018-05-14
     */
    public function rollback()
    {
        $this->init_db()->transaction_rollback();
    }

    /**
     * transaction_commit
     * @author: nzw
     * @date: 2018-05-14
     */
    public function commit()
    {
        $this->init_db()->transaction_start();
    }
}
