import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawRoute extends StatefulWidget {
  Set<Polyline> polyline;
  final Set<Marker> markers;
  Marker? marker;
  var route_id;

  DrawRoute(
      {Key? key,
      required this.route_id,
      required this.polyline,
      required this.markers,
      required this.marker})
      : super(key: key);

  @override
  _DrawRouteState createState() => _DrawRouteState();
}

class _DrawRouteState extends State<DrawRoute> {
  Completer<GoogleMapController> _controller = Completer();

  late LatLngBounds _bounds;
  Polyline mapToPolyline(Map<String, dynamic> map) {
    return Polyline(
      polylineId: PolylineId(map['polylineId']),
      points: (map['points'] as List)
          .map((point) => LatLng(point['latitude'], point['longitude']))
          .toList(),
      width: map['width'],
      color: Color(map['color']),
    );
  }

  Future<void> _fetchRoute() async {
    Set<Polyline> retrievedPolylines = await getPolylines();
    //setState(() {
    widget.polyline = retrievedPolylines;
    // });
  }

  Future<Set<Polyline>> getPolylines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> polylineList = prefs.getStringList('polylines') ?? [];
    return polylineList
        .map((polylineString) => mapToPolyline(jsonDecode(polylineString)))
        .toSet();
  }

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<String> _loadNightStyle() async {
    // Load the JSON style file from assets
    String nightStyleJson = await DefaultAssetBundle.of(context)
        .loadString('assets/themes/aubergine_style.json');
    await _fetchRoute();
    return nightStyleJson;
  }

  late GoogleMapController mapController;
  dynamic EY_lat = 36.85135579846211, EY_lng = 10.179065957033673;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _loadNightStyle(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      (EY_lat),
                      (EY_lng),
                    ),
                    zoom: 10.5,
                  ),
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                    mapController = controller;
                    mapController.setMapStyle(snapshot.data);
                  },
                  polylines: widget.polyline,
                  markers: widget.markers,
                  mapType: MapType.normal,
                  buildingsEnabled: true,
                  onTap: _onMapTapped,
                ),
                Positioned(
                  top:
                      16.0, // Adjust this value to position the zoom buttons as needed
                  right:
                      16.0, // Adjust this value to position the zoom buttons as needed
                  child: Column(
                    children: [
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: colorsFile.backgroundNvavigaton,
                        onPressed: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        },
                        child: Icon(Icons.add),
                      ),
                      SizedBox(height: 16.0),
                      FloatingActionButton(
                        backgroundColor: colorsFile.backgroundNvavigaton,
                        mini: true,
                        onPressed: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        },
                        child: Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading night style'));
          } else {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }

  Future<void> _onMapTapped(LatLng latLng) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.marker == null) {
        widget.marker = Marker(
          markerId: MarkerId("1"),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          draggable: true,
          onDragEnd: (dragEndPosition) {
            setState(() {
              widget.marker =
                  widget.marker?.copyWith(positionParam: dragEndPosition);
            });
          },
        );
        widget.markers.add(widget.marker!);
      } else {
        widget.markers.remove(widget.marker!);

        widget.marker = Marker(
          markerId: MarkerId("1"),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          draggable: true,
          onDragEnd: (dragEndPosition) {
            setState(() {
              widget.marker =
                  widget.marker?.copyWith(positionParam: dragEndPosition);
            });
          },
        );
        widget.markers.add(widget.marker!);
        widget.marker = widget.marker?.copyWith(positionParam: latLng);
      }
    });
    prefs.setDouble("markerLat", widget.marker!.position.latitude);
    prefs.setDouble("markerLng", widget.marker!.position.longitude);
  }
}
