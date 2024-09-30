import 'package:emp_app/app/moduls/payroll/controller/payroll_controller.dart';
import 'package:get/get.dart';

class PayrollBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayrollController>(
      () => PayrollController(),
    );
  }
}
