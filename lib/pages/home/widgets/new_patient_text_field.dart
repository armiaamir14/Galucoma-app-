import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';

class NewPatientTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  NewPatientTextField({@required this.controller, @required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: (Get.width - 30) / 2,
      child: TextField(
        controller: controller,
        cursorColor: backgroundColor,
        style: TextStyle(color: backgroundColor, fontSize: 20),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: backgroundColor.withOpacity(0.5), fontSize: 20),
          hintText: hint,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: backgroundColor.withOpacity(0.5), width: 3)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: backgroundColor, width: 3)),
        ),
      ),
    );
  }
}
