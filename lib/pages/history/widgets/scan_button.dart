import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/pages/history/history_page_controller.dart';

class ScanButton extends GetView<HistoryPageController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.makeScan,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: backgroundColor),
        child: ObxValue<Rx<ScanningState>>(
          (Rx<ScanningState> rxState) {
            final ScanningState state = rxState.value;
            if (state == ScanningState.normal) {
              return Text('Scan', style: TextStyle(color: highlight1Color, fontSize: 25, fontWeight: FontWeight.bold));
            } else {
              return Theme(data: ThemeData(accentColor: highlight1Color), child: Center(child: CircularProgressIndicator()));
            }
          },
          controller.scanningState,
        ),
      ),
    );
  }
}
