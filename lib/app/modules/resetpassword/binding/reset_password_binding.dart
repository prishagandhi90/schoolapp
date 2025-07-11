import 'package:schoolapp/app/modules/resetpassword/controller/resetpass_controller.dart';
import 'package:get/get.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetpassController>(
      () => ResetpassController(),
    );
  }
}
