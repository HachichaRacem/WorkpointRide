import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:osmflutter/Drivers/Screens/addSchedule/want_to_book.dart';
import 'package:osmflutter/Drivers/widgets/proposed_rides.dart';
import 'package:osmflutter/GoogleMaps/driver_polyline_map.dart';
import 'package:osmflutter/GoogleMaps/googlemaps.dart';
import 'package:osmflutter/Services/route.dart';
import 'package:osmflutter/Services/schedule.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:osmflutter/models/Directions.dart';
import 'package:osmflutter/models/Steps.dart';
import 'package:osmflutter/shared_preferences/shared_preferences.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddRides extends StatefulWidget {
  const AddRides({Key? key}) : super(key: key);

  @override
  _AddRidesState createState() => _AddRidesState();
}

class _AddRidesState extends State<AddRides>
    with SingleTickerProviderStateMixin {
  //Google Maps For Home

  late GoogleMapController mapController;
  bool check_map = true;
  final routeService _routeService = routeService();
  scheduleServices _scheduleServices = scheduleServices();
  int nbPlaces = 0;
  Set<Polyline> _polyline = {};
  Set<Marker> _markers = {};
  //For home
  String routeType = "toOffice";
  var origin_address_name = 'Home';
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  List<Marker> myMarker = [];

  List<Marker> markers = [];
  List<dynamic> listRoutes = [];

  Completer<GoogleMapController> _controller = Completer();

  double total_km = 0.0;
  bool check = false;
  List<LatLng> routeCoords = [];
  int totalDurationInMinutes = 0;
  double constantSpeed = 60.0; // Constant speed in km/h

  int selectedIndex = 0;
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth;
  bool isSearchPoPupVisible = false;
  bool listSearchBottomSheet = false;
  bool box_check = false;
  bool bottomSheetVisible = true;
  bool myRidesbottomSheetVisible = false;
  bool ridesIsVisible = false;
  late double _height;
  late double _width;
  bool condition = true; //true

  TimeOfDay _selectedTime = TimeOfDay.now();
  List<DateTime> dates = [];
  bool check_shared_data = true;

  dynamic position1_lat, position1_lng;
  dynamic currentPosition_lat, currentPosition_lng;

  dynamic position2_lat = 36.84451734808181, position2_lng = 10.200780224955338;

  bool check_visible = true;
  void origin_address_method(dynamic newlat, dynamic newlng) async {
    position1_lat = newlat;
    position1_lng = newlng;

    List<Placemark> placemark = await placemarkFromCoordinates(newlat, newlng);
    origin_address_name =
        "${placemark.reversed.last.country} , ${placemark.reversed.last.locality}, ${placemark.reversed.last.street} ";

    print("Origin Name == ${origin_address_name}");

    setState(() {
      print("Setstate is done for origin address name");
    });
  }

  Future<void> _fetchRoute() async {
    final apiKey =
        'AIzaSyBglflWQihT8c4yf4q2MVa2XBtOrdAylmI'; // Replace with your Google Maps API key
    final start = '${position1_lat},${position1_lng}';
    final end = '${position2_lat},${position2_lng}';
    final apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$start&destination=$end&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    print('response ${response}');
    final responseData = json.decode(response.body);

    if (responseData['status'] == 'OK') {
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
            position: LatLng(position1_lat, position1_lng),
            infoWindow: InfoWindow(title: 'start'),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        _markers.add(
          Marker(
            markerId: MarkerId('end'),
            position: LatLng(position2_lat, position2_lng),
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

  Future<void> getRoutes() async {
    print("hello");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? user = prefs.getString('user');

      await _routeService.getRouteByUser(user!).then((value) async {
        print("vvvvvvaaalllllllllll${value.data}");

        if (value.statusCode == 200) {
          setState(() {
            listRoutes = value.data;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${value.data["error"]}"),
          ));
        }
      });
    } catch (e) {
      print("eeeee${e}");
    }
  }

  google_map_for_origin(GoogleMapController? map_controller) async {
    currentPosition_lat = await sharedpreferences.getlat();
    currentPosition_lng = await sharedpreferences.getlng();

    print(
        "cccccccccc Shared data currentttt${currentPosition_lat} : ${currentPosition_lng}");

    setState(() {
      check = true;
    });

    showDialog(
        context: context,
        builder: (context) {
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;

          return Dialog(
            child: Stack(
              children: [
                Container(
                  height: height * 0.99,
                  width: width,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  child: check == true
                      ? FutureBuilder<String>(
                          future: _loadNightStyle(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Stack(
                                children: [
                                  Container(
                                    height: height * 0.99,
                                    width: width,
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(currentPosition_lat,
                                            currentPosition_lng), // Should be LatLng(current_lat,current_lng)
                                        zoom: 14,
                                      ),
                                      markers: Set<Marker>.of(myMarker),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        // _controller.complete(controller);
                                        setState(() {
                                          map_controller = controller;
                                          mapController = controller;
                                          mapController
                                              .setMapStyle(snapshot.data);
                                        });
                                      },
                                      onTap: (position) {
                                        mapGoogle(position);
                                        setState(() {});
                                      },
                                      myLocationEnabled: true,
                                      buildingsEnabled: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 8, right: 8),
                                    child: SearchMapPlaceWidget(
                                        hasClearButton: true,
                                        iconColor: Colors.black,
                                        placeType: PlaceType.region,
                                        bgColor: Colors.white,
                                        textColor: Colors.black,
                                        placeholder: "Search Any Location",
                                        apiKey:
                                            "AIzaSyBglflWQihT8c4yf4q2MVa2XBtOrdAylmI",
                                        onSelected: (Place place) async {
                                          print(
                                              "------------Selected origin location from search:----------");
                                          Geolocation? geo_location =
                                              await place.geolocation;
                                          print(
                                              "--------- Coordinates are: ${geo_location?.coordinates}");

                                          //Finalize the lat & lng and then call the GoogleMap Method for origin name!

                                          print("running-----");
                                          map_controller!.animateCamera(
                                              CameraUpdate.newLatLng(
                                                  geo_location?.coordinates));
                                          map_controller!.animateCamera(
                                              CameraUpdate.newLatLngBounds(
                                                  geo_location?.bounds, 0));
                                        }),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error loading night style'));
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white));
                            }
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                ),
              ],
            ),
          );
          ;
        });
  }

  mapGoogle(position) async {
    myMarker.clear();
    position1_lat = position.latitude;
    position1_lng = position.longitude;

    Navigator.pop(context);
    origin_address_method(position1_lat, position1_lng);
    myMarker.add(Marker(
      markerId: const MarkerId("First"),
      position: LatLng(position1_lat, position1_lng),
      infoWindow: const InfoWindow(title: "Home Location"),
    ));

    myMarker.add(Marker(
      markerId: const MarkerId("First"),
      position: LatLng(position2_lat, position2_lng),
      infoWindow: const InfoWindow(title: "Home Location"),
    ));

    print("After Selecting Origin: Lat & Lng is ");

    setState(() {});

    CameraPosition camera_position =
        CameraPosition(target: LatLng(position1_lat, position1_lng), zoom: 12);

    GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(camera_position));
  }

  var destination_address_name = 'EY Tower';

/*  void destination_address_method(double newlat, double newlng) async {
    print("Our required lat and lng for Destination-polyline is: ");
    poly2_lat = newlat;
    poly2_lng = newlng;
    print("Lat: ${poly2_lat} & Lng: ${poly2_lng} ");

    //Storing poly_lat and poly_lng in shared preferences



    setState(() {});
    List<Placemark> placemark = await placemarkFromCoordinates(newlat, newlng);
    setState(() {});
    destination_address_name =
        "${placemark.reversed.last.country} , ${placemark.reversed.last.locality}, ${placemark.reversed.last.street} ";

    print("Destination Name == ${destination_address_name}");

    //Now getting shared preferences values

    get_shared();
  }*/

  Completer<GoogleMapController> _controller1 = Completer();

  // Markers

  List<Marker> myMarker1 = [];

  List<Marker> markers1 = [];

/*
  mapGoogle1(position) async {
    myMarker1.clear();
    current_lat2 = position.latitude;
    current_lng2 = position.longitude;

    print("After Selecting Destination: Lat & Lng is ");
    print(current_lat2);
    print(current_lng2);

    Navigator.pop(context);
    destination_address_method(current_lat2, current_lng2);
    myMarker1.add(Marker(
      markerId: const MarkerId("First"),
      position: LatLng(current_lat2, current_lng2),
      infoWindow: const InfoWindow(title: "EY Tower Location"),
    ));

    setState(() {});
    //Setting camera position in setstate
    CameraPosition camera_position1 =
        CameraPosition(target: LatLng(current_lat2, current_lng2), zoom: 14);

    GoogleMapController controller = await _controller1.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(camera_position1));

    print("-----------Updated-----------");
    print(current_lat2);
    print(current_lng2);
  }
*/

  get_shared() async {
    print("Inside the method where I fetch the sp polylines values");

/*    final prefs = await sharedpreferences.get_poly_lat1();
    sp_poly_lat1 = prefs;
    print("Poly_lat1 = ${sp_poly_lat1}");

    final prefs1 = await sharedpreferences.get_poly_lng1();
    sp_poly_lng1 = prefs1;
    print("Poly_lng1 = ${sp_poly_lng1}");

    final prefs2 = await sharedpreferences.get_poly_lat2();
    sp_poly_lat2 = prefs2;
    print("Poly_lat2 = ${sp_poly_lat2}");

    final prefs3 = await sharedpreferences.get_poly_lng2();
    sp_poly_lng2 = prefs3;
    print("Poly_lng2 = ${sp_poly_lng2}");

    setState(() {});

    print("Calling the total km function");*/

    calculateDistance(
        position1_lat, position1_lng, position2_lat, position2_lng);

    print("Calling the total km function");

    calculateDuration(
        position1_lat, position1_lng, position2_lat, position2_lng);
  }

  void calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    total_km = 12742 * asin(sqrt(a));

    String inString = total_km.toStringAsFixed(2); // '2.35'
    total_km = double.parse(inString);

    setState(() {});
  }

  void calculateDuration(double lat1, double lon1, double lat2, double lon2) {
    // Convert latitude and longitude from degrees to radians
    final double p = 0.017453292519943295;
    // Earth's radius in kilometers
    final double earthRadius = 6371.0;

    // Convert latitudes and longitudes from degrees to radians
    double lat1Rad = lat1 * p;
    double lat2Rad = lat2 * p;
    double lon1Rad = lon1 * p;
    double lon2Rad = lon2 * p;

    // Calculate differences
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    // Haversine formula
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    // Calculate duration in hours
    double totalDurationInHours = distance / constantSpeed;

    // Convert hours to minutes and round to the nearest integer
    totalDurationInMinutes = (totalDurationInHours * 60).round();

    setState(() {});
  }

  void _selectDateRange(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Change background color to blue
          content: Container(
            width: 300,
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: SfDateRangePicker(
                      toggleDaySelection: true,
                      selectionShape: DateRangePickerSelectionShape.rectangle,
                      selectionRadius: 10,
                      view: DateRangePickerView.month,
                      backgroundColor: Colors.white,
                      selectionColor: colorsFile.backgroundNvavigaton,
                      headerStyle: const DateRangePickerHeaderStyle(
                          textStyle: TextStyle(color: colorsFile.titlebotton),
                          backgroundColor: Colors.white),
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        weekendDays: [7, 6],
                        dayFormat: 'EEE',
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(color: colorsFile.titlebotton),
                        ),
                        showTrailingAndLeadingDates: true,
                      ),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(color: colorsFile.titlebotton),
                        trailingDatesTextStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                            color: Colors.black38),
                        leadingDatesTextStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                            color: Colors.black38),
                        todayTextStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: colorsFile.done),
                        todayCellDecoration: BoxDecoration(
                            //  color: Colors.red,
                            border: Border.all(
                                color: colorsFile.titlebotton, width: 1),
                            shape: BoxShape.circle),
                      ),
                      selectionMode: DateRangePickerSelectionMode.multiple,
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        // Handle selection change
                        print(args.value);

                        setState(() {
                          dates.addAll(args.value);
                        });
                      },
                    ),
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: ThemeData(
              primaryColor: Colors.blue, // Change primary color
              // Add more color customizations as needed
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    getRoutes();
    //  shared_data();
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  }

/*
  shared_data() async {
    print("Getting the shared data");

    final prefs = await sharedpreferences.get_poly_lat1();
    sp_data_poly_lat1 = prefs;
    print("Poly_lat1 = ${sp_data_poly_lat1}");

    final prefs1 = await sharedpreferences.get_poly_lng1();
    sp_data_poly_lng1 = prefs1;
    print("Poly_lng1 = ${sp_data_poly_lng1}");

    final prefs2 = await sharedpreferences.get_poly_lat2();
    sp_data_poly_lat2 = prefs2;
    print("Poly_lat2 = ${sp_data_poly_lat2}");

    final prefs3 = await sharedpreferences.get_poly_lng2();
    sp_data_poly_lng2 = prefs3;
    print("Poly_lng2 = ${sp_data_poly_lng2}");

    setState(() {
      if (sp_data_poly_lat1 == null ||
          sp_data_poly_lng1 == null ||
          sp_data_poly_lat2 == null ||
          sp_data_poly_lng2 == null) {
        print("Shared data values are null");
        check_shared_data = true;
      } else {
        print("Shared data values are not null");
        check_shared_data = false;
      }
    });
  }
*/

  _showSearchRides() {
    setState(() {
      print("object");
      isSearchPoPupVisible = true;
      bottomSheetVisible = false;
      condition = false;
      check_visible = false;
    });
  }

  _showMyRides() {
    setState(() {
      isSearchPoPupVisible = true;
      listSearchBottomSheet = false;
      check_visible = false;
    });
  }

  showRide() {
    setState(() {
      ridesIsVisible = !ridesIsVisible;
    });
  }

  //Map new Theme
  Future<String> _loadNightStyle() async {
    // Load the JSON style file from assets
    String nightStyleJson = await DefaultAssetBundle.of(context)
        .loadString('assets/themes/aubergine_style.json');
    return nightStyleJson;
  }

  //slide moving

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color.fromRGBO(94, 149, 180, 1),
                Color.fromRGBO(77, 140, 175, 1),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
        toolbarHeight: 40.0,
        title: Container(
          color: Colors.transparent, // Adjust as needed
        ),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isSearchPoPupVisible = false;
            listSearchBottomSheet = false;
            bottomSheetVisible = true;
            check_visible = true;
            condition = true;
            box_check = false;
            print("inside the rides method inkwell");
          });
        },
        child: Stack(
          children: [
            // Background Photo

            Positioned(
              child: Container(
                child: check_map == true
                    ? MapsGoogleExample()
                    : DriverOnMap(
                        poly_lat1: position1_lat,
                        poly_lng1: position1_lng,
                        poly_lat2: position2_lat,
                        poly_lng2: position2_lng,
                        route_id: 'route',
                        polyline: _polyline,
                        markers: _markers,
                      ),
              ),
            ),

            // SlidingUpPanel

            Visibility(
              visible: check_visible,
              child: SlidingUpPanel(
                maxHeight: _height * 0.99,
                minHeight: 250,
                panel: SingleChildScrollView(
                  child: InkWell(
                    onTap: () {
                      print("inside the inkwell of sheet");
                      print(bottomSheetVisible);
                    },
                    child: (listRoutes.length == 0)
                        ? WantToBook(
                            "Your proposed rides",
                            "Want to add a ride? Press + button!",
                            _showSearchRides,
                          )
                        : ProposedRides(
                            listRoutes,
                            _showMyRides,
                            showRide,
                          ),
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
                    bottomSheetVisible = pos > 0.5;
                    print("sadasddsadds $bottomSheetVisible");
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
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      print("Button Press");
                      condition = true;
                      isSearchPoPupVisible = false;
                      bottomSheetVisible = true;
                      //   bottomSheetVisible=false;
                      check_visible = true;
                    });
                  },
                  child: GlassmorphicContainer(
                    height: 275,
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
                                icon: const Icon(
                                    Icons.calendar_month), // Use calendar icon
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
                                      print("close");
                                      isSearchPoPupVisible = false;
                                      bottomSheetVisible = true;
                                      condition = true;
                                      check_visible = true;
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
                                  //height: 150,
                                  width: _width * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: TextField(
                                                      readOnly: true,
                                                      controller: routeType ==
                                                              "toOffice"
                                                          ? originController
                                                          : destinationController,
                                                      keyboardType:
                                                          TextInputType.none,
                                                      onTap: () {
                                                        //Calling the map functions
                                                        print("Ontaped");
                                                        if (routeType ==
                                                            "toOffice") {
                                                          GoogleMapController?
                                                              map_controller;
                                                          google_map_for_origin(
                                                              map_controller);
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: routeType ==
                                                                "toOffice"
                                                            ? "${origin_address_name}"
                                                            : "${destination_address_name}",
                                                        prefixIcon: Container(
                                                          width: 37.0,
                                                          height: 37.0,
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5,
                                                                  right: 10),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2.0,
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              //Calling the map functions
                                                              if (routeType ==
                                                                  "toOffice") {
                                                                GoogleMapController?
                                                                    map_controller;
                                                                google_map_for_origin(
                                                                    map_controller);
                                                              }
                                                            },
                                                            child: const Icon(
                                                              Icons.place,
                                                              color: colorsFile
                                                                  .icons,
                                                            ),
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.white,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.blue,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                height: 50,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: TextField(
                                                    controller: routeType ==
                                                            "toOffice"
                                                        ? destinationController
                                                        : originController, // Ensures the address text is controlled programmatically
                                                    readOnly:
                                                        true, // Makes the field non-editable directly, only updated programmatically
                                                    onTap: () {
                                                      if (routeType !=
                                                          "toOffice") {
                                                        GoogleMapController?
                                                            map_controller;
                                                        google_map_for_origin(
                                                            map_controller);
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: routeType ==
                                                              "toOffice"
                                                          ? "${destination_address_name}"
                                                          : "${origin_address_name}",
                                                      prefixIcon: Container(
                                                        width: 37.0,
                                                        height: 37.0,
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 5, right: 10),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 2.0,
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        child: InkWell(
                                                          onTap: () {
                                                            print(
                                                                "Icon tapped for destination");
                                                          },
                                                          child: const Icon(
                                                            Icons.place,
                                                            color: colorsFile
                                                                .icons,
                                                          ),
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.blue,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                swapTextFields();
                                              },
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
                                      ],
                                    ),
                                  ),
                                ),
                                //start
                                const SizedBox(height: 10),
                                Container(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: RatingBar.builder(
                                            initialRating: nbPlaces.toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            itemCount: 4,
                                            itemBuilder: (context, _) =>
                                                Image.asset(
                                              'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                              width:
                                                  5, // Adjust width and height as per your image size
                                              height: 5,
                                              color: colorsFile
                                                  .done, // You can also apply color to the image if needed
                                            ),
                                            onRatingUpdate: (rating) {
                                              nbPlaces = rating.toInt();
                                            },
                                          ),
                                        ),
                                        // Adjust the space between the two icons
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  listSearchBottomSheet = true;
                                                  isSearchPoPupVisible = false;
                                                  box_check = true;
                                                });
                                                print("Navigate to polylines");
                                                setState(() {
                                                  check_map = false;
                                                  //shared_data();
                                                });
                                                final SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                final String? user =
                                                    prefs.getString('user');
                                                final now = new DateTime.now();
                                                DateTime startDate = DateTime(
                                                    now.year,
                                                    now.month,
                                                    now.day,
                                                    _selectedTime.hour,
                                                    _selectedTime.minute);
                                                print("uuuserrrr ${user}");
                                                await _fetchRoute();
                                                print(
                                                    "ccccccccccccccc ${routeCoords}");
                                                List<List<dynamic>> polyline =
                                                    [];
                                                routeCoords.map((latLng) {
                                                  polyline.add([
                                                    latLng.latitude,
                                                    latLng.longitude
                                                  ]);
                                                }).toList();
                                                await _scheduleServices
                                                    .addSchedule(
                                                  user:
                                                      user!, // Provide a value for the 'user' parameter
                                                  startTime:
                                                      startDate, // Provide a value for the 'startTime' parameter
                                                  scheduledDate:
                                                      dates, // Provide a value for the 'scheduledDate' parameter
                                                  availablePlaces: nbPlaces,
                                                  startPointLat: position1_lat,
                                                  startPointLang: position1_lng,
                                                  endPointLat: position1_lat,
                                                  endPointLang: position1_lng,
                                                  duration:
                                                      totalDurationInMinutes,
                                                  distance: total_km,
                                                  type: routeType,
                                                  polyline: polyline,
                                                  // Provide a value for the 'availablePlaces' parameter
                                                )
                                                    .then((value) {
                                                  // Check if the response is successful
                                                  if (value.statusCode == 200) {
                                                    print(
                                                        "Schedule added successfully");
                                                    // You can access response data if needed: value.data
                                                  } else {
                                                    // Handle unsuccessful response (non-200 status code)
                                                    print(
                                                        "Failed to add schedule: ${value.data}");
                                                  }
                                                }).catchError((error) {
                                                  // Handle any errors that occurred during the request
                                                  print(
                                                      "Error adding schedule: $error");
                                                });
                                              },
                                              child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white60,
                                                  ),
                                                  child: Center(
                                                    child: ClayContainer(
                                                      color: Colors.white,
                                                      height: 35,
                                                      width: 35,
                                                      borderRadius: 40,
                                                      curveType:
                                                          CurveType.concave,
                                                      depth: 30,
                                                      spread: 2,
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.send,
                                                          color: colorsFile
                                                              .buttonIcons,
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
                  ),
                ),
              ),
            ),

            // Visibility(
            //   visible: listSearchBottomSheet,
            //   child: Positioned(
            //       left: 0,
            //       right: 0,
            //       bottom: 0,
            //       child: Container(
            //         height: 400,
            //         decoration: const BoxDecoration(
            //           // color: colorsFile.cardColor,
            //           borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(50.0),
            //             topRight: Radius.circular(50.0),
            //           ),
            //         ),
            //         child: ProposedRides(
            //           _showMyRides,
            //           showRide,
            //         ),
            //       )),
            // ),

            Visibility(
                visible: box_check,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: GlassmorphicContainer(
                      height: _height * 0.14,
                      width: _width * 0.4,
                      borderRadius: 5,
                      blur: 2,
                      //alignment: Alignment.center,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 6, bottom: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        box_check = false;
                                        setState(() {});
                                      },
                                      child: Icon(Icons.close, size: 18))
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Duration = ${totalDurationInMinutes} Minutes ",
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text("Total Kilometer = ${total_km} km",
                                    style: const TextStyle(fontSize: 10))
                              ],
                            ),
                          ],
                        ),
                      )),
                ))
          ],
        ),
      ),
    );
  }

  void scheduleRide() {
    setState(() {
      isSearchPoPupVisible = true;
      bottomSheetVisible = false;
      listSearchBottomSheet = false;
      box_check = false;
    });
  }

  void swapTextFields() {
    setState(() {
/*      String tempText = originController.text;
      originController.text = destinationController.text;
      destinationController.text = tempText;

      String tempAddressName = origin_address_name;
      origin_address_name = destination_address_name;
      destination_address_name = tempAddressName;*/
      if (routeType == "toOffice") {
        routeType = "fromOffice";
      } else {
        routeType = "toOffice";
      }
    });
  }

  Widget buildTextField(String label, TextEditingController controller,
      String hintText, VoidCallback onTap) {
    return TextField(
      controller: controller,
      onTap: onTap,
      readOnly: true, // Make it readOnly if it triggers map selection
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(Icons.place, color: colorsFile.icons),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.white, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }
}
