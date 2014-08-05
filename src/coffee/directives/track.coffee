bakken.directive 'rbTrack', ['$timeout', '$window', 'Audio', 'Analytics', ($timeout, $window, Audio, Analytics) ->

  class Track

    constructor: (@scope) ->
      @playback_url = @scope.track.stream_url
      @sound = new Audio.Sound @scope.track

      onstop = (evt) =>
        @scope.playing = false

      onstart = (evt) =>
        @scope.playing = true

      @sound.on
        stop: onstop
        play: onstart

    stop: () ->
      @scope.playing = false
      @sound.stop()

    start: () ->
      @scope.playing = true
      @sound.play()

  Track.$inject = ['$scope']

  rbTrack =
    restrict: 'EA'
    scope:
      track: '='
      index: '='
    replace: true
    controller: Track
    require: ['rbTrack', '^rbPlaylist']
    templateUrl: 'directives.track'
    link: ($scope, $element, $attrs, controllers) ->
      $scope.revealed = false
      track_controller = controllers[0]
      playlist_controller = controllers[1]

      twitter_params =
        via: 'RBakk'
        text: 'Cool track'

      twitter_query_string = []
      twitter_query_string.push [key, $window.encodeURIComponent(value)].join('=') for key, value of twitter_params

      reveal = () ->
        $scope.revealed = true

      makeTwitterUrl = (local_url) ->
        twitter_base = ['https://twitter.com/share?url=', local_url].join('')
        query_strings = twitter_query_string.join '&'
        [twitter_base, query_strings].join '&'

      $scope.goTo = (rel) ->
        if rel == 'soundcloud'
          permalink_url = $scope.track.permalink_url
          $window.open permalink_url
        else
          local_url = ['http://bakken.fm', $scope.track.id].join('/')
          encoded = $window.encodeURIComponent local_url
          twitter_url = makeTwitterUrl encoded
          $window.open twitter_url, 'twitter share', "width=800, height=250"
        true

      $scope.toggle = () ->
        if $scope.playing
          playlist_controller.killAll()
        else
          track_controller.start()
          Analytics.trackEvent 'audio', 'play', $scope.track.permalink

      $timeout reveal, 100 * $scope.index
      playlist_controller.registerTrack track_controller

]
