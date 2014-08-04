bakken.service 'Audio', ['SAK', (SAK) ->

  isStr = angular.isString
  isFn = angular.isFunction
  isObj = angular.isObject
    
  class Sound

    constructor: (@track) ->
      @playing = false

      @sm_sound = soundManager.createSound
        url: [@track.stream_url, ['client_id', SAK].join('=')].join('?')

      @events =
        finish: []
        stop: []
        play: []

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

    @open: (track) ->
      if @active_track != null
        @active_track.stop()

      if @active_sound != null
        @active_sound.stop()

      @active_track = track
      @active_track.start()

      @active_sound = soundManager.createSound
        url: [@active_track.playback_url, SAK].join '?client_id='
        onfinish: () ->
          console.log 'whoa'

      @active_sound.play()
      @active_sound

    @close: () ->
      if @active_track != null
        @active_track.stop()
        @active_track = null

      if @active_sound != null
        @active_sound.stop()
        @active_sound = null

    @Sound: Sound

  Audio

]
