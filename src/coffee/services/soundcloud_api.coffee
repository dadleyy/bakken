bakken.service "SoundcloudAPI", ['$resource', ($resource) ->
  
  user_actions = 
    tracks: 
      method: 'GET'

  user_url = 'api.soundcloud.com'
  user_params = { }

  User = $resource user_url, user_params, user_actions

  SoundcloudAPI =
    User: User

  SoundcloudAPI

]
