import 'package:emp_app/app/moduls/notification/controller/notification_controller.dart';
import 'package:get/get.dart';

class FilterScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
  }
}
