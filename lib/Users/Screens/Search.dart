import 'dart:async';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:osmflutter/Drivers/Screens/addSchedule/want_to_book.dart';
import 'package:osmflutter/GoogleMaps/DrawRouteFromStorage.dart';
import 'package:osmflutter/GoogleMaps/driver_polyline_map.dart';
import 'package:osmflutter/GoogleMaps/googlemaps.dart';
import 'package:osmflutter/Services/reservation.dart';
import 'package:osmflutter/Users/BottomSheet/MyRides.dart';
import 'package:osmflutter/Users/BottomSheet/ride_card.dart';
import 'package:osmflutter/Users/widgets/chooseRide.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:osmflutter/shared_preferences/shared_preferences.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //Map new Theme
  Future<String> _loadNightStyle() async {
    // Load the JSON style file from assets
    String nightStyleJson = await DefaultAssetBundle.of(context)
        .loadString('assets/themes/aubergine_style.json');
    return nightStyleJson;
  }

  late GoogleMapController mapController;

  //Google Maps For Home

  //For home
  String routeType = "toOffice";
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  var origin_address_name = 'Home';
  Set<Polyline> _polyline = {};
  Set<Marker> _markers = {};
  bool isCardSelected = false;
  bool check_map = true;
  bool isSearch = false;
  List<dynamic> listRoutes = [];
  int selectedIndexRoute = 0;
  List<LatLng> routeCoords = [];
  dynamic position1_lat, position1_lng;
  dynamic position2_lat = 36.85135579846211, position2_lng = 10.179065957033673;
  void swapTextFields() {
    setState(() {
      if (routeType == "toOffice") {
        routeType = "fromOffice";
      } else {
        routeType = "toOffice";
      }
    });
  }

  dynamic currentDate;

  void selectMap() {
    setState(() {
      check_map = false;
    });
  }

  Marker? pickMarker;

  void isSearchMap() {
    setState(() {
      isSearch = true;
    });
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
    _polyline.clear();
    _markers.clear();
    _polyline = {};
    setState(() {
      check_map = false;
      isSearch = false;

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
          position: LatLng(
              listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0],
              listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][1]),
          infoWindow: InfoWindow(title: 'start'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('end'),
          position: LatLng(
              listRoutes[selectedIndexRoute]["endPoint"]["coordinates"][0],
              listRoutes[selectedIndexRoute]["endPoint"]["coordinates"][1]),
          infoWindow: InfoWindow(title: 'End'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      // check_map = false;
    });
    /* CameraPosition camera_position = CameraPosition(
        target: LatLng(
            listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0],
            listRoutes[selectedIndexRoute]["startPoint"]["coordinates"][0]),
        zoom: 7);

    mapController = await _controller.future;

    mapController
        .animateCamera(CameraUpdate.newCameraPosition(camera_position));*/
  }

  List<Marker> myMarker = [];

  List<Marker> markers = [];

  Completer<GoogleMapController> _controller = Completer();

  dynamic current_lat1, current_lng1, current_lat2, current_lng2;

  bool check = false;

  var destination_address_name = 'EY Tower';

  bool map_check = false;

  List<Marker> myMarker1 = [];

  List<Marker> markers1 = [];
  dynamic currentPosition_lat, currentPosition_lng;

  int selectedIndex = 0;
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth;
  bool isSearchPoPupVisible = false;
  bool listSearchBottomSheet = false;
  bool bottomSheetVisible = true;
  bool myRidesbottomSheetVisible = false;
  bool ridesIsVisible = false;
  late double _height;
  late double _width;
  bool condition = true;
  Map selectedRouteCardInfo = {};

  Future _loadReservation() async {
    final DateTime date = now.add(Duration(days: selectedIndex));
    final String dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString("user");
    debugPrint("[DATA]: userID: $userID");
    dynamic data =
        await Reservation().getReservationsByDate(userID!, dateString);
    for (int index = 0; index < data.data.length; index++) {
      listRoutes.add(data.data?[index]["schedule"]["routes"]);
    }

    return data.data;
  }

  late Future _getReservations = _loadReservation();

  @override
  void initState() {
    super.initState();
    // get_shared();
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  }

  bool check_shared_data = true;

  _showSearchRides() {
    setState(() {
      isSearchPoPupVisible = true;
      bottomSheetVisible = false;
      condition = false;
    });
  }

  _updateRides() {
    _getReservations = _loadReservation();
    setState(() {});
  }

  _showMyRides() {
    setState(() {
      myRidesbottomSheetVisible = true;
      listSearchBottomSheet = false;
    });
  }

  showRide() {
    setState(() {
      ridesIsVisible = !ridesIsVisible;
    });
  }

  updateSelectedRouteCardInfo(Map data) {
    debugPrint(
        "[DATA]: updateSelectedRouteCardInfo has been called with data = $data");
    selectedRouteCardInfo = data;
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
                                        placeType: PlaceType.region,
                                        bgColor: Colors.white,
                                        // location: LatLng(currentPosition_lat,
                                        //     currentPosition_lng),
                                        /*language: 'ar',
                                        radius: 500,*/
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

  void origin_address_method(dynamic newlat, dynamic newlng) async {
    position1_lat = newlat;
    position1_lng = newlng;

    List<Placemark> placemark = await placemarkFromCoordinates(newlat, newlng);
    origin_address_name =
        "${placemark.reversed.last.country} , ${placemark.reversed.last.locality}, ${placemark.reversed.last.street} ";

    setState(() {});
  }

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
        toolbarHeight: 120.0,
        title: Column(
          children: [
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: List.generate(
                  lastDayOfMonth.day - now.day + 1,
                  (index) {
                    currentDate = now.add(Duration(days: selectedIndex));
                    final dayName = DateFormat('EEE').format(currentDate);
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16.0 : 0.0, right: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          _getReservations = _loadReservation();
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 42.0,
                              width: 42.0,
                              alignment: Alignment.center,
                              child: Text(
                                "${now.day + index}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : colorsFile.titleCard,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dayName.substring(0, 3),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.white30,
                                fontWeight: selectedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isSearchPoPupVisible = false;
            listSearchBottomSheet = false;
            bottomSheetVisible = true;
            myRidesbottomSheetVisible = false;
          });
        },
        child: Stack(
          children: [
            // Background Photo

            //pass_route_map(lat1: sp_data_poly_lat1, lng1: sp_data_poly_lng1, lat2: sp_data_poly_lat2, lng2: sp_data_poly_lng2)
            check_map == true
                ? MapsGoogleExample()
                : isSearch == false
                    ? DriverOnMap(
                        poly_lat1: position1_lat,
                        poly_lng1: position1_lng,
                        poly_lat2: position2_lat,
                        poly_lng2: position2_lng,
                        route_id: 'route',
                        polyline: _polyline,
                        markers: _markers,
                        isSearch: isSearch)
                    : DrawRoute(
                        poly_lat1: position1_lat,
                        poly_lng1: position1_lng,
                        poly_lat2: position2_lat,
                        poly_lng2: position2_lng,
                        route_id: 'route',
                        polyline: _polyline,
                        markers: _markers,
                        marker: pickMarker),
            SlidingUpPanel(
              maxHeight: _height * 0.99,
              minHeight: _height * 0.2,
              panel: SingleChildScrollView(
                child: InkWell(
                  onTap: () {},
                  child: FutureBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.isNotEmpty) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50, 8.0, 0, 8),
                                      child: Text(
                                        'Your rides pass',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: colorsFile.titleCard),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: GestureDetector(
                                          onTap: _showSearchRides,
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
                                                Center(
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
                                                        Icons.add,
                                                        color: colorsFile
                                                            .buttonIcons,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                          snapshot.data.length, (index) {
                                        late dynamic data;
                                        if (snapshot.data != null) {
                                          data = {
                                            'id': snapshot.data[index]['_id'],
                                            'driverName': snapshot.data[index]
                                                ['user']['firstName'],
                                            'driverNum': snapshot.data[index]
                                                ['user']['phoneNumber'],
                                            'scheduleStartTime': snapshot
                                                .data[index]['pickupTime'],
                                            'type': snapshot.data[index]
                                                ['schedule']['routes']['type'],
                                          };
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              selectedIndexRoute = index;
                                              drawRoute();
                                            },
                                            child: RideCard(
                                                selectedRouteCardInfo: data,
                                                updateRides: _updateRides),
                                          ),
                                        );
                                      }),
                                    )),
                              ],
                            );
                          } else {
                            return WantToBook(
                              "Your proposed rides",
                              "Want to book a ride? Press + button!",
                              _showSearchRides,
                            );
                          }
                        }
                        return const Center(
                            child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 0.8, color: Colors.white)));
                      },
                      future: _getReservations),
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
                    });
                  },
                  child: GlassmorphicContainer(
                    height: 215,
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
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.only(top: 1),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSearchPoPupVisible = false;
                                    bottomSheetVisible = true;
                                    condition = true;
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xFFFFFFFF), // White color
                                  size: 25.0,
                                ),
                              ),
                            ),
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
                                Container(
                                  //  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      children: [
                                        Expanded(child: Container()),
                                        // Adjust the space between the two icons
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: GestureDetector(
                                              onTap: () async {
                                                final SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                final String? user =
                                                    prefs.getString('user');
                                                setState(() {
                                                  listSearchBottomSheet = true;
                                                  isSearchPoPupVisible = false;
                                                  map_check = true;
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
              visible: listSearchBottomSheet,
              child: Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    //   height: 310,
                    decoration: const BoxDecoration(
                      //color: colorsFile.cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                    ),
                    child: ChooseRide(
                        _showMyRides,
                        showRide,
                        updateSelectedRouteCardInfo,
                        selectMap,
                        _polyline,
                        _markers,
                        isSearchMap,
                        pickMarker,
                        currentDate,
                        routeType),
                  )),
            ),
            Visibility(
              visible: myRidesbottomSheetVisible,
              child: Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    //  height: 300,
                    decoration: const BoxDecoration(
                      color: colorsFile.cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                    ),
                    child: MyRides(
                      selectedRouteCardInfo: selectedRouteCardInfo,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
