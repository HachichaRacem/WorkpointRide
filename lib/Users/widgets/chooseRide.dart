import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:osmflutter/constant/colorsFile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChooseRide extends StatefulWidget {
  Function() showMyRides;
  Function() ridesVisible;
  ChooseRide(this.showMyRides, this.ridesVisible, {Key? key}) : super(key: key);

  @override
  _ChooseRideState createState() => _ChooseRideState();
}

class _ChooseRideState extends State<ChooseRide> {
  late double _height;
  late double _width;
  bool bottomSheetVisible = true;
  List<Color> containerColors = List.filled(
      4, colorsFile.cardColor); // Use the background color as the default color

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return

    SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height * 0.7,
      minHeight: MediaQuery.of(context).size.height * 0.35,
      panel: Stack(
        alignment: AlignmentDirectional.topCenter,
       // clipBehavior: Clip.none,
        children: [
          Positioned(
           top: 5,
            child: Container(
              width: 60,
              height: 7,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                  color: colorsFile.background,
              ),
            ),
          ),
          Positioned(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 8.0, 0, 8),
                      child: Text(
                        "Choose a ride",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorsFile.titleCard,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            GestureDetector(
                              onTap: () {
                                print("heloooo");
                                widget.showMyRides();
                              },
                              child: Center(
                                child: ClayContainer(
                                  color: Colors.white,
                                  height: 40,
                                  width: 40,
                                  borderRadius: 40,
                                  curveType: CurveType.convex,
                                  depth: 30,
                                  spread: 1,
                                  child: Center(
                                    child: Icon(
                                      Icons.send,
                                      color: colorsFile.buttonIcons,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      4,
                          (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle the clicked state
                            containerColors[index] =
                            (containerColors[index] == colorsFile.cardColor)
                                ? colorsFile.icons
                                : colorsFile.cardColor;
                          });
                          widget.ridesVisible();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 16.0,
                          ),
                          child: GlassmorphicContainer(
                            height: 185,
                            width: _width * 0.3,
                            borderRadius: 15,
                            blur: 100,
                            alignment: Alignment.center,
                            border: 2,
                            linearGradient: LinearGradient(
                              colors: [
                                (containerColors[index] == colorsFile.cardColor)
                                    ? Color(0xFFD8E6EE)
                                    : containerColors[index],
                                (containerColors[index] == colorsFile.cardColor)
                                    ? Color(0xFFD8E6EE)
                                    : containerColors[index],
                              ],
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
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          Center(
                                            child: Container(
                                              height: 60,
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: colorsFile.borderCircle,
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipOval(
                                                child: SizedBox.fromSize(
                                                  size: Size.fromRadius(28),
                                                  child: index == 1
                                                      ? Image(
                                                    image: AssetImage(
                                                      "assets/images/homme1.jpg",
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )
                                                      : index == 2
                                                      ? Image(
                                                    image: AssetImage(
                                                      "assets/images/homme2.jpg",
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )
                                                      : index == 3
                                                      ? Image(
                                                    image:
                                                    AssetImage(
                                                      "assets/images/femme1.jpg",
                                                    ),
                                                    fit: BoxFit
                                                        .cover,
                                                  )
                                                      : Image(
                                                    image:
                                                    AssetImage(
                                                      "assets/images/femme2.jpg",
                                                    ),
                                                    fit: BoxFit
                                                        .cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 13),
                                          Text(
                                            "12 Foulen Ben Foulen",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: (containerColors[index] ==
                                                  colorsFile.cardColor)
                                                  ? colorsFile.titleCard
                                                  : Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                color: (containerColors[index] ==
                                                    colorsFile.cardColor)
                                                    ? colorsFile.icons
                                                    : Colors.white,
                                                size: 12,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "55 555 555",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color:
                                                  (containerColors[index] ==
                                                      colorsFile
                                                          .cardColor)
                                                      ? colorsFile.titleCard
                                                      : Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              index == 1
                                                  ? Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .airline_seat_recline_normal_sharp,
                                                    color: colorsFile
                                                        .buttonIcons,
                                                    size: 12,
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .airline_seat_recline_normal_sharp,
                                                    color: colorsFile
                                                        .buttonIcons,
                                                    size: 12,
                                                  ),
                                                ],
                                              )
                                                  : index == 2
                                                  ? Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .airline_seat_recline_normal_sharp,
                                                    color: colorsFile
                                                        .buttonIcons,
                                                    size: 12,
                                                  ),

                                                ],
                                              )
                                                  : Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .airline_seat_recline_normal_sharp,
                                                    color: colorsFile
                                                        .buttonIcons,
                                                    size: 12,
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .airline_seat_recline_normal_sharp,
                                                    color: colorsFile
                                                        .buttonIcons,
                                                    size: 12,
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .airline_seat_recline_normal_sharp,
                                                    color: colorsFile
                                                        .buttonIcons,
                                                    size: 12,
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                  "07:20",
                                                  textAlign: TextAlign.end,
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    color: (containerColors[
                                                    index] ==
                                                        colorsFile.cardColor)
                                                        ? colorsFile.detailColor
                                                        : Colors.white,
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50.0),
        topRight: Radius.circular(50.0),
      ),
      color: colorsFile.cardColor,
      onPanelSlide: (double pos) {
        setState(() {
          print("dbvskcxjb");
          bottomSheetVisible = pos > 0.5;
        });
      },
      isDraggable: true,
    );

  }
}
