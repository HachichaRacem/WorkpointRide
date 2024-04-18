import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:osmflutter/constant/colorsFile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProposedRides extends StatefulWidget {
  Function() showMyRides;
  Function() ridesVisible;
  ProposedRides(this.showMyRides, this.ridesVisible, {Key? key})
      : super(key: key);

  @override
  _ProposedRidesState createState() => _ProposedRidesState();
}

class _ProposedRidesState extends State<ProposedRides> {
  late double _height;
  late double _width;
  bool bottomSheetVisible = false;
  List<Color> containerColors = List.filled(
      4, colorsFile.cardColor); // Use the background color as the default color

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return SlidingUpPanel(
      maxHeight: _height * 0.38,
      minHeight: _height * 0.11,
      panel:
      Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 5,
            child: Container(
              width: 60,
              height: 7,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white60,
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
                        "Your  rides",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorsFile.titleCard,
                        ),
                      ),
                    ),
                    const Spacer(),
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
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      size:30,
                                      color: colorsFile.buttonIcons,
                                      
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
                Column(
                  children: [
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
                                        CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 5),
                                          Center(
                                            child: Container(
                                              height: 60,
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: colorsFile.buttonIcons,
                                                shape: BoxShape.circle,
                                              ),
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
                                // print("heloooo");
                                // widget.showMyRides();
                              },
                              child: Center(
                                child: ClayContainer(
                                  color: Colors.white,
                                  height: 30,
                                  width: 30,
                                  borderRadius: 40,
                                  curveType: CurveType.convex,
                                  depth: 30,
                                  spread: 1,
                                  child: const Center(
                                    child: Icon(
                                      Icons.route,
                                      size:30,
                                      color: colorsFile.buttonIcons,
                                      
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Home",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: (containerColors[index] ==
                                                  colorsFile.cardColor)
                                                  ? colorsFile.titleCard
                                                  : Colors.white,
                                            ),
                                          ),
                                          
                                              Text(
                                                "|",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                  (containerColors[index] ==
                                                      colorsFile
                                                          .cardColor)
                                                      ? colorsFile.titleCard
                                                      : Colors.white,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_downward,
                                                color: (containerColors[index] ==
                                                    colorsFile.cardColor)
                                                    ? colorsFile.icons
                                                    : Colors.white,
                                                size: 15,
                                              ),
                                              SizedBox(width: 10),
                                              
                                           
                                          Text(
                                                "EY Tower",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                  (containerColors[index] ==
                                                      colorsFile
                                                          .cardColor)
                                                      ? colorsFile.titleCard
                                                      : Colors.white,
                                                ),
                                              ),
                                          //SizedBox(height: 10),
                                          Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10.0,5,5,5),
                                    child: Row(
                                      children: [
                                        Container(child:
                                        Image.asset(
                                          'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                          width: 12, // Adjust width and height as per your image size
                                          height: 12,
                                          color: colorsFile.done, // You can also apply color to the image if needed
                                        ),),
                                        Container(child:
                                        Image.asset(
                                          'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                         width: 12, // Adjust width and height as per your image size
                                          height: 12,
                                          color: colorsFile.done, // You can also apply color to the image if needed
                                        ),),
                                        Container(child:
                                        Image.asset(
                                          'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                          width: 12, // Adjust width and height as per your image size
                                          height: 12,
                                          color: colorsFile.done, // You can also apply color to the image if needed
                                        ),),
                                        Container(child:
                                        Image.asset(
                                          'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                          width: 12, // Adjust width and height as per your image size
                                          height: 12,
                                          color: colorsFile.done, // You can also apply color to the image if needed
                                        ),),


                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0,5,10,5),
                                    child: Text(
                                      "07 : 20",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                        color: colorsFile.detailColor,
                                      ),
                                    ),
                                  ),
                                 
                                ],
                              )
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
                )
              ],
            ),
          ),
        ],
      ),
      body: Container(), // Your body widget here
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50.0),
        topRight: Radius.circular(50.0),
      ),
      color: colorsFile.cardColor,
      //isDraggable: true,
      onPanelSlide: (double pos) {
        print("objectasdasdasda");
        setState(() {
          bottomSheetVisible = pos > 0.5;
        });
      },
      isDraggable: true,
    );

  }
}
