<?php

use Phalcon\Mvc\View;
use Phalcon\Mvc\View\Engine\Php as PhpEngine;
use Phalcon\Mvc\Url as UrlResolver;
use Phalcon\Mvc\View\Engine\Volt as VoltEngine;
use Phalcon\Mvc\Model\Metadata\Memory as MetaDataAdapter;
// use Phalcon\Session\Manager;
use Phalcon\Session\Adapter\Files as SessionAdapter;
use Phalcon\Flash\Direct as Flash;
// use Phalcon\Di\FactoryDefault;


// $di = new FactoryDefault();


$di->setShared('mail', function () {
    return new MailController();
});

/**
 * Shared configuration service
 */
$di->setShared('config', function () {
    return new \Phalcon\Config\Adapter\Ini(APP_PATH . "/config/config.ini");
});

/**
 * The URL component is used to generate all kind of urls in the application
 */
$di->setShared('url', function () {
    $config = $this->getConfig();

    $url = new UrlResolver();
    $url->setBaseUri($config->application->baseUri);

    return $url;
});

/**
 * Setting up the view component
 */
$di->setShared('view', function () {
    $config = $this->getConfig();

    $view = new View();
    $view->setDI($this);
    $view->setViewsDir($config->application->viewsDir);

    $view->registerEngines([
        '.volt' => function ($view) {
            $config = $this->getConfig();

            $volt = new VoltEngine($view, $this);

            $volt->setOptions([
                'compiledPath' => $config->application->cacheDir,
                'compiledSeparator' => '_',
                'compileAlways' => true,
                'stat' => true
            ]);

            $compiler = $volt->getCompiler();
            $compiler->addFunction('number_format', function ($resolvedArgs, $exprArgs) use ($compiler) {
                $firstArgument = $compiler->expression($exprArgs[0]['expr']);
                return 'number_format('.$firstArgument.", 0, '.', '.')";
            });
            $compiler->addFunction('decimal_format', function ($resolvedArgs, $exprArgs) use ($compiler) {
                $firstArgument = $compiler->expression($exprArgs[0]['expr']);
                return 'number_format('.$firstArgument.", 2, ',', '.')";
            });
            $compiler->addFunction('currency_format', function ($resolvedArgs, $exprArgs) use ($compiler) {
                $session = $this->getShared('session');
                $curr = $session->get('currency')['converted'];
                $rate = $session->get('currency')['rate'];
                $firstArgument = $compiler->expression($exprArgs[0]['expr']);
                if($curr == 'IDR'){
                    return 'number_format('.$firstArgument.'*'.$rate.", 0, '.', ',')";
                }else{
                    return 'number_format('.$firstArgument.'*'.$rate.", 2, '.', ',')";
                }
            });
            return $volt;
        },
        '.phtml' => PhpEngine::class

    ]);

    return $view;
});

/**
 * Database connection is created based in the parameters defined in the configuration file
 */
$di->setShared('db', function () {
    $config = $this->getConfig();

    $class = 'Phalcon\Db\Adapter\Pdo\\' . $config->database->adapter;
    $params = [
        'host'     => $config->database->host,
        'username' => $config->database->username,
        'password' => $config->database->password,
        'dbname'   => $config->database->dbname,
        'charset'  => $config->database->charset
    ];

    if ($config->database->adapter == 'Postgresql') {
        unset($params['charset']);
    }

    if (isset($config->database->port)) {
        $params['port'] = $config->database->port;
    }

    $connection = new $class($params);

    return $connection;
});


/**
 * If the configuration specify the use of metadata adapter use it or use memory otherwise
 */
$di->setShared('modelsMetadata', function () {
    return new MetaDataAdapter();
});

/**
 * Register the session flash service with the Twitter Bootstrap classes
 */
$di->set('flash', function () {
    return new Flash([
        'error'   => 'alert alert-danger',
        'success' => 'alert alert-success',
        'notice'  => 'alert alert-info',
        'warning' => 'alert alert-warning'
    ]);
});

/**
 * Start the session the first time some component request the session service
 */
$di->setShared('session', function () {
    $session = new SessionAdapter();
    $session->start();

    return $session;
});
