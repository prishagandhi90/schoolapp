import 'package:emp_app/app/moduls/invest_requisit/controller/invest_requisit_controller.dart';
import 'package:get/get.dart';

class InvestRequisitScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestRequisitController>(
      () => InvestRequisitController(),
    );
  }
}
