import 'package:emp_app/app/moduls/verifyotp/controller/otp_controller.dart';
import 'package:get/get.dart';

class VerifyotpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(
      () => OtpController(),
    );
  }
}
