bakken.directive 'rbPlaylist', [() ->

  rbPlaylist =
    restrict: 'EA'
    replace: true
    templateUrl: 'directives.playlist'
    scope:
      playlist: '='
    link: ($scope, $element, $attrs) ->

]
