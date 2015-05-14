class SearchController
  constructor: (uiGmapIsReady, api) ->
    ctrl = this
    @mapInstance = {}
    @filterMinistries = {}

    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (pos) ->
        ctrl.mapSettings =
          center:
            latitude: pos.coords.latitude
            longitude: pos.coords.longitude

          zoom: 10

    else
      ctrl.mapSettings =
        center:
          latitude: 28.4158
          longitude: 81.2989

        zoom: 8
    api.getMinistryStrategies().success (data) ->
      angular.forEach data, (m) ->
        ctrl.filterMinistries[m.name] = true

      ctrl.ministries = data

    ctrl.mapEvents = idle: ->
      ctrl.getMarkers()

    @getMarkers = ->
      map = ctrl.mapInstance.getGMap()
      nw = new google.maps.LatLng(map.getBounds().getNorthEast().lat(), map.getBounds().getSouthWest().lng())
      se = new google.maps.LatLng(map.getBounds().getSouthWest().lat(), map.getBounds().getNorthEast().lng())
      ministries = _.keys(_.pick(ctrl.filterMinistries, (v) ->
        v
      ))
      api.getMarkers(
        ministries: ministries
        nwBounds: nw
        seBounds: se
      ).success (data) ->
        ctrl.markers = data.locations

    @suggest = (typed) ->
      api.search(typed).then (response) ->
        response.data.locations

    @selectLocation = (item) ->
      ctrl.mapSettings.center =
        latitude: item.latitude
        longitude: item.longitude


    uiGmapIsReady.promise(2).then (instances) ->
      instances.forEach (inst) ->
        inst.map.ourID = inst.instance
        return
      return

angular.module("ml").controller "SearchController", ["uiGmapIsReady", "api", SearchController ]