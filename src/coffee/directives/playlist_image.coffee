bakken.directive 'rbPlaylistImage', ['$timeout', '$q', 'Viewport', ($timeout, $q, Viewport) ->

  image_cache = {}
  blur_filter = new createjs.BlurFilter 25, 25, 10
  color_filter = new createjs.ColorMatrixFilter [
    0.23,0.23,0.23,0,0,
    0.23,0.23,0.23,0,0,
    0.23,0.23,0.23,0,0,
    0,0,0,1,0
  ]

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

  drawImage = (canvas, active_image) ->
    deffered = $q.defer()

    context = canvas.getContext '2d'
    width = canvas.width
    height = canvas.height
    x = 0
    y = 0

    render = (image_ele) ->
      context.drawImage image_ele, x, y, width, height
      blur_filter.applyFilter context, x, y, width, height
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
    scope:
      playlist: '='
    link: ($scope, $element, $attrs) ->
      canvas = document.createElement 'canvas'
      active_image = 0
      first_load = true

      $element.append canvas

      makeViewable = () ->
        first_load = false
        $scope.viewable = true

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


      $timeout draw
      Viewport.addListener draw

]
