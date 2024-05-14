import 'package:clay_containers/clay_containers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/Services/reservation.dart';
import 'package:osmflutter/Services/schedule.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChooseRide extends StatefulWidget {
  final Function() showMyRides;
  final Function() ridesVisible;
  final Function(Map) updateSelectedRouteCardInfo;
  const ChooseRide(
      this.showMyRides, this.ridesVisible, this.updateSelectedRouteCardInfo,
      {Key? key})
      : super(key: key);

  @override
  _ChooseRideState createState() => _ChooseRideState();
}

class _ChooseRideState extends State<ChooseRide> {
  late double _height;
  late double _width;
  bool bottomSheetVisible = true;
  List<Color> containerColors = List.filled(
      4, colorsFile.cardColor); // Use the background color as the default color
  final Future<Response> _getAllSchedules =
      scheduleServices().getAllSchedules();
  List schedules = [];
  int selectedRouteCardIndex = 0;

  Future _createReservation() async {
    if (schedules.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final userID = prefs.getString("user");
      final reqBody = {
        "user": userID,
        "schedule": schedules[selectedRouteCardIndex]["_id"],
        "status": "pending",
        "pickupTime": DateTime.now().toString(),
      };
      try {
        await Reservation().createReservation(reqBody);
        widget.showMyRides();
      } catch (e) {
        debugPrint("ERROR: $e");
      }
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
                  future: _getAllSchedules,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      schedules = snapshot.data?.data;
                      debugPrint("[TEST]: ${schedules[0]}");
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            schedules.length,
                            (index) {
                              print("snapshot${snapshot.data?.data}");
                              final Map? driverData =
                                  snapshot.data?.data[index]['user'];
                              return RouteCard(
                                updateSelectedRouteCardInfo:
                                    widget.updateSelectedRouteCardInfo,
                                driverName: driverData?['firstName'],
                                driverNum: driverData?['phoneNumber'],
                                scheduleStartTime:
                                    (schedules[index]['startTime'] as String)
                                        .substring(11, 17),
                                selectedSeats:
                                    (schedules[index]['availablePlaces'] as int)
                                        .toDouble(),
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
class RouteCard extends StatefulWidget {
  final String? driverName;
  final String? driverNum;
  final String? scheduleStartTime;
  final String? image;
  final double? selectedSeats;
  final Function()? ridesVisible;
  final Function(Map)? updateSelectedRouteCardInfo;

  const RouteCard(
      {super.key,
      this.driverName,
      this.driverNum,
      this.scheduleStartTime,
      this.image,
      this.ridesVisible,
      this.selectedSeats,
      this.updateSelectedRouteCardInfo});

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  bool isClicked = false;
  final Color _selectedColor = colorsFile.icons;
  final Color _unselectedColor = colorsFile.cardColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });
        if (widget.ridesVisible != null) {
          widget.ridesVisible!();
        }
        if (widget.updateSelectedRouteCardInfo != null) {
          widget.updateSelectedRouteCardInfo!({
            "driverName": widget.driverName,
            "driverNum": widget.driverNum,
            "scheduleStartTime": widget.scheduleStartTime,
            "image": widget.image,
            "selectedSeats": widget.selectedSeats
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16.0,
        ),
        child: GlassmorphicContainer(
          height: 185,
          width: MediaQuery.of(context).size.width * 0.3,
          borderRadius: 15,
          blur: 100,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            colors: [
              (isClicked == true) ? _selectedColor : _unselectedColor,
              (isClicked == true) ? _selectedColor : _unselectedColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderGradient: LinearGradient(
            colors: [
              Colors.white24.withOpacity(0.2),
              Colors.white70.withOpacity(0.2),
            ],
          ),
          child: Container(
              child: Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Center(
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: colorsFile.borderCircle,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                            child: SizedBox.fromSize(
                                size: const Size.fromRadius(28),
                                child: Image(
                                  image: AssetImage(
                                    widget.image ?? "assets/images/homme1.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ))),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      widget.driverName ?? "Foulen Ben Falten",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: (isClicked == false)
                            ? colorsFile.titleCard
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: (isClicked == false)
                              ? colorsFile.icons
                              : Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.driverNum ?? "55 555 555",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: (isClicked == false)
                                ? colorsFile.titleCard
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 55,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                (widget.selectedSeats ?? 3).toInt(),
                                (index) => const Icon(
                                  Icons.airline_seat_recline_normal_sharp,
                                  color: colorsFile.buttonIcons,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            widget.scheduleStartTime ?? '7:15',
                            textAlign: TextAlign.end,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              color: (isClicked == false)
                                  ? colorsFile.detailColor
                                  : Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ])),
        ),
      ),
    );
  }
}
