import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/screen.dart';
import 'config/custom_loading_animation.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  configureGlobalLoader();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _username = '';

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Franko ',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: kBackgroundColor,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _username.isEmpty ? const SplashPage() : const webviewPage(),
      builder: EasyLoading.init(),
    );
  }
}

void configureGlobalLoader() {
  EasyLoading.instance
    ..animationStyle = EasyLoadingAnimationStyle.opacity
    ..displayDuration = const Duration(milliseconds: 5000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..indicatorColor = Colors.white
    ..progressColor = Colors.transparent
    ..backgroundColor = kBackgroundColor
    ..maskType = EasyLoadingMaskType.black
    ..textColor = kBackgroundColor
    ..textStyle = const TextStyle(fontSize: 14, color: kBackgroundColor)
    ..userInteractions = false
    ..customAnimation = CustomAnimation();
}
