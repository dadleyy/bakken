bakken.service "SoundcloudAPI", ['$resource', 'SAK', ($resource, SAK) ->
  
  api_base = 'http://api.soundcloud.com'

  default_params =
    client_id: SAK
    format: 'json'

  user_url = [api_base, '/users/:id/:fn.:format'].join('')

  user_params = angular.extend default_params

  User = $resource user_url, user_params,
    tracks:
      method: 'GET'
      isArray: true
      params:
        fn: 'tracks'

  SoundcloudAPI =
    User: User

  SoundcloudAPI

]
