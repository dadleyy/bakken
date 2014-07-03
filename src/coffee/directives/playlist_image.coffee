bakken.directive 'rbPlaylistImage', ['Viewport', (Viewport) ->

  rbPlaylistImage =
    restrict: 'A'
    scope:
      playlist: '='
    link: ($scope, $element, $attrs) ->
      draw = () ->
        console.log 'drawing'

      draw()
      Viewport.addListener draw

]
