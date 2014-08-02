bakken.directive 'rbPlaylist', [() ->


  class PlaylistController

    constructor: (@scope) ->

    initialize: () ->
      @scope.ready = true


    setElement: (element) ->
      @element = element

    open: () ->
      $element = @element
      @scope.active = true
      display = "none"
      style =
        opacity: 0.0
      self = @

      finish = () ->
        $element.find('.title-area').css {display: display}
        self.scope.$emit 'playlistOpened', self

      $element.find('.title-area').stop().animate style, 300, finish


    close: () ->
      $element = @element
      @scope.active = false
      display = "block"
      style =
        opacity: 1.0

      emit = @scope.$emit


      $element.find('.title-area').css({display: display}).stop().animate style, 300



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

      $scope.reveal = () ->
        playlist.setElement $element

        if !$scope.active
          playlist.open($element)
        else
          playlist.close($element)

        $scope.active

]
