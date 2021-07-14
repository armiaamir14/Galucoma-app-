import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/home/home_page_controller.dart';

class SaveButton extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.savePatient,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: backgroundColor),
        child: ObxValue<Rx<SavingPatientState>>(
          (Rx<SavingPatientState> rxState) {
            final SavingPatientState state = rxState.value;
            if (state == SavingPatientState.normal) {
              return Text('Save', style: TextStyle(color: highlight1Color, fontSize: 25, fontWeight: FontWeight.bold));
            } else {
              return Theme(data: ThemeData(accentColor: highlight1Color), child: Center(child: CircularProgressIndicator()));
            }
          },
          controller.savingState,
        ),
      ),
    );
  }
}
