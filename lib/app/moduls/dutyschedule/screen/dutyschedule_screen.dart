import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_stepper.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/dutyschedule/controller/dutyschedule_controller.dart';
import 'package:emp_app/app/moduls/dutyschedule/model/dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DutyscheduleScreen extends GetView<DutyscheduleController> {
  const DutyscheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DutyscheduleController());
    return GetBuilder<DutyscheduleController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Duty Schedule',
              style: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w700,
                fontFamily: CommonFontStyle.plusJakartaSans,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.snackbar(
                    AppString.comingsoon,
                    '',
                    colorText: AppColor.white,
                    backgroundColor: AppColor.black,
                    duration: const Duration(seconds: 1),
                  );
                },
                icon: Image.asset(AppImage.notification, width: 20),
              )
            ],
            centerTitle: true,
          ),
          body: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // 60% width for the dropdown
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: CustomDropdown(
                        text: controller.DutyDropdownNameController.text.isNotEmpty
                            ? controller.DutyDropdownNameController.text
                            : controller.getCurrentWeekDate(),
                        controller: controller.DutyDropdownNameController,
                        buttonStyleData: ButtonStyleData(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(199, 255, 255, 255),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) async {
                          await controller.DutyScheduleChangeMethod(value);
                        },
                        items: controller.Sheduledrpdwnlst.isNotEmpty
                            ? controller.Sheduledrpdwnlst.map(
                                (sheduledrpdwnlst item) => DropdownMenuItem<Map<String, String>>(
                                  value: {
                                    'value': item.value ?? '',
                                    'text': item.name ?? '',
                                  },
                                  child: Text(
                                    item.name ?? '',
                                    style: AppStyle.black.copyWith(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ).toList()
                            : [],
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // 40% width for the text field
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(199, 255, 255, 255),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            controller.dutySchSftData.isNotEmpty && controller.dutySchSftData[0].dateColumnsValue != null
                                ? controller.dutySchSftData[0].subDepartment!
                                : "",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //   controller.isLoading
              //       // Show loading indicator
              //       ? Center(
              //           child: Padding(
              //             padding: EdgeInsets.symmetric(vertical: 100),
              //             child: ProgressWithIcon(),
              //           ),
              //         )
              //       : controller.dutySchSftData.isEmpty
              //           // Show "No Data Found" message if data is empty
              //           ? Center(
              //               child: Padding(
              //                 padding: EdgeInsets.symmetric(vertical: 100),
              //                 child: Text(
              //                   "No Data Found",
              //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //                   textAlign: TextAlign.center,
              //                 ),
              //               ),
              //             )
              //           : SizedBox(
              //               height: MediaQuery.of(context).size.height * 0.6,
              //               child: StepperListView(
              //                 showStepperInLast: true,
              //                 stepperData: List.generate(
              //                     // weekData.length,
              //                     controller.dutySchSftData.isNotEmpty &&
              //                             controller.dutySchSftData[0].dateColumnsValue != null
              //                         ? controller.dutySchSftData[0].dateColumnsValue!.length
              //                         : 0,
              //                     (index) => StepperItemData(
              //                           id: '$index',
              //                           content: ({
              //                             'date': controller.dutySchSftData[0].dateColumnsValue?[index].name ?? '',
              //                             'name': controller.dutySchSftData[0].dateColumnsValue![index].value ?? '',
              //                             'activeYN':
              //                                 controller.dutySchSftData[0].dateColumnsValue![index].activeYN ?? '',
              //                             // 'born_date': weekData[index]['date'] ?? '',
              //                             // 'born_date': '',
              //                           }),
              //                         )),
              //                 stepAvatar: (_, data) {
              //                   final stepData = data as StepperItemData;
              //                   // final stepIndex = int.parse((data as StepperItemData).id ?? '0');
              //                   bool isActive = controller.dutySchSftData.isNotEmpty &&
              //                       controller.dutySchSftData[0].dateColumnsValue != null &&
              //                       stepData.content['activeYN'] ==
              //                           "true"; // Check if it's the active step (current day)

              //                   return PreferredSize(
              //                     preferredSize: const Size.fromRadius(10),
              //                     child: CircleAvatar(
              //                       backgroundColor:
              //                           isActive ? AppColor.primaryColor : Colors.grey, // Active step color
              //                       radius: 10,
              //                       child: CircleAvatar(
              //                         radius: 5,
              //                         backgroundColor: isActive ? AppColor.white : AppColor.grey, // Inactive step color
              //                       ),
              //                     ),
              //                   );
              //                 },
              //                 stepWidget: (_, data) {
              //                   final stepData = data as StepperItemData;
              //                   // final stepIndex = int.parse(stepData.id ?? '0');
              //                   bool isActive = controller.dutySchSftData.isNotEmpty &&
              //                       controller.dutySchSftData[0].dateColumnsValue != null &&
              //                       stepData.content['activeYN'] == "true"; // Current date is active

              //                   return PreferredSize(
              //                     preferredSize: const Size.fromWidth(40),
              //                     child: Padding(
              //                       padding: const EdgeInsets.symmetric(horizontal: 7),
              //                       child: Text(
              //                         stepData.content['date'] ?? '',
              //                         style: TextStyle(
              //                           color: isActive ? AppColor.primaryColor : Colors.grey, // Highlight active step
              //                           fontSize: 15,
              //                         ),
              //                         textAlign: TextAlign.center,
              //                       ),
              //                     ),
              //                   );
              //                 },
              //                 stepContentWidget: (_, data) {
              //                   final stepData = data as StepperItemData;
              //                   // final stepIndex = int.parse(stepData.id ?? '0');
              //                   bool isActive = controller.dutySchSftData.isNotEmpty &&
              //                       controller.dutySchSftData[0].dateColumnsValue != null &&
              //                       stepData.content['activeYN'] == "true";

              //                   return GestureDetector(
              //                     onTap: () {
              //                       // setState(() {
              //                       //   // No need to change _activeStep dynamically because we only highlight the current date
              //                       // });
              //                     },
              //                     child: Container(
              //                       margin: const EdgeInsets.symmetric(
              //                           vertical: 5, horizontal: 10), // Adjust the outer space
              //                       padding: const EdgeInsets.all(8),
              //                       decoration: BoxDecoration(
              //                         color: AppColor.lightblue1, // Set light blue background color here
              //                         borderRadius: BorderRadius.circular(0),
              //                         // border: Border.all(
              //                         //   color: isActive ? AppColor.primaryColor : Theme.of(context).dividerColor,
              //                         //   width: 1.0,
              //                         // ),
              //                       ),
              //                       child: ListTile(
              //                         contentPadding: const EdgeInsets.all(3),
              //                         visualDensity: VisualDensity(vertical: -1, horizontal: -1),
              //                         title: Text(
              //                           stepData.content['name'] ?? '',
              //                           style: TextStyle(
              //                             fontWeight:
              //                                 isActive ? FontWeight.bold : FontWeight.normal, // Bold active step text
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 },
              //                 stepperThemeData: StepperThemeData(
              //                   lineColor: AppColor.primaryColor,
              //                   lineWidth: 2,
              //                 ),
              //                 physics: const BouncingScrollPhysics(),
              //               ),
              //             )
              CustomStepper(),
            ],
          ),
        );
      },
    );
  }
}
