import 'package:get/get.dart';

import '../modules/home/home_controller.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }

}