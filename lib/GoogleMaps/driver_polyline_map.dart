import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osmflutter/constant/colorsFile.dart';

class DriverOnMap extends StatefulWidget {
  final double poly_lat1, poly_lng1, poly_lat2, poly_lng2;
  final Set<Polyline> polyline;
  final Set<Marker> markers;

  var route_id;

  DriverOnMap(
      {Key? key,
      required this.poly_lat1,
      required this.poly_lng1,
      required this.poly_lat2,
      required this.poly_lng2,
      required this.route_id,
      required this.polyline,
      required this.markers})
      : super(key: key);

  @override
  _DriverOnMapState createState() => _DriverOnMapState();
}

class _DriverOnMapState extends State<DriverOnMap> {
  Completer<GoogleMapController> _controller = Completer();

  late LatLngBounds _bounds;

  @override
  void initState() {
    super.initState();
    //  _fetchRoute();
  }

  Future<String> _loadNightStyle() async {
    // Load the JSON style file from assets
    String nightStyleJson = await DefaultAssetBundle.of(context)
        .loadString('assets/themes/aubergine_style.json');
    return nightStyleJson;
  }

  late GoogleMapController mapController;

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
                      (widget.poly_lat1 + widget.poly_lat2) / 2,
                      (widget.poly_lng1 + widget.poly_lng2) / 2,
                    ),
                    zoom: 14.5,
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
                  onTap: (_) {},
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
}
//
