import 'dart:async';

import 'package:flutter/material.dart';

import 'driver_page.dart';
import 'language_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DriverWebPage()),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Image(
          image: AssetImage('assets/images/Franko1.png'),
        ),
      ),
    ));
  }
}
