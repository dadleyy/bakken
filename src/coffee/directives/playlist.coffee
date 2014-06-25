bakken.directive 'rbPlaylist', [() ->

  rbPlaylist =
    restrict: 'EA'
    replace: true
    templateUrl: 'directives.playlist'
    scope:
      playlist: '='
    link: ($scope, $element, $attrs) ->
      canvas = document.createElement 'canvas'
      
      d3.select($element[0]).select('.art-area')[0][0].appendChild canvas

]
