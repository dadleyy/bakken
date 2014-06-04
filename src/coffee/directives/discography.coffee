bakken.directive 'rbDiscography', [() ->

  rbDiscography =
    replace: true
    scope:
      tracks: '='
    templateUrl: 'directives.discography'
    link: ($scope, $element, $attrs) ->


]
