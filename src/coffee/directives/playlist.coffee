bakken.directive 'rbPlaylist', [() ->

  class PlaylistController

    constructor: (@scope) ->

    initialize: () ->
      @scope.ready = true


  PlaylistController.$inject = ['$scope']

  rbPlaylist =
    restrict: 'EA'
    replace: true
    templateUrl: 'directives.playlist'
    controller: PlaylistController
    scope:
      playlist: '='
    link: ($scope, $element, $attrs) ->
      $scope.ready = false

]
