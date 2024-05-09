import 'dart:async';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddRouteDialogue extends StatefulWidget {
  Completer<GoogleMapController> _controller;
  AddRouteDialogue(this._controller, {Key? key}) : super(key: key);

  @override
  State<AddRouteDialogue> createState() => _AddRouteDialogueState();
}

class _AddRouteDialogueState extends State<AddRouteDialogue> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  Color baseColor = const Color(0xFFf2f2f2);
  String originAddressName = 'Home';
  String destinationAddressName = 'EY';
  List<Marker> myMarker = [];
  double? selectedStartLat;
  double? selectedStartLong;
  double? selectedDestLat;
  double? selectedDestLong;

  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return GlassmorphicContainer(
      height: 270,
      width: _width * 0.85,
      borderRadius: 15,
      blur: 2,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          const Color(0xFF003A5A).withOpacity(0.37),
          const Color(0xFF003A5A).withOpacity(1),
          const Color(0xFF003A5A).withOpacity(0.36),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderGradient: LinearGradient(
        colors: [
          const Color(0xFF003A5A).withOpacity(0.37),
          const Color(0xFF003A5A).withOpacity(1),
          const Color(0xFF003A5A).withOpacity(0.36),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 10, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    _selectDateRange(
                        context); // Call function to show date range picker
                  },
                  icon: const Icon(Icons.calendar_month), // Use calendar icon
                ),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(
                    ' ${_selectedTime.hour}:${_selectedTime.minute}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                //SizedBox(width: 15.0),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // widget.showRoutes();
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFFFFFFFF), // White color
                      size: 25.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: TextField(
                            controller: TextEditingController(
                                text: '${originAddressName}'),
                            keyboardType: TextInputType.none,
                            onTap: () {
                              //Calling the map functions
                              print("Ontttttttttaped");
                              GoogleMapController? map_controller;

                              showSearchDialogue(
                                  map_controller, originAddressName);
                              // widget.searchMap;
                            },
                            decoration: InputDecoration(
                              hintText: "from",
                              prefixIcon: Container(
                                width: 37.0,
                                height: 37.0,
                                margin:
                                    const EdgeInsets.only(left: 5, right: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  color: Colors.white,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    //Calling the map functions
                                    print("Ontaped");
                                    // GoogleMapController? map_controller;
                                    // widget.searchMap;
                                  },
                                  child: const Icon(
                                    Icons.place,
                                    color: colorsFile.icons,
                                  ),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.favorite_outline,
                                    // Icons.favorite,
                                    //     color: colorsFile.detailColor,
                                    // color: Colors.pink,
                                    size: 40,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: TextEditingController(
                                text: '${destinationAddressName}'),
                            keyboardType: TextInputType.none,
                            onTap: () {
                              //Calling the map functions
                              print("Ontaped");
                              //   widget.searchMap;
                            },
                            decoration: InputDecoration(
                              hintText: "from",
                              prefixIcon: Container(
                                width: 37.0,
                                height: 37.0,
                                margin:
                                    const EdgeInsets.only(left: 5, right: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                  color: Colors.white,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    //Calling the map functions
                                    print("Ontaped");
                                    // GoogleMapController? map_controller;
                                    //   widget.searchMap;
                                  },
                                  child: const Icon(
                                    Icons.place,
                                    color: colorsFile.icons,
                                  ),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(
                              width:
                                  8), // Adjust the space between the two icons

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.swap_vert,
                                    // Icons.favorite,
                                    //     color: colorsFile.detailColor,
                                    // color: Colors.pink,
                                    size: 40,
                                  ),
                                )),
                          ),

                          // Adjust the space between the two icons
                        ],
                      ),
                    ),
                  ),

                  //start
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          Expanded(
                            child: RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                  width:
                                      10, // Adjust width and height as per your image size
                                  height: 10,
                                  color: colorsFile
                                      .done, // You can also apply color to the image if needed
                                );
                              },
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                          const SizedBox(
                              width:
                                  80), // Adjust the space between the two icons
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                                onTap: () {
                                  //   widget.onAddPressed;
                                },
                                child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white60,
                                    ),
                                    child: Center(
                                      child: ClayContainer(
                                        color: Colors.white,
                                        height: 35,
                                        width: 35,
                                        borderRadius: 40,
                                        curveType: CurveType.concave,
                                        depth: 30,
                                        spread: 2,
                                        child: const Center(
                                          child: Icon(
                                            Icons.send,
                                            color: colorsFile.buttonIcons,
                                          ),
                                        ),
                                      ),
                                    ))),
                          ), // Adjust the space between the two icons
                        ],
                      ),
                    ),
                  ),
                  // end
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDateRange(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorsFile.icons, // Change background color to blue
          content: Container(
            width: 300,
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    headerStyle: const DateRangePickerHeaderStyle(
                      textStyle: TextStyle(color: colorsFile.icons),
                    ),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      weekendDays: [7, 6],
                      dayFormat: 'EEE',
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        textStyle: TextStyle(color: colorsFile.icons),
                      ),
                      showTrailingAndLeadingDates: true,
                    ),
                    monthCellStyle: const DateRangePickerMonthCellStyle(
                      textStyle: TextStyle(color: colorsFile.icons),
                    ),
                    selectionMode:
                        DateRangePickerSelectionMode.multiple, // or .multiRange
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            colorsFile.buttonRole), // Change the color here
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: colorsFile.icons),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your submit logic here
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            colorsFile.buttonRole), // Change the color here
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: colorsFile.icons),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showSearchDialogue(GoogleMapController? ShowDialogueMapController,
      String destination) async {
    showDialog(
        context: context,
        builder: (context) {
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;

          return Dialog(
            child: Container(
                height: height * 0.7,
                width: width * 0.8,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(30.254551,
                            10.2551), // Should be LatLng(current_lat,current_lng)
                        zoom: 14,
                      ),
                      // markers: Set<Marker>.of(myMarker),
                      onMapCreated: (GoogleMapController controller) {
                        // _controller.complete(controller);
                        setState(() {
                          ShowDialogueMapController = controller;
                          // mapController.setMapStyle(snapshot.data);
                        });
                      },
                      onTap: (position) async {
                        /*   await addMarker(
                              position,
                              selectedStartLat,
                              selectedStartLong,
                            );*/
                        print("laaatttttttttt${position.latitude}");
                        print("longggggggggggggg${position.longitude}");
                        List<Placemark> placemark =
                            await placemarkFromCoordinates(
                                position.latitude, position.longitude);
                        Navigator.pop(context);

                        destination =
                            "${placemark.reversed.last.country} , ${placemark.reversed.last.locality}, ${placemark.reversed.last.street} ";
                      },
                      myLocationEnabled: true,
                      buildingsEnabled: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: SearchMapPlaceWidget(
                          hasClearButton: true,
                          iconColor: Colors.black,
                          placeType: PlaceType.region,
                          bgColor: Colors.white,
                          textColor: Colors.black,
                          placeholder: "Search Any Location",
                          apiKey: "AIzaSyBglflWQihT8c4yf4q2MVa2XBtOrdAylmI",
                          onSelected: (Place place) async {
                            print(
                                "------------Selected origin location from search:----------");
                            Geolocation? geo_location = await place.geolocation;
                            print(
                                "--------- Coordinates are: ${geo_location?.coordinates}");

                            //Finalize the lat & lng and then call the GoogleMap Method for origin name!

                            print("running-----");
                            ShowDialogueMapController!.animateCamera(
                                CameraUpdate.newLatLng(
                                    geo_location?.coordinates));
                            ShowDialogueMapController!.animateCamera(
                                CameraUpdate.newLatLngBounds(
                                    geo_location?.bounds, 0));
                          }),
                    ),
                  ],
                )),
          );
          ;
        });
  }

/*  Future<String> getAddress(
    dynamic newlat,
    dynamic newlng,
  ) async {
    //Storing poly_lat and poly_lng in shared preferences

    await sharedpreferences.set_poly_lat1(newlat);
    await sharedpreferences.set_poly_lng1(newlng);

    List<Placemark> placemark = await placemarkFromCoordinates(newlat, newlng);
    print(
        "tttttttttttttttttttttttttt ${placemark.reversed.last.country} , ${placemark.reversed.last.locality}, ${placemark.reversed.last.street} ");
    return "${placemark.reversed.last.country} , ${placemark.reversed.last.locality}, ${placemark.reversed.last.street} ";
  }*/
/*

  addMarker(
    position,
    selectedLat,
    selectedLong,
  ) async {
    myMarker.clear();
    selectedLat = position.latitude;
    selectedLong = position.longitude;

    Navigator.pop(context);

    myMarker.add(Marker(
      markerId: const MarkerId("First"),
      position: LatLng(selectedLat, selectedLong),
      infoWindow: const InfoWindow(title: "Home Location"),
    ));

    CameraPosition camera_position =
        CameraPosition(target: LatLng(selectedLat, selectedLong), zoom: 14);

    GoogleMapController controller = await widget._controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(camera_position));
  }
*/

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor:
                Colors.blue, // Change the primary color of the TimePicker
            hintColor:
                Colors.green, // Change the accent color of the TimePicker
            backgroundColor:
                Colors.white, // Change the background color of the TimePicker
            dialogBackgroundColor:
                Colors.grey[200], // Change the dialog background color
            textTheme: const TextTheme(
              headline1:
                  TextStyle(color: Colors.black), // Change the text color
              button:
                  TextStyle(color: Colors.red), // Change the button text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }
}
