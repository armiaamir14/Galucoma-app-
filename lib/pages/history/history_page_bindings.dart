import 'package:get/get.dart';

import 'history_page_controller.dart';

class HistoryPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<HistoryPageController>(HistoryPageController());
  }
}
