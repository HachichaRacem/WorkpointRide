import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/GoogleMaps/googlemaps.dart';

import 'package:osmflutter/constant/colorsFile.dart';
import 'package:osmflutter/shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late double _height;
  late double _width;
  Color baseColor = const Color(0xFFf2f2f2);

  bool bottomSheetVisible = true;
  bool check = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("Inside the insit state \n getting the shared preferences values");
    // getshared();
  }

  // dynamic sp_poly_lat1, sp_poly_lng1, sp_poly_lat2, sp_poly_lng2;
  // getshared() async {
  //   final prefs = await sharedpreferences.get_poly_lat1();
  //   sp_poly_lat1 = prefs;
  //   print("Poly_lat1 = ${sp_poly_lat1}");

  //   final prefs1 = await sharedpreferences.get_poly_lng1();
  //   sp_poly_lng1 = prefs1;
  //   print("Poly_lng1 = ${sp_poly_lng1}");

  //   final prefs2 = await sharedpreferences.get_poly_lat2();
  //   sp_poly_lat2 = prefs2;
  //   print("Poly_lat2 = ${sp_poly_lat2}");

  //   final prefs3 = await sharedpreferences.get_poly_lng2();
  //   sp_poly_lng2 = prefs3;
  //   print("Poly_lng2 = ${sp_poly_lng2}");

  //   if (sp_poly_lng1 != null ||
  //       sp_poly_lat1 != null ||
  //       sp_poly_lng2 != null ||
  //       sp_poly_lat2 != null) {
  //     setState(() {
  //       check = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(

      body: Stack(
        children: [
          // Background Photo
          // MapsGoogleExample(),
          MapsGoogleExample(),

          SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            minHeight: MediaQuery.of(context).size.height * 0.18,
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
                        borderRadius: BorderRadius.only(
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
                            image: AssetImage("assets/images/homme1.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
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
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => History(),
                                      //   ),
                                      // );
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
                                                  Icons
                                                      .airline_seat_recline_normal_sharp,
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
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 20,
                                  color: colorsFile.titleCard,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  textAlign: TextAlign.center,
                                  "55 555 555",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: colorsFile.titleCard,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        GlassmorphicContainer(
                          height: 210,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.favorite,
                                                  color: colorsFile.detailColor,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "V5VP+RH La Marsa1",
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
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.favorite,
                                                  color: colorsFile.detailColor,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "V5VP+RH La Marsa2",
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.favorite,
                                                      color: colorsFile
                                                          .detailColor,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "V5VP+RH La Marsa3",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13,
                                                            color: colorsFile
                                                                .titleCard,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: colorsFile
                                                                .skyBlue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                //const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
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
                                                            curveType: CurveType
                                                                .concave,
                                                            depth: 30,
                                                            spread: 1,
                                                          ),
                                                          Center(
                                                            child:
                                                                ClayContainer(
                                                              color:
                                                                  Colors.white,
                                                              height: 40,
                                                              width: 40,
                                                              borderRadius: 40,
                                                              curveType:
                                                                  CurveType
                                                                      .convex,
                                                              depth: 30,
                                                              spread: 1,
                                                              child:
                                                                  const Center(
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 35,
                                                                  color: colorsFile
                                                                      .ProfileIcon,
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
