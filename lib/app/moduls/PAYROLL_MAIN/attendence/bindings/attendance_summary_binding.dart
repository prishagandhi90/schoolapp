import 'package:schoolapp/app/moduls/PAYROLL_MAIN/attendence/controller/attendence_controller.dart';
import 'package:get/get.dart';

class AttendanceSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendenceController>(
      () => AttendenceController(),
    );
  }
}
