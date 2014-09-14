bakken.controller 'HomeController', ['$scope', 'Playlists', ($scope, Playlists) ->

  trackCount = (a, b) ->
    ret = 0
    if a.tracks.length < b.tracks.length
      ret = 1
    else
      ret = -1
    ret

  $scope.playlists = Playlists.sort trackCount

]
