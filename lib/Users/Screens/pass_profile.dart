import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:osmflutter/login/choose_role.dart';
import 'package:osmflutter/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../GoogleMaps/passenger_map.dart';
import 'history.dart';

class pass_profile extends StatefulWidget {
  const pass_profile({super.key});

  @override
  State<pass_profile> createState() => _pass_profileState();
}

class _pass_profileState extends State<pass_profile> {
  late String user = "";
  late String firstName = "";
  late String lastName = "";
  late String phoneNumber = "";
  List<dynamic> favLocations = [];

  Future<void> _loadUserFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user')!;
    firstName = prefs.getString('firstName')!;
    lastName = prefs.getString('lastName')!;
    phoneNumber = prefs.getString('phoneNumber')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    print("inside the initstate");
    _loadUserFromStorage();

    // get_shared();
    super.initState();
  }

  // List favLocations = User().favoritePlaces ?? [];

  bool check_shared_data = true;

  dynamic sp_data_poly_lat1,
      sp_data_poly_lng1,
      sp_data_poly_lat2,
      sp_data_poly_lng2;

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
      body: Stack(
        children: [
          // Background Photo
          // MapsGoogleExample(),

          //check_shared_data == true
          PassengerMap(condition: false),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.clear();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 50,
                child: Stack(children: [
                  const Center(
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
            ),
          ),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => History(),
                                        ),
                                      );
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChooseRole(),
                                        ),
                                      );
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
                              "${firstName} ${lastName}",
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
                                        child: favLocations.isEmpty
                                            ? Center(
                                                child: Text(
                                                  "No favorite locations",
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: colorsFile.titleCard,
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.phone,
                                                        color: colorsFile
                                                            .detailColor,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          _launchPhoneDialer(
                                                              '${phoneNumber}');
                                                        },
                                                        child: Text(
                                                          '${phoneNumber}',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                            color: colorsFile
                                                                .titleCard,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  ...List.generate(
                                                    favLocations.length,
                                                    (index) => Row(
                                                      children: [
                                                        Text(
                                                          favLocations[index]
                                                              ['name'],
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13,
                                                            color: colorsFile
                                                                .titleCard,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
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
                                                                  color: Colors
                                                                      .white,
                                                                  height: 50,
                                                                  width: 50,
                                                                  borderRadius:
                                                                      50,
                                                                  curveType:
                                                                      CurveType
                                                                          .concave,
                                                                  depth: 30,
                                                                  spread: 1,
                                                                ),
                                                                Center(
                                                                  child:
                                                                      ClayContainer(
                                                                    color: Colors
                                                                        .white,
                                                                    height: 40,
                                                                    width: 40,
                                                                    borderRadius:
                                                                        40,
                                                                    curveType:
                                                                        CurveType
                                                                            .convex,
                                                                    depth: 30,
                                                                    spread: 1,
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .directions,
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
            boxShadow: const [],
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
