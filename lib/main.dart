import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_notify/wp_notify.dart';

import './screens/screen.dart';
import 'config/custom_loading_animation.dart';
import 'config/notification.dart';
import 'constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WPNotifyAPI.instance.initWith(baseUrl: "https://www.franko-pizza.sk");
  notification();
  configureGlobalLoader();
  String username;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username') ?? '';
  runApp(MyApp(
    username: username,
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.username});
  String username;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      //navigating splash page
      home: const SplashPage(),
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
