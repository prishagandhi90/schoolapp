import 'package:emp_app/app/moduls/overtime/controller/overtime_controller.dart';
import 'package:get/get.dart';

class OvertimeFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OvertimeController>(
      () => OvertimeController(),
    );
  }
}
