bakken.directive 'rbPlaylistImage', ['$timeout', '$q', 'Drawing', 'Viewport', ($timeout, $q, Drawing, Viewport) ->

  image_cache = {}

  cleanImageUrl = (url) ->
    original = url.replace /large/gi, 'original'
    no_proto = original.replace /https?:\/\//, ''
    final = ['/api/images', no_proto].join '/'

  getPlaylistImageList = (playlist) ->
    if playlist.artwork_url
      [cleanImageUrl(playlist.artwork_url)]
    else
      images = []
      images.push(cleanImageUrl(track.artwork_url)) if track.artwork_url for track in playlist.tracks
      images

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
      canvas = document.createElement 'canvas'
      context = canvas.getContext '2d'
      $element.append canvas
      
      # playlists are only viewable after their images
      # are done being rendered into the canvas
      makeViewable = () ->
        cb = () ->
          playlistController.viewable true

        $timeout cb, (200 * $scope.order) + 400

      draw = () ->
        playlist = $scope.playlist
        image_urls = getPlaylistImageList playlist
        width = $element.outerWidth()
        height = $element.outerHeight()

        image = new Image()
        image.src = image_urls[0]

        image.onload = ->
          context.drawImage image, 0, 0, width, height
          Drawing.blur canvas, 0, 0, width, height, 10, 2
          Drawing.desaturate canvas, width, height
          makeViewable()

        image.onerror = ->
          makeViewable()


        canvas.width = width
        canvas.height = height

      resize = () ->
        if resize_timeout != null
          $timeout.cancel resize_timeout
        resize_timeout = $timeout draw, 100

      timeout_id = $timeout draw
      Viewport.addListener resize

]
