map = undefined

@initMap = (c) ->
  loc = []
  i = 0
  while i < gon.user.length
    loc.push
      name: gon.user[i].name
      lat: parseFloat(gon.user[i].latitude)
      lng: parseFloat(gon.user[i].longitude)
      picture: gon.user[i].picture
    i++
  myLatLng = 
    lat: 20.5937
    lng: 78.9629
  minZoomLevel = 3
  map = new (google.maps.Map)(document.getElementById('map'),
    zoom: 4
    draggable: true
    scrollwheel: true
    zoomControl: true
    minZoom: minZoomLevel
    setMaxZoom: 11
    center: myLatLng
    gestureHandling: 'none')
  infoWindow = new (google.maps.InfoWindow)(map: map)
  prev_infowindow = false
  marker = undefined
  markers = loc.map((location, i) ->
    image = 
      url: loc[i].picture
      scaledSize: new (google.maps.Size)(25, 32)
      origin: new (google.maps.Point)(0, 0)
      anchor: new (google.maps.Point)(0, 32)
    marker = new (google.maps.Marker)(
      position: location
      icon: image)
    infowindow = new (google.maps.InfoWindow)(
      position: location
      content: loc[i].name)
    marker.addListener 'click', ->
      if prev_infowindow
        prev_infowindow.close()
      prev_infowindow = infowindow
      infowindow.open map
      return
    marker
  )

  markerCluster = new MarkerClusterer(map, markers,
    imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'
    maxZoom: 10
    )


  google.maps.event.addListener markerCluster, 'clusterclick', (cluster) ->
    return

  map.addListener 'zoom_changed', ->
    console.log map.getZoom() 
    return
  
  coordsDiv = document.getElementById('coords')
  map.controls[google.maps.ControlPosition.TOP_CENTER].push coordsDiv


  strictBounds = new (google.maps.LatLngBounds)(new (google.maps.LatLng)(-75, -180), new (google.maps.LatLng)(83, 180))
  google.maps.event.addListener map, 'bounds_changed', ->
    if strictBounds.contains(map.getCenter())
      return
    c = map.getCenter()
    x = c.lng()
    y = c.lat()
    maxX = strictBounds.getNorthEast().lng()
    maxY = strictBounds.getNorthEast().lat()
    minX = strictBounds.getSouthWest().lng()
    minY = strictBounds.getSouthWest().lat()
    if x < minX
      x = minX
    if x > maxX
      x = maxX
    if y < minY
      y = minY
    if y > maxY
      y = maxY
    map.setCenter new (google.maps.LatLng)(y, x)
    return

  if navigator.geolocation
    navigator.geolocation.getCurrentPosition ((position) ->
      pos = 
        lat: position.coords.latitude
        lng: position.coords.longitude
      infoWindow.setPosition pos
      infoWindow.setContent 'Your Location'
      setTimeout (->
        infoWindow.close()
        return
      ), 3000
      map.setCenter pos
      return
    ), ->
      handleLocationError true, infoWindow, map.getCenter()
      return
  else
    handleLocationError false, infoWindow, map.getCenter()
  return

handleLocationError = (browserHasGeolocation, infoWindow, pos) ->
  infoWindow.setPosition pos
  infoWindow.setContent if browserHasGeolocation then 'Error: The Geolocation service failed.' else 'Error: Your browser doesn\'t support geolocation.'
  setTimeout (->
    infoWindow.close()
    return
  ), 3000
  return
@panning = (x) ->
  if !x
    map.setOptions
      draggable: false
  else
    map.setOptions
      draggable: true
  return
@zooming = (x) ->
  if !x
    map.setOptions
      zoomControl: false
      scrollwheel: false
      disableDoubleClickZoom: true
  else
    map.setOptions
      zoomControl: true
      scrollwheel: true
      disableDoubleClickZoom: false
  return
