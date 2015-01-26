<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace Application;

use Zend\Log\Logger;
use Zend\Mvc\ModuleRouteListener;
use Zend\Mvc\MvcEvent;
use Application\ErrorHandling as ApplicationErrorHandling;
use Zend\Log\Writer\Stream as LogWriterStream;

class Module
{
    public function onBootstrap(MvcEvent $e)
    {
        // Aplicação
        $app = $e->getApplication();
        // Event manager
        $em = $app->getEventManager();
        // Service Manager
        $sm = $app->getServiceManager();

        $em->attach('dispatch.error', function($event){
            $exception = $event->getResult()->exception;
            if ($exception) {
                $sm = $event->getApplication()->getServiceManager();
                $service = $sm->get('ApplicationServiceErrorHandling');
                $service->logException($exception);
            }
        });

        $moduleRouteListener = new ModuleRouteListener();
        $moduleRouteListener->attach($em);
        $authService = $sm->get('auth.service');
        $this->restrictLogin($e, $authService, ['login'], 'login');
    }

    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
    }

    public function getAutoloaderConfig()
    {
        return [
            'Zend\Loader\StandardAutoloader' => [
                'namespaces' => [
                    __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                ],
            ],
        ];
    }

    /**
     * Restringe o acesso às páginas fora da white list. útil para controlar login.
     *
     * @param Zend\Mvc\MvcEvent $e               Instância
     * @param Mixed             $authService     Instância do serviço de autenticação
     * @param Array             $whiteListRoutes Lista de rotas na white list (Sem precisar de login)
     * @param String            $loginRoute      Nome da rota para o login
     * @link http://stackoverflow.com/questions/14137868/zend-framework-2-global-check-for-authentication-with-zfcuser
     * @return void
     */
    private function restrictLogin(MvcEvent $e, $authService, array $whiteListRoutes = ['login'], $loginRoute = 'login')
    {
        // Aplicação
        $app = $e->getApplication();
        // Event manager
        $em = $app->getEventManager();
        // Service Manager
        $sm = $app->getServiceManager();

        $em->attach(MvcEvent::EVENT_ROUTE, function($e) use ($authService, $whiteListRoutes, $loginRoute) {
            //Response
            $response = $e->getResponse();
            //Request
            $request = $e->getRequest();
            //Route Match
            $match = $e->getRouteMatch();
            // A rota não existe 404
            if (!$match instanceof \Zend\Mvc\Router\Http\RouteMatch) {
                return;
            }
            // A rota acessada está na white list. O usuário pode continuar o acesso
            $name = $match->getMatchedRouteName();
            if (in_array($name, $whiteListRoutes)) {
                return;
            }
            // Usuário está autenticado. O usuário pode continuar o acesso
            if ($authService->hasIdentity()) {
                return;
            }

            //Se for chamada Ajax e o usuário não está logado
            //Retorna http error 401
            if ($request->isXmlHttpRequest()) {
                $response->setStatusCode(401);
                return $response;
            }

            // Troca a rota para a qual o usuário será redirecionado
            $router = $e->getRouter();
            $url = $router->assemble([], [
                'name' => $loginRoute
            ]);
            // Redireciona o usuário
            $response->getHeaders()->addHeaderLine('Location', $url);
            $response->setStatusCode(302);
            return $response;
        }, -100);
    }

    public function getServiceConfig()
    {
        return [
            'factories' => [
                'ApplicationServiceErrorHandling' =>  function($sm) {
                    $logger = $sm->get('ZendLog');
                    $service = new ApplicationErrorHandling($logger);
                    return $service;
                },
                'ZendLog' => function ($sm) {
                    $filename = 'log_' . date('Y-m-d') . '.txt';
                    $log = new Logger();
                    $writer = new LogWriterStream('./data/logs/' . $filename);
                    $log->addWriter($writer);

                    return $log;
                },
            ],
        ];
    }
}
