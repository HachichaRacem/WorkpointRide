import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:osmflutter/GoogleMaps/googlemaps.dart';
import 'package:osmflutter/Users/BottomSheet/MyRides.dart';
import 'package:osmflutter/constant/colorsFile.dart';

class DriverRides extends StatefulWidget {
  const DriverRides({Key? key}) : super(key: key);

  @override
  _DriverRidesState createState() => _DriverRidesState();
}

class _DriverRidesState extends State<DriverRides> {
  late double _height;
  late double _width;
  bool isContainerVisible = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      _showModalBottomSheet(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: MapsGoogleExample(),
          ),
          Visibility(
            visible: isContainerVisible,
            child: Positioned(
              top: 100,
              right: _width / 2 * 0.15,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isContainerVisible = false;
                  });
                },
                child: GlassmorphicContainer(
                  height: 250,
                  width: _width * 0.85,
                  borderRadius: 15,
                  blur: 2,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: LinearGradient(
                    colors: [
                      Color(0xFF003A5A).withOpacity(0.37),
                      Color(0xFF003A5A).withOpacity(1),
                      Color(0xFF003A5A).withOpacity(0.36),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderGradient: LinearGradient(
                    colors: [
                      Color(0xFF003A5A).withOpacity(0.37),
                      Color(0xFF003A5A).withOpacity(1),
                      Color(0xFF003A5A).withOpacity(0.36),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isContainerVisible = false;
                                });
                              },
                              child: Icon(
                                Icons.close,
                                color: Color(0xFFFFFFFF), // White color
                                size: 25.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(
                                                    0xFFFFFFFF), // White color
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(
                                                    0xFFFFFFFF), // White color
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            hintText: 'Home',
                                            hintStyle: TextStyle(
                                              color: Color(
                                                  0xFFFFFFFF), // White color
                                            ),
                                            prefixIcon: Icon(Icons.location_on),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              5), // Adjust the space between the two icons
                                      Icon(
                                        Icons.face,
                                        color: Color(0xFFFFFFFF), // White color
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(
                                                    0xFFFFFFFF), // White color
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(
                                                    0xFFFFFFFF), // White color
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            hintText: 'Ey tower',
                                            hintStyle: TextStyle(
                                              color: Color(
                                                  0xFFFFFFFF), // White color
                                            ),
                                            prefixIcon: Icon(Icons.location_on),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              5), // Adjust the space between the two icons
                                      Icon(
                                        Icons.change_circle_outlined,
                                        color: Color(0xFFFFFFFF), // White color
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.9,
        minChildSize: 0.32,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: colorsFile.cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: MyRides(),
            ),
          );
        },
      ),
    );
  }

  void AddRides(BuildContext context) {
    setState(() {
      isContainerVisible = true;
    });
  }
}
