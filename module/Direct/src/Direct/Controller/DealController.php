<?php
/**
 * Predicta Market Place
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */
namespace Direct\Controller;

use Exception;
use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\JsonModel;
use Direct\Model;

/**
 * Class DealController
 *
 * @package Direct\Controller
 */
class DealController extends AbstractActionController
{

    public function indexAction()
    {
        return new JsonModel( [] );
    }

    /**
     * @return array|JsonModel
     */
    public function sendAction()
    {
        $cart = $this->getServiceLocator()->get('cart.service');
        $request = $this->getRequest();
        if ($request->isPost() && count($cart->items) > 0) {
            try {
                $deal = new Model\Deal();
                $deal->save($cart->items);
                $cart->clear();
                return new JsonModel( ['result' => 'success'] );
            } catch ( Exception $e ) {
                $this->getResponse()->setStatusCode(418);
            }
        }
        return new JsonModel( [] );
    }

}
