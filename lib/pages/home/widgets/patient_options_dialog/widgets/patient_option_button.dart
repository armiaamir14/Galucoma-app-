import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';

class PatientOptionButton extends StatelessWidget {
  final Color color;
  final Function action;
  final String label;

  PatientOptionButton({@required this.color, @required this.action, @required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
        action();
      },
      child: Container(
        width: 300,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(label, style: TextStyle(color: backgroundColor, fontSize: 20, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
