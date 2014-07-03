bakken.service 'Loop', ['$window', ($window) ->

  luid = do ->
    id = 0
    () ->
      id += 1
      id

  active_listeners = []
  running = false

  run = () ->
    if active_listeners.length == 0
      running = false
    else
      for wrapper in active_listeners
        wrapper()

    if running
      $window.setTimeout run, 33

  Loop =

    add: (fn) ->
      wrapper = () ->
        fn()
      wrapper.uid = luid()
      active_listeners.push wrapper

      if !running
        running = true
        run()
      
      wrapper.uid

    remove: (id) ->
      for wrapper, indx in active_listeners
        if wrapper.uid == id
          active_listeners.splice indx, 1
          break
]
