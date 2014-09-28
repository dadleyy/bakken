bakken.directive 'rbDiscography', ['Viewport', (Viewport) ->

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
      column_heights = [0, 0]
      resized = false

      togglePlaylists = (evt, playlist) ->
        if active_playlist
          active_playlist.close()
        active_playlist = playlist

      getPlaylistHeight = (playlist) ->
        track_count = playlist.tracks.length
        (track_count * 80) + 30

      getLowestColumn = () ->
        min = Infinity
        selected_index = -1

        for height, index in column_heights
          if height < min
            selected_index = index
            min = height

        selected_index

      resize = (window_width, window_height) ->
        if window_width < 820
          column_heights = [0]
        else
          column_heights = [0, 0]

      $scope.getPlaylistPosition = (playlist, index) ->
        style = { }
        column_count = column_heights.length
        column = index % column_count

        if index < column_count
          playlist.top = 0
          style.top = '0px'
          if column_count > 1
            style.left = if column % column_count == 0 then '50%' else '0%'
          else
            style.left = '0%'
          column_heights[column] = getPlaylistHeight playlist

        else
          col_indx = getLowestColumn()
          col_bottom = column_heights[col_indx]
          style.top = [col_bottom, 'px'].join ''
          if column_count > 1
            style.left = if col_indx % column_count == 0 then '50%' else '0%'
          else
            style.left = '0%'
          column_heights[col_indx] += getPlaylistHeight playlist

        style.width = (100 / column_count) + '%'
        style

      $scope.getDiscographyHeight = () ->
        heights = [0, 0]
        heights[index % 2] += getPlaylistHeight playlist for playlist, index in $scope.playlists
        max_height = Math.max.apply(null, heights)
        height: [max_height, 'px'].join ''


      $scope.$on 'playlistOpened', togglePlaylists
      Viewport.addListener resize

]
