angular.module('ml').service 'api', ($http) ->

  @get = (url, params) ->
    $http.get url, params: params

  return