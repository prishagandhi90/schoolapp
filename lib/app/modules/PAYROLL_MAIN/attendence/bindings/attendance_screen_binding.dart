import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/controller/attendence_controller.dart';
import 'package:get/get.dart';

class AttendanceScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendenceController>(
      () => AttendenceController(),
    );
  }
}
