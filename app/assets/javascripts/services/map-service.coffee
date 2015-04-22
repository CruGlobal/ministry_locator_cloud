class MapService
  constructor: ($log, $http, SearchService) ->
    @initializeMap = ->
      @mapOptions = {
        zoom: 9
      }
      @map = new google.maps.Map(document.getElementById('map-canvas'), @mapOptions)
      @markers = []
      service = @

      # Try W3C Geolocation (Preferred)
      if(navigator.geolocation)
        navigator.geolocation.getCurrentPosition (position) ->
          initialLocation = {lat: position.coords.latitude, lng: position.coords.longitude}
          service.map.setCenter(initialLocation)
          initialLocation
        , ->
          @handleNoGeolocation(@map)

        # Browser doesn't support Geolocation
      else
        @handleNoGeolocation(@map)

      # Add a listener to automatically search when the map center changes.
      google.maps.event.addListener @map, "center_changed", ->
        bounds = service.map.getBounds()
        $log.debug(bounds)
        ne = bounds.getNorthEast()
        sw = bounds.getSouthWest()

        if ne.lat() == sw.lat() && ne.lng() == sw.lng()
          # Trigger a resize if bounds have 0 area
          google.maps.event.trigger( service.map, 'resize' )
        else
          nw = {lat: ne.lat(), lng: sw.lng()}
          se = {lat: sw.lat(), lng: ne.lng()}
          service.loadLocations(nw, se)

    @handleNoGeolocation = (map) ->
      $http.jsonp('http://freegeoip.net/json/?callback=JSON_CALLBACK')
      .success (data)->
        initialLocation = {lat: data.latitude, lng: data.longitude}
        map.setCenter(initialLocation)
        initialLocation
      .error ->
        orlando = {lat: 28.4158, lng: 81.2989}
        map.setCenter(orlando)
        orlando

    @loadLocations = (nw, se)->
      service = @
      SearchService.geoSearch(nw, se).then (resp) ->
        service.setLocations(resp.locations)
      false

    @setLocations = (locations) ->
      service = @
      angular.forEach locations, (location) ->
        service.addMarker(location)

    @addMarker = (location) ->
      return unless location.latitude? && location.longitude
      latLng = new google.maps.LatLng(location.latitude, location.longitude)
      marker = new google.maps.Marker({
        position: latLng,
        map: @map
      })

angular.module( 'ml.services' ).service( 'MapService', ['$log', '$http', 'SearchService', MapService] );