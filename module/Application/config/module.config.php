<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

return [
    'router' => [
        'routes' => [
            'home' => [
                'type' => 'Zend\Mvc\Router\Http\Literal',
                'options' => [
                    'route'    => '/',
                    'defaults' => [
                        'controller' => 'Application\Controller\Index',
                        'action'     => 'index',
                    ],
                ],
            ],
            'login' => array(
                'type'    => 'Literal',
                'options' => array(
                    'route'    => '/login',
                    'defaults' => array(
                        'controller' => 'Auth',
                        'action'     => 'login',
                    ),
                ),
            ),
            'logout' => array(
                'type'    => 'Literal',
                'options' => array(
                    'route'    => '/logout',
                    'defaults' => array(
                        'controller' => 'Auth',
                        'action'     => 'logout',
                    ),
                ),
            ),
            'search' => array(
                'type'    => 'Literal',
                'options' => array(
                    'route'    => '/search',
                    'defaults' => array(
                        'controller' => 'Application\Controller\Index',
                        'action'     => 'Index',
                    ),
                ),
            ),
            'purchases' => array(
                'type'    => 'Literal',
                'options' => array(
                    'route'    => '/purchases',
                    'defaults' => array(
                        'controller' => 'Application\Controller\Index',
                        'action'     => 'Index',
                    ),
                ),
            ),
            'bids' => array(
                'type'    => 'Literal',
                'options' => array(
                    'route'    => '/bids',
                    'defaults' => array(
                        'controller' => 'Application\Controller\Index',
                        'action'     => 'Index',
                    ),
                ),
            ),
            // The following is a route to simplify getting started creating
            // new controllers and actions without needing to create a new
            // module. Simply drop new controllers in, and you can access them
            // using the path /application/:controller/:action
            'application' => [
                'type'    => 'Literal',
                'options' => [
                    'route'    => '/application',
                    'defaults' => [
                        '__NAMESPACE__' => 'Application\Controller',
                        'controller'    => 'Index',
                        'action'        => 'index',
                    ],
                ],
                'may_terminate' => true,
                'child_routes' => [
                    'default' => [
                        'type'    => 'Segment',
                        'options' => [
                            'route'    => '/[:controller[/:action]]',
                            'constraints' => [
                                'controller' => '[a-zA-Z][a-zA-Z0-9_-]*',
                                'action'     => '[a-zA-Z][a-zA-Z0-9_-]*',
                            ],
                            'defaults' => [
                            ],
                        ],
                    ],
                ],
            ],
        ],
    ],
    'service_manager' => [
        'abstract_factories' => [
            'Zend\Cache\Service\StorageCacheAbstractServiceFactory',
            'Zend\Log\LoggerAbstractServiceFactory',
        ],
        'aliases' => [
            'translator' => 'MvcTranslator',
        ],
        'factories' => [
            'form.login' => function($sm) {
                return new \Application\Form\LoginFormBuilder();
            },
            'auth.service' => function ($sm) {
                // contexto aonde o login será armazenado
                $storage = new \Zend\Authentication\Storage\Session();

                // contexto utilizado como meio de autenticação
                $adapter = $sm->get( 'Cas\Core\CasAdapter' );

                // serviço de autenticação do Zend
                $authService = new \Zend\Authentication\AuthenticationService( $storage, $adapter );
                return $authService;
            }
        ],
        'invokables' => [
            'Zend\Authentication\AuthenticationService' => 'Zend\Authentication\AuthenticationService',
        ],
    ],
    'translator' => [
        'locale' => 'en_US',
        'translation_file_patterns' => [
            [
                'type'     => 'gettext',
                'base_dir' => __DIR__ . '/../language',
                'pattern'  => '%s.mo',
            ],
        ],
    ],
    'controllers' => [
        'invokables' => [
            'Application\Controller\Index' => 'Application\Controller\IndexController',
            'Auth'         => 'Application\Controller\AuthController',
        ],
    ],
    'view_manager' => [
        'display_not_found_reason' => true,
        'display_exceptions'       => true,
        'doctype'                  => 'HTML5',
        'not_found_template'       => 'error/404',
        'exception_template'       => 'error/index',
        'template_map' => [
            'layout/layout'           => __DIR__ . '/../view/layout/layout.phtml',
            'application/index/index' => __DIR__ . '/../view/application/index/index.phtml',
            'error/404'               => __DIR__ . '/../view/error/404.phtml',
            'error/index'             => __DIR__ . '/../view/error/index.phtml',
        ],
        'template_path_stack' => [
            __DIR__ . '/../view',
        ],
    ],
    // Placeholder for console routes
    'console' => [
        'router' => [
            'routes' => [
            ],
        ],
    ],
];
