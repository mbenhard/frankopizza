import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:franko/screens/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Image(
          image: AssetImage('assets/images/Franko1.png'),
        ),
      ),
    ));
  }
}
*/

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  String _username = '';
  @override
  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  @override
  void initState() {
    getUserName().then((value) {
      print('salam');
      _username = value;
      print(_username);
    });

    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              _username.isEmpty ? languagePage() : driverwebPage(),
        ),
      ),
    );
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
