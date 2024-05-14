import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:osmflutter/models/Directions.dart';
import 'package:osmflutter/models/Steps.dart';

class BackgroundMap extends StatefulWidget {
  double? poly_lat1, poly_lng1, poly_lat2, poly_lng2;
  BackgroundMap(this.poly_lat1, this.poly_lat2, this.poly_lng1, this.poly_lng2,
      {Key? key})
      : super(key: key);

  @override
  _BackgroundMapState createState() => _BackgroundMapState();
}

class _BackgroundMapState extends State<BackgroundMap> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  Set<Polyline> _polyline = {};
  Set<Marker> _markers = {};
  late GoogleMapController gmapController;
  bool _mapCreated = false;

/*  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      widget.mapController = controller;
    });
    getLocation();
  }*/
  _onMapCreated(GoogleMapController controller) {
    gmapController = controller;
    setState(() {
      _mapCreated = true;
    });
  }

  void getLocation() async {
    late Position position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      print("errrrrrrrroooorrr${e}");
    }

    if (position != null) {
      setState(() {
        _initialcameraposition = LatLng(
          position.latitude!,
          position.longitude!,
        );
      });
    }
  }

  @override
  void dispose() {
    gmapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          // myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _initialcameraposition,
            zoom: 14,
          ),
          onMapCreated: _onMapCreated,
        ),
        if (!_mapCreated) const Center(child: CircularProgressIndicator())
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.poly_lat1 != null) _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final apiKey =
        'AIzaSyBglflWQihT8c4yf4q2MVa2XBtOrdAylmI'; // Replace with your Google Maps API key
    final start = '${widget.poly_lat1},${widget.poly_lng1}';
    final end = '${widget.poly_lat2},${widget.poly_lng2}';
    final apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$start&destination=$end&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    final responseData = json.decode(response.body);

    if (responseData['status'] == 'OK') {
      final List<LatLng> routeCoords = [];
      final List<Steps> steps =
          Directions.fromJson(responseData).routes.first.steps;
      steps.forEach((step) {
        routeCoords.add(LatLng(step.startLocation.lat, step.startLocation.lng));
        routeCoords.addAll(_decodePolyline(step.polyline));
      });

      setState(() {
        _polyline.add(Polyline(
          polylineId: PolylineId('route'),
          visible: true,
          points: routeCoords,
          color: Colors.white,
          width: 5,
        ));

        // Add markers
        _markers.add(
          Marker(
            markerId: MarkerId('start'),
            position: LatLng(widget.poly_lat1!, widget.poly_lng1!),
            infoWindow: InfoWindow(title: 'start'),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        _markers.add(
          Marker(
            markerId: MarkerId('end'),
            position: LatLng(widget.poly_lat2!, widget.poly_lng2!),
            infoWindow: InfoWindow(title: 'End'),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }
    return points;
  }
}
