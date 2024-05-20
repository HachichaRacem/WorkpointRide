import 'dart:async';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/Services/schedule.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProposedRides extends StatefulWidget {
  final List<dynamic> listRoutes;
  final Function() showMyRides;
  final Function() ridesVisible;
  int selectedIndex;
  final Function(int) selectCard;
  bool isCardSelected;

  ProposedRides(this.listRoutes, this.showMyRides, this.ridesVisible,
      this.selectCard, this.selectedIndex, this.isCardSelected,
      {Key? key})
      : super(key: key);

  @override
  _ProposedRidesState createState() => _ProposedRidesState();
}

class _ProposedRidesState extends State<ProposedRides> {
  late double _height;
  late double _width;
  bool bottomSheetVisible = false;
  // Use the background color as the default color
// Initialize the selected index
  int nbPlaces = 0;
  scheduleServices _scheduleServices = scheduleServices();
  List<DateTime> dates = [];

/*
  void toggleSelection(int index) {
    print("seeeeeeeeeeeeee" + widget.selectedIndex.toString());
    print("iiiiiiiiii" + index.toString());

    if (widget.selectedIndex == index) {
      // Toggle the selection state if the card is tapped again
      setState(() {
        widget.selectedIndex = -1;
        isCardSelected = !isCardSelected;
      });
      // Reset card color to default when the second tab is selected
    } else {
      setState(() {
        widget.selectedIndex = index;
        isCardSelected = true;
      });
      // If it's a new selection, update the selected index and set the selection state to true
      widget.selectedIndex = index;

      widget.drawRoute();
    }
    print("wwwwwwwwwwwwwwwwww" + widget.selectedIndex.toString());

    widget.ridesVisible();
  }
*/

  TimeOfDay _selectedTime = TimeOfDay.now();
  double _rating = 0;
  void _selectDateRange(
    BuildContext context,
  ) {
    dates = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            width: 300,
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: SfDateRangePicker(
                    toggleDaySelection: true,
                    selectionShape: DateRangePickerSelectionShape.rectangle,
                    selectionRadius: 10,
                    view: DateRangePickerView.month,
                    minDate: DateTime.now(),
                    backgroundColor: Colors.white,
                    selectionColor: colorsFile.backgroundNvavigaton,
                    headerStyle: DateRangePickerHeaderStyle(
                        textStyle: TextStyle(color: colorsFile.titlebotton),
                        backgroundColor: Colors.white),
                    monthViewSettings: DateRangePickerMonthViewSettings(
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
                          border: Border.all(
                              color: colorsFile.titlebotton, width: 1),
                          shape: BoxShape.circle),
                    ),
                    selectionMode: DateRangePickerSelectionMode.multiple,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      print(args.value);
                      setState(() {
                        dates = args.value;
                      });
                    },
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
                            colorsFile.buttonRole),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: colorsFile.icons),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print(dates.toString()); // Add your submit logic here
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            colorsFile.buttonRole),
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

  void showSchedulingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: GlassmorphicContainer(
              height: 160,
              width: _width * 0.85,
              borderRadius: 15,
              blur: 2, // Increased for a softer blur effect
              alignment: Alignment.center,
              border: 2,
              linearGradient: LinearGradient(
                colors: [
                  const Color(0xFF003A5A).withOpacity(0.3),
                  const Color(0xFF003A5A).withOpacity(1),
                  const Color(0xFF003A5A).withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderGradient: LinearGradient(
                colors: [
                  const Color(0xFF003A5A).withOpacity(0.3),
                  const Color(0xFF003A5A).withOpacity(1),
                  const Color(0xFF003A5A).withOpacity(0.3),
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
                              onPressed: () => _selectDateRange(context),
                              icon: const Icon(Icons.calendar_month,
                                  color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () => _selectTime(context),
                              child: Text(
                                ' ${_selectedTime.hour}:${_selectedTime.minute}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFFFFFFFF), // White color
                                size: 25.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: RatingBar.builder(
                                    initialRating: nbPlaces.toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    itemCount: 4,
                                    itemBuilder: (context, _) => Image.asset(
                                      'assets/images/seat.png',
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      color: colorsFile.done, //
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        nbPlaces = rating.toInt();
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: GestureDetector(
                                        onTap: () async {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          final String? user =
                                              prefs.getString('user');
                                          final DateTime now = DateTime.now();
                                          DateTime startDate = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              _selectedTime.hour,
                                              _selectedTime.minute);

                                          await _scheduleServices
                                              .addSchedule(
                                            user:
                                                user!, // Provide a value for the 'user' parameter
                                            startTime:
                                                startDate, // Provide a value for the 'startTime' parameter
                                            scheduledDate:
                                                dates, // Provide a value for the 'scheduledDate' parameter
                                            availablePlaces:
                                                nbPlaces, // Provide a value for the 'availablePlaces' parameter
                                            //routeId: widget.listRoutes[selectedIndex]["_id"]
                                          )
                                              .then((value) {
                                            if (value.statusCode == 200) {
                                              print(
                                                  "Schedule added successfully");
                                            } else {
                                              print(
                                                  "Failed to add schedule: ${value.data}");
                                            }
                                          }).catchError((error) {
                                            print(
                                                "Error adding schedule: $error");
                                          });
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
                                            )))))
                              ],
                            ),
                          ),
                        )
                      ]))),
        );
      },
    );
  }

  List<String> startPointAddresses = [];
  List<String> endPointAddresses = [];
  List<String> routeTypes = [];

  @override
  void initState() {
    super.initState();
    extractAddressesAndTypes();
  }

  Future<void> extractAddressesAndTypes() async {
    for (var route in widget.listRoutes) {
      var startPointCoordinates = route['startPoint']['coordinates'];
      var endPointCoordinates = route['endPoint']['coordinates'];
      var type = route['type'];
      String startPointAddress =
          await getAddress(startPointCoordinates[1], startPointCoordinates[0]);
      String endPointAddress =
          await getAddress(endPointCoordinates[1], endPointCoordinates[0]);

      setState(() {
        startPointAddresses.add(startPointAddress);
        endPointAddresses.add(endPointAddress);
        routeTypes.add(type);
      });
    }
  }

  Future<String> getAddress(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark placemark = placemarks[0];
    print("ppppppppppp ${placemark}");
    return placemark.name ?? 'Unknown Address';
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 5,
          child: Container(
            width: 60,
            height: 7,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white60,
            ),
          ),
        ),
        Positioned(
          child: Column(
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8.0, 0, 8),
                    child: Text(
                      "Your rides",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: colorsFile.titleCard,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                            onTap: widget.isCardSelected
                                ? showSchedulingDialog
                                : widget.showMyRides,
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
                                    widget.isCardSelected
                                        ? Icons.calendar_today
                                        : Icons.add,
                                    size: 30,
                                    color: colorsFile.buttonIcons,
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
              startPointAddresses.length != 0
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          widget.listRoutes.length,
                          (index) => GestureDetector(
                            onTap: () {
                              // widget.toggleSelection(index);
                              widget.selectCard(index);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 16.0,
                              ),
                              child: GlassmorphicContainer(
                                height: 180,
                                width: _width * 0.3,
                                borderRadius: 15,
                                blur: 100,
                                alignment: Alignment.center,
                                border: 2,
                                linearGradient: LinearGradient(
                                  colors: [
                                    index == widget.selectedIndex &&
                                            widget.isCardSelected
                                        ? colorsFile.titleCard
                                        : Color(0xFFD8E6EE),
                                    index == widget.selectedIndex &&
                                            widget.isCardSelected
                                        ? colorsFile.titleCard
                                        : Color(0xFFD8E6EE),
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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 5),
                                              Center(
                                                child: Container(
                                                  height: 60,
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: colorsFile
                                                        .backgroundNvavigaton,
                                                    shape: BoxShape.circle,
                                                  ),
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
                                                          curveType:
                                                              CurveType.concave,
                                                          depth: 30,
                                                          spread: 1,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            widget.selectCard(
                                                                index);
                                                          },
                                                          child: Center(
                                                            child:
                                                                ClayContainer(
                                                              color:
                                                                  Colors.white,
                                                              height: 30,
                                                              width: 30,
                                                              borderRadius: 40,
                                                              curveType:
                                                                  CurveType
                                                                      .convex,
                                                              depth: 30,
                                                              spread: 1,
                                                              child:
                                                                  const Center(
                                                                child: Icon(
                                                                  Icons.route,
                                                                  size: 30,
                                                                  color: colorsFile
                                                                      .backgroundNvavigaton,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              // Text(
                                              //   startPointAddresses.length != 0
                                              //       ? startPointAddresses[index]
                                              //       : "",
                                              //   textAlign: TextAlign.center,
                                              //   style: GoogleFonts.montserrat(
                                              //       fontWeight: FontWeight.w600,
                                              //       fontSize: 12,
                                              //       color: (widget.selectedIndex ==
                                              //                   index &&
                                              //               widget
                                              //                   .isCardSelected)
                                              //           ? Colors.white
                                              //           : colorsFile.titleCard),
                                              // ),
                                              // Text(
                                              //   "|",
                                              //   textAlign: TextAlign.center,
                                              //   style: GoogleFonts.montserrat(
                                              //       fontWeight: FontWeight.w600,
                                              //       fontSize: 12,
                                              //       color: (widget.selectedIndex ==
                                              //                   index &&
                                              //               widget
                                              //                   .isCardSelected)
                                              //           ? Colors.white
                                              //           : colorsFile.titleCard),
                                              // ),
                                              // Icon(
                                              //   Icons.arrow_downward,
                                              //   color: (widget.selectedIndex ==
                                              //               index &&
                                              //           widget.isCardSelected)
                                              //       ? Colors.white
                                              //       : colorsFile.titleCard,
                                              //   size: 15,
                                              // ),
                                              // SizedBox(width: 10),
                                              // Text(
                                              //   endPointAddresses.length != 0
                                              //       ? endPointAddresses[index]
                                              //       : "",
                                              //   textAlign: TextAlign.center,
                                              //   style: GoogleFonts.montserrat(
                                              //       fontWeight: FontWeight.w600,
                                              //       fontSize: 12,
                                              //       color: (widget.selectedIndex ==
                                              //                   index &&
                                              //               widget
                                              //                   .isCardSelected)
                                              //           ? Colors.white
                                              //           : colorsFile.titleCard),
                                              // ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                routeTypes.length != 0
                                                    ? routeTypes[index]
                                                        .replaceAll(
                                                            "fromOffice",
                                                            "from office")
                                                        .replaceAll("toOffice",
                                                            "to office")
                                                    : "",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: (widget.selectedIndex ==
                                                                index &&
                                                            widget
                                                                .isCardSelected)
                                                        ? Colors.white
                                                        : colorsFile.titleCard),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
