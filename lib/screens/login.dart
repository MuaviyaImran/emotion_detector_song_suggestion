import 'package:emosift/colors_scheme.dart';
import 'package:emosift/screens/emotion_detector.dart';
import 'package:emosift/screens/home_screen.dart';
import 'package:emosift/widgets/app_bar.dart';
import 'package:emosift/widgets/custom_button.dart';
import 'package:emosift/widgets/custom_field.dart';
import 'package:flutter/material.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColorScheme.whiteColor,
      appBar: const MyAppBar(
        title: 'Login',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Image(image: AssetImage("assets/images/logo.jpg")),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
              ),
              child: MyCustomTextField(
                title: "Email",
                icon: Icons.email,
                hintText: "Enter your mail",
                leadingIconColor: AppColorScheme.secondaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06, vertical: 12),
              child: MyCustomTextField(
                title: "Password",
                isPassword: true,
                icon: Icons.lock,
                hintText: "**********",
                leadingIconColor: AppColorScheme.secondaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: MyCustomButton(
                isWhite: false,
                name: "Login",
                textColor: AppColorScheme.whiteColor,
                bgColor: Colors.blue.shade900,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmotionDetector()),
                  );
                },
                isSocial: false,
                borderColor: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
