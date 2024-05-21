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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: colorsFile.cardColor,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,  // Changed to vertical for a list of cards
          child: Column(
            children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),  // Changed padding to bottom for vertical list
                child: GlassmorphicContainer(
                  height: _height * 0.15,  // Adjusted for better proportions
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
                  child: ListTile(
                    leading: Icon(Icons.directions_car, color: colorsFile.icons),
                    title: Text(
                      "From Office",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorsFile.titleCard,
                      ),
                    ),
                    subtitle: Text(
                      "2024-05-21 at 09:20",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: colorsFile.titleCard,
                      ),
                    ),
                    trailing: Text(
                      "Today at 09:20",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: colorsFile.titleCard,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

