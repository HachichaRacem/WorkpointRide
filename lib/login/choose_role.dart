import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:osmflutter/constant/colorsFile.dart';

import '../Drivers/bottom_nav.dart' as driver;
import '../Users/bottom_nav.dart' as passenger;

class ChooseRole extends StatefulWidget {
  const ChooseRole({Key? key}) : super(key: key);

  @override
  _ChooseRoleState createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  late double _height;
  late double _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                            height: _height * 0.36,
                            //  color: Colors.red,
                            child:
                                Lottie.asset('assets/lottieFiles/driver.json')),
                      ),
                      Positioned.fill(
                        bottom: -150,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your button press logic here
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        driver.BottomNav(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ));
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  colorsFile
                                      .buttonRole), // Change the color here
                            ),
                            child: Text(
                              'Browse app as a driver',
                              style: TextStyle(color: colorsFile.icons),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                            height: _height * 0.36,
                            //  color: Colors.red,
                            child: Lottie.asset(
                                'assets/lottieFiles/passenger.json')),
                      ),
                      Positioned.fill(
                        bottom: -150,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your button press logic here
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        passenger.BottomNav(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ));
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  colorsFile
                                      .buttonRole), // Change the color here
                            ),
                            child: Text(
                              'Browse app as a passenger',
                              style: TextStyle(color: colorsFile.icons),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
