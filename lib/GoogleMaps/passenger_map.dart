// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: passenger_polyline_map(),
//   ));
// }
//
// class passenger_polyline_map extends StatefulWidget {
//
//   passenger_polyline_map(
//       {Key? key,
//       })
//       : super(key: key);
//
//   @override
//   _passenger_polyline_mapState createState() => _passenger_polyline_mapState();
// }
//
// class _passenger_polyline_mapState extends State<passenger_polyline_map> {
//   late GoogleMapController mapController;
//   late LatLng currentLocation =
//   LatLng(0.0, 0.0); // Initialize with default location
//
//   Set<Marker> markers = {};
//
//   bool loading = true;
//
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//   }
//
//   void getCurrentLocation() async {
//     LocationPermission permission;
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       // Handle location permissions denied
//       setState(() {
//         loading = false;
//       });
//     } else {
//       Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         currentLocation = LatLng(position.latitude, position.longitude);
//         loading = false;
//       });
//       addMarker(currentLocation);
//     }
//   }
//
//   void addMarker(LatLng position) {
//     markers.add(
//       Marker(
//         markerId: MarkerId("currentLocation"),
//         position: position,
//         infoWindow: InfoWindow(
//           title: "Current Location",
//           onTap: () {
//             // Handle marker tap here
//           },
//         ),
//         icon: BitmapDescriptor.defaultMarker, // Use the default marker icon
//       ),
//     );
//   }
//
//   Future<String> _loadNightStyle() async {
//     // Load the JSON style file from assets
//     String nightStyleJson = await DefaultAssetBundle.of(context)
//         .loadString('assets/themes/aubergine_style.json');
//     return nightStyleJson;
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: loading
//           ? Center(child: CircularProgressIndicator(color: Colors.white))
//           : FutureBuilder<String>(
//         future: _loadNightStyle(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: currentLocation,
//                 zoom: 14.5,
//               ),
//               onMapCreated: (controller) {
//                 mapController = controller;
//                 mapController.setMapStyle(snapshot.data!);
//               },
//               markers: markers,
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error loading night style'));
//           } else {
//             return Center(
//                 child: CircularProgressIndicator(color: Colors.white));
//           }
//         },
//       ),
//     );
//   }
// }

//Updated coded by MA
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

import 'package:osmflutter/constant/colorsFile.dart';
import 'package:osmflutter/shared_preferences/shared_preferences.dart';

import 'driver_polyline_map.dart';

class PassengerMap extends StatefulWidget {
  bool condition;
   PassengerMap({Key? key,required this.condition}) : super(key: key);
  @override
  _PassengerMapState createState() => _PassengerMapState();
}

class _PassengerMapState extends State<PassengerMap> {
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



  Completer<GoogleMapController> _controller = Completer();


  void getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
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
      if(widget.condition)
        {
          addMarker(currentLocation);
          addFavoriteAndHomeMarkers();
        }
      else
        {
          print("Markers are not displayed");
        }
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

  Future<BitmapDescriptor> _createMarkerImageFromAsset(
      String assetName, int width, int height) async {
    ByteData byteData = await rootBundle.load(assetName);
    Uint8List byteList = byteData.buffer.asUint8List();

    ui.Codec codec = await ui.instantiateImageCodec(byteList);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;

    ui.Image resizedImage = await _resizeImage(image, width, height);

    ByteData? resizedByteData =
    await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? resizedBytes = resizedByteData?.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedBytes!);
  }

  Future<ui.Image> _resizeImage(ui.Image image, int width, int height) async {
    Completer<ui.Image> completer = Completer();

    // Convert the image to byte data
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List bytes = byteData!.buffer.asUint8List();

    // Decode the image from the byte data
    ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image decodedImage = frameInfo.image;

    // Create a PictureRecorder to draw the resized image onto
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    // Draw the resized image onto the canvas
    canvas.drawImageRect(
      decodedImage,
      Rect.fromLTRB(0, 0, decodedImage.width.toDouble(), decodedImage.height.toDouble()),
      Rect.fromLTRB(0, 0, width.toDouble(), height.toDouble()),
      Paint(),
    );

    // End recording and finalize the image
    ui.Image resizedImage = await recorder.endRecording().toImage(width, height);
    completer.complete(resizedImage);

    return completer.future;
  }



  void addFavoriteAndHomeMarkers() async {
    // Dummy favorite and home locations near to current location
    LatLng favorite1 =
    LatLng(currentLocation.latitude + 0.01, currentLocation.longitude + 0.01);
    LatLng favorite2 =
    LatLng(currentLocation.latitude - 0.01, currentLocation.longitude - 0.01);
    LatLng home1 =
    LatLng(currentLocation.latitude + 0.01, currentLocation.longitude - 0.01);
    LatLng home2 =
    LatLng(currentLocation.latitude + 0.0001, currentLocation.longitude - 0.02);

    // Adding favorite markers
    BitmapDescriptor favoriteIcon =
    await _createMarkerImageFromAsset('assets/images/heart.png', 130, 130);
    markers.add(
      Marker(
        markerId: MarkerId("favorite1"),
        position: favorite1,
        infoWindow: InfoWindow(
          title: "Favorite Location # 01",
          onTap: () {
            // Handle marker tap here
          },
        ),
        icon: favoriteIcon,
      ),
    );

    markers.add(
      Marker(
        markerId: MarkerId("favorite2"),
        position: favorite2,
        infoWindow: InfoWindow(
          title: "Favorite Location # 02",
          onTap: () {
            // Handle marker tap here
          },
        ),
        icon: favoriteIcon,
      ),
    );

    // Adding home markers
    BitmapDescriptor homeIcon =
    await _createMarkerImageFromAsset('assets/images/home--removebg-preview.png', 130, 130);
    markers.add(
      Marker(
        markerId: MarkerId("home1"),
        position: home1,
        infoWindow: InfoWindow(
          title: "Home Location # 01",
          onTap: () {
            // Handle marker tap here
          },
        ),
        icon: homeIcon,
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId("home2"),
        position: home2,
        infoWindow: InfoWindow(
          title: "Home Location # 02",
          onTap: () {
            // Handle marker tap here
          },
        ),
        icon: homeIcon,
      ),
    );
    setState(() {}); // Refresh the map to show the markers
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
                    _controller.complete(controller);
                    mapController = controller;
                    mapController.setMapStyle(snapshot.data!);
                  },
                  markers: markers,
                  onTap: (_){

                  },
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
