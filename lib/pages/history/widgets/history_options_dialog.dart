import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glaucoma/core/constants/colors.dart';
import 'package:glaucoma/models/scan_history.dart';
import 'package:glaucoma/pages/history/history_page_controller.dart';

class HistoryOptionsMenu extends GetView<HistoryPageController> {
  final ScanHistory scanHistory;

  HistoryOptionsMenu(this.scanHistory);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent.withOpacity(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 70,
            width: 300,
            color: backgroundColor,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => controller.deleteHistory(scanHistory),
                  child: Container(
                    width: 300,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: highlight4Color, borderRadius: BorderRadius.circular(10)),
                    child: Text('Delete', style: TextStyle(color: backgroundColor, fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
