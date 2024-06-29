import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emosift/colors_scheme.dart';
import 'package:emosift/models/user.dart';
import 'package:emosift/screens/home_screen.dart';
import 'package:emosift/widgets/app_bar.dart';
import 'package:emosift/widgets/custom_button.dart';
import 'package:emosift/widgets/custom_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _emailController = TextEditingController();
  //final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lNameController = TextEditingController();
  File? _image;
  bool isLoading = false;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  UserData userData;
  _EditProfileState()
      : userData = UserData(
          uid: '',
          name: '',
          email: '',
          dob: '',
          profileImageUrl: '',
        );

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = UserData.fromSharedPreferences(prefs);
      _emailController.text = userData.email;
      _nameController.text = userData.name;
    });
  }

  Future<void> updateProfile() async {
    try {
      setState(() {
        isLoading = true;
      });
      String uid = userData.uid;

      if (_image != null) {
        userData.profileImageUrl = await uploadImageToFirebaseStorage(uid);
      }
      // Update profile without changing image
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'profileImageUrl': userData.profileImageUrl,
      });

      // Update SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('profileImageUrl', userData.profileImageUrl);
      fetchData();

      // Navigate back to home screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error updating profile: $e');
      // Handle error
    }
  }

  Future<String> uploadImageToFirebaseStorage(String uid) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('profile_images').child('$uid.jpg');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(
        title: "Profile",
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Center(
          child: Center(
            child: Container(
              width: width * 0.25,
              height: height * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColorScheme.primaryColor,
                  width: 4.0,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 52,
                    right: 3,
                    child: userData.profileImageUrl != '' && _image == null
                        ? CircleAvatar(
                            radius: 42.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(userData.profileImageUrl),
                          )
                        : _image != null
                            ? CircleAvatar(
                                radius: 42.0,
                                backgroundColor: Colors.transparent,
                                backgroundImage: FileImage(_image!),
                              )
                            : Icon(
                                Icons.person,
                                size: 60.0,
                                color: Colors.grey[600],
                              ),
                  ),
                  Positioned(
                    bottom: 40,
                    right: -10,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: AppColorScheme.primaryColor,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: MyCustomButton(
            onPressed: _pickImage,
            name: 'Pick Image',
            bgColor: Colors.blue.shade900,
            textColor: Colors.white,
            borderColor: Colors.white,
            isWhite: true,
          ),
        ),
        SizedBox(
          height: height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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
                isDisabled: true,
                icon: Icons.email,
                controller: _emailController,
                hintText: 'Enter your email',
                leadingIconColor: Colors.green,
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
        SizedBox(
          height: 100,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: MyCustomButton(
            onPressed: () {
              updateProfile();
            },
            name: 'Update',
            bgColor: Colors.blue.shade900,
            textColor: Colors.white,
            borderColor: Colors.white,
            isWhite: true,
          ),
        ),
      ]),
    );
  }
}

class customTile extends StatelessWidget {
  final String title;
  final Color iconColor;
  final Color iconBg;
  final IconData icon;
  final VoidCallback? onPressed;
  const customTile({
    super.key,
    required this.title,
    required this.iconColor,
    required this.iconBg,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onPressed,
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          title: Text(
            title,
            style: AppColorScheme.bodyText(),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 0.5,
          ),
        )
      ],
    );
  }
}
