bakken.config ['$routeProvider', ($routeProvider) ->

  resumeRoute =
    templateUrl: 'views.resume'
    controller: 'ResumeController'
    loadingText: 'Loading...'
    resolve:
      resumePage: ['$http', '$q', ($http, $q) ->
        deferred = $q.defer()
        resume_request = $http
          method: 'GET'
          url: '/bp/pages?filter[p]=7'

        finish = (response) ->
          deferred.resolve response.data[0]

        resume_request.then finish
        deferred.promise
      ]
      analytics: ['Analytics', (Analytics) ->
        Analytics.trackPage '/resume'
      ]

  $routeProvider.when '/resume', resumeRoute


]

