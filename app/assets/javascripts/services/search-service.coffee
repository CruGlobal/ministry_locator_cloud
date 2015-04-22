class SearchService
  constructor: ($log, $http, $q) ->
    @suggest = (val)->
      service = @
      deferred = $q.defer()

      $http.get('/search/suggest?size=20&q=' + val).success (resp)->
        deferred.resolve(resp)
      .error (err)->
        service.handle_error(err)
        deferred.reject('There was an error')

      deferred.promise

    @search = (val)->
      service = @
      deferred = $q.defer()

      $http.get('/search/suggest?q=' + val).success (resp)->
        deferred.resolve(resp)
      .error (err)->
        service.handle_error(err)
        deferred.reject('There was an error')
      deferred.promise


    @geoSearch = (nw, se)->
      service = @
      deferred = $q.defer()

      url = "/search/suggest?q='College'&fields=type&&fq=latlon:['" + nw.lat + "," + nw.lng + "','" + se.lat + "," + se.lng + "']&parser=structured"

      $http.get(url).success (resp)->
        deferred.resolve(resp)
      .error (err)->
        service.handle_error(err)
        deferred.reject('There was an error')
      deferred.promise

    @handle_error = (err) ->
      $log.debug(err)
      alert('request failed')

angular.module( 'ml.services' ).service( 'SearchService', ['$log', '$http', '$q', SearchService] );