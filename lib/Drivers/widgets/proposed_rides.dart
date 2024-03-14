import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:osmflutter/constant/colorsFile.dart';

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
  List<Color> containerColors = List.filled(
      4, colorsFile.cardColor); // Use the background color as the default color

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -15,
          child: Container(
            width: 60,
            height: 7,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: colorsFile.cardColor,
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
                      "Your proposed rides",
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
                                    Icons.add,
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
              Column(
                children: [
                  GlassmorphicContainer(
                    height: 100,
                    width: _width * 0.8,
                    borderRadius: 15,
                    blur: 100,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      colors: [
                        colorsFile.card2,
                        colorsFile.card2,
                        colorsFile.card2
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
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18.0,10,5,10),
                              child: Text(
                                "Home",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: colorsFile.icons,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                "--->",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: colorsFile.icons,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                "EY Tower",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: colorsFile.icons,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18.0,5,5,5),
                              child: Row(
                                children: [
                                  Container(child:
                                  Image.asset(
                                    'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                    width: 25, // Adjust width and height as per your image size
                                    height: 25,
                                    color: colorsFile.done, // You can also apply color to the image if needed
                                  ),),
                                  Container(child:
                                  Image.asset(
                                    'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                    width: 25, // Adjust width and height as per your image size
                                    height: 25,
                                    color: colorsFile.done, // You can also apply color to the image if needed
                                  ),),
                                  Container(child:
                                  Image.asset(
                                    'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                    width: 25, // Adjust width and height as per your image size
                                    height: 25,
                                    color: colorsFile.done, // You can also apply color to the image if needed
                                  ),),
                                  Container(child:
                                  Image.asset(
                                    'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                    width: 25, // Adjust width and height as per your image size
                                    height: 25,
                                    color: colorsFile.done, // You can also apply color to the image if needed
                                  ),),


                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18.0,5,18,5),
                              child: Text(
                                "07 : 20",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: colorsFile.detailColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18.0,5,5,5),
                              child: Row(
                                children: [
                                  Container(child:
                                 Icon(Icons.delete,color: colorsFile.skyBlue,)),
                                  SizedBox(width: 5,),
                                  Container(child:
                                  Icon(Icons.edit,color: colorsFile.skyBlue,)),



                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                    ),
                  ),
                  SizedBox(height:10),
                  GlassmorphicContainer(
                    height: 100,
                    width: _width * 0.8,
                    borderRadius: 15,
                    blur: 100,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      colors: [
                        colorsFile.card2,
                        colorsFile.card2,
                        colorsFile.card2
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(18.0,10,5,10),
                                  child: Text(
                                    "Home",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: colorsFile.icons,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "--->",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: colorsFile.icons,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "EY Tower",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: colorsFile.icons,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(18.0,5,5,5),
                                  child: Row(
                                    children: [
                                      Container(child:
                                      Image.asset(
                                        'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                        width: 25, // Adjust width and height as per your image size
                                        height: 25,
                                        color: colorsFile.done, // You can also apply color to the image if needed
                                      ),),
                                      Container(child:
                                      Image.asset(
                                        'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                        width: 25, // Adjust width and height as per your image size
                                        height: 25,
                                        color: colorsFile.done, // You can also apply color to the image if needed
                                      ),),
                                      Container(child:
                                      Image.asset(
                                        'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                        width: 25, // Adjust width and height as per your image size
                                        height: 25,
                                        color: colorsFile.done, // You can also apply color to the image if needed
                                      ),),
                                      Container(child:
                                      Image.asset(
                                        'assets/images/seat.png', // Replace 'assets/star_image.png' with your image path
                                        width: 25, // Adjust width and height as per your image size
                                        height: 25,
                                        color: colorsFile.done, // You can also apply color to the image if needed
                                      ),),


                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(18.0,5,18,5),
                                  child: Text(
                                    "07 : 20",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: colorsFile.detailColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(18.0,5,5,5),
                                  child: Row(
                                    children: [
                                      Container(child:
                                      Icon(Icons.delete,color: colorsFile.skyBlue,)),
                                      SizedBox(width: 5,),
                                      Container(child:
                                      Icon(Icons.edit,color: colorsFile.skyBlue,)),



                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
