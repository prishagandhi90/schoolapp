import 'package:schoolapp/app/moduls/pharmacy/controller/pharmacy_controller.dart';
import 'package:get/get.dart';

class PharmacyScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyController>(
      () => PharmacyController(),
    );
  }
}
