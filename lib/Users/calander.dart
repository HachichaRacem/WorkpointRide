// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// class Calender extends StatefulWidget {
//   const Calender({super.key});

//   @override
//   State<Calender> createState() => _CalenderState();
// }

// class _CalenderState extends State<Calender> {
//   DateTime today = DateTime.now();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(child:
        
//         TableCalendar(
//           locale: "en_tu",
//           rowHeight:43,
//           headerStyle: 
//           const HeaderStyle(formatButtonVisible: false,titleCentered: true),
//           availableGestures: AvailableGestures.all,
//           focusedDay: today,
//           firstDay:DateTime.utc(2024,1,1) ,
//           lastDay: DateTime.utc(2030,3,14),
          
//         ),
//         ),
//       ],
//     );

//   }
 
// }
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';

// class Calender extends StatefulWidget {
//   const Calender({Key? key}) : super(key: key);

//   @override
//   State<Calender> createState() => _CalenderState();
// }

// class _CalenderState extends State<Calender> {
//   int selectedIndex = 0;
//   DateTime now = DateTime.now();
//   late DateTime lastDayOfMonth;
//   @override
//   void initState() {
//     super.initState();
//     lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Colors.white,
//       appBar: AppBar(
//         //backgroundColor: Colors.white,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment(0.8, 1),
//               colors: <Color>[
//                 Color.fromRGBO(94, 149, 180, 1),
//                 Color.fromRGBO(77, 140, 175, 1),
//               ],
//               tileMode: TileMode.mirror,
//             ),
//           ),
//         ),
//         toolbarHeight: 120.0,
//         title: Column(
//           children: [
            
        
//           const SizedBox(height: 16.0),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               physics: const ClampingScrollPhysics(),
//               child: Row(
//                 children: List.generate(
//                   lastDayOfMonth.day,
//                   (index) {
//                     final currentDate =
//                         lastDayOfMonth.add(Duration(days: index + 1));
//                     final dayName = DateFormat('E').format(currentDate);
//                     return Padding(
//                       padding: EdgeInsets.only(
//                           left: index == 0 ? 16.0 : 0.0, right: 16.0),
//                       child: GestureDetector(
//                         onTap: () => setState(() {
//                           selectedIndex = index;
//                         }),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 42.0,
//                               width: 42.0,
//                               alignment: Alignment.center,
//                               // decoration: BoxDecoration(
//                               //   color: selectedIndex == index
//                               //       ? Colors.white
//                               //       : Color.fromRGBO(0, 58, 90, 1),
//                               //   borderRadius: BorderRadius.circular(44.0),
//                               // ),
//                               child: Text(
//                               "${index + 1}",
//                               style: const TextStyle(
//                                 fontSize: 16.0,
//                                 color: Colors.black54,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             ),
//                             const SizedBox(height:4),
                            
//                             Text(
//                                 dayName.substring(0, 1),
//                                 style: TextStyle(
//                                   fontSize: 20.0,
//                                   color: selectedIndex == index
//                                       ? Colors.white
//                                       : Colors.black54,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             // const SizedBox(height: 8.0),
//                             // Container(
//                             //   height: 2.0,
//                             //   width: 28.0,
//                             //   color: selectedIndex == index
//                             //       ? Colors.orange
//                             //       : Colors.transparent,
//                             // ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

/// Flutter code sample for [showModalBottomSheet].

void main() => runApp(const BottomSheetApp());

class BottomSheetApp extends StatelessWidget {
  const BottomSheetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Bottom Sheet Sample')),
        body: const BottomSheetExample(),
      ),
    );
  }
}

class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('showModalBottomSheet'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
