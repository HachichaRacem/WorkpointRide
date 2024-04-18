import 'package:flutter/material.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:osmflutter/GoogleMaps/googlemaps.dart';
import 'package:osmflutter/mapOsm/home_example.dart';
import 'package:osmflutter/shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
import '../../GoogleMaps/calendar_map.dart';
import '../../GoogleMaps/driver_polyline_map.dart';

class Person {
  final String name;
  final String phoneNumber;

  Person({required this.name, required this.phoneNumber});
}

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late String selectedTime = '07:20';
  late List<Person> people;
  Person? selectedPerson;
int selectedIndex = 0;
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth;
  bool bottomSheetVisible = true;

  @override
  void initState() {
    super.initState();
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    // Populate the list of people
    people = [
      Person(name: 'Foulen Ben Foulen', phoneNumber: '25658997'),
      Person(name: 'Zayd Ali', phoneNumber: '55555555'),
      Person(name: 'foulena Foulenia', phoneNumber: '96224774'),
      Person(name: 'Mariem Ali', phoneNumber: '58121211'),
    ];
    print("Inside the insit state \n getting the shared preferences values");
    getshared();
  }


  bool check=true;
  dynamic sp_poly_lat1,sp_poly_lng1,sp_poly_lat2,sp_poly_lng2;
  getshared()async
  {
    final prefs = await sharedpreferences.get_poly_lat1();
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


    if(sp_poly_lng1!=null || sp_poly_lat1!=null || sp_poly_lng2!=null || sp_poly_lat2!=null) {
      setState(() {
        check = false;
      });
    }
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
                  lastDayOfMonth.day,
                  (index) {
                    final currentDate =
                        lastDayOfMonth.add(Duration(days: index + 1));
                    final dayName = DateFormat('EEE').format(currentDate);
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16.0 : 0.0, right: 16.0),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          selectedIndex = index;
                        }),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 42.0,
                              width: 42.0,
                              alignment: Alignment.center,
                              child: Text(
                                "${index + 1}",
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

          //MapsGoogleExample(),
          //
          // check == true
          //     ?
          calendarMap(),
          //     : DriverOnMap(
          //   poly_lat1: sp_poly_lat1,
          //   poly_lng1: sp_poly_lng1,
          //   poly_lat2: sp_poly_lat2,
          //   poly_lng2: sp_poly_lng2,
          //   route_id: 'route',
          // ),

          //Updated Code

          SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height * 0.45,
            minHeight: MediaQuery.of(context).size.height  * 0.11,
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
                  child: Column(
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
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: colorsFile.background,
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 0, 5, 10),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedTime = '07:20';
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        '07:20',
                                        style: TextStyle(
                                          color: selectedTime == '07:20' ? Colors.white : Colors.grey,
                                          decoration: selectedTime == '07:20' ? TextDecoration.underline : TextDecoration.none,
                                        ),
                                      ),
                                      if (selectedTime == '07:20') const Icon(Icons.edit, color: Colors.white),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedTime = '18:30';
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        '18:30',
                                        style: TextStyle(
                                          color: selectedTime == '18:30' ? Colors.white : Colors.grey,
                                          decoration: selectedTime == '18:30' ? TextDecoration.underline : TextDecoration.none,
                                        ),
                                      ),
                                      if (selectedTime == '18:30') const Icon(Icons.edit, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      selectedTime == '07:20'
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5.0, 5, 5, 5),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(5.0, 10, 5, 10),
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
                                      padding: EdgeInsets.only(right: 8.0),
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
                                      padding: EdgeInsets.only(right: 8.0),
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
                                    Container(
                                      child: Image.asset(
                                        'assets/images/seat.png',
                                        width: 15,
                                        height: 15,
                                        color: colorsFile.done,
                                      ),
                                    ),
                                    Container(
                                      child: Image.asset(
                                        'assets/images/seat.png',
                                        width: 15,
                                        height: 15,
                                        color: colorsFile.done,
                                      ),
                                    ),
                                    Container(
                                      child: Image.asset(
                                        'assets/images/seat.png',
                                        width: 15,
                                        height: 15,
                                        color: colorsFile.done,
                                      ),
                                    ),
                                    Container(
                                      child: Image.asset(
                                        'assets/images/seat.png',
                                        width: 15,
                                        height: 15,
                                        color: colorsFile.done,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(5.0, 5, 18, 5),
                                child: Text(
                                  "07 : 20",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: colorsFile.detailColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5.0, 5, 5, 5),
                                child: Row(
                                  children: [
                                    Container(
                                      child: const Icon(
                                        Icons.delete,
                                        color: colorsFile.skyBlue,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Container(
                                      child: const Icon(
                                        Icons.edit,
                                        color: colorsFile.skyBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // First avatar
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPerson = people[0];
                                    //inkwell call another polyline.......
                                    print("First passenger selected");
                                    DriverOnMap(
                                      poly_lat1: 37.43316,
                                      poly_lng1: -122.083061,
                                      poly_lat2: 37.427847,
                                      poly_lng2: -122.097320,
                                      route_id: 'route12',
                                    );
                                    print("state set");
                                  });
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: const AssetImage('assets/images/homme1.jpg'),
                                      radius: 30,
                                      backgroundColor: selectedPerson == people[0] ? Colors.blue : null,
                                    ),
                                    const SizedBox(height: 8),
                                    if (selectedPerson == people[0])
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            selectedPerson!.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: colorsFile.titleCard),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone),
                                              const SizedBox(width: 8),
                                              Text(selectedPerson!.phoneNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: colorsFile.titleCard)),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              // Second avatar
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPerson = people[1];
                                  });
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: const AssetImage('assets/images/homme2.jpg'),
                                      radius: 30,
                                      backgroundColor: selectedPerson == people[1] ? Colors.blue : null,
                                    ),
                                    const SizedBox(height: 8),
                                    if (selectedPerson == people[1])
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(selectedPerson!.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone),
                                              const SizedBox(width: 8),
                                              Text(selectedPerson!.phoneNumber, style: const TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              // Third avatar
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPerson = people[2];
                                  });
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: const AssetImage('assets/images/femme1.jpg'),
                                      radius: 30,
                                      backgroundColor: selectedPerson == people[2] ? Colors.blue : null,
                                    ),
                                    const SizedBox(height: 8),
                                    if (selectedPerson == people[2])
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(selectedPerson!.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone),
                                              const SizedBox(width: 8),
                                              Text(selectedPerson!.phoneNumber, style: const TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              // Fourth avatar
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPerson = people[3];
                                  });
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: const AssetImage('assets/images/femme2.jpg'),
                                      radius: 30,
                                      backgroundColor: selectedPerson == people[3] ? Colors.blue : null,
                                    ),
                                    const SizedBox(height: 8),
                                    if (selectedPerson == people[3])
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(selectedPerson!.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone),
                                              const SizedBox(width: 8),
                                              Text(selectedPerson!.phoneNumber, style: const TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                          : const SizedBox(), // Placeholder, you can add content for '18:30' here
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
}
