import 'package:flutter/material.dart';
import 'package:glaucoma/core/constants/colors.dart';

class AuthenticationTextFieldLabel extends StatelessWidget {
  final String text;

  AuthenticationTextFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: textColor,
      ),
    );
  }
}
