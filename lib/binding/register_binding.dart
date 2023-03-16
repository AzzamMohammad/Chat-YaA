import 'package:get/get.dart';

import '../modules/register/register_controller.dart';

class RegisterBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }

}