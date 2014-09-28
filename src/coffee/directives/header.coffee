bakken.directive 'rbHeader', ['$timeout', ($timeout) ->
  
  rbHeader =
    replace: true
    templateUrl: 'directives.header'
    link: ($scope, $element, $attrs) ->
      $scope.expanded = false

      $scope.toggle = () ->
        $scope.expanded = !$scope.expanded

]
