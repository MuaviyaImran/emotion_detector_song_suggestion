// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:emosift/screens/auth_main.dart';
import 'package:emosift/screens/emotion_detector.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  renderTo() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('uid') != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmotionDetector()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthMain()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      renderTo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/images/logo.jpg"))),
      ),
    );
  }
}
