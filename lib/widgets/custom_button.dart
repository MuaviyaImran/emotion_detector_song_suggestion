import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  final String name;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;
  final bool isSocial;
  final bool isWhite;
  final String? leadingImagePath;

  const MyCustomButton({
    Key? key,
    required this.name,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
    required this.onPressed,
    this.isSocial = false,
    this.leadingImagePath,
    required this.isWhite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: borderColor,
              width: 2.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: isSocial
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            if (isSocial)
              Image(
                image: AssetImage(leadingImagePath!),
                width: 24.0,
                height: 24.0,
              ),
            if (isSocial) const SizedBox(width: 8.0),
            Text(
              name,
              style: TextStyle(
                fontSize: 18.0,
                color: isWhite ? Colors.white : textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: isSocial ? 24.0 : 0),
          ],
        ),
      ),
    );
  }
}
