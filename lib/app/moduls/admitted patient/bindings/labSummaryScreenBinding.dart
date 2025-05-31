import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:get/get.dart';

class LabSummaryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdPatientController>(
      () => AdPatientController(),
    );
  }
}
