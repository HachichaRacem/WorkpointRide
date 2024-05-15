import 'package:flutter/material.dart';
import 'package:osmflutter/constant/colorsFile.dart';

class PasswordField extends StatefulWidget {
  TextEditingController? textEditingController;
  ValueChanged<String>? onChanged;
  bool? icon;
  String? hint;

  PasswordField(
      {Key? key,
      this.onChanged,
      this.icon,
      this.textEditingController,
      this.hint})
      : super(key: key);

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  late bool visible;
  @override
  void initState() {
    // TODO: implement initState
    visible = false;
  }

  @override
  Widget build(BuildContext context) {
    IconData eyeN = Icons.visibility_off_outlined;
    IconData eye = Icons.visibility_rounded;
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: TextField(
        style: TextStyle(color: Colors.black),
        controller: widget.textEditingController,
        obscureText: !visible,
        onChanged: widget.onChanged,
        cursorColor: colorsFile.kDarkBlue,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: colorsFile.kgrey),
          focusColor: colorsFile.loginButton,
          hoverColor: Colors.white,
          fillColor: colorsFile.loginButton,
          hintText: widget.hint,
          icon: Icon(
            Icons.lock_outline_rounded,
            color: colorsFile.loginButton,
          ),
          suffixIcon: visible == false
              ? IconButton(
                  icon: Icon(
                    eyeN,
                    color: colorsFile.loginButton,
                  ),
                  onPressed: () {
                    visible = true;
                    setState(() {
                      visible = true;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    eye,
                    color: colorsFile.loginButton,
                  ),
                  onPressed: () {
                    setState(() {
                      visible = false;
                    });
                  },
                ),
          focusedBorder: UnderlineInputBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: colorsFile.loginButton)),
          border: UnderlineInputBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: colorsFile.loginButton)),
        ),
      ),
    );
  }
}
