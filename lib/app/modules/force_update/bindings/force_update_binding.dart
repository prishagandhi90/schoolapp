// force_update_binding.dart

import 'package:schoolapp/app/modules/force_update/controller/force_update_controller.dart';
import 'package:get/get.dart';

class ForceUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForceUpdateController>(() => ForceUpdateController());
  }
}
