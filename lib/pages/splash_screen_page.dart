import 'dart:async';

import 'package:ezbill/pages/login_page/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: Center(
          child: SizedBox(
              child: Image.asset(
            'assets/4005024.jpg',
            fit: BoxFit.fitHeight,
          )),
        ),
      ),
    );
  }
}
