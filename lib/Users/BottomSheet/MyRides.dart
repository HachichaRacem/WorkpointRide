import 'package:flutter/widgets.dart';
import 'package:osmflutter/Users/widgets/chooseRide.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:osmflutter/constant/colorsFile.dart';

import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class MyRides extends StatefulWidget {
  final Map? selectedRouteCardInfo;
  const MyRides({super.key, this.selectedRouteCardInfo});

  @override
  State<MyRides> createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  late double _height;
  late double _width;
  bool bottomSheetVisible = true;
  bool isClicked = false;
  final Color _selectedColor = colorsFile.icons;
  final Color _unselectedColor = colorsFile.cardColor;


  Color baseColor = const Color(0xFFf2f2f2);


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height * 0.4,
      minHeight: MediaQuery.of(context).size.height * 0.2,
      panel: Stack(
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
                color: colorsFile.background,
              ),
            ),
          ),
          Positioned(
            child: Column(children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 8.0, 0, 8),
                    child: Text(
                      'Your rides pass2',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorsFile.titleCard),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                        onTap: () {
                        
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
              GlassmorphicContainer(
                  height: 200,
                  width: _width * 0.6,
                  borderRadius: 15,
                  blur: 100,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: LinearGradient(
            colors: [
              (isClicked == true) ? _selectedColor : _unselectedColor,
              (isClicked == true) ? _selectedColor : _unselectedColor,
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
          child: GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked; // Toggle the state of isClicked
        });
      },
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Container(
                                height: 70,
                                padding:
                                    const EdgeInsets.all(5), // Border width
                                decoration: const BoxDecoration(
                                    color: colorsFile.borderCircle,
                                    shape: BoxShape.circle),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        30), // Image radius
                                    child: Image(
                                      image: AssetImage(
                                          widget.selectedRouteCardInfo![
                                                  'image'] ??
                                              "assets/images/homme1.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.selectedRouteCardInfo![
                                            'driverName'] ??
                                        "Foulen Ben Falten",
                                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: (isClicked == false)
                            ? colorsFile.titleCard
                            : Colors.white,
                      ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () => {},
                                      icon:  Icon(
                                        Icons.delete,
                                        color: (isClicked == false)
                              ? colorsFile.icons
                              : Colors.white,
                          size: 12,
                                      )),
                                ],
                              ),

                              Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Stack(
                                      children: [
                                        ClayContainer(
                                          color: Colors.white,
                                          height: 30,
                                          width: 30,
                                          borderRadius: 50,
                                          curveType: CurveType.concave,
                                          depth: 20,
                                          spread: 1,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("heloooo");
                                            _launchPhone("55555555");
                                          },
                                          child: Center(
                                            child: ClayContainer(
                                              color: Colors.white,
                                              height: 20,
                                              width: 20,
                                              borderRadius: 40,
                                              curveType: CurveType.convex,
                                              depth: 30,
                                              spread: 1,
                                              child:  Center(
                                                child: Icon(
                                                  Icons.phone,
                                                  color: (isClicked == false)
                              ? colorsFile.icons
                              : Colors.white,
                          size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.selectedRouteCardInfo![
                                            'driverNum'] ??
                                        "55 555 555",
                                    style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: (isClicked == false)
                                ? colorsFile.titleCard
                                : Colors.white,
                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Home",
                                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: (isClicked == false)
                                ? colorsFile.titleCard
                                : Colors.white,
                          ),
                                      ),
                                      Text(
                                        "--->",
                                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: (isClicked == false)
                                ? colorsFile.titleCard
                                : Colors.white,
                          ),
                                      ),
                                      Text(
                                        "EY Tower",
                                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: (isClicked == false)
                                ? colorsFile.titleCard
                                : Colors.white,
                          ),
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        widget.selectedRouteCardInfo![
                                                'scheduleStartTime'] ??
                                            '7:15',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: (isClicked == false)
                                ? colorsFile.titleCard
                                : Colors.white,
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
                  )),
              ),
            ]),
          )
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
          bottomSheetVisible = pos > 0.5;
        });
      },
    );
  }

  _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
