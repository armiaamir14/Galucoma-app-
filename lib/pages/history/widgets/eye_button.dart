import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/history/history_page_controller.dart';

class EyeButton extends GetView<HistoryPageController> {
  final Eye eye;

  EyeButton(this.eye);

  @override
  Widget build(BuildContext context) {
    final String title = eye == Eye.left ? 'Left' : 'Right';
    return GestureDetector(
      onTap: () => controller.selectedEye.value = eye,
      child: ObxValue<Rx<Eye>>(
        (Rx<Eye> rxGender) {
          final bool isSelected = eye == rxGender.value;
          return Container(
            alignment: Alignment.center,
            width: (Get.width - 30) / 2,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(width: 3, color: isSelected ? backgroundColor : highlight1Color)),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: backgroundColor)),
          );
        },
        controller.selectedEye,
      ),
    );
  }
}
