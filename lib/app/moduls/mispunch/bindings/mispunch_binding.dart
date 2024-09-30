import 'package:emp_app/app/moduls/mispunch/controller/mispunch_controller.dart';
import 'package:get/get.dart';

class MispunchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MispunchController>(
      () => MispunchController(),
    );
  }
}
