class SearchController
  constructor: ($scope, $log, SearchService, MapService) ->
    @search = {}
    @locations = []
    @location_names = []
    ctrl = this

    @suggest = (val)->
      SearchService.suggest(val).then (resp)->
        $scope.location_names = []
        angular.forEach resp.locations, (location)->
          $scope.location_names.push(location.name)
    false

    @search = ->
      SearchService.search(ctrl.search.q).then (resp) ->
        ctrl.locations = resp.locations
        ctrl.mapResults()

    @searchOnCoords = (coords)->
      SearchService.searchOnCoords(coords).then (resp) ->
        ctrl.locations = resp.locations
        ctrl.mapResults()

    @mapResults = ->
      MapService.setLocations(@locations)

    angular.element(document).ready ->
      location = MapService.initializeMap()
      #@searchOnCoords(location)

angular.module( 'ml.controllers' ).controller( 'SearchController', ['$scope', '$log', 'SearchService', 'MapService', SearchController] )