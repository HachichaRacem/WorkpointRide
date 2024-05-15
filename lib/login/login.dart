import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:osmflutter/Services/authentication.dart';
import 'package:osmflutter/Users/widgets/input_field.dart';
import 'package:osmflutter/Users/widgets/password_field.dart';
import 'package:osmflutter/constant/colorsFile.dart';
import 'package:osmflutter/login/choose_role.dart';
import 'package:osmflutter/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Icon eye;
  late String token;
  var animationStatus = 0;
  var indexpage = 0;
  bool _clicked = false;
  double _opacity = 1.0;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  late AnimationController _loginButtonController;

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;

    double timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.1,
                    ),
                    Center(
                      child: Container(
                        // color: colorsFile.background,
                        //margin: EdgeInsets.all(20),
                        width: size.width * 0.7,
                        height: height / 2.5,
                        child: Center(
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/WP_Logo.png"),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.1,
                    )
                  ],
                ),
                // SizedBox(height: size.height * 0.001),
                InputField(
                  hintText: "Your Email",
                  textEditingController: email,
                  onChanged: (value) {},
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PasswordField(
                      textEditingController: password,
                      onChanged: (value) {},
                      hint: "your password",
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextButton(
                            child: Text(
                              'Forgot password ?',
                              style: TextStyle(color: colorsFile.loginButton),
                            ),
                            onPressed: () {}),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.04),

                Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _clicked = !_clicked;
                          _opacity = _opacity == 1.0 ? 0.0 : 1.0;
                        });
                      },
                      child: Container(
                        child: AnimatedContainer(
                          width: _clicked ? 65 : 200,
                          height: 65,
                          curve: Curves.fastOutSlowIn,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(_clicked ? 65.1 : 30.0),
                            color: colorsFile.loginButton,
                          ),
                          duration: Duration(milliseconds: 700),
                          child: Center(
                            child: AnimatedOpacity(
                              duration: Duration(seconds: 1),
                              child: Text(
                                "Sign In",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              opacity: _opacity,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _clicked = !_clicked;
                          _opacity = _opacity == 1.0 ? 0.0 : 1.0;
                        });

                        if (email.text.trim() == "" &&
                            password.text.trim() == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'email and password are empty',
                            style: TextStyle(color: Colors.orange),
                          )));
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _clicked = !_clicked;
                              _opacity = _opacity == 1.0 ? 0.0 : 1.0;
                            });
                          });
                        } else if (email.text.trim() == "" &&
                            password.text.trim() != "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'password is empty',
                            style: TextStyle(color: Colors.orange),
                          )));
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _clicked = !_clicked;
                              _opacity = _opacity == 1.0 ? 0.0 : 1.0;
                            });
                          });
                        } else if (password.text.trim() == "" &&
                            email.text.trim() != "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'password is empty',
                            style: TextStyle(color: Colors.orange),
                          )));
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _clicked = !_clicked;
                              _opacity = _opacity == 1.0 ? 0.0 : 1.0;
                            });
                          });
                        } else {
                          Future<dynamic> loginUser =
                              authentication().login(email.text, password.text);
                          loginUser.then((value) async {
                            if (value.statusCode == 200) {
                              print("vvvvvvvvvvvvvvvvvv ${value}");
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              Map<String, dynamic> payload = JwtDecoder.decode(
                                value.data["accessToken"].toString(),
                              );

                              await prefs.setString(
                                  "user", payload["id"].toString());

                              prefs.setString(
                                "token",
                                value.data["accessToken"].toString(),
                              );
                              User().updateFromJSON(payload);

                              print("pppppppppppppppppppppppayload ${payload}");
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChooseRole()));
                              });
                            } else {
                              if (value.toString().contains("errors")) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  value["errors"].toString(),
                                  style: TextStyle(color: Colors.red),
                                )));
                                Future.delayed(Duration(seconds: 3), () {
                                  setState(() {
                                    _clicked = !_clicked;
                                    _opacity = _opacity == 1.0 ? 0.0 : 1.0;
                                  });
                                });
                              }
                            }
                          });
                        }
                      },
                      child: Column(
                        children: [
                          AnimatedContainer(
                            width: _clicked ? 65 : 200,
                            height: 65,
                            curve: Curves.fastOutSlowIn,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(_clicked ? 65.1 : 30.0),
                            ),
                            duration: Duration(milliseconds: 700),
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 700),
                              child: Padding(
                                child: CircularProgressIndicator(
                                    backgroundColor: colorsFile.titleCard,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        _clicked
                                            ? colorsFile.kgrey
                                            : Colors.white)),
                                padding: EdgeInsets.all(1),
                              ),
                              opacity: _opacity == 0.0 ? 1.0 : 0.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextButton(
                            child: Text(
                              'V 1.0.0',
                              style: TextStyle(color: colorsFile.titleCard),
                            ),
                            onPressed: () async {}),
                      ),
                    ),
                  ],
                ),

                /*          SharedPreferences preferences = await SharedPreferences.getInstance();
            await preferences.clear();
        final _storage = const FlutterSecureStorage();
        await _storage.deleteAll();*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
