import 'package:emp_app/app/moduls/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:get/get.dart';

class lvot_appr_screen_Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LvotapprovalController>(
      () => LvotapprovalController(),
    );
  }
}
