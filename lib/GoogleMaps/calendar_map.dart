import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:osmflutter/shared_preferences/shared_preferences.dart';

class calendarMap extends StatefulWidget {


  calendarMap(
      {Key? key,
      })
      : super(key: key);

  @override
  _calendarMapState createState() => _calendarMapState();
}

class _calendarMapState extends State<calendarMap> {

  late GoogleMapController mapController;
  var lat,lng;
  late LatLng currentLocation =
  LatLng(0.0, 0.0); // Initialize with default location

  Set<Marker> markers = {};

  bool loading = true;


  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    print("------------------------Getting current location------------------------G");
  }

  void getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle location permissions denied
      print("------------------------DENIED");
      setState(() {
        loading = false;
      });
    } else {
      Position position = await Geolocator.getCurrentPosition();
      print("------------------------ACCEPT");
      await sharedpreferences.setlat(position.latitude);
      await sharedpreferences.setlng(position.longitude);
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        currentLocation = LatLng(position.latitude, position.longitude);

        loading = false;
      });
      addMarker(currentLocation);
    }
  }



  void addMarker(LatLng position) async{


    print("Lat is ${lat}");
    print("Lng is ${lng}");


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

    //First iamge

    BitmapDescriptor markerbitmap1 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/homme1-70.jpg",

    );

    markers.add(
        Marker( //add start location marker
          markerId: const MarkerId('marker1'),
          position: LatLng(lat-0.001,lng-0.001), //position of marker
          infoWindow: const InfoWindow( //popup info
              title: 'Passenger#01'
          ),
          icon: markerbitmap1, //Icon for Marker
        )
    );


    //second image

    BitmapDescriptor markerbitmap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/homme2-70.jpg",

    );

    markers.add(
        Marker( //add start location marker
          markerId: const MarkerId('marker2'),
          position: LatLng(lat+0.0007,lng+0.0007), //position of marker
          infoWindow: const InfoWindow( //popup info
              title: 'Passenger#02'
          ),
          icon: markerbitmap2, //Icon for Marker
        )
    );

    //third image

    BitmapDescriptor markerbitmap3 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/femme1-70.jpg",

    );

    markers.add(
        Marker( //add start location marker
          markerId: const MarkerId('marker3'),
          position: LatLng(lat+0.01,lng+0.01), //position of marker
          infoWindow: const InfoWindow( //popup info
              title: 'Passenger#03'
          ),
          icon: markerbitmap3, //Icon for Marker
        )
    );

    //fourth image

    BitmapDescriptor markerbitmap4 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/femme2-70.jpg",

    );

    markers.add(
        Marker(
          markerId: const MarkerId('marker4'),
          position: LatLng(lat+0.004,lng+0.004), //position of marker
          infoWindow: const InfoWindow( //popup info
              title: 'Passenger#04'
          ),
          icon: markerbitmap4, //Icon for Marker
        )
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
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentLocation,
                    zoom: 14.5,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                    setState(() {

                    });
                    mapController.setMapStyle(snapshot.data!);
                  },
                  markers: markers,
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
