import 'package:get/get.dart';
import 'package:emp_app/app/moduls/IPD/medication_sheet/controller/medicationsheet_controller.dart';

class AddMedicationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicationsheetController>(
      () => MedicationsheetController(),
    );
  }
}
