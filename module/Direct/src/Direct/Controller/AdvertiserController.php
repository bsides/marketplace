<?php
namespace Direct\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\Session\Container;
use Zend\View\Model\JsonModel;
use Direct\Model;

class AdvertiserController extends AbstractActionController {

    /**
     * @return JsonModel
     */
    public function listAction()
    {
        $service = $this->getServiceLocator()->get('direct.common.advertiser');
        $id = $this->params('id', null);

        return new JsonModel($service->fetch($id)['data']);
    }

    /**
     * @return JsonModel
     */
    public function setAction()
    {
        if ('0' !== ($id = (int) $this->params('id'))) {
            $session = new Container('advertiser');
            $session->advertiser_id = $id;
        }
        return new JsonModel([]);
    }

    /**
     * @return JsonModel
     */
    public function getAction()
    {
        $session = new Container('advertiser');
        $retorno = [];
        if ($session && $session->advertiser_id) {
            $retorno['advertiser_id'] = $session->advertiser_id;
        }

        return new JsonModel($retorno);
    }
}
