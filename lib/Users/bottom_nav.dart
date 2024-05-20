import 'package:osmflutter/Users/Screens/notif.dart';
import 'package:osmflutter/Users/Screens/profile.dart';
import 'package:osmflutter/Users/BottomSheet/MyRides.dart';
import 'package:osmflutter/Users/Screens/Search.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'Screens/pass_profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int indexSelected = 1;
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
        TabController(length: 3, vsync: this, initialIndex: indexSelected);
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
          Search(),
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
            icon: Icon(Icons.search, color: colorsFile.icons),
          ),
          TabItem(
            icon: Icon(Icons.notifications, color: colorsFile.icons),
          ),
        ],
        initialActiveIndex: 1,
        gradient: LinearGradient(
          colors: [
            const Color.fromRGBO(94, 149, 180, 1),
            const Color.fromRGBO(77, 140, 175, 1)
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
