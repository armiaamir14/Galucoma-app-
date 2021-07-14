import 'package:get/get.dart';
import 'package:glaucoma/pages/home/home_page_controller.dart';

class HomePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<HomePageController>(HomePageController());
  }
}
