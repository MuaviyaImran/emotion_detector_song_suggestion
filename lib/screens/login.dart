import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emosift/colors_scheme.dart';
import 'package:emosift/screens/emotion_detector.dart';
import 'package:emosift/widgets/app_bar.dart';
import 'package:emosift/widgets/custom_button.dart';
import 'package:emosift/widgets/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  _LoginPageViewState createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = '';
  bool isLoading = false;
  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Handle case where email or password is empty
      print("Email and password must not be empty");
      setState(() {
        error = "Email and password must not be empty";
      });
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uid);
        await prefs.setString('name', userData['name']);
        await prefs.setString('email', userData['email']);
        await prefs.setString('dob', userData['dob'] ?? '');
        await prefs.setString('profileImageUrl', userData['profileImageUrl']);

        if (uid != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => EmotionDetector()),
          );
        }
      } else {
        error = "User data not found in Firestore";
        setState(() {
          print("User data not found in Firestore");
          isLoading = false;
        });
      }
    } catch (e) {
      error = e.toString();
      setState(() {
        isLoading = false;
        print("Login failed: $e");
      });
      // Handle error
    }
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                controller: _emailController,
                hintText: "Enter your mail",
                leadingIconColor: AppColorScheme.secondaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: 12,
              ),
              child: MyCustomTextField(
                title: "Password",
                isPassword: true,
                controller: _passwordController,
                icon: Icons.lock,
                hintText: "**********",
                leadingIconColor: AppColorScheme.secondaryColor,
              ),
            ),
            if (error != '')
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                ),
                child: Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            if (isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  ),
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
                  _login();
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
