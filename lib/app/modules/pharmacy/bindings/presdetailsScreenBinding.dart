import 'package:schoolapp/app/modules/pharmacy/controller/pharmacy_controller.dart';
import 'package:get/get.dart';

class PresdetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyController>(
      () => PharmacyController(),
    );
  }
}
