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
      d3el = d3.select $element[0]

      display = (val) ->
        () ->
          titleArea().style({display: val})

      titleArea = () ->
        d3el.selectAll('.title-area')

      transition = (state) ->
        style = if state == 'off' then {opacity: 1} else {opacity: 0}
        display_fn = if state == 'off' then display('block') else display('none')

        () ->
          if state == 'off'
            display_fn()

          titleArea().transition().duration(600).style(style).each "end", display_fn

      $element.hover transition('on'), transition('off')

]
