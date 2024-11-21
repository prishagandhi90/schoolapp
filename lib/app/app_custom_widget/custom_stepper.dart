import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/dutyschedule/controller/dutyschedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stepper_list_view/stepper_list_view.dart';

class CustomStepper extends StatefulWidget {
  CustomStepper({Key? key}) : super(key: key);

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    Get.put(DutyscheduleController());
    return GetBuilder<DutyscheduleController>(builder: (controller) {
      if (controller.isLoading) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: ProgressWithIcon(),
          ),
        );
      } else if (controller.dutySchSftData.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: Text(
              "No Data Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: StepperListView(
            showStepperInLast: true,
            stepperData: List.generate(
                // weekData.length,
                controller.dutySchSftData.isNotEmpty && controller.dutySchSftData[0].dateColumnsValue != null
                    ? controller.dutySchSftData[0].dateColumnsValue!.length
                    : 0,
                (index) => StepperItemData(
                      id: '$index',
                      content: ({
                        'date': controller.dutySchSftData[0].dateColumnsValue?[index].name ?? '',
                        'name': controller.dutySchSftData[0].dateColumnsValue![index].value ?? '',
                        'activeYN': controller.dutySchSftData[0].dateColumnsValue![index].activeYN ?? '',
                        // 'born_date': weekData[index]['date'] ?? '',
                        // 'born_date': '',
                      }),
                    )),
            stepAvatar: (_, data) {
              final stepData = data as StepperItemData;
              // final stepIndex = int.parse((data as StepperItemData).id ?? '0');
              bool isActive = controller.dutySchSftData.isNotEmpty &&
                  controller.dutySchSftData[0].dateColumnsValue != null &&
                  stepData.content['activeYN'] == "true"; // Check if it's the active step (current day)

              return PreferredSize(
                preferredSize: const Size.fromRadius(10),
                child: CircleAvatar(
                  backgroundColor: isActive ? AppColor.primaryColor : Colors.grey, // Active step color
                  radius: 10,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: isActive ? AppColor.white : AppColor.grey, // Inactive step color
                  ),
                ),
              );
            },
            stepWidget: (_, data) {
              final stepData = data as StepperItemData;
              // final stepIndex = int.parse(stepData.id ?? '0');
              bool isActive = controller.dutySchSftData.isNotEmpty &&
                  controller.dutySchSftData[0].dateColumnsValue != null &&
                  stepData.content['activeYN'] == "true"; // Current date is active

              return PreferredSize(
                preferredSize: const Size.fromWidth(40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    stepData.content['date'] ?? '',
                    style: TextStyle(
                      color: isActive ? AppColor.primaryColor : Colors.grey, // Highlight active step
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            stepContentWidget: (_, data) {
              final stepData = data as StepperItemData;
              // final stepIndex = int.parse(stepData.id ?? '0');
              bool isActive = controller.dutySchSftData.isNotEmpty &&
                  controller.dutySchSftData[0].dateColumnsValue != null &&
                  stepData.content['activeYN'] == "true";

              return GestureDetector(
                onTap: () {
                  // setState(() {
                  //   // No need to change _activeStep dynamically because we only highlight the current date
                  // });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Adjust the outer space
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.lightblue1, // Set light blue background color here
                    borderRadius: BorderRadius.circular(0),
                    // border: Border.all(
                    //   color: isActive ? AppColor.primaryColor : Theme.of(context).dividerColor,
                    //   width: 1.0,
                    // ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(3),
                    visualDensity: VisualDensity(vertical: -1, horizontal: -1),
                    title: Text(
                      stepData.content['name'] ?? '',
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal, // Bold active step text
                      ),
                    ),
                    // subtitle: Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const SizedBox(height: 10),
                    //     Row(
                    //       children: [
                    //         Text(stepData.content['occupation'] ?? ''),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(0),
                    //   side: BorderSide(
                    //     color: isActive ? AppColor.primaryColor : theme.dividerColor, // Highlight active step border
                    //     width: 1.0,
                    //   ),
                    // ),
                  ),
                ),
              );
            },
            stepperThemeData: StepperThemeData(
              lineColor: AppColor.primaryColor,
              lineWidth: 2,
            ),
            physics: const BouncingScrollPhysics(),
          ),
        );
      }
    });
  }
}
