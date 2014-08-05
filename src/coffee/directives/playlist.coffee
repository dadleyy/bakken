bakken.directive 'rbPlaylist', ['Analytics', (Analytics) ->

  class PlaylistController

    constructor: (@scope) ->
      @track_controllers = []
      @active_index = null

    viewable: (state) ->
      @scope.ready = state

    killAll: () ->
      track.stop() for track in @track_controllers
      @active_index = null

    isPlaying: () ->
      @active_index != null

    registerTrack: (track_controller) ->
      indx = @track_controllers.length

      on_finish = () =>
        @playNext()

      set_active = () =>
        @scope.$emit 'playlistStart', @scope.index

        if @active_index != null
          @track_controllers[@active_index].sound.stop()

        @active_index = indx

      track_controller.sound.on 'play', set_active
      track_controller.sound.on 'finish', on_finish

      @track_controllers.push track_controller

    playNext: () ->
      @track_controllers[@active_index].sound.stop()
      add_indx = @active_index + 1
      length = @track_controllers.length
      next = if add_indx > length - 1 then 0 else add_indx
      @track_controllers[next].start()
      @track_controllers[next].pushAnalytics 'cycle'


  PlaylistController.$inject = ['$scope']

  rbPlaylist =
    restrict: 'EA'
    replace: true
    templateUrl: 'directives.playlist'
    controller: PlaylistController
    require: ['^rbDiscography', 'rbPlaylist']
    scope:
      playlist: '='
      order: '='
    link: ($scope, $element, $attrs, controllers) ->
      $scope.ready = false
      $scope.active = false
      discography_controller = controllers[0]
      playlist_controller = controllers[1]

      $scope.open = () ->
        $scope.active = true

        finish = () ->
          $element.find('.title-area').css {display: "none"}
          $scope.$emit 'playlistOpened', $scope
          
        style = {opacity: 0.0}
        $element.find('.title-area').stop().animate style, 300, finish

      $scope.close = () ->
        if playlist_controller.isPlaying()
          return

        $scope.active = false
        style = {opacity: 1.0}
        $element.find('.title-area').css({display: 'block'}).stop().animate style, 300

      $scope.reveal = () ->
        if !$scope.active
          $scope.open()
        else
          $scope.close()
        $scope.active

      $scope.index = discography_controller.registerPlaylist playlist_controller

]
