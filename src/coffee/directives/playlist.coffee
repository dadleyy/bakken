bakken.directive 'rbPlaylist', [() ->


  class PlaylistController

    constructor: (@scope) ->
      @track_controllers = []

    viewable: (state) ->
      @scope.ready = state

    registerTrack: (track_controller) ->
      @track_controllers.push track_controller

  PlaylistController.$inject = ['$scope']

  rbPlaylist =
    restrict: 'EA'
    replace: true
    templateUrl: 'directives.playlist'
    controller: PlaylistController
    scope:
      playlist: '='
      order: '='
    link: ($scope, $element, $attrs, playlist) ->
      $scope.ready = false
      $scope.active = false

      $scope.open = () ->
        $scope.active = true

        finish = () ->
          $element.find('.title-area').css {display: "none"}
          $scope.$emit 'playlistOpened', $scope
          
        style = {opacity: 0.0}
        $element.find('.title-area').stop().animate style, 300, finish

      $scope.close = () ->
        $scope.active = false
        style = {opacity: 1.0}
        $element.find('.title-area').css({display: 'block'}).stop().animate style, 300

      $scope.reveal = () ->
        if !$scope.active
          $scope.open()
        else
          $scope.close()
        $scope.active

]
