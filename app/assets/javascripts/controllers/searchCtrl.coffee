class SearchController
  constructor: (uiGmapIsReady, api) ->
    ctrl = this
    @mapInstance = {}
    @filterMinistries = {}
    map = undefined

    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (pos) ->
        ctrl.map =
          center:
            latitude: pos.coords.latitude
            longitude: pos.coords.longitude

          zoom: 10

    else
      ctrl.map =
        center:
          latitude: 28.4158
          longitude: 81.2989

        zoom: 8
    api.get("/ministry_strategies").success (data) ->
      angular.forEach data, (m) ->
        ctrl.filterMinistries[m.name] = true

      ctrl.ministries = data

    ctrl.mapEvents = idle: ->
      map = ctrl.mapInstance.getGMap()
      ctrl.getMarkers()

    @getMarkers = ->
      nw = new google.maps.LatLng(map.getBounds().getNorthEast().lat(), map.getBounds().getSouthWest().lng())
      se = new google.maps.LatLng(map.getBounds().getSouthWest().lat(), map.getBounds().getNorthEast().lng())
      ministries = _.keys(_.pick(ctrl.filterMinistries, (v) ->
        v
      ))
      api.get("/search/suggest",
        q: "(or ministries:'" + ministries.join("' ministries:'") + "')"
        fq: "latlon:['" + nw.lat() + "," + nw.lng() + "','" + se.lat() + "," + se.lng() + "']"
        parser: "structured"
      ).success (data) ->
        ctrl.markers = data.locations

    @suggest = (typed) ->
      api.get("/search/suggest?q=" + encodeURIComponent(typed)).then (response) ->
        response.data.locations

    @selectLocation = (item) ->
      ctrl.map.center =
        latitude: item.latitude
        longitude: item.longitude


    uiGmapIsReady.promise(2).then (instances) ->
      instances.forEach (inst) ->
        inst.map.ourID = inst.instance
        return
      return

angular.module("ml").controller "SearchController", ["uiGmapIsReady", "api", SearchController ]