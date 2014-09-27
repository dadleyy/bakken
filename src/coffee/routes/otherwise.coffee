bakken.config ['$routeProvider', ($routeProvider) ->

  $routeProvider.otherwise
    redirectTo: () ->
      '/discography'

]
