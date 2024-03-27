import 'package:flutter/cupertino.dart';
import 'package:osmflutter/GoogleMaps/pass_route_map.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/GoogleMaps/googlemaps.dart';

import 'package:osmflutter/mapOsm/home_example.dart';
import 'package:osmflutter/shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../GoogleMaps/driver_polyline_map.dart';
import '../../GoogleMaps/passenger_map.dart';

class pass_profile extends StatefulWidget {
  const pass_profile({super.key});

  @override
  State<pass_profile> createState() => _pass_profileState();
}

class _pass_profileState extends State<pass_profile> {

  @override
  void initState() {
    // TODO: implement initState
    print("inside the initstate");
    get_shared();
    super.initState();
  }


  bool check_shared_data = true;

  dynamic sp_data_poly_lat1,
      sp_data_poly_lng1,
      sp_data_poly_lat2,
      sp_data_poly_lng2;
  get_shared() async {
    print("Getting the shared data");

    final prefs = await sharedpreferences.get_pass_poly_lat1();
    sp_data_poly_lat1 = prefs;
    print("Poly_lat1 = ${sp_data_poly_lat1}");

    final prefs1 = await sharedpreferences.get_pass_poly_lng1();
    sp_data_poly_lng1 = prefs1;
    print("Poly_lng1 = ${sp_data_poly_lng1}");

    final prefs2 = await sharedpreferences.get_pass_poly_lat2();
    sp_data_poly_lat2 = prefs2;
    print("Poly_lat2 = ${sp_data_poly_lat2}");

    final prefs3 = await sharedpreferences.get_pass_poly_lng2();
    sp_data_poly_lng2 = prefs3;
    print("Poly_lng2 = ${sp_data_poly_lng2}");

    setState(() {});

    if (sp_data_poly_lat1 == null ||
        sp_data_poly_lng1 == null ||
        sp_data_poly_lat2 == null ||
        sp_data_poly_lng2 == null) {
      print("Shared data values are null");
      check_shared_data = true;
      setState(() {

      });
    } else {
      print("Shared data values are not null");
      check_shared_data = false;
      setState(() {});
    }

  }

  bool bottomSheetVisible = true;


  // Function to launch the phone dialer
  Future<void> _launchPhoneDialer(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }




  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
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
        toolbarHeight: 80.0,
        title: const Column(
          children: [
            SizedBox(height: 16.0),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Photo
          // MapsGoogleExample(),

          check_shared_data==true ?
          PassengerMap(condition: false) : pass_route_map(lat1: sp_data_poly_lat1, lng1: sp_data_poly_lng1, lat2: sp_data_poly_lat2, lng2: sp_data_poly_lng2),


          SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minHeight: MediaQuery.of(context).size.height * 0.45,
            panel: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: const BoxDecoration(
                        color: colorsFile.cardColor,
                        borderRadius:  BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 25,
                  left: 25,
                  child: Center(
                    child: Container(
                      height: 90,
                      padding: const EdgeInsets.all(5), // Border width
                      decoration: const BoxDecoration(
                        color: colorsFile.borderCircle,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(40), // Image radius
                          child: const Image(
                            image: AssetImage("assets/images/homme1.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    child:
                    Column(
                      children: [
                        const SizedBox(height: 30),
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Call your void method or add logic for the entire structure
                                      // _showModalBottomSheet1(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Stack(
                                        children: [
                                          ClayContainer(
                                            color: Colors.white,
                                            height: 50,
                                            width: 50,
                                            borderRadius: 50,
                                            curveType: CurveType.concave,
                                            depth: 30,
                                            spread: 1,
                                          ),
                                          Center(
                                            child: ClayContainer(
                                              color: Colors.white,
                                              height: 40,
                                              width: 40,
                                              borderRadius: 40,
                                              curveType: CurveType.convex,
                                              depth: 30,
                                              spread: 1,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.history_outlined,
                                                  color: colorsFile.ProfileIcon,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Call your void method or add logic for the entire structure
                                      // _showModalBottomSheet1(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Stack(
                                        children: [
                                          ClayContainer(
                                            color: Colors.white,
                                            height: 50,
                                            width: 50,
                                            borderRadius: 50,
                                            curveType: CurveType.concave,
                                            depth: 30,
                                            spread: 1,
                                          ),
                                          Center(
                                            child: ClayContainer(
                                              color: Colors.white,
                                              height: 40,
                                              width: 40,
                                              borderRadius: 40,
                                              curveType: CurveType.convex,
                                              depth: 30,
                                              spread: 1,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.airline_seat_recline_normal_sharp,
                                                  color: colorsFile.ProfileIcon,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Foulen Ben Foulen",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: colorsFile.titleCard,
                              ),
                            ),
                          ],
                        ),
                        GlassmorphicContainer(
                          height: 250,
                          width: MediaQuery.of(context).size.width * 0.9,
                          borderRadius: 15,
                          blur: 100,
                          alignment: Alignment.center,
                          border: 2,
                          linearGradient: const LinearGradient(
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
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: _width * 0.9,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    _launchPhoneDialer('55555555');
                                                  },
                                                  child: const Icon(
                                                    Icons.phone,
                                                    color: colorsFile.detailColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                InkWell(
                                                  onTap: (){
                                                    _launchPhoneDialer('55555555');
                                                  },
                                                  child: Text(
                                                    "55 555 555",
                                                    style: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: colorsFile.titleCard,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.home,
                                                  color: colorsFile.detailColor,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "V5VP+RH La Marsa",
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: colorsFile.titleCard,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: colorsFile.skyBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.favorite,
                                                      color: colorsFile.detailColor,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "V5VP+RH La Marsa",
                                                              style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 13,
                                                                color: colorsFile.titleCard,
                                                              ),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color: colorsFile.skyBlue,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "V5VP+RH La Marsa",
                                                              style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 13,
                                                                color: colorsFile.titleCard,
                                                              ),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color: colorsFile.skyBlue,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.add,
                                                            color: colorsFile.skyBlue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // Call your void method or add logic for the entire structure
                                                      // _showModalBottomSheet1(context);
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: Stack(
                                                        children: [
                                                          ClayContainer(
                                                            color: Colors.white,
                                                            height: 50,
                                                            width: 50,
                                                            borderRadius: 50,
                                                            curveType: CurveType.concave,
                                                            depth: 30,
                                                            spread: 1,
                                                          ),
                                                          Center(
                                                            child: ClayContainer(
                                                              color: Colors.white,
                                                              height: 40,
                                                              width: 40,
                                                              borderRadius: 40,
                                                              curveType: CurveType.convex,
                                                              depth: 30,
                                                              spread: 1,
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons.directions,
                                                                  color: colorsFile.ProfileIcon,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      ],
                    ),

                  ),
                ),
              ],
            ),
            body: Container(),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            color: Colors.transparent,
            boxShadow: [],
            onPanelSlide: (double pos) {
              setState(() {
                bottomSheetVisible = pos > 0.5;
              });
            },
          )


        ],
      ),
    );
  }
}
