import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:osmflutter/login/choose_role.dart';
import 'package:osmflutter/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 5);
    Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("token")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChooseRole()),
      );
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0), // here the desired height
        child: Text(''),
      ),
      backgroundColor: Colors.white,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  flex: 20,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //  mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: height / 10,
                      ),
                      Lottie.asset(
                        'assets/logosplash.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                      ),
                      Spacer(),
                      Text(
                        "WORKPOINT RIDE",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,

                          //customize size here
                          // AND others usual text style properties (fontFamily, fontWeight, ...)
                        ),
                      ),
                      SizedBox(
                        height: height / 50,
                      )
                    ],
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
