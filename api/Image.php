<?php namespace Bakken;

use \Illuminate\Filesystem\Filesystem;

class Image {

  private $image_handle;
  private $image_name;
  private $image_url;
  private $width;
  private $height;

  function __construct($image_url, $width=800, $height=600) {
    $this->image_handle = false;

    $this->image_url = $image_url;
    $this->image_name = basename($image_url);
    $this->width = $width;
    $this->height = $height;

    if($this->exists())
      $this->loadLocal();
    else
      $this->loadRemote();
  }

  public function save() {
    if(!$this->isValid())
      return false;

    imagejpeg($this->image_handle, $this->filename());

    return true;
  }

  private function loadLocal() {
    $this->image_handle = imagecreatefromjpeg($this->filename());
  }

  public function exists() {
    $image_path = $this->filename();
    $fs = new Filesystem();
    $exists = $fs->exists($image_path);
    return $exists;
  }

  private function filename() {
    $image_name = $this->image_name;
    return __DIR__.'/../storage/'.$image_name;
  }

  private function loadRemote() {
    $image_url = $this->image_url;
    $width = $this->width;
    $height = $this->height;

    try {
      // start by getting the dimensions of the image
      $source_dimensions = @getimagesize($image_url);
    } catch(Exception $e) {
      return;
    }

    if(!is_array($source_dimensions))
      return;

    $source_width = $source_dimensions[0];
    $source_height = $source_dimensions[1];


    // create image handles for the original, and the new one to be rendered
    $source_image = imagecreatefromjpeg($image_url);
    $temp_image = imagecreatetruecolor($width, $height);

    // copy the old image into the new one
    imagecopyresized($temp_image, $source_image, 0, 0, 0, 0, $width, $height, $source_width, $source_height);

    // clean up the temporary oldimage
    imagedestroy($source_image);

    // save the new image has the image handle
    $this->image_handle = $temp_image;
  }

  public function isValid() {
    return $this->image_handle != false;
  }

  public function addFilter($amount=180) {
    if(!$this->isValid())
      return false;

    $handle = $this->image_handle;
    for($i = 0; $i < $amount; $i++)
      imagefilter($this->image_handle, IMG_FILTER_GAUSSIAN_BLUR);

    return true;
  }

  public function getData() {
    if(!$this->isValid())
      return false;

    $handle = $this->image_handle;

    ob_start();
    imagejpeg($handle);
    $image_data = ob_get_contents();
    ob_end_clean();

    return $image_data;
  }

  public function destroy() {
    imagedestroy($this->image_handle);
  }

}

?>
