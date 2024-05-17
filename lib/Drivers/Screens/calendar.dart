import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:osmflutter/GoogleMaps/driver_polyline_map.dart';
import 'package:osmflutter/GoogleMaps/googlemaps.dart';
import 'package:osmflutter/Services/schedule.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:osmflutter/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class Person {
  final String name;
  final String phoneNumber;

  Person({required this.name, required this.phoneNumber});

  @override
  String toString() => 'Person(name: $name, phoneNumber: $phoneNumber)';
}

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late String selectedTime = '07:20';
  List? schedules;
  int selectedIndex = 0;
  int selectedTimeIndex = 0;
  int selectedPersonIndex = -1;
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth;
  bool bottomSheetVisible = true;
  Set<Polyline> _polyline = {};
  Set<Marker> _markers = {};
  dynamic position2_lat = 36.85135579846211, position2_lng = 10.179065957033673;
  dynamic position1_lat, position1_lng;
  bool check_map = true;
  List<LatLng> routeCoords = [];
  List<dynamic> listRoutes = [];

  void drawRoute() async {
    routeCoords = [];
    listRoutes[selectedIndex]["polyline"].forEach((polyline) {
      //  print("sssssssssss${polyline[0]}");

      routeCoords.add(LatLng(polyline[0], polyline[1]));
    });
    print("sssssssssss${routeCoords}");
    position1_lat = listRoutes[selectedIndex]["startPoint"]["coordinates"][0];
    position1_lng = listRoutes[selectedIndex]["startPoint"]["coordinates"][1];
    position2_lat = listRoutes[selectedIndex]["endPoint"]["coordinates"][0];
    position2_lng = listRoutes[selectedIndex]["endPoint"]["coordinates"][1];
    _polyline.clear();
    _markers.clear();
    _polyline = {};
    setState(() {
      check_map = false;
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
              listRoutes[selectedIndex]["startPoint"]["coordinates"][0],
              listRoutes[selectedIndex]["startPoint"]["coordinates"][1]),
          infoWindow: InfoWindow(title: 'start'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('end'),
          position: LatLng(
              listRoutes[selectedIndex]["endPoint"]["coordinates"][0],
              listRoutes[selectedIndex]["endPoint"]["coordinates"][1]),
          infoWindow: InfoWindow(title: 'End'),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      check_map = false;
    });
    /*  CameraPosition camera_position = CameraPosition(
        target: LatLng(
            listRoutes[selectedIndex]["startPoint"]["coordinates"][0],
            listRoutes[selectedIndex]["startPoint"]["coordinates"][0]),
        zoom: 7);*/
    //
    // mapController = await _controller.future;
    //
    // mapController
    //     .animateCamera(CameraUpdate.newCameraPosition(camera_position));
  }

  @override
  void initState() {
    super.initState();
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    _loadPassengers(currentDate: "${now.year}-${now.month}-${now.day}");
  }

  void _loadPassengers({String? currentDate}) {
    final DateTime date = now.add(Duration(days: selectedIndex));
    final String dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    SharedPreferences.getInstance().then(
      (prefs) => scheduleServices()
          .getScheduleReservationsByDate(dateString, User().id!)
          .then(
        (resp) async {
          print("[DATAaaaaaaaaaaaaaaaaaaaaaaaaaa]: ${resp.data}");
          schedules = resp.data['schedule'];
          if (schedules!.isNotEmpty) {
            for (final (index, schedule) in schedules!.indexed) {
              listRoutes.add(schedules?[index]["routes"]);
              List<Person> ppl = (schedule['reservations'] as List)
                  .map((element) => Person(
                      name:
                          "${element['user']['firstName']} ${element['user']['lastName']}",
                      phoneNumber: element['user']['phoneNumber'] ?? "-"))
                  .toList();
              schedules![index]['people'] = ppl;
            }
          }
          drawRoute();
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        toolbarHeight: 100.0,
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
                    final currentDate = now.add(Duration(days: index));
                    final dayName = DateFormat('EEE').format(currentDate);
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16.0 : 0.0, right: 16.0),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          debugPrint("Selected Index : $index");
                          selectedIndex = index;
                          _loadPassengers();
                        }),
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
      body: Stack(
        children: [
          //  MapsGoogleExample(),

          check_map == true
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

          //Updated Code

          SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height * 0.45,
            minHeight: MediaQuery.of(context).size.height * 0.11,
            panel: Column(
              children: [
                Container(
                  height: 350,
                  decoration: const BoxDecoration(
                    color: colorsFile.cardColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50.0),
                    ),
                  ),
                  child: schedules == null
                      ? Container(
                          height: 127,
                          decoration: const BoxDecoration(
                            color: colorsFile.ProfileIcon,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(50.0),
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : schedules!.isEmpty
                          ? Container(
                              height: 127,
                              decoration: const BoxDecoration(
                                color: colorsFile.ProfileIcon,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(50.0),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "No passengers yet",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  height: 127,
                                  decoration: const BoxDecoration(
                                    color: colorsFile.ProfileIcon,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(50.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 60,
                                        height: 7,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: colorsFile.background,
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 0, 5, 10),
                                          child: Text(
                                            "Passengers",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: List.generate(
                                          schedules!.length,
                                          (index) => TextButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedTimeIndex = index;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  schedules![index][
                                                              'scheduledDate'] !=
                                                          null
                                                      ? TimeOfDay.fromDateTime(
                                                          DateTime.parse(
                                                              schedules![index][
                                                                  'scheduledDate']),
                                                        ).format(context)
                                                      : "",
                                                  style: TextStyle(
                                                    color: selectedTimeIndex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.grey,
                                                    decoration:
                                                        selectedTimeIndex ==
                                                                index
                                                            ? TextDecoration
                                                                .underline
                                                            : TextDecoration
                                                                .none,
                                                  ),
                                                ),
                                                // if (selectedTimeIndex == index)
                                                //   const Icon(Icons.edit,
                                                //       color: Colors.white),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 5, 5, 5),
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 10, 5, 10),
                                                child: Text(
                                                  "Home",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: colorsFile.icons,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: Text(
                                                  "--->",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: colorsFile.icons,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: Text(
                                                  "EY Tower",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: colorsFile.icons,
                                                  ),
                                                ),
                                              ),
                                              ...List.generate(
                                                schedules![selectedTimeIndex]
                                                    ['availablePlaces'],
                                                (index) => Container(
                                                  child: Image.asset(
                                                    'assets/images/seat.png',
                                                    width: 15,
                                                    height: 15,
                                                    color: colorsFile.done,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 5, 18, 5),
                                          child: Text(
                                            TimeOfDay.fromDateTime(
                                              DateTime.parse(
                                                  schedules![selectedTimeIndex]
                                                      ["startTime"]),
                                            ).format(context),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: colorsFile.detailColor,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 5, 5, 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: colorsFile.skyBlue,
                                                ),
                                              ),
                                              // const SizedBox(width: 2),
                                              // Container(
                                              //   child: const Icon(
                                              //     Icons.edit,
                                              //     color: colorsFile.skyBlue,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ...List.generate(
                                          schedules![selectedTimeIndex]
                                                  ['people']
                                              .length,
                                          (index) => GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (selectedPersonIndex ==
                                                    index) {
                                                  selectedPersonIndex = -1;
                                                } else {
                                                  selectedPersonIndex = index;
                                                  // DriverOnMap(
                                                  //   poly_lat1: 37.43316,
                                                  //   poly_lng1: -122.083061,
                                                  //   poly_lat2: 37.427847,
                                                  //   poly_lng2: -122.097320,
                                                  //   route_id: 'route12',

                                                  // );
                                                }
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: const AssetImage(
                                                      'assets/images/homme1.png'),
                                                  radius: 30,
                                                  backgroundColor:
                                                      selectedPersonIndex ==
                                                              index
                                                          ? Colors.blue
                                                          : null,
                                                ),
                                                const SizedBox(height: 8),
                                                if (selectedPersonIndex ==
                                                    index)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        schedules![selectedTimeIndex]
                                                                    ['people']
                                                                [index]
                                                            .name,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: colorsFile
                                                                .titleCard),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: Stack(
                                                              children: [
                                                                ClayContainer(
                                                                  color: Colors
                                                                      .white,
                                                                  height: 30,
                                                                  width: 30,
                                                                  borderRadius:
                                                                      50,
                                                                  curveType:
                                                                      CurveType
                                                                          .concave,
                                                                  depth: 20,
                                                                  spread: 1,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    print(
                                                                        "heloooo");
                                                                    _launchPhone(schedules![selectedTimeIndex]['people']
                                                                            [
                                                                            index]
                                                                        .phoneNumber);
                                                                  },
                                                                  child: Center(
                                                                    child:
                                                                        ClayContainer(
                                                                      color: Colors
                                                                          .white,
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      borderRadius:
                                                                          40,
                                                                      curveType:
                                                                          CurveType
                                                                              .convex,
                                                                      depth: 30,
                                                                      spread: 1,
                                                                      child:
                                                                          const Center(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .phone,
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              colorsFile.buttonIcons,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                              schedules![selectedTimeIndex]
                                                                          ['people']
                                                                      [index]
                                                                  .phoneNumber,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: colorsFile
                                                                      .titleCard)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                                // Placeholder, you can add content for '18:30' here
                              ],
                            ),
                ),
              ],
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
          ),
        ],
      ),
    );
  }

  // Function to launch the phone app
  _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
