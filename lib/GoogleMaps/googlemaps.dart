import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    home: MapsGoogleExample(),
  ));
}

class MapsGoogleExample extends StatefulWidget {


  MapsGoogleExample(
      {Key? key,
      })
      : super(key: key);

  @override
  _MapsGoogleExampleState createState() => _MapsGoogleExampleState();
}

class _MapsGoogleExampleState extends State<MapsGoogleExample> {
  late GoogleMapController mapController;
  late LatLng currentLocation =
      LatLng(0.0, 0.0); // Initialize with default location

  Set<Marker> markers = {};

  bool loading = true;


  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle location permissions denied
      setState(() {
        loading = false;
      });
    } else {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        loading = false;
      });
      addMarker(currentLocation);
    }
  }

  void addMarker(LatLng position) {
    markers.add(
      Marker(
        markerId: MarkerId("currentLocation"),
        position: position,
        infoWindow: InfoWindow(
          title: "Current Location",
          onTap: () {
            // Handle marker tap here
          },
        ),
        icon: BitmapDescriptor.defaultMarker, // Use the default marker icon
      ),
    );
  }

  Future<String> _loadNightStyle() async {
    // Load the JSON style file from assets
    String nightStyleJson = await DefaultAssetBundle.of(context)
        .loadString('assets/themes/aubergine_style.json');
    return nightStyleJson;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : FutureBuilder<String>(
              future: _loadNightStyle(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLocation,
                      zoom: 14.5,
                    ),
                    onMapCreated: (controller) {
                      mapController = controller;
                      mapController.setMapStyle(snapshot.data!);
                    },
                    markers: markers,
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading aubergine style'));
                } else {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.white));
                }
              },
            ),
    );
  }
}
