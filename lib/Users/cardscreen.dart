import 'package:flutter/material.dart';


class CardScreen extends StatelessWidget {
  const CardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
            ),
          ),
        ),
        Column(children: [
          const SizedBox(
            height: 20,
          ),
          // SignInButton(
          //   onTap: () {},
          //   iconPath: 'assets/logos/email.png',
          //   textLabel: 'Sign in with email',
          //   backgroundColor: Colors.white,
          //   elevation: 5.0,
          // ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'OR',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          // SignInButton(
          //   onTap: () {},
          //   iconPath: 'assets/logos/google.png',
          //   textLabel: 'Sign in with Google',
          //   backgroundColor: Colors.grey.shade300,
          //   elevation: 0.0,
          // ),
          const SizedBox(
            height: 14,
          ),
          // SignInButton(
          //   onTap: () {},
          //   iconPath: 'assets/logos/facebook.png',
          //   textLabel: 'Sign in with Facebook',
          //   backgroundColor: Colors.blue.shade300,
          //   elevation: 0.0,
          // ),
        ])
      ],
    );
  }
}
