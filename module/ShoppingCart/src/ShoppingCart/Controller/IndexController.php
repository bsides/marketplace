<?php
namespace ShoppingCart\Controller;

use ArrayObject;
use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\JsonModel;
use ShoppingCart\Model;

class IndexController extends AbstractActionController
{
    public function indexAction()
    {
        $cart = $this->getServiceLocator()->get('cart.service');
        $return = [];
        if (count($cart->items) > 0) {
            $array_object = array_map(function($a) { return (new ArrayObject($a))->getArrayCopy(); }, $cart->items);
            $publishers = array_column(array_column($array_object, 'features'), 'publisher');
            foreach($publishers as $publisher) {
                if (isset($return[$publisher['id']]))
                    continue;

                $return[$publisher['id']]['id'] = $publisher['id'];
                $return[$publisher['id']]['description'] = $publisher['description'];
                $return[$publisher['id']]['comment'] = '';
                $return[$publisher['id']]['items'] = array_filter($array_object, function($item) use ($publisher) { return count(array_diff($item['features']['publisher'], $publisher)) == 0; });
            }
            $return = array_filter($return, function($item) { return count($item['items']) > 0; });
        }
        return new JsonModel($return);
    }

    public function addAction()
    {
        if ('0' !== ($hash = (string) $this->params('hash'))) {
            $service = $this->getServiceLocator()->get('direct.newspaper.item');
            $params = $this->getRequest()->getQuery()->toArray();
            $features = array_filter($service->find($params)['data'], function($item) use ($hash) { return $item['hash'] == $hash; });

            $cart = $this->getServiceLocator()->get('cart.service');
            $item = new Model\Item(array('hash' => $hash, 'features' => reset($features)));
            $cart->addItem($item);
        }
        return new JsonModel(['message' => 'success']);
    }

    public function deleteAction()
    {
        $request = $this->getRequest();
        if ('0' !== ($hash = (string) $this->params('id'))) {
            $cart = $this->getServiceLocator()->get('cart.service');
            $cart->removeItem($hash);
        }
        return new JsonModel(['message' => 'success']);
    }

    public function emptyAction()
    {
        $request = $this->getRequest();
        $cart = $this->getServiceLocator()->get('cart.service');
        $cart->clear();
        return new JsonModel(['message' => 'success']);
    }

    public function existsAction()
    {
        $request = $this->getRequest();
        if ($request->isXmlHttpRequest() === FALSE)
            return new JsonModel([]);

        $return = FALSE;
        if ($request->isPost()) {
            $cart = $this->getServiceLocator()->get('cart.service');
            $hash = $request->getPost('hash');
            $return = $cart->itemExists($hash);
        }
        return new JsonModel(['return' => $return]);
    }
}