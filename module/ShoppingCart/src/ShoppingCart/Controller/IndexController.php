<?php
namespace ShoppingCart\Controller;

use ArrayObject;
use Zend\Json\Json;
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
                if (is_object($publisher))
                    $publisher = (array) $publisher;

                if (isset($return[$publisher['id']]))
                    continue;

                $return[$publisher['id']]['id'] = $publisher['id'];
                $return[$publisher['id']]['description'] = $publisher['description'];
                $return[$publisher['id']]['comment'] = '';
                $return[$publisher['id']]['items'] = array_filter($array_object, function($item) use ($publisher) { return count(array_diff((array) $item['features']['publisher'], $publisher)) == 0; });
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
            $item = new Model\Item(['hash' => $hash, 'features' => reset($features)]);
            $cart->addItem($item);
        }
        return new JsonModel(['message' => 'success']);
    }

    public function deleteAction()
    {
        if ('0' !== ($hash = (string) $this->params('id'))) {
            $cart = $this->getServiceLocator()->get('cart.service');
            $cart->removeItem($hash);
        }
        return new JsonModel(['message' => 'success']);
    }

    public function emptyAction()
    {
        $cart = $this->getServiceLocator()->get('cart.service');
        $cart->clear();
        return new JsonModel(['message' => 'success']);
    }

    public function updateAction()
    {
        $cart = $this->getServiceLocator()->get('cart.service');
        $request = $this->getRequest();
        if ($request->isPost()) {
            try {
                $post = Json::decode($this->getRequest ()->getContent());
                foreach($post as $publisher_line) {
                    foreach($publisher_line->items as $item) {
                        $item_cart = new Model\Item();
                        $item_cart->hash = $item->hash;
                        $item_cart->features = (new ArrayObject($item->features))->getArrayCopy();
                        $item_cart->ads = (new ArrayObject($item->ads))->getArrayCopy();;
                        $item_cart->price = $item->price;
                        $cart->addItem($item_cart);
                    }
                }
                return new JsonModel( ['result' => 'success'] );
            } catch ( Exception $e ) {
                $this->getResponse()->setStatusCode(418);
            }
        }
        return new JsonModel( [] );
    }
}
