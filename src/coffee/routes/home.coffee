bakken.config ['$routeProvider', ($routeProvider) ->

  homeRoute = 
    templateUrl: 'views.home'
    controller: 'HomeController'
    resolve: 
      User: ['SoundcloudAPI', 'USER_ID', (SoundcloudAPI, USER_ID) ->
        user_params =
          id: USER_ID

        user = SoundcloudAPI.User.get user_params

        # user.$promise
      ]

  $routeProvider.when '/', homeRoute

]
