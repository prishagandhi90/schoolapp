import 'package:emp_app/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
import 'package:get/get.dart';

class MedicationScreenbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicationsheetController>(
      () => MedicationsheetController(),
    );
  }
}
