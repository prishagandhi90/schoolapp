import 'package:get/get.dart';
import 'package:schoolapp/app/modules/registration/controller/registration_controller.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegistrationController());
  }
}
