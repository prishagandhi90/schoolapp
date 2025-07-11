import 'package:get/get.dart';
import 'package:schoolapp/app/modules/IPD/medication_sheet/controller/medicationsheet_controller.dart';

class AddMedicationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicationsheetController>(
      () => MedicationsheetController(),
    );
  }
}
