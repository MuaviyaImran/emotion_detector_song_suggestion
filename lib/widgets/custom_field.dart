import 'package:emosift/colors_scheme.dart';
import 'package:flutter/material.dart';

class MyCustomTextField extends StatefulWidget {
  final String title;
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final Color leadingIconColor;

  MyCustomTextField({
    Key? key,
    required this.title,
    required this.icon,
    required this.hintText,
    this.isPassword = false,
    required this.leadingIconColor,
  }) : super(key: key);

  @override
  _MyCustomTextFieldState createState() => _MyCustomTextFieldState();
}

class _MyCustomTextFieldState extends State<MyCustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.blue.shade900),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          style: TextStyle(color: Colors.black),
          obscureText: widget.isPassword ? _obscureText : false,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: Colors.blue.shade900,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.blue.shade900),
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: _isFocused ? Colors.blue.shade900 : Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Colors.blue.shade900,
                width: 2.0,
              ),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _isFocused = value.isNotEmpty;
            });
          },
          onTap: () {
            setState(() {
              _isFocused = true;
            });
          },
          onFieldSubmitted: (value) {
            setState(() {
              _isFocused = false;
            });
          },
          onEditingComplete: () {
            setState(() {
              _isFocused = false;
            });
          },
          // Add more callbacks if needed
        ),
      ],
    );
  }
}
