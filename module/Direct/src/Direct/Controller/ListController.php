<?php
/**
 * Predicta Market Place
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */
namespace Direct\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\JsonModel;

/**
 * Class ListController
 *
 * @package Direct\Controller
 */
class ListController extends AbstractActionController
{
    /**
     * @return array|JsonModel
     */
    public function indexAction()
    {
        return new JsonModel( [] );
    }

    /**
     * @return JsonModel
     */
    public function newspaperAction()
    {
        $service = $this->getServiceLocator()->get('direct.common.publisher');
        $id = $this->params('id', null);

        return new JsonModel($service->fetch($id)['data']);
    }

    /**
     * @return JsonModel
     */
    public function categoryAction()
    {
        $service = $this->getServiceLocator()->get('direct.common.category');
        $id = $this->params('id', null);

        return new JsonModel($service->fetch($id)['data']);
    }

    /**
     * @return JsonModel
     */
    public function colorAction()
    {
        $service = $this->getServiceLocator()->get('direct.newspaper.color');
        $id = $this->params('id', null);

        return new JsonModel($service->fetch($id)['data']);
    }

    /**
     * @return JsonModel
     */
    public function determinationAction()
    {
        $service = $this->getServiceLocator()->get('direct.newspaper.determination');
        $id = $this->params('id', null);

        return new JsonModel($service->fetch($id)['data']);
    }

    /**
     * @return JsonModel
     */
    public function formatAction()
    {
        $service = $this->getServiceLocator()->get('direct.common.format');
        $id = $this->params('id', null);

        return new JsonModel($service->fetch($id)['data']);
    }

    /**
     * @return JsonModel
     */
    public function weekDayAction()
    {
        $service = $this->getServiceLocator()->get('direct.common.weekday');
        $id = $this->params('id', null);

        return new JsonModel($service->fetch($id)['data']);
    }

    /**
     * @return JsonModel
     */
    public function advertiserAction()
    {
        $service = $this->getServiceLocator()->get('direct.common.advertiser');
        $id = $this->params('id', null);

        return new JsonModel($service->fetch($id)['data']);
    }

    /**
     * @return JsonModel
     */
    public function regionAction()
    {
        $service = $this->getServiceLocator()->get('direct.common.geo.state');
        $id = $this->params('id', null);

        return new JsonModel($service->fetch($id)['data']);
    }
}
