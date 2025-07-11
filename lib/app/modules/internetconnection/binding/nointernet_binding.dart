import 'package:get/get.dart';

import '../controller/nointernet_controller.dart';

class NoInternetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoInternetController>(
      () => NoInternetController(),
    );
  }
}
