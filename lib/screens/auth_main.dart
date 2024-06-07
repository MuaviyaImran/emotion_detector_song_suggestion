// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:emosift/colors_scheme.dart';
import 'package:emosift/my_images.dart';
import 'package:emosift/screens/login.dart';
import 'package:emosift/screens/signup.dart';
import 'package:emosift/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AuthMain extends StatefulWidget {
  @override
  _AuthMainState createState() => _AuthMainState();
}

class _AuthMainState extends State<AuthMain> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColorScheme.white,
              AppColorScheme.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const SizedBox(height: 20.0),
              Image.asset(
                MyImages.logo,
                height: height * 0.4,
                width: width,
                fit: BoxFit.contain,
              ),
              Container(
                height: height * 0.3,
                width: width - 30,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Authentication",
                        style: AppColorScheme.heading2(color: Colors.black),
                      ),
                      MyCustomButton(
                          isWhite: false,
                          name: "Signup",
                          bgColor: Colors.blue.shade800,
                          textColor: Colors.white,
                          borderColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => SignupScreen()));
                          }),
                      MyCustomButton(
                          isWhite: true,
                          name: "Login",
                          bgColor: Colors.transparent,
                          textColor: Colors.black,
                          borderColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => LoginPageView()));
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
