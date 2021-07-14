import 'package:get/get.dart';
import 'package:glaucoma/pages/auth/auth_page_controller.dart';

class AuthPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthPageController>(AuthPageController());
  }
}
