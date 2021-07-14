import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/home/home_page_controller.dart';

class AgeWheel extends GetView<HomePageController> {
  final int initialAge;

  AgeWheel(this.initialAge);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - 20,
      height: 50,
      child: RotatedBox(
        quarterTurns: 1,
        child: ListWheelScrollView(
          itemExtent: 40,
          onSelectedItemChanged: (int index) => controller.selectedAge.value = index,
          diameterRatio: 1.5,
          children: List<Widget>.generate(
            121,
            (int index) {
              return ObxValue<RxInt>(
                (RxInt rxSelectedAge) {
                  final bool isSelected = rxSelectedAge.value == index;
                  return RotatedBox(
                    quarterTurns: -1,
                    child: Text(
                      index.toString(),
                      style: TextStyle(color: isSelected ? backgroundColor : backgroundColor.withOpacity(0.5), fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  );
                },
                controller.selectedAge,
              );
            },
          ),
        ),
      ),
    );
  }
}
