<?php
  require_once __DIR__.'/../vendor/autoload.php';

  $app = new Silex\Application();
  
  $app['debug'] = true;

  $app->get('/', function() use($app) {
      return 'Parrots @' . gethostname() . ' (PHP7)';
  });
  
  $app->run();
?>