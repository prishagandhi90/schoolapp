import 'package:schoolapp/app/modules/IPD/invest_requisit/controller/invest_requisit_controller.dart';
import 'package:get/get.dart';

class InvestServiceScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestRequisitController>(
      () => InvestRequisitController(),
    );
  }
}
