import 'package:emp_app/app/moduls/admitted%20patient/controller/labreport_controller.dart';
import 'package:get/get.dart';

class LabReportsViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabReportsController>(
      () => LabReportsController(),
    );
  }
}
