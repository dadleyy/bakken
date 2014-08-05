bakken.directive 'rbPlaylistImage', ['$timeout', '$q', 'Viewport', ($timeout, $q, Viewport) ->

  image_cache = {}

  cleanImageUrl = (url) ->
    original = url.replace /large/gi, 'original'
    final = ['/api/images', original.replace(/http:\/\//, '')].join '/'

  getPlaylistImageList = (playlist) ->
    if playlist.artwork_url
      [cleanImageUrl(playlist.artwork_url)]
    else
      images = []
      images.push(cleanImageUrl(track.artwork_url)) for track in playlist.tracks
      images

  drawImage = (active_image, width, height) ->
    deffered = $q.defer()
    render = (image_ele) ->
      $(image_ele).pixastic("blurfast", {
        amount: 3.0,
      }).pixastic "hsl",
        hue: 0
        saturation: -90
        lightness: -40

    image_ele = new Image()
    image_ele.width = width
    image_ele.height = height
    image_ele.src = active_image
    image_ele.onload = () ->
      render(image_ele)
      deffered.resolve(image_ele)
  
    {promise: deffered.promise, image: image_ele}

  rbPlaylistImage =
    restrict: 'AE'
    replace: true
    templateUrl: 'directives.playlist_image'
    require: '^rbPlaylist'
    scope:
      playlist: '='
      order: '='
    link: ($scope, $element, $attrs, playlistController) ->
      active_image = 0
      resize_timeout = null
      
      # playlists are only viewable after their images
      # are done being rendered into the canvas
      makeViewable = (element) ->
        cb = () ->
          playlistController.viewable(true)
        $timeout cb, (200 * $scope.order) + 400

      draw = () ->
        playlist = $scope.playlist
        image_urls = getPlaylistImageList playlist
        width = $element.outerWidth()
        height = $element.outerHeight()
        data = drawImage image_urls[active_image], width, height
        data.promise.then makeViewable
        $element.append data.image

      resize = () ->
        if resize_timeout != null
          $timeout.cancel resize_timeout
        resize_timeout = $timeout draw, 100

      timeout_id = $timeout draw
      #Viewport.addListener resize

]
