import 'package:schoolapp/app/modules/superlogin/controller/superlogin_controller.dart';
import 'package:get/get.dart';

class SuperLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuperloginController>(
      () => SuperloginController(),
    );
  }
}
