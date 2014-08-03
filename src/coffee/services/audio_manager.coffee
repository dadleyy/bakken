bakken.service 'Audio', ['SAK', (SAK) ->

  class Audio

    constructor: () ->
      @active_track = null
      @active_sound = null
      console.log 'new audio class'

    open: (track) ->
      if @active_track != null
        @active_track.stop()

      if @active_sound != null
        @active_sound.stop()

      @active_track = track
      @active_track.start()

      @active_sound = soundManager.createSound
        url: [@active_track.playback_url, SAK].join '?client_id='

      @active_sound.play()
      @active_sound

    close: () ->
      if @active_track != null
        @active_track.stop()
        @active_track = null

      if @active_sound != null
        @active_sound.stop()
        @active_sound = null

    close: () ->

  new Audio

]
