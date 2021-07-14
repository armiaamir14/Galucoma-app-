import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/home/home_page_controller.dart';

class NewPatientFloatingButton extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<HomePageState>>(
      (Rx<HomePageState> rxState) {
        final HomePageState state = rxState.value;
        if (state == HomePageState.loaded) {
          return ObxValue<RxBool>(
            (RxBool rxIsOpened) {
              final bool isOpened = rxIsOpened.value;
              return FloatingActionButton(
                child: Icon(isOpened ? Icons.close : Icons.add, color: backgroundColor),
                backgroundColor: highlight1Color,
                onPressed: controller.openBottomSheet,
              );
            },
            controller.isBottomSheetOpen,
          );
        } else {
          return SizedBox();
        }
      },
      controller.state,
    );
  }
}
