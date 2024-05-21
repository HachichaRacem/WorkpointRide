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
import 'package:rflutter_alert/rflutter_alert.dart';
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
  Completer<GoogleMapController> _controller = Completer();

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
  int selectedIndex = 0;
  List<Marker> myMarker = [];

  List<Marker> markers = [];
  List<dynamic> listRoutes = [];
  bool isCardSelected = false;

  double total_km = 0.0;
  bool check = false;
  List<LatLng> routeCoords = [];
  int totalDurationInMinutes = 0;
  double constantSpeed = 60.0; // Constant speed in km/h

  int selectedIndexRoute = 0;
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
/*  double tunisiaLat = 9.374317816630263;
  double tunisiaLng = 34.094398748658556;*/
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<DateTime> dates = [];
  bool check_shared_data = true;

  dynamic position1_lat, position1_lng;
  dynamic currentPosition_lat, currentPosition_lng;
  dynamic position2_lat = 36.85135579846211, position2_lng = 10.179065957033673;

  final alertStyle = AlertStyle(
      backgroundColor: const Color(0xFF003A5A).withOpacity(0.8),
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.red,
      ),
      // constraints: BoxConstraints.expand(width: 300),
      //First to chars "55" represents transparency of color
      overlayColor: Colors.black.withOpacity(0.36),
      alertElevation: 0,
      alertAlignment: Alignment.topCenter);

  bool check_visible = true;
  void origin_address_method(dynamic newlat, dynamic newlng) async {
    position1_lat = newlat;
    position1_lng = newlng;

    List<Placemark> placemark = await placemarkFromCoordinates(newlat, newlng);
    origin_address_name =
        "${placemark.reversed.last.country} , ${placemark.reversed.last.locality}, ${placemark.reversed.last.street} ";

    setState(() {});
  }

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
        selectedIndexRoute = index;
        isCardSelected = true;
      });
      // If it's a new selection, update the selected index and set the selection state to true

      drawRoute();
    }

    showRide();
  }

  void drawRoute() async {
    routeCoords = [];
    listRoutes[selectedIndexRoute]["polyline"].forEach((polyline) {
      //  print("sssssssssss${polyline[0]}");

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
    _polyline.clear();
    _markers.clear();
    _polyline = {};
    setState(() {
      check_map = false;
      _polyline.add(Polyline(
        polylineId: const PolylineId('route'),
        visible: true,
        points: routeCoords,
        color: Colors.white,
        width: 5,
      ));

      // Add markers
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: LatLng(
              listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0],
              listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][1]),
          infoWindow: const InfoWindow(title: 'start'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: LatLng(
              listRoutes[selectedIndexRoute]["endPoint"]["coordinates"][0],
              listRoutes[selectedIndexRoute]["endPoint"]["coordinates"][1]),
          infoWindow: const InfoWindow(title: 'End'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      // check_map = false;
    });
    CameraPosition camera_position = CameraPosition(
        target: LatLng(
            listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0],
            listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0]),
        zoom: 7);

    mapController = await _controller.future;

    mapController
        .animateCamera(CameraUpdate.newCameraPosition(camera_position));
  }

  Future<void> _fetchRoute() async {
    final apiKey =
        'AIzaSyBglflWQihT8c4yf4q2MVa2XBtOrdAylmI'; // Replace with your Google Maps API key
    final start = '${position1_lat},${position1_lng}';
    final end = '${position2_lat},${position2_lng}';
    final apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$start&destination=$end&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    final responseData = json.decode(response.body);

    if (responseData['status'] == 'OK') {
      routeCoords = [];
      final List<Steps> steps =
          Directions.fromJson(responseData).routes.first.steps;
      steps.forEach((step) {
        routeCoords.add(LatLng(step.startLocation.lat, step.startLocation.lng));
        //   routeCoords.addAll(_decodePolyline(step.polyline));
      });
      _polyline.clear();
      _polyline = {};
      setState(() {
        _polyline.add(Polyline(
          polylineId: const PolylineId('route'),
          visible: true,
          points: routeCoords,
          color: Colors.white,
          width: 5,
        ));

        // Add markers
        _markers.add(
          Marker(
            markerId: const MarkerId('start'),
            position: LatLng(position1_lat, position1_lng),
            infoWindow: const InfoWindow(title: 'start'),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        _markers.add(
          Marker(
            markerId: const MarkerId('end'),
            position: LatLng(position2_lat, position2_lng),
            infoWindow: const InfoWindow(title: 'End'),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        check_map = false;
      });
    }
  }

  Future<void> getRoutes() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? user = prefs.getString('user');

      await _routeService.getRouteByUser(user!).then((value) async {
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
    } catch (e) {}
  }

  google_map_for_origin(GoogleMapController? map_controller) async {
    currentPosition_lat = await sharedpreferences.getlat();
    currentPosition_lng = await sharedpreferences.getlng();

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
                                      onTap: (position) async {
                                        mapGoogle(position);
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
                                        placeType: PlaceType.establishment,
                                        bgColor: Colors.white,
                                        // location: LatLng(currentPosition_lat,
                                        //     currentPosition_lng),
                                        //language: 'ar',
                                        //  radius: 5000000000,
                                        textColor: Colors.black,
                                        placeholder: "Search Any Location",
                                        apiKey:
                                            "AIzaSyBglflWQihT8c4yf4q2MVa2XBtOrdAylmI",
                                        onSelected: (Place place) async {
                                          Geolocation? geo_location =
                                              await place.geolocation;

                                          //Finalize the lat & lng and then call the GoogleMap Method for origin name!

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
    await _fetchRoute();

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

    CameraPosition camera_position =
        CameraPosition(target: LatLng(position1_lat, position1_lng), zoom: 7);

    GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(camera_position));
    });
  }

  var destination_address_name = 'EY Tower';

  List<Marker> myMarker1 = [];

  List<Marker> markers1 = [];

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
    dates = [];
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
                      minDate: DateTime.now(),
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
                        textStyle:
                            const TextStyle(color: colorsFile.titlebotton),
                        trailingDatesTextStyle: const TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                            color: Colors.black38),
                        leadingDatesTextStyle: const TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                            color: Colors.black38),
                        todayTextStyle: const TextStyle(
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

                        setState(() {
                          dates = args.value;
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
              primaryColor: Colors.blue,
              backgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch(
                  cardColor: Colors.white,
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  primarySwatch: Colors.blue), // Change primary color
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

  _showSearchRides() {
    setState(() {
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
      body: GestureDetector(
        onTap: () {
          setState(() {
            isSearchPoPupVisible = false;
            listSearchBottomSheet = false;
            bottomSheetVisible = true;
            check_visible = true;
            condition = true;
            box_check = false;
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
                        isSearch: false,
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
                    onTap: () {},
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
                            toggleSelection,
                            selectedIndexRoute,
                            isCardSelected),
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
                    bottomSheetVisible = pos > 0.5;
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
                                                          onTap: () {},
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03, // Adjust the width dynamically
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
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
                                                    Alert(
                                                      context: context,
                                                      type: AlertType.info,
                                                      style: alertStyle,
                                                      title: "",
                                                      desc:
                                                          "Schedule created successfully",
                                                      buttons: [
                                                        DialogButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          color: Colors.grey,
                                                          child: const Text(
                                                            "Close",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                      ],
                                                    ).show();
                                                  } else {
                                                    Alert(
                                                      context: context,
                                                      type: AlertType.error,
                                                      style: alertStyle,
                                                      title: "",
                                                      desc:
                                                          "Failed to create new schedule",
                                                      buttons: [
                                                        DialogButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          color: Colors.grey,
                                                          child: const Text(
                                                            "Close",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                      ],
                                                    ).show();
                                                  }
                                                }).catchError((error) {
                                                  // Handle any errors that occurred during the request
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
                              padding: const EdgeInsets.only(top: 6, bottom: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        box_check = false;
                                        setState(() {});
                                      },
                                      child: const Icon(Icons.close, size: 18))
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Duration = ${totalDurationInMinutes} Minutes ",
                                  style: const TextStyle(fontSize: 10),
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
        prefixIcon: const Icon(Icons.place, color: colorsFile.icons),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }
}
