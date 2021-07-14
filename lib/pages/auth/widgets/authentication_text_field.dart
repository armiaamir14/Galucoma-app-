import 'package:flutter/material.dart';
import 'package:glaucoma/core/constants/colors.dart';

class AuthenticationTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;

  AuthenticationTextField({
    @required this.controller,
    @required this.hint,
    @required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      cursorColor: highlight1Color,
      decoration: InputDecoration(
        focusColor: highlight1Color,
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: highlight1Color, width: 3)),
        border: UnderlineInputBorder(borderSide: BorderSide(color: textColor.withOpacity(0.7), width: 3)),
        hintText: hint,
        suffixIcon: Icon(icon, color: highlight1Color),
      ),
    );
  }
}
