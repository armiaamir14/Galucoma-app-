import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/home/home_page_controller.dart';

class GenderButton extends GetView<HomePageController> {
  final Gender gender;

  GenderButton(this.gender);

  @override
  Widget build(BuildContext context) {
    final String title = gender == Gender.male ? 'Male' : 'Female';
    return GestureDetector(
      onTap: () => controller.gender.value = gender,
      child: ObxValue<Rx<Gender>>(
        (Rx<Gender> rxGender) {
          final bool isSelected = gender == rxGender.value;
          return Container(
            alignment: Alignment.center,
            width: (Get.width - 30) / 2,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(width: 3, color: isSelected ? backgroundColor : highlight1Color)),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: backgroundColor)),
          );
        },
        controller.gender,
      ),
    );
  }
}
