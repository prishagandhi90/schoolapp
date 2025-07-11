import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/app/modules/registration/controller/registration_controller.dart';
import 'package:schoolapp/app/modules/registration/widgets/custom_text_field.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      init: RegistrationController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text("Student Registration")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Name',
                    controller: controller.nameController,
                  ),
                  CustomTextField(
                    label: 'Father Name',
                    controller: controller.fatherNameController,
                  ),
                  CustomTextField(
                    label: 'Surname',
                    controller: controller.surnameController,
                  ),
                  GestureDetector(
                    onTap: controller.pickDate,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: 'Date of Birth',
                        controller: controller.dobController,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: controller.selectedGender.value,
                    decoration: InputDecoration(labelText: 'Gender'),
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (val) {
                      controller.selectedGender.value = val.toString();
                      controller.update();
                    },
                  ),
                  CustomTextField(
                    label: 'Address',
                    controller: controller.addressController,
                    maxLines: 3,
                  ),
                  CustomTextField(
                    label: 'Pincode',
                    controller: controller.pincodeController,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    label: 'City',
                    controller: controller.cityController,
                  ),
                  CustomTextField(
                    label: 'Mobile No. 1',
                    controller: controller.mobile1Controller,
                    keyboardType: TextInputType.phone,
                  ),
                  CustomTextField(
                    label: 'Mobile No. 2',
                    controller: controller.mobile2Controller,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.submitForm,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
