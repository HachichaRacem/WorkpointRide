// import 'package:osmflutter/Users/widgets/Notification/canceled.dart';
// import 'package:osmflutter/Users/widgets/Notification/completed.dart';
// import 'package:osmflutter/Users/widgets/Notification/upcoming.dart';
// import 'package:flutter/material.dart';
// import 'package:clay_containers/clay_containers.dart';
// import 'package:glassmorphism/glassmorphism.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:osmflutter/constant/colorsFile.dart';



// class Notif extends StatefulWidget {
//   @override
//   _NotifState createState() => _NotifState();
// }

// class _NotifState extends State<Notif> with SingleTickerProviderStateMixin {
//   late double _height;
//   late double _width;
 

//   late TabController _tabController;

//   @override
//   void initState() {
//     _tabController = TabController(length: 3, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _height = MediaQuery.of(context).size.height;
//     _width = MediaQuery.of(context).size.width;
//     final _tabs = [
//       Tab(text: 'Upcoming'),
//       Tab(text: 'Completed'),
//       Tab(text: 'Cancelled'),
//     ];

//     return Scaffold(
//       backgroundColor: colorsFile.background,
//       body: Column(
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 30.0,
//               ),
//               height: _height * 0.07,
//               width: _width,
//             ),
//           ),
//           Expanded(
//             child: Container(
//               width: _width,
//               decoration: BoxDecoration(
//                 color: colorsFile.cardColor,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40.0),
//                   topRight: Radius.circular(40.0),
//                 ),
//               ),
//               child: Container(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 30,),
                    // Container(
                    //   width: _width * 0.9,
                    //   height: kToolbarHeight - 0.0,
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey.shade200,
                    //     borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(  color: colorsFile.icons,)
                    //   ),
                    //   child: TabBar(
                    //     controller: _tabController,
                    //     indicator: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       color: colorsFile.icons,
                    //     ),
                    //     labelColor: Colors.white,
                    //     dividerColor: Colors.transparent,
                    //     unselectedLabelColor: colorsFile.tabbar,
                    //     indicatorSize: TabBarIndicatorSize.tab,
                    //     tabs: _tabs,
                    //   ),
                    // ),
                    // Expanded(
                    //   child: TabBarView(
                    //     controller: _tabController,
                    //     children: [
                          // Import and use the UpcomingWidget
                          // AlertUpcoming(),
                          // // Import and use the CompletedWidget
                          // AlertCompleted(),
                          // // Import and use the CancelledWidget
                          // AlertCancelled(),
//                           Padding(
//                     padding: EdgeInsets.only(top: _height * 0.2), // 10% from the bottom of the container
//                     child: Text(
//                       "Coming Soon",
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.montserrat(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: colorsFile.icons,
//                       )
//                     ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/constant/colorsFile.dart';

class Notif extends StatefulWidget {
  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
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
              
                  Text(
                    "reservation cancellation",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: colorsFile.notiftitle,
                    ),
                  ),
               
             SizedBox(height: 8), 
                  Text(
                    "foulen el fouleni has cancelled your reservation",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: colorsFile.notiftext,
                    ),
                  ),
                
              SizedBox(height: 8),  // Increased height for more spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "Today at 09:20",
                      textAlign: TextAlign.end,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: colorsFile.notifdate,
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