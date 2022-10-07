import 'package:flutter/material.dart';
import 'package:programming_hero/app_config.dart';

import 'main_menu_screen.dart';

/*
  this is a splash screen to show the app icon to user
   */

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // after a period of time the splash screen will go off and main menu screen will show
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const MainMenuScreen();
      }), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
          child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        // is this the icon of the app
        child: Image.asset(appIcon),
      )),
    );
  }
}
