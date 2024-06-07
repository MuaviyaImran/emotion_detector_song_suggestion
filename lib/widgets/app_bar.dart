import 'package:emosift/colors_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return AppBar(
      elevation: 0,
      backgroundColor: AppColorScheme.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Icon(
                CupertinoIcons.left_chevron,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      title: Text(title, style: AppColorScheme.heading2(color: Colors.black)),
      centerTitle: true,
      actions: const <Widget>[
        // You can add additional actions here if needed
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
