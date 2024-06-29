// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emosift/colors_scheme.dart';
import 'package:emosift/screens/emotion_detector.dart';
import 'package:emosift/screens/home_screen.dart';
import 'package:emosift/widgets/app_bar.dart';
import 'package:emosift/widgets/custom_button.dart';
import 'package:emosift/widgets/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  DateTime? _selectedDate;
  XFile? _pickedImage;
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    String error = '';

    void _signup() async {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      DateTime? dob = _selectedDate;
      XFile? image = _pickedImage;
      if (name.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          dob == null ||
          image == null) {
        setState(() {
          error = "All fields are required";
        });
        return;
      }
      try {
        setState(() {
          isLoading = true;
        });
        // Create user with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String uid = userCredential.user!.uid;

        // Upload image to Firebase Storage
        String imageUrl = '';
        if (image != null) {
          File imageFile = File(image.path);
          UploadTask uploadTask = FirebaseStorage.instance
              .ref('profile_images/$uid.jpg')
              .putFile(imageFile);
          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
        }

        // Save user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': name,
          'email': email,
          'dob': dob?.toIso8601String(),
          'profileImageUrl': imageUrl,
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uid);
        await prefs.setString('name', name);
        await prefs.setString('email', email);
        await prefs.setString('dob', dob?.toIso8601String() ?? '');
        await prefs.setString('profileImageUrl', imageUrl);

        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => EmotionDetector()),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
          error = e.toString();
        });
        print("Signup failed: $e");
        // Handle error
      }
    }

    void dispose() {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      super.dispose();
    }

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
                controller: _nameController,
                hintText: 'Enter your name',
                leadingIconColor: Colors.blue,
              ),
              SizedBox(height: 16.0),
              MyCustomTextField(
                title: 'Email',
                icon: Icons.email,
                controller: _emailController,
                hintText: 'Enter your email',
                leadingIconColor: Colors.green,
              ),
              SizedBox(height: 16.0),
              MyCustomTextField(
                title: 'Password',
                icon: Icons.lock,
                controller: _passwordController,
                hintText: 'Enter your password',
                isPassword: true,
                leadingIconColor: Colors.red,
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: _selectedDate != null
                          ? _selectedDate!.toLocal().toString().split(' ')[0]
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
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              _pickedImage != null
                  ? Image.file(
                      File(_pickedImage!.path),
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
                          Icon(Icons.image, size: 50, color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: Text(
                                  "Upload a file",
                                  style: AppColorScheme.heading4(
                                      fontSize: 18,
                                      color: Colors.blue.shade900),
                                ),
                              ),
                              SizedBox(width: 10),
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
              if (error != '')
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                  ),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              SizedBox(height: 16.0),
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
              MyCustomButton(
                  name: "Signup",
                  bgColor: Colors.blue.shade800,
                  textColor: AppColorScheme.white,
                  borderColor: AppColorScheme.secondaryColor,
                  onPressed: () {
                    _signup();
                  },
                  isWhite: true)
            ],
          ),
        ),
      ),
    );
  }
}
