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
      Tracks: ['SoundcloudAPI', 'USER_ID', (SoundcloudAPI, USER_ID) ->
        user_params =
          id: USER_ID
        
        tracks = SoundcloudAPI.User.tracks user_params
      ]

  $routeProvider.when '/', homeRoute

]
