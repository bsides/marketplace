<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

return array(
    'router' => array(
        'routes' => array(
            // The following is a route to simplify getting started creating
            // new controllers and actions without needing to create a new
            // module. Simply drop new controllers in, and you can access them
            // using the path /application/:controller/:action
            'direct' => array(
                'type'    => 'Literal',
                'options' => array(
                    'route'    => '/direct',
                    'defaults' => array(
                        '__NAMESPACE__' => 'Direct\Controller',
                        'controller'    => 'Index',
                        'action'        => 'index',
                    ),
                ),
                'may_terminate' => true,
                'child_routes' => array(
                    'default' => array(
                        'type'    => 'Segment',
                        'options' => array(
                            'route'    => '/[:controller[/:action]]',
                            'constraints' => array(
                                'controller' => '[a-zA-Z][a-zA-Z0-9_-]*',
                                'action'     => '[a-zA-Z][a-zA-Z0-9_-]*',
                            ),
                            'defaults' => array(
                                'controller' => 'Direct\Controller\List',
                                'action'     => 'index',
                            ),
                        ),
                    ),
                    'list' => array(
                        'type'    => 'Segment',
                        'options' => array(
                            'route'    => '/list[/:action][/:id]',
                            'constraints' => array(
                                'action'     => '[a-zA-Z][a-zA-Z0-9_-]*',
                                'id'     => '[0-9]*',
                            ),
                            'defaults' => array(
                                'controller' => 'Direct\Controller\List',
                                'action'     => 'index',
                            ),
                        ),
                    ),
                    'deal' => array(
                        'type'    => 'Segment',
                        'options' => array(
                            'route'    => '/deal[/:action]',
                            'constraints' => array(
                                'action'     => '[a-zA-Z][a-zA-Z0-9_-]*',
                            ),
                            'defaults' => array(
                                'controller' => 'Direct\Controller\Deal',
                                'action'     => 'index',
                            ),
                        ),
                    ),
                    'advertiser' => array(
                        'type'    => 'Segment',
                        'options' => array(
                            'route'    => '/advertiser[/:action][/:id]',
                            'constraints' => array(
                                'action'     => '[a-zA-Z][a-zA-Z0-9_-]*',
                                'id'     => '[0-9]*',
                            ),
                            'defaults' => array(
                                'controller' => 'Direct\Controller\Advertiser',
                                'action'     => 'list',
                            ),
                        ),
                    ),
                ),
            ),
        ),
    ),
    'service_manager' => array(
        'factories' => array(
            'Column' => function() {
                return new \Direct\Model\Column();
            },
            'Newspaper' => function() {
                return new \Direct\Model\Newspaper();
            },
            'Category' => function() {
                return new \Direct\Model\Category();
            },
            'Color' => function() {
                return new \Direct\Model\Color();
            },
            'Determination' => function() {
                return new \Direct\Model\Determination();
            },
            'Format' => function() {
                return new \Direct\Model\Format();
            },
            'Profile' => function() {
                return new \Direct\Model\Profile();
            },
            'WeekDay' => function() {
                return new \Direct\Model\WeekDay();
            },
            'Advertiser' => function() {
                return new \Direct\Model\Advertiser();
            },
        ),
        'aliases' => array(
            'Direct\Model\Section' => 'Section',
        ),
    ),
    'controllers' => array(
        'invokables' => array(
            'Direct\Controller\Index' => 'Direct\Controller\IndexController',
            'Direct\Controller\List' => 'Direct\Controller\ListController',
            'Direct\Controller\Item' => 'Direct\Controller\ItemController',
            'Direct\Controller\Deal' => 'Direct\Controller\DealController',
            'Direct\Controller\UltimasCompras' => 'Direct\Controller\UltimasComprasController',
            'Direct\Controller\Advertiser' => 'Direct\Controller\AdvertiserController'
        ),
    ),
    'view_manager' => array(
        'display_not_found_reason' => true,
        'display_exceptions'       => true,
        'doctype'                  => 'HTML5',
        'not_found_template'       => 'error/404',
        'exception_template'       => 'error/index',
        'template_map' => array(
            'layout/layout'           => __DIR__ . '/../view/layout/layout.phtml',
            'application/index/index' => __DIR__ . '/../view/direct/index/index.phtml',
            'error/404'               => __DIR__ . '/../view/error/404.phtml',
            'error/index'             => __DIR__ . '/../view/error/index.phtml',
        ),
        'template_path_stack' => array(
            __DIR__ . '/../view',
        ),
        'strategies' => array(
            'ViewJsonStrategy',
        ),
    ),
    // Placeholder for console routes
    'console' => array(
        'router' => array(
            'routes' => array(
            ),
        ),
    ),
);
