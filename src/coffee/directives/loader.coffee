bakken.directive 'rbLoader', ['$rootScope', '$timeout', ($rootScope, $timeout) ->

  rbLoader =
    templateUrl: 'directives.loader'
    link: ($scope, $element, $attrs) ->
      $scope.loading = false
      spinner_stop_on = 'loaderFinished'

      routeStart = (evt, routing) ->
        $scope.loading = true
        $scope.text = routing.$$route.loadingText || 'Loading...'

      finish = () ->
        $scope.loading = false
        $scope.$broadcast spinner_stop_on

      routeFinish = () ->
        $timeout finish, 1000

      routeError = () ->
        $scope.loading = false

      $rootScope.$on '$routeChangeStart', routeStart
      $rootScope.$on '$routeChangeSuccess', routeFinish
      $rootScope.$on '$routeChangeError', routeError

]
