bakken.directive 'rbDiscography', [() ->

  class Discography

    constructor: (@scope) ->
      @playlist_controllers = []
      @active_playlist = null

      update = (evt, active_index) =>
        if @active_playlist != null
          if active_index != @active_playlist
            active_playlist = @playlist_controllers[@active_playlist]
            active_playlist.killAll()
            active_playlist.scope.close()

        @active_playlist = active_index

      @scope.$on 'playlistStart', update

    registerPlaylist: (playlist) ->
      index = @playlist_controllers.length
      @playlist_controllers.push playlist
      index

  Discography.$inject = ['$scope']

  rbDiscography =
    restrict: 'EA'
    replace: true
    scope:
      playlists: '='
    controller: Discography
    templateUrl: 'directives.discography'
    link: ($scope, $element, $attrs) ->
      active_playlist = null

      togglePlaylists = (evt, playlist) ->
        if active_playlist
          active_playlist.close()
        active_playlist = playlist

      $scope.getPlaylistPosition = (playlist, index) ->
        if index - 2 < 0
          top: '0px'
        else
          pl_above = $scope.playlists[index-2]
          track_count = pl_above.tracks.length
          top = (track_count * 80) + 30
          top: [top,'px'].join('')

      getPlaylistHeight = (playlist) ->
        track_count = playlist.tracks.length
        (track_count * 80) + 30

      $scope.getDiscographyHeight = () ->
        heights = [0, 0]
        heights[index % 2] += getPlaylistHeight playlist for playlist, index in $scope.playlists
        max_height = Math.max.apply(null, heights)
        height: [max_height, 'px'].join ''

      $scope.$on 'playlistOpened', togglePlaylists

]
