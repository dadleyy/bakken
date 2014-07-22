bakken.directive 'rbDiscography', [() ->

  rbDiscography =
    restrict: 'EA'
    replace: true
    scope:
      playlists: '='
    templateUrl: 'directives.discography'
    link: ($scope, $element, $attrs) ->

      $scope.getPlaylistPosition = (playlist, index) ->
        if index - 2 < 0
          top: '0px'
        else
          pl_above = $scope.playlists[index-2]
          track_count = pl_above.tracks.length
          top = (track_count * 80) + 30
          top: [top,'px'].join('')

]
