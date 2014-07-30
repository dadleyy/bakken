<?php namespace Bakken;

use \Illuminate\Http\Request;
use \Illuminate\Http\Response;

class App {

  private static function missing() {
    $response = new Response();
    $response->setStatusCode(404);
    return $response->send();
  }

  public static function run() {
    $request = Request::createFromGlobals();
    $response = new Response();

    if(!$request->get('url'))
      return static::missing();

    $image_url = $request->get('url');
    $image = new Image($image_url);

    if($image->isValid() == false)
      return static::missing();

    if(!$image->exists()) {
      $blur_amt = (int)($request->get('blur') ? $request->get('blur') : 170);
      $response->header('X-Blur-Amt', $blur_amt);
      $image->addFilter($blur_amt);
      $image->save();
    }

    $image_data = $image->getData();

    $response->header('Content-Type', 'image/jpeg');
    $response->setContent($image_data);

    $image->destroy();
    $response->send();
  }

}


?>
