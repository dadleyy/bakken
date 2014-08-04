bakken.directive 'rbPlaylistImage', ['$timeout', '$q', 'Viewport', ($timeout, $q, Viewport) ->

  image_cache = {}
  color_filter = new createjs.ColorMatrixFilter [
    0.25, 0.20, 0.25, 0, 0,
    0.25, 0.20, 0.25, 0, 0,
    0.25, 0.20, 0.25, 0, 0,
    0.00, 0.00, 0.00, 1, 0
  ]

  cleanImageUrl = (url) ->
    original = url.replace /large/gi, 'original'
    ['/api/images', original].join '?url='

  getPlaylistImageList = (playlist) ->
    if playlist.artwork_url
      [cleanImageUrl(playlist.artwork_url)]
    else
      images = []
      images.push(cleanImageUrl(track.artwork_url)) for track in playlist.tracks
      images

  drawImage = (canvas, active_image) ->
    deffered = $q.defer()

    context = canvas.getContext '2d'
    width = canvas.width
    height = canvas.height
    x = 0
    y = 0

    render = (image_ele) ->
      context.drawImage image_ele, x, y, width, height
      #blur_filter.applyFilter context, x, y, width, height
      color_filter.applyFilter context, x, y, width, height

    if !image_cache[active_image]
      image_ele = new Image()
      image_ele.src = active_image
      image_cache[active_image] = image_ele
      image_ele.onload = () ->
        render(image_ele)
        deffered.resolve()
    else
      render image_cache[active_image]
      deffered.resolve()
    
    deffered.promise

  rbPlaylistImage =
    restrict: 'AE'
    replace: true
    templateUrl: 'directives.playlist_image'
    require: '^rbPlaylist'
    scope:
      playlist: '='
      order: '='
    link: ($scope, $element, $attrs, playlistController) ->
      canvas = document.createElement 'canvas'
      active_image = 0
      resize_timeout = null

      $element.append canvas
      
      # playlists are only viewable after their images
      # are done being rendered into the canvas
      makeViewable = () ->
        cb = () ->
          playlistController.viewable(true)
        $timeout cb, (200 * $scope.order) + 400

      draw = () ->
        element = $element[0].parentNode
        width = element.offsetWidth
        height = element.offsetHeight
        canvas.setAttribute 'width', width
        canvas.setAttribute 'height', height
        playlist = $scope.playlist

        image_urls = getPlaylistImageList playlist
        promise = drawImage canvas, image_urls[active_image]
        promise.then makeViewable

      resize = () ->
        if resize_timeout != null
          $timeout.cancel resize_timeout
        resize_timeout = $timeout draw, 100

      timeout_id = $timeout draw
      Viewport.addListener resize

]
