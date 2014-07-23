bakken.directive 'rbSpinner', [() ->

  rbSpinner =
    replace: true
    restrict: 'EA'
    templateUrl: 'directives.spinner'
    link: ($scope, $element, $attrs) ->
      svg = d3.select($element[0]).append('svg')

]
