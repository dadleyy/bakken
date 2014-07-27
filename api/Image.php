<?php namespace Bakken;

class Image {

  private $image_handle;
  private $valid = false;

  function __construct($image_url, $width=800, $height=600) {
    $source_dimensions = false;

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
    $this->valid = true;
  }

  public function isValid() {
    return $this->valid;
  }

  public function addFilter($amount=20) {
    if(!$this->valid)
      return false;

    $handle = $this->image_handle;
    for($i = 0; $i < $amount; $i++)
      imagefilter($this->image_handle, IMG_FILTER_GAUSSIAN_BLUR);
  }

  public function getData() {
    if(!$this->valid)
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
