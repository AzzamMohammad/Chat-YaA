import 'package:get/get.dart';

import '../modules/login/login_controller.dart';

class LoginBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }

}