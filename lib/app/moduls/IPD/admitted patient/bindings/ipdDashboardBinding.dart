import 'package:schoolapp/app/moduls/IPD/admitted%20patient/controller/adpatient_controller.dart';
import 'package:get/get.dart';

class IPDDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdPatientController>(
      () => AdPatientController(),
    );
  }
}
