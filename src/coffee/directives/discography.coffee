bakken.directive 'rbDiscography', [() ->

  rbDiscography =
    restrict: 'EA'
    replace: true
    scope:
      tracks: '='
    templateUrl: 'directives.discography'
    link: ($scope, $element, $attrs) ->

]
