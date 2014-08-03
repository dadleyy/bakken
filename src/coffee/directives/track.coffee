bakken.directive 'rbTrack', ['$timeout', '$window', 'Audio', ($timeout, $window, Audio) ->

  class Track

      constructor: (@scope) ->
        @playback_url = @scope.track.stream_url
        @sound = null

      stop: () ->
        @scope.playing = false

      start: () ->
        @scope.playing = true

  Track.$inject = ['$scope']

  rbTrack =
    restrict: 'EA'
    scope:
      track: '='
      index: '='
    replace: true
    controller: Track
    templateUrl: 'directives.track'
    link: ($scope, $element, $attrs, trackController) ->
      $scope.revealed = false
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
          Audio.close()
        else
          Audio.open trackController

      $timeout reveal, 100 * $scope.index

]
