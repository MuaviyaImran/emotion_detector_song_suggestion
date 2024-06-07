import 'dart:io';

import 'package:emosift/colors_scheme.dart';
import 'package:emosift/screens/auth_main.dart';
import 'package:emosift/screens/edit_profile.dart';
import 'package:emosift/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
        Container(
          height: height * 0.3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: InkWell(
              onTap: _pickImage,
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
                    CircleAvatar(
                      radius: 36.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                    ),
                    if (_image == null)
                      Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 40.0,
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
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: AppColorScheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Text(
          "Amna Hassan",
          style: AppColorScheme.heading3(
              fontWeight: FontWeight.normal, color: Colors.black),
        ),
        Text(
          "amna.00427332@gmail.com",
          style: AppColorScheme.bodyText(
              fontWeight: FontWeight.normal, color: Colors.grey),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => EditProfile()));
          },
          child: Container(
            height: height * 0.06,
            width: width * 0.7,
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                SizedBox(width: 20),
                Text(
                  "Edit Profile",
                  style: AppColorScheme.bodyText(color: AppColorScheme.white),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: height * 0.03,
        ),
        customTile(
          title: 'My Services',
          icon: Icons.message,
          iconBg: Colors.yellow.withOpacity(0.1),
          iconColor: Colors.yellow,
        ),
        customTile(
          title: 'Help and Support',
          icon: Icons.calendar_month,
          iconBg: Colors.orange.withOpacity(0.1),
          iconColor: Colors.orange,
        ),
        customTile(
          title: 'Privacy Policy',
          icon: Icons.privacy_tip,
          iconBg: Colors.pink.withOpacity(0.1),
          iconColor: Colors.pink,
        ),
        customTile(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (ctx) => AuthMain()));
          },
          title: 'Logout',
          icon: Icons.person,
          iconBg: Color(0xff474CBD).withOpacity(0.1),
          iconColor: Color(0xff474CBD),
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
