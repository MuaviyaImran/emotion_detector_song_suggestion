import 'dart:io';

import 'package:emosift/colors_scheme.dart';
import 'package:emosift/screens/home_screen.dart';
import 'package:emosift/widgets/app_bar.dart';
import 'package:emosift/widgets/custom_button.dart';
import 'package:emosift/widgets/custom_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _emailController = TextEditingController();
  //final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
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
        Center(
          child: InkWell(
            onTap: _pickImage,
            child: Container(
              width: width * 0.25,
              height: height * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.shade900,
                  width: 4.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 46.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(
                            Icons.person,
                            size: 60.0,
                            color: Colors.grey[600],
                          )
                        : CircleAvatar(),
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
                title: 'Phone',
                icon: Icons.phone,
                hintText: 'Enter your phone number',
                isPassword: true,
                leadingIconColor: Colors.red,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: MyCustomButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
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
