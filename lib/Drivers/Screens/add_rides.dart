import 'package:osmflutter/Drivers/widgets/proposed_rides.dart';
import 'package:flutter/material.dart';
import 'package:osmflutter/Users/BottomSheet/MyRides.dart';
import 'package:osmflutter/Users/BottomSheet/want_to_book.dart';
import 'package:osmflutter/Users/widgets/chooseRide.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:osmflutter/map/home_example.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class AddRides extends StatefulWidget {
  const AddRides({Key? key}) : super(key: key);

  @override
  _AddRidesState createState() => _AddRidesState();
}

class _AddRidesState extends State<AddRides> {

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


  List<DateTime> _selectedDates = [];
  TimeOfDay _selectedTime = TimeOfDay.now();
  double _rating = 0;

  void _selectDateRange(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Change background color here
          content: Container(
            width: 300,
            height: 500,
            child: Column(
              children: [
                Expanded(
                    child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  headerStyle: DateRangePickerHeaderStyle(
                    textStyle: TextStyle(color: colorsFile.icons),
                  ),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      weekendDays: [7, 6],
                      dayFormat: 'EEE',
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(color: colorsFile.icons)),
                      showTrailingAndLeadingDates: true),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    textStyle: TextStyle(color: colorsFile.icons),
                  ),
                )),
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
                      child: Text(
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
                      child: Text(
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
            textTheme: TextTheme(
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

  @override
  void initState() {
    super.initState();
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  }

  _showSearchRides() {
    setState(() {
      isSearchPoPupVisible = true;
      bottomSheetVisible = false;
    });
  }

  _showMyRides() {
    setState(() {
      isSearchPoPupVisible = true;
      listSearchBottomSheet = false;
    });
  }

  showRide() {
    setState(() {
      ridesIsVisible = !ridesIsVisible;
    });
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
        title: Container(
          color: colorsFile.background,
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
            Positioned(
  child:
   Container(
    
    child: OldMainExample()),
),


            // Content on top of the background
            Visibility(
              visible: bottomSheetVisible,
              child: Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: colorsFile.cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      // controller: scrollController,
                      child: WantToBook(
                          "Your proposed rides",
                          "Want to add a ride? Press + button!",
                          _showSearchRides),
                    ),
                  )),
            ),
            Visibility(
              visible: isSearchPoPupVisible,
              child: Positioned(
                top: 20,
                right: _width / 2 * 0.15,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearchPoPupVisible = false;
                      bottomSheetVisible = true;
                    });
                  },
                  child: GlassmorphicContainer(
                    height: 220,
                    width: _width * 0.85,
                    borderRadius: 15,
                    blur: 2,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      colors: [
                        Color(0xFF003A5A).withOpacity(0.37),
                        Color(0xFF003A5A).withOpacity(1),
                        Color(0xFF003A5A).withOpacity(0.36),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderGradient: LinearGradient(
                      colors: [
                        Color(0xFF003A5A).withOpacity(0.37),
                        Color(0xFF003A5A).withOpacity(1),
                        Color(0xFF003A5A).withOpacity(0.36),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 10, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _selectDateRange(
                                      context); // Call function to show date range picker
                                },
                                icon: Icon(
                                    Icons.calendar_month), // Use calendar icon
                              ),
                              SizedBox(width: 3.0),
                              TextButton(
                                onPressed: () => _selectTime(context),
                                child: Text(
                                  ' ${_selectedTime.hour}:${_selectedTime.minute}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              //Spacer(),
                              Container(
                                  child: RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                itemCount: 4,
                                itemBuilder: (context, _) => Image.asset(
                                  'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                  width:
                                      10, // Adjust width and height as per your image size
                                  height: 10,
                                  color: colorsFile
                                      .done, // You can also apply color to the image if needed
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              )),
                              //SizedBox(width: 15.0),
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSearchPoPupVisible = false;
                                      bottomSheetVisible = true;
                                    });
                                  },
                                  child: Icon(
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
                                      children: [
                                        Expanded(
                                            child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Home',
                                            prefixIcon: Container(
                                              width: 37.0,
                                              height: 37.0,
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 10),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2.0,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: Icon(
                                                Icons.place,
                                                color: colorsFile.icons,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        )),
                                        SizedBox(width: 5),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {},
                                              child: Center(
                                                child: Icon(
                                                  Icons.swap_vert,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'EY Tower',
                                            prefixIcon: Container(
                                              width: 37.0,
                                              height: 37.0,
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 10),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2.0,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: Icon(
                                                Icons.place,
                                                color: colorsFile.icons,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        )),
                                        SizedBox(
                                            width:
                                                10), // Adjust the space between the two icons
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  listSearchBottomSheet = true;
                                                  isSearchPoPupVisible = false;
                                                });
                                              },
                                              child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
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
                                                      child: Center(
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
                    height: 350,
                    decoration: BoxDecoration(
                      color: colorsFile.cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                        //controller: scrollController,
                        child: ProposedRides(_showMyRides, showRide)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
