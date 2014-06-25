bakken.directive 'rbDiscography', [() ->

  rbDiscography =
    restrict: 'EA'
    replace: true
    scope:
      playlists: '='
    templateUrl: 'directives.discography'
    link: ($scope, $element, $attrs) ->

]
