// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:emosift/colors_scheme.dart';
import 'package:emosift/screens/emotion_detector.dart';
import 'package:emosift/screens/home_screen.dart';
import 'package:emosift/widgets/app_bar.dart';
import 'package:emosift/widgets/custom_button.dart';
import 'package:emosift/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  DateTime? _selectedDate;
  bool _agreeToTerms = false;
  bool _receiveUpdates = false;
  XFile? _pickedImage;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(title: "Signup"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyCustomTextField(
                title: 'Name',
                icon: Icons.person,
                hintText: 'Enter your name',
                leadingIconColor: Colors.blue,
              ),
              SizedBox(height: 16.0),
              MyCustomTextField(
                title: 'Email',
                icon: Icons.email,
                hintText: 'Enter your email',
                leadingIconColor: Colors.green,
              ),
              SizedBox(height: 16.0),
              MyCustomTextField(
                title: 'Password',
                icon: Icons.lock,
                hintText: 'Enter your password',
                isPassword: true,
                leadingIconColor: Colors.red,
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixText: _selectedDate != null
                        ? _selectedDate.toString().split(' ')[0]
                        : 'Select your date of birth',
                    hintStyle:
                        const TextStyle(color: AppColorScheme.blackColor),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: AppColorScheme.secondaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  // Add more callbacks if needed
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              _pickedImage != null
                  ? Image.file(
                      File(
                        _pickedImage!.path,
                      ),
                      height: height * 0.3,
                      width: width,
                    )
                  : SizedBox.shrink(),
              _pickedImage == null
                  ? Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      height: height * 0.15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _pickImage();
                                },
                                child: Text(
                                  "Upload a file",
                                  style: AppColorScheme.heading4(
                                      fontSize: 18,
                                      color: Colors.blue.shade900),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "through Gallery",
                                style: AppColorScheme.heading4(
                                    fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                          Text(
                            "PNG, JPG, GIF up to 10MB",
                            style: AppColorScheme.heading4(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              MyCustomButton(
                  name: "Signup",
                  bgColor: Colors.blue.shade800,
                  textColor: AppColorScheme.white,
                  borderColor: AppColorScheme.secondaryColor,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => EmotionDetector()));
                  },
                  isWhite: true)
            ],
          ),
        ),
      ),
    );
  }
}
