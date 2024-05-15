import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:osmflutter/Drivers/Screens/addSchedule/add_ride_page.dart';
import 'package:osmflutter/Drivers/Screens/calendar.dart';
import 'package:osmflutter/Users/Screens/notif.dart';
import 'package:osmflutter/Users/Screens/pass_profile.dart';
import 'package:osmflutter/Users/Screens/profile.dart';
import 'package:osmflutter/constant/colorsFile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int indexSelected = 2;

  void onBarItemClicked(int i) {
    setState(() {
      indexSelected = i;
      controller.index = indexSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    controller =
        TabController(length: 4, vsync: this, initialIndex: indexSelected);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          //SearchDestinationPage(),
          pass_profile(),
          Calendar(),
          AddRides(),
          Notif(),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        height: 60,
        items: const [
          TabItem(
            icon: Icon(Icons.person, color: colorsFile.icons),
          ),
          TabItem(
            icon: Icon(Icons.calendar_month, color: colorsFile.icons),
            isIconBlend: false,
            //   activeIcon: Icon(Icons.calendar_month, color: Colors.white, size: 35),
          ),
          TabItem(
            icon: Icon(Icons.directions, color: colorsFile.icons),
            isIconBlend: false,
            //  activeIcon: Icon(Icons.add, color: Colors.white, size: 35),
          ),
          TabItem(
            icon: Icon(Icons.notifications, color: colorsFile.icons),
          ),
        ],
        initialActiveIndex: 2,
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(94, 149, 180, 1),
            Color.fromRGBO(77, 140, 175, 1)
          ],
        ),
        curveSize: 150,
        activeColor: Color.fromRGBO(94, 149, 180, 1),
        style: TabStyle.react,
        onTap: onBarItemClicked,
      ),
    );
  }
}
