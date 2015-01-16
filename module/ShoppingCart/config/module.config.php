<?php
return [
    'router'          => [
        'routes' => [
            // The following is a route to simplify getting started creating
            // new controllers and actions without needing to create a new
            // module. Simply drop new controllers in, and you can access them
            // using the path /application/:controller/:action
            'cart'          => [
                'type'    => 'Literal',
                'options' => [
                    'route'    => '/cart',
                    'defaults' => [
                        '__NAMESPACE__' => 'ShoppingCart\Controller',
                        'controller'    => 'Index',
                        'action'        => 'index',
                    ],
                ],
            ],
            'cart-add' => array(
                'type'    => 'Segment',
                'options' => array(
                    'route'    => '/cart/add[/:hash]',
                    'defaults' => [
                        '__NAMESPACE__' => 'ShoppingCart\Controller',
                        'controller'    => 'Index',
                        'action'        => 'add',
                    ],
                ),
            ),
            'cart-delete' => array(
                'type'    => 'Segment',
                'options' => array(
                    'route'    => '/cart/delete[/:id]',
                    'defaults' => [
                        '__NAMESPACE__' => 'ShoppingCart\Controller',
                        'controller'    => 'Index',
                        'action'        => 'delete',
                    ],
                ),
            ),
            'cart-empty' => array(
                'type'    => 'Segment',
                'options' => array(
                    'route'    => '/cart/empty',
                    'defaults' => [
                        '__NAMESPACE__' => 'ShoppingCart\Controller',
                        'controller'    => 'Index',
                        'action'        => 'empty',
                    ],
                ),
            ),
            'cart-exists' => array(
                'type'    => 'Segment',
                'options' => array(
                    'route'    => '/cart/exists',
                    'defaults' => [
                        '__NAMESPACE__' => 'ShoppingCart\Controller',
                        'controller'    => 'Index',
                        'action'        => 'exists',
                    ],
                ),
            ),
        ],
    ],
    'service_manager' => [
        'aliases'   => [
            'ShoppingCart\Model\ShoppingCart' => 'cart.service',
        ],
        'factories' => [
            'cart.service' => function ($sm) {
                // contexto aonde o login será armazenado
                $storage = new \ShoppingCart\Storage\Session();

                //Carrinho
                $cart = new ShoppingCart\Model\ShoppingCart( $storage );

                return $cart;
            }
        ],
    ],
    'controllers'     => [
        'invokables' => [
            'ShoppingCart\Controller\Index' => 'ShoppingCart\Controller\IndexController',
        ],
    ],
];