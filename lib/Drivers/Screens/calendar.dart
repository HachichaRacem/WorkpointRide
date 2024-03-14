import 'package:flutter/material.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:osmflutter/map/home_example.dart';

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

  @override
  void initState() {
    super.initState();
    // Populate the list of people
    people = [
      Person(name: 'Foulen Ben Foulen', phoneNumber: '25658997'),
      Person(name: 'Zayd Ali', phoneNumber: '55555555'),
      Person(name: 'foulena Foulenia', phoneNumber: '96224774'),
      Person(name: 'Mariem Ali', phoneNumber: '58121211'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: [
                Color.fromRGBO(94, 149, 180, 1),
                Color.fromRGBO(77, 140, 175, 1),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
        toolbarHeight: 80.0,
        title: Column(
          children: [
            SizedBox(height: 16.0),
            // Add your title widgets here
          ],
        ),
      ),
      body: Stack(
        children: [
          
          // Background Photo
          OldMainExample(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                color: colorsFile.cardColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50.0), // Adjust the radius as needed
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: colorsFile.ProfileIcon,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                            50.0), // Adjust the radius as needed
                      ),
                    ),
                    child: Column(
                      children: [
                        Align(
      alignment: Alignment.centerLeft,
      child:
                       Padding(
                                  padding: const EdgeInsets.fromLTRB(30,12,5,10),
                                  child: Text(
                                    "Passengers",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
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
                                      color: selectedTime == '07:20'
                                          ? Colors.white
                                          : Colors.grey,
                                      decoration: selectedTime == '07:20'
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  if (selectedTime == '07:20')
                                    Icon(Icons.edit, color: Colors.white),
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
                                      color: selectedTime == '18:30'
                                          ? Colors.white
                                          : Colors.grey,
                                      decoration: selectedTime == '18:30'
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  if (selectedTime == '18:30')
                                    Icon(Icons.edit, color: Colors.white),
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
                            SizedBox(height: 10,),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5.0,5,5,5),
                                  child: Row(
                                    children: [
                                      Padding(
                                  padding: const EdgeInsets.fromLTRB(5.0,10,5,10),
                                  child: Text(
                                    "Home",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: colorsFile.icons,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "--->",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: colorsFile.icons,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "EY Tower",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5.0,5,18,5),
                                  child: Text(
                                    "07 : 20",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: colorsFile.detailColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5.0,5,5,5),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Icon(Icons.delete,color: colorsFile.skyBlue,),
                                      ),
                                      SizedBox(width: 2,),
                                      Container(
                                        child: Icon(Icons.edit,color: colorsFile.skyBlue,),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                             ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // First avatar
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPerson = people[0];
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/homme1.jpg'),
                                        radius: 30,
                                        backgroundColor:
                                            selectedPerson == people[0]
                                                ? Colors.blue
                                                : null,
                                      ),
                                      SizedBox(height: 8),
                                      if (selectedPerson == people[0])
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              selectedPerson!.name,
                                               style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: colorsFile.titleCard),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.phone),
                                                SizedBox(width: 8),
                                                Text(
                                                  selectedPerson!.phoneNumber,
                                                   style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: colorsFile.titleCard),
                                                ),
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
                                        backgroundImage: AssetImage(
                                            'assets/images/homme2.jpg'),
                                        radius: 30,
                                        backgroundColor:
                                            selectedPerson == people[1]
                                                ? Colors.blue
                                                : null,
                                      ),
                                      SizedBox(height: 8),
                                      if (selectedPerson == people[1])
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              selectedPerson!.name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.phone),
                                                SizedBox(width: 8),
                                                Text(
                                                  selectedPerson!.phoneNumber,
                                                  style: TextStyle(fontSize: 16),
                                                ),
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
                                        backgroundImage: AssetImage(
                                            'assets/images/femme1.jpg'),
                                        radius: 30,
                                        backgroundColor:
                                            selectedPerson == people[2]
                                                ? Colors.blue
                                                : null,
                                      ),
                                      SizedBox(height: 8),
                                      if (selectedPerson == people[2])
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              selectedPerson!.name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.phone),
                                                SizedBox(width: 8),
                                                Text(
                                                  selectedPerson!.phoneNumber,
                                                  style: TextStyle(fontSize: 16),
                                                ),
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
                                        backgroundImage: AssetImage(
                                            'assets/images/femme2.jpg'),
                                        radius: 30,
                                        backgroundColor:
                                            selectedPerson == people[3]
                                                ? Colors.blue
                                                : null,
                                      ),
                                      SizedBox(height: 8),
                                      if (selectedPerson == people[3])
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              selectedPerson!.name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.phone),
                                                SizedBox(width: 8),
                                                Text(
                                                  selectedPerson!.phoneNumber,
                                                  style: TextStyle(fontSize: 16),
                                                ),
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
                      : SizedBox(), // Placeholder, you can add content for '18:30' here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
