<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
date_default_timezone_set('America/New_York');
require __DIR__.'/../vendor/autoload.php';
use \Bakken\App;
App::run();
?>
