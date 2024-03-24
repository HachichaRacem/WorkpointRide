import 'package:osmflutter/Users/widgets/Notification/canceled.dart';
import 'package:osmflutter/Users/widgets/Notification/completed.dart';
import 'package:osmflutter/Users/widgets/Notification/upcoming.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/constant/colorsFile.dart';



class Notif extends StatefulWidget {
  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> with SingleTickerProviderStateMixin {
  late double _height;
  late double _width;
 

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final _tabs = [
      Tab(text: 'Upcoming'),
      Tab(text: 'Completed'),
      Tab(text: 'Cancelled'),
    ];

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
              height: _height * 0.07,
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
                  children: [
                    SizedBox(height: 30,),
                    Container(
                      width: _width * 0.9,
                      height: kToolbarHeight - 0.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(  color: colorsFile.icons,)
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: colorsFile.icons,
                        ),
                        labelColor: Colors.white,
                        dividerColor: Colors.transparent,
                        unselectedLabelColor: colorsFile.tabbar,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: _tabs,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Import and use the UpcomingWidget
                          AlertUpcoming(),
                          // Import and use the CompletedWidget
                          AlertCompleted(),
                          // Import and use the CancelledWidget
                          AlertCancelled(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
