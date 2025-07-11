import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/controller/leave_controller.dart';
import 'package:get/get.dart';

class LeaveViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveController>(
      () => LeaveController(),
    );
  }
}
