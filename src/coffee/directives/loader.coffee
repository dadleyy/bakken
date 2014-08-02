bakken.directive 'rbLoader', ['$rootScope', '$timeout', ($rootScope, $timeout) ->

  rbLoader =
    templateUrl: 'directives.loader'
    link: ($scope, $element, $attrs) ->
      $scope.loading = false

      routeStart = (evt, routing) ->
        $scope.loading = true
        $scope.text = routing.$$route.loadingText || 'Loading...'

      finish = () ->
        $scope.loading = false
        $scope.$broadcast 'spinnerStop'

      routeFinish = () ->
        $timeout finish, 1000

      routeError = () ->
        $scope.loading = false

      $rootScope.$on '$routeChangeStart', routeStart
      $rootScope.$on '$routeChangeSuccess', routeFinish
      $rootScope.$on '$routeChangeError', routeError

]
