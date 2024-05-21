import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osmflutter/constant/colorsFile.dart';

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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        title.toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: colorsFile.titleCard),
                      ),
                    ),
                  ),
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 8, 0),
                  child: Text(
                    desc.toString(),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: colorsFile.titleCard),
                  ),
                ),
                Spacer()
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
