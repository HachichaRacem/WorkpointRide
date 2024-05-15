import 'package:flutter/material.dart';
import 'package:osmflutter/constant/colorsFile.dart';

class InputField extends StatelessWidget {
  String? hintText;
  IconData? icon;
  TextEditingController? textEditingController;
  ValueChanged<String>? onChanged;
  InputField({
    Key? key,
    this.hintText,
    this.textEditingController,
    this.icon = Icons.account_circle_outlined,
    this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: size.width * 0.8,
        child: TextFormField(
            style: TextStyle(color: Colors.black),
            onChanged: onChanged,
            cursorColor: colorsFile.loginButton,
            controller: textEditingController,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: colorsFile.kgrey),
              icon: Icon(icon, color: colorsFile.loginButton),
              hintText: hintText,
              focusedBorder: UnderlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: colorsFile.loginButton)),
              border: UnderlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: colorsFile.loginButton)),
            )));
  }
}
