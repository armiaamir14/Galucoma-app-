import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/home/home_page_controller.dart';
import 'package:glaucoma/pages/home/widgets/age_wheel.dart';
import 'package:glaucoma/pages/home/widgets/gender_button.dart';
import 'package:glaucoma/pages/home/widgets/new_patient_text_field.dart';
import 'package:glaucoma/pages/home/widgets/save_button.dart';

class PatientBottomSheet extends GetView<HomePageController> {
  static const double _borderRadius = 20;
  static const double _headerSize = 25;
  static const double _labelSize = 20;

  final int initialAge;

  PatientBottomSheet(this.initialAge);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      width: Get.width,
      height: 500,
      decoration: BoxDecoration(color: highlight1Color, borderRadius: BorderRadius.only(topLeft: Radius.circular(_borderRadius))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Add New Patient', textAlign: TextAlign.center, style: TextStyle(color: backgroundColor, fontSize: _headerSize, fontWeight: FontWeight.w700)),
          Text('Full Name', style: TextStyle(color: backgroundColor, fontSize: _labelSize, fontWeight: FontWeight.w700)),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [NewPatientTextField(controller: controller.firstNameController, hint: 'First'), Spacer(), NewPatientTextField(controller: controller.lastNameController, hint: 'Last')],
          ),
          Text('Age', style: TextStyle(color: backgroundColor, fontSize: _labelSize, fontWeight: FontWeight.w700)),
          AgeWheel(initialAge),
          Text('Gender', style: TextStyle(color: backgroundColor, fontSize: _labelSize, fontWeight: FontWeight.w700)),
          Row(
            children: [
              GenderButton(Gender.male),
              Spacer(),
              GenderButton(Gender.female),
            ],
          ),
          SaveButton(),
        ],
      ),
    );
  }
}
