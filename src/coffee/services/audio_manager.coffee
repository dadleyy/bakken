bakken.service 'Audio', ['$q', 'SAK', ($q, SAK) ->

  isStr = angular.isString
  isFn = angular.isFunction
  isObj = angular.isObject
    
  class Sound

    constructor: (@track) ->
      @playing = false
      @load_promise = $q.defer()

      @sm_sound = soundManager.createSound
        url: [@track.stream_url, ['client_id', SAK].join('=')].join('?')
        onfinish: () =>
          @fire 'finish'
        onload: () =>
          @load_promise.resolve @sm_sound.duration
          @duration = @sm_sound.duration

      @events =
        finish: []
        stop: []
        play: []

    load: () ->
      @load_promise.promise

    goTo: (time) ->
      @sm_sound.setPosition time

    on: (evt, fn) ->

      add = (evt, fn) =>
        if @events[evt]
          @events[evt].push fn

      if isStr(evt) and isFn(fn)
        add evt, fn
      else if isObj(evt)
        add e, f for e, f of evt
      else false

    fire: (evt) ->
      if @events[evt]
        fn() for fn in @events[evt]

    play: () ->
      @playing = true
      @fire 'play'
      @sm_sound.play()

    stop: () ->
      @playing = false
      @fire 'stop'
      @sm_sound.stop()

  class Audio

    constructor: () ->
      @active_track = null
      @active_sound = null

    @Sound: Sound

  Audio

]
