import 'package:emp_app/app/moduls/internetconnection/controller/nointernet_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectivityController>(() => ConnectivityController());

  }
}