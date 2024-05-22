// import 'package:flutter/material.dart';
// import 'package:glassmorphism/glassmorphism.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:osmflutter/Services/history.dart';
// import 'package:osmflutter/constant/colorsFile.dart';
// import 'package:osmflutter/models/user.dart';

// class History extends StatefulWidget {
//   @override
//   _HistoryState createState() => _HistoryState();
// }

// class _HistoryState extends State<History> {
//   late double _height;
//   late double _width;

//   List? histories;
//   HistoryService _historyService = HistoryService();
//   // late SharedPreferences _prefs;
//   Future<void> getHistorybyUser() async {
//     await _historyService.getHistoryByUser(User().id!).then((resp) {
//       print("ressssssssssssss${resp.data.toString()}");
//       setState(() => histories = resp.data);
//     });
//   }

//   @override
//   void initState() {
//     getHistorybyUser();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _height = MediaQuery.of(context).size.height;
//     _width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.only(left: 30, right: 30, top: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.0),
//           color: colorsFile.cardColor,
//         ),
//         child: histories == null
//             ? const Center(
//                 child: CircularProgressIndicator(color: Colors.white))
//             : histories!.isEmpty
//                 ? const Center(
//                     child: Text(
//                     "No histories yet",
//                     style: TextStyle(color: Colors.white),
//                   ))
//                 : SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Column(
//                       children: List.generate(
//                         histories!.length,
//                         (index) => Padding(
//                           padding:
//                               const EdgeInsets.only(right: 16.0, top: 16.0),
//                           child: GlassmorphicContainer(
//                             height: _height * 0.1,
//                             width: _width * 0.8,
//                             borderRadius: 15,
//                             blur: 100,
//                             alignment: Alignment.center,
//                             border: 2,
//                             linearGradient: LinearGradient(
//                               colors: [Color(0xFFD8E6EE), Color(0xFFD8E6EE)],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                             borderGradient: LinearGradient(
//                               colors: [
//                                 Colors.white24.withOpacity(0.2),
//                                 Colors.white70.withOpacity(0.2),
//                               ],
//                             ),
//                             child: Container(
//                               child: Row(
//                                 children: [
//                                   SizedBox(width: 8),
//                                   Expanded(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(5.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(height: 8),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               SizedBox(height: 18),
//                                               Text(
//                                                 histories![index]['user']
//                                                     ['firstName'],
//                                                 textAlign: TextAlign.center,
//                                                 style: GoogleFonts.montserrat(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12,
//                                                   color: colorsFile.titleCard,
//                                                 ),
//                                               ),
//                                               Spacer(),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     right: 8.0),
//                                                 child: Text(
//                                                   DateTime.parse(
//                                                           histories![index]
//                                                               ['createdAt'])
//                                                       .toLocal()
//                                                       .toString(),
//                                                   textAlign: TextAlign.center,
//                                                   style: GoogleFonts.montserrat(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 10,
//                                                     color: colorsFile.titleCard,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Text(
//                                             histories![index]['status'],
//                                             style: GoogleFonts.montserrat(
//                                               fontSize: 12,
//                                               color: colorsFile.tabbar,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/constant/colorsFile.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late double _height;
  late double _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colorsFile.background,
      body: Column(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
              ),
              height: _height * 0.09,
              width: _width,
            ),
          ),
          Expanded(
            child: Container(
              width: _width,
              decoration: BoxDecoration(
                color: colorsFile.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Container(
                child: Column(
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                      child: GlassmorphicContainer(
                        height: _height * 0.15,
                        width: _width * 0.8,
                        borderRadius: 15,
                        blur: 100,
                        alignment: Alignment.center,
                        border: 2,
                        linearGradient: LinearGradient(
                          colors: [Color(0xFFD8E6EE), Color(0xFFD8E6EE)],
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
      SizedBox(width: 8),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),  // Increased height for more top padding
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Ride reservation",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: colorsFile.done,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),  // Increased height for more spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.route_sharp,
                    color: colorsFile.historyIcon,
                    size: 18,
                  ),
                  SizedBox(width: 3),  // Added space between icon and text
                  Text(
                    "From Office",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: colorsFile.titleCard,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),  // Increased height for more spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: colorsFile.historyIcon,
                        size: 18,
                      ),
                      SizedBox(width: 3),  // Added space between icon and text
                      Text(
                        "2023-01-25 at 07:20",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: colorsFile.titleCard,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "Today at 09:20",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: colorsFile.titleCard,
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 15),  // Added more space at the bottom
            ],
          ),
        ),
      ),
    ],
  ),
)

                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
