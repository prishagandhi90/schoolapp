import 'package:schoolapp/app/moduls/forgotpassword/controller/forgotpass_controller.dart';
import 'package:get/get.dart';

class ForgotpasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotpassController>(
      () => ForgotpassController(),
    );
  }
}
