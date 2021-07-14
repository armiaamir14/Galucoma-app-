import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/core/constants/routes.dart';
import 'package:glaucoma/models/patient.dart';
import 'package:glaucoma/pages/home/home_page_controller.dart';
import 'package:glaucoma/pages/home/widgets/patient_options_dialog/widgets/patient_option_button.dart';

class PatientOptionsDialog extends GetView<HomePageController> {
  final Patient patient;

  PatientOptionsDialog(this.patient);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent.withOpacity(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 200,
            width: 300,
            color: backgroundColor,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PatientOptionButton(color: accentColor, action: () => controller.editPatient(patient), label: 'Edit'),
                PatientOptionButton(color: highlight4Color, action: () => controller.deletePatient(patient), label: 'Delete'),
                PatientOptionButton(color: highlight2Color, action: () => Get.toNamed(AppRoutes.history, arguments: [patient]), label: 'History'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
