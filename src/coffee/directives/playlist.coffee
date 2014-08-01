bakken.directive 'rbPlaylist', [() ->

  class PlaylistController

    constructor: (@scope) ->

    initialize: () ->
      @scope.ready = true


  PlaylistController.$inject = ['$scope']

  rbPlaylist =
    restrict: 'EA'
    replace: true
    templateUrl: 'directives.playlist'
    controller: PlaylistController
    scope:
      playlist: '='
      order: '='
    link: ($scope, $element, $attrs) ->
      $scope.ready = false

      display = (val) ->
        () ->
          titleArea().css
            display: val

      titleArea = () ->
        $element.find '.title-area'

      transition = (state) ->
        style = if state == 'off' then {opacity: 1} else {opacity: 0}
        display_fn = if state == 'off' then display('block') else display('none')

        () ->
          if state == 'off'
            display_fn()

          titleArea().animate style, 600, display_fn

      $element.hover transition('on'), transition('off')

]
