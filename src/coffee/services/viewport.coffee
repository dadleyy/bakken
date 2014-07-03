bakken.service 'Viewport', ['$window', 'Loop', ($window, Loop) ->

  resize_loop_id = null
  listeners = []
  stop_timeout = null

  stopListening = () ->
    Loop.remove resize_loop_id
    resize_loop_id = null

  $window.onresize = () ->
    if resize_loop_id == null
      resize_loop_id = Loop.add Viewport.update

    $window.clearTimeout stop_timeout
    stop_timeout = $window.setTimeout stopListening, 1000

  Viewport =
    addListener: (fn) ->
      listeners.push fn

    update: () ->
      for listener in listeners
        listener()


]
