import 'package:schoolapp/app/modules/PAYROLL_MAIN/lvotApproval/controller/lvotapproval_controller.dart';
import 'package:get/get.dart';

class lv_screen_Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LvotapprovalController>(
      () => LvotapprovalController(),
    );
  }
}
