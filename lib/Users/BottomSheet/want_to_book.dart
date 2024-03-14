import 'package:osmflutter/Users/widgets/chooseRide.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:osmflutter/constant/colorsFile.dart';

import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

class WantToBook extends StatelessWidget {
  String title;
  String desc;
  Function() onAddPressed;
  WantToBook(this.title, this.desc, this.onAddPressed, {Key? key})
      : super(key: key);
  late double _height;
  late double _width;
  Color baseColor = const Color(0xFFf2f2f2);
  bool isContainerVisible = false;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
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
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      title.toString(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: colorsFile.titleCard),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          this.onAddPressed();
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
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: colorsFile.buttonIcons,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                desc.toString(),
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: colorsFile.titleCard),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  // void _showModalBottomSheet1(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(50),
  //       ),
  //     ),
  //     builder: (context) => DraggableScrollableSheet(
  //       initialChildSize: 0.4,
  //       maxChildSize: 0.9,
  //       minChildSize: 0.32,
  //       expand: false,
  //       builder: (context, scrollController) {
  //         return Container(
  //           decoration: BoxDecoration(
  //             color: colorsFile.cardColor,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(50.0),
  //               topRight: Radius.circular(50.0),
  //             ),
  //           ),
  //           child: SingleChildScrollView(
  //             controller: scrollController,
  //             child: ChooseRide(),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
