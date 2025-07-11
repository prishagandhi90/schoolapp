import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final surnameController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final mobile1Controller = TextEditingController();
  final mobile2Controller = TextEditingController();

  RxString selectedGender = 'Male'.obs;

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime(2005),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      // TODO: API call to register student
      Get.snackbar('Success', 'Form Submitted!');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    fatherNameController.dispose();
    surnameController.dispose();
    dobController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    mobile1Controller.dispose();
    mobile2Controller.dispose();
    super.onClose();
  }
}
