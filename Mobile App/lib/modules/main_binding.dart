import 'package:fungi_app/modules/main_controller.dart';
import 'package:get/get.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put(MainController());
  }
}
