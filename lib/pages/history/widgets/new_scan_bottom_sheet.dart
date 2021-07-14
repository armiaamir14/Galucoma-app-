import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/history/history_page_controller.dart';
import 'package:glaucoma/pages/history/widgets/eye_button.dart';
import 'package:glaucoma/pages/history/widgets/scan_button.dart';

class ScanBottomSheet extends GetView<HistoryPageController> {
  static const double _borderRadius = 20;
  static const double _headerSize = 25;
  static const double _labelSize = 20;

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
          Text('Make New Scan', textAlign: TextAlign.center, style: TextStyle(color: backgroundColor, fontSize: _headerSize, fontWeight: FontWeight.w700)),
          Text('Eye', style: TextStyle(color: backgroundColor, fontSize: _labelSize, fontWeight: FontWeight.w700)),
          Row(children: [EyeButton(Eye.left), Spacer(), EyeButton(Eye.right)]),
          Container(
            height: 50,
            width: (Get.width - 30),
            child: TextField(
              controller: controller.notesController,
              cursorColor: backgroundColor,
              style: TextStyle(color: backgroundColor, fontSize: 20),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: backgroundColor.withOpacity(0.5), fontSize: 20),
                hintText: 'Any notes?',
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: backgroundColor.withOpacity(0.5), width: 3)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: backgroundColor, width: 3)),
              ),
            ),
          ),
          Text('Image', style: TextStyle(color: backgroundColor, fontSize: _labelSize, fontWeight: FontWeight.w700)),
          GestureDetector(
            onTap: controller.pickImage,
            child: Container(
              height: 150,
              width: Get.width - 30,
              child: ObxValue<Rx<File>>(
                (Rx<File> rxImageFile) {
                  if (rxImageFile == null || rxImageFile.value == null) {
                    return Image.asset('assets/placeholder.png');
                  } else {
                    return Image.file(rxImageFile.value);
                  }
                },
                controller.imageFile,
              ),
            ),
          ),
          ScanButton(),
        ],
      ),
    );
  }
}
