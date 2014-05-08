bakken.config ['$routeProvider', ($routeProvider) ->
  homeRoute = 
    templateUrl: 'views.home'

  $routeProvider.when '/', homeRoute

]
