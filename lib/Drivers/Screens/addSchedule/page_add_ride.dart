import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osmflutter/Drivers/Screens/addSchedule/add_route_dialogue.dart';
import 'package:osmflutter/Drivers/Screens/addSchedule/background_map.dart';
import 'package:osmflutter/Drivers/Screens/addSchedule/want_to_book.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PageAddRide extends StatefulWidget {
  PageAddRide({Key? key}) : super(key: key);

  @override
  _PageAddRideState createState() => _PageAddRideState();
}

class _PageAddRideState extends State<PageAddRide> {
  bool MyRides_visible = true;
  bool isSearchPoPupVisible = false;
  bool condition = true;

  late GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  double? poly_lat1, poly_lng1, poly_lat2, poly_lng2;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      
      body: Stack(
        children: [
          // Background Photo

          Positioned(
            child: Container(
                child:
                    BackgroundMap(poly_lat1, poly_lat2, poly_lng1, poly_lng2)),
          ),
          Visibility(
            visible: MyRides_visible,
            child: SlidingUpPanel(
              maxHeight: _height * 0.99,
              minHeight: _height * 0.2,
              panel: SingleChildScrollView(
                child: WantToBook(
                  "Your proposed rides",
                  "Want to add a ride? Press + button!",
                  _showDialogueSearch,
                ),
              ),
              body: Container(), // Your body widget here
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
              color: colorsFile.cardColor,
              onPanelSlide: (double pos) {
                setState(() {
                  print("dddddddd");
                  MyRides_visible = pos > 0.5;
                  print("sadasddsadds $MyRides_visible");
                });
              },
              isDraggable: condition,
            ),
          ),
          Visibility(
            visible: isSearchPoPupVisible,
            child: Positioned(
                top: 20,
                right: _width / 2 * 0.15,
                child: AddRouteDialogue(
                     _controller)),
          ),
        ],
      ),
    );
  }

  void _showDialogueSearch() {
    setState(() {
      isSearchPoPupVisible = true;
      MyRides_visible = false;
    });
  }
}
