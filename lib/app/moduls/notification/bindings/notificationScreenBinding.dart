import 'package:schoolapp/app/moduls/notification/controller/notification_controller.dart';
import 'package:get/get.dart';

class NotificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
  }
}
