import 'package:emp_app/app/moduls/leave/controller/leave_controller.dart';
import 'package:get/get.dart';

class LeaveMainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveController>(
      () => LeaveController(),
    );
  }
}
