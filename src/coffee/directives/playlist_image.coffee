bakken.directive 'rbPlaylistImage', ['$timeout', 'Viewport', ($timeout, Viewport) ->

  cleanImageUrl = (url) ->
    original = url.replace /large/gi, 'original'
    original.replace /^http:\/\/(.*)/i, "/api/images/$1"

  getPlaylistImageList = (playlist) ->
    if playlist.artwork_url
      [cleanImageUrl(playlist.artwork_url)]
    else
      images = []
      images.push(cleanImageUrl(track.artwork_url)) for track in playlist.tracks
      images

  drawPlaylistImages = (canvas, image_list) ->
    context = canvas.getContext '2d'
    width = canvas.width
    height = canvas.height
    block_width = width / image_list.length
    block_height = height

    drawImage = (image_url, indx) ->
      image_ele = new Image()
      image_ele.src = image_url
      image_ele.onload = () ->
        y = 0
        x = block_width * indx
        context.drawImage image_ele, x, y, block_width, block_height
        image_data = context.getImageData x, y, block_width, block_height

    drawImage image, i for image, i in image_list
    

  rbPlaylistImage =
    restrict: 'A'
    scope:
      playlist: '='
    link: ($scope, $element, $attrs) ->
      canvas = document.createElement 'canvas'
      $element.append canvas

      draw = () ->
        element = $element[0].parentNode
        width = element.offsetWidth
        height = element.offsetHeight
        canvas.setAttribute 'width', width
        canvas.setAttribute 'height', height
        playlist = $scope.playlist

        image_urls = getPlaylistImageList playlist
        drawPlaylistImages canvas, image_urls

      $timeout draw
      Viewport.addListener draw

]
