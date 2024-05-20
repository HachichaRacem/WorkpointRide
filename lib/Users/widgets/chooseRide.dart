import 'dart:convert';

import 'package:clay_containers/clay_containers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osmflutter/Services/reservation.dart';
import 'package:osmflutter/Services/schedule.dart';
import 'package:osmflutter/Users/widgets/routeCrad.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChooseRide extends StatefulWidget {
  final Function() showMyRides;
  final Function() ridesVisible;
  final Function(Map) updateSelectedRouteCardInfo;
  final Function() selectMap;
  Set<Polyline>? _polyline;
  Set<Marker>? _markers;
  final Function() isSearch;
  Marker? pickMarker;
  dynamic selectedDate;
  String routeType;
  ChooseRide(
      this.showMyRides,
      this.ridesVisible,
      this.updateSelectedRouteCardInfo,
      this.selectMap,
      this._polyline,
      this._markers,
      this.isSearch,
      this.pickMarker,
      this.selectedDate,
      this.routeType,
      {Key? key})
      : super(key: key);

  @override
  _ChooseRideState createState() => _ChooseRideState();
}

class _ChooseRideState extends State<ChooseRide> {
  late double _height;
  late double _width;
  bool bottomSheetVisible = true;
  bool isCardSelected = false;
  int selectedIndexRoute = -1;
  List<LatLng> routeCoords = [];

  List<dynamic> listRoutes = [];
  dynamic position1_lat, position1_lng;
  dynamic currentPosition_lat, currentPosition_lng;
  dynamic position2_lat = 36.85135579846211, position2_lng = 10.179065957033673;
  List<Color> containerColors = List.filled(
      4, colorsFile.cardColor); // Use the background color as the default color
  Future<Response> _getAllSchedules() async {
    dynamic data = await scheduleServices().getAllSchedules();
    for (int index = 0; index < data.data.length; index++) {
      print("dataaaaaaaaa ${data.data}");
      listRoutes.add(data.data?[index]["routes"]);
    }
    return data;
  }

  List schedules = [];
  int selectedRouteCardIndex = 0;
  void toggleSelection(int index) {
    if (selectedIndexRoute == index) {
      // Toggle the selection state if the card is tapped again
      setState(() {
        selectedIndexRoute = -1;
        isCardSelected = !isCardSelected;
      });
      // Reset card color to default when the second tab is selected
    } else {
      setState(() {
        if (widget.ridesVisible != null) {
          widget.ridesVisible!();
        }
        selectedIndexRoute = index;
        isCardSelected = true;
      });
      // If it's a new selection, update the selected index and set the selection state to true

      drawRoute();
    }
  }

  Map<String, dynamic> polylineToMap(Polyline polyline) {
    return {
      'polylineId': polyline.polylineId.value,
      'points': polyline.points
          .map((point) =>
              {'latitude': point.latitude, 'longitude': point.longitude})
          .toList(),
      'width': polyline.width,
      'color': polyline.color.value,
    };
  }

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

  Future<void> savePolylines(Set<Polyline> polylines) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> polylineList = polylines
        .map((polyline) => jsonEncode(polylineToMap(polyline)))
        .toList();
    await prefs.setStringList('polylines', polylineList);
  }

  void drawRoute() async {
    routeCoords = [];

    listRoutes[selectedIndexRoute]["polyline"].forEach((polyline) {
      routeCoords.add(LatLng(polyline[0], polyline[1]));
    });
    position1_lat =
        listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0];
    position1_lng =
        listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][1];
    position2_lat =
        listRoutes[selectedIndexRoute]["endPoint"]["coordinates"][0];
    position2_lng =
        listRoutes[selectedIndexRoute]["endPoint"]["coordinates"][1];
    widget._polyline!.clear();
    widget._markers!.clear();
    widget._polyline = {};
    setState(() {
      widget._polyline!.add(Polyline(
        polylineId: PolylineId('polyline1'),
        visible: true,
        points: routeCoords,
        color: Colors.white,
        width: 5,
      ));

      // Add markers
      widget._markers!.add(
        Marker(
          markerId: MarkerId('start'),
          position: LatLng(
              listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0],
              listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][1]),
          infoWindow: InfoWindow(title: 'start'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      widget._markers!.add(
        Marker(
          markerId: MarkerId('end'),
          position: LatLng(
              listRoutes[selectedIndexRoute]["endPoint"]["coordinates"][0],
              listRoutes[selectedIndexRoute]["endPoint"]["coordinates"][1]),
          infoWindow: InfoWindow(title: 'End'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      widget.isSearch();
      widget.selectMap();
    });
    await savePolylines(widget._polyline!);

/*    CameraPosition camera_position = CameraPosition(
        target: LatLng(
            listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0],
            listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0]),
        zoom: 7);

    mapController = await _controller.future;

    mapController
        .animateCamera(CameraUpdate.newCameraPosition(camera_position));*/
  }

  void updateSelectedCardIndex(int index) {
    setState(() => selectedRouteCardIndex = index);
  }

  Future _createReservation() async {
    //   try {
    if (schedules.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final userID = prefs.getString("user");
      final latitude = prefs.getDouble("markerLat");
      final longitude = prefs.getDouble("markerLng");
      final reqBody = {
        "user": userID,
        "schedule": schedules[selectedIndexRoute]["_id"],
        "pickupTime": schedules[selectedIndexRoute]["startTime"],
        "pickupLocation": {
          "type": "Point",
          "coordinates": [latitude, longitude],
        }
      };
      print("reqBody${reqBody}");

      var value = await Reservation().createReservation(reqBody);
      print("createReservationr Reeessss${value}");

      // widget.showMyRides();
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height * 0.7,
      minHeight: MediaQuery.of(context).size.height * 0.35,
      panel: Stack(
        alignment: AlignmentDirectional.topCenter,
        // clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 5,
            child: Container(
              width: 60,
              height: 7,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: colorsFile.background,
              ),
            ),
          ),
          Positioned(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 8.0, 0, 8),
                      child: Text(
                        "Choose a ride",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorsFile.titleCard,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Stack(
                          children: [
                            ClayContainer(
                              color: Colors.white,
                              height: 50,
                              width: 50,
                              borderRadius: 50,
                              curveType: CurveType.concave,
                              depth: 30,
                              spread: 1,
                            ),
                            GestureDetector(
                              onTap: _createReservation,
                              child: Center(
                                child: ClayContainer(
                                  color: Colors.white,
                                  height: 40,
                                  width: 40,
                                  borderRadius: 40,
                                  curveType: CurveType.convex,
                                  depth: 30,
                                  spread: 1,
                                  child: Center(
                                    child: Icon(
                                      Icons.send,
                                      color: colorsFile.buttonIcons,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: _getAllSchedules(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      schedules = snapshot.data?.data;
                      //debugPrint("[TEST]: ${schedules[0]}");
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            schedules.length,
                            (index) {
                              print("snapshot${snapshot.data?.data}");
                              final Map? driverData =
                                  snapshot.data?.data[index]['user'];
                              return GestureDetector(
                                onTap: () {
                                  toggleSelection(index);
                                },
                                child: RouteCard(schedules, driverData,
                                    isCardSelected, selectedIndexRoute, index),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "Fetching routes...",
                          style: TextStyle(color: colorsFile.cardColor),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50.0),
        topRight: Radius.circular(50.0),
      ),
      color: colorsFile.cardColor,
      onPanelSlide: (double pos) {
        setState(() {
          print("dbvskcxjb");
          bottomSheetVisible = pos > 0.5;
        });
      },
      isDraggable: true,
    );
  }
}

// Available routes once the passenger picks the route, time and date
