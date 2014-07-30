<?php

use Bakken\Image;
use Illuminate\Filesystem\Filesystem;

class ImageTest extends PHPUnit_Framework_TestCase {

  public static function setUpBeforeClass() {
    $fs = new Filesystem();
    $success = $fs->deleteDirectory(__DIR__.'/../../storage');
    $success = $fs->makeDirectory(__DIR__.'/../../storage');
  }

  public function testRemoteLoad() {
    $image = new Image('http://i1.sndcdn.com/artworks-000083257947-elfxnt-original.jpg');
    $this->assertTrue($image->exists() == false);
    $image->save();
    $this->assertTrue($image->exists() == true);

    $image_two = new Image('http://i1.sndcdn.com/artworks-000083257947-elfxnt-original.jpg');
  }

}

?>
