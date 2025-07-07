import 'package:emp_app/app/moduls/PAYROLL_MAIN/attendence/controller/attendence_controller.dart';
import 'package:get/get.dart';

class AttendanceScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendenceController>(
      () => AttendenceController(),
    );
  }
}
