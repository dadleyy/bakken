bakken.directive 'rbTrack', ['$timeout', ($timeout) ->

  rbTrack =
    restrict: 'EA'
    scope:
      track: '='
      index: '='
    replace: true
    templateUrl: 'directives.track'
    link: ($scope, $element, $attrs) ->
      $scope.revealed = false

      reveal = () ->
        $scope.revealed = true

      $timeout reveal, 100 * $scope.index

]
