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
        $post = $this->getRequest()->getPost()->toArray();
        $deal = new Model\Deal();
        $deal->save($post);
        return new JsonModel( ['result' => 'success'] );
    }

}
