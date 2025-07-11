import 'package:schoolapp/app/modules/PAYROLL_MAIN/overtime/controller/overtime_controller.dart';
import 'package:get/get.dart';

class OvertimeFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OvertimeController>(
      () => OvertimeController(),
    );
  }
}
