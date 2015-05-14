angular.module('ml').service 'api', ($http) ->
  
  @getMinistryStrategies = ->
    $http.get '/ministry_strategies'

  @search = (term) ->
    $http.get '/search/suggest', params: q: term

  @getMarkers = (filters) ->
    $http.get '/search/suggest', params:
      q: '(or ministries:\'' + filters.ministries.join('\' ministries:\'') + '\')'
      fq: 'latlon:[\'' + filters.nwBounds.lat() + ',' + filters.nwBounds.lng() + '\',\'' + filters.seBounds.lat() + ',' + filters.seBounds.lng() + '\']'
      parser: 'structured'

  return