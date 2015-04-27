angular.module("ml").controller "SearchController", ($scope, api) ->
  $scope.mapInstance = {}
  $scope.filterMinistries = {}
  map = undefined
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (pos) ->
      $scope.map =
        center:
          latitude: pos.coords.latitude
          longitude: pos.coords.longitude

        zoom: 10

  else

  #default to Orlando
    $scope.map =
      center:
        latitude: 28.4158
        longitude: 81.2989

      zoom: 8

  #get ministries list
  api.get("/ministry_strategies").success (data) ->
    angular.forEach data, (m) ->
      $scope.filterMinistries[m.name] = true

    $scope.ministries = data

  $scope.getMarkers = ->
    nw = new google.maps.LatLng(map.getBounds().getNorthEast().lat(), map.getBounds().getSouthWest().lng())
    se = new google.maps.LatLng(map.getBounds().getSouthWest().lat(), map.getBounds().getNorthEast().lng())
    ministries = _.keys(_.pick($scope.filterMinistries, (v) ->
      v
    ))
    api.get("/search/suggest",
      q: "(or ministries:'" + ministries.join("' ministries:'") + "')"
      fq: "latlon:['" + nw.lat() + "," + nw.lng() + "','" + se.lat() + "," + se.lng() + "']"
      parser: "structured"
    ).success (data) ->
      $scope.markers = data.locations


  $scope.mapEvents = idle: ->
    map = $scope.mapInstance.getGMap()
    $scope.getMarkers()

  $scope.suggest = (typed) ->
    api.get("/search/suggest?q=" + encodeURIComponent(typed)).then (response) ->
      response.data.locations


  $scope.selectLocation = (item) ->
    $scope.map.center =
      latitude: item.latitude
      longitude: item.longitude
