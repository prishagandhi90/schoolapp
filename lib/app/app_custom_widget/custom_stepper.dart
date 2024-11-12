import 'package:emp_app/app/core/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:stepper_list_view/stepper_list_view.dart';
import 'package:intl/intl.dart'; // For formatting dates

class CustomStepper extends StatefulWidget {
  CustomStepper({Key? key}) : super(key: key);

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  final int _activeStep = DateTime.now().weekday - 1; // Active step based on current day of the week

  // Get the current week's dates (from Monday to Sunday)
  List<Map<String, String>> _getCurrentWeekData() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
    List<Map<String, String>> weekData = [];

    for (int i = 0; i < 7; i++) {
      DateTime date = startOfWeek.add(Duration(days: i));
      String formattedDate = DateFormat('d\nMMM').format(date); // Format: day \n month
      weekData.add({
        'date': formattedDate,
        'name': 'Subhash Chandra Shukla',
        'occupation': 'Flutter Developer',
      });
    }
    return weekData;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekData = _getCurrentWeekData();

    return Expanded(
      child: StepperListView(
        showStepperInLast: true,
        stepperData: List.generate(
            weekData.length,
            (index) => StepperItemData(
                  id: '$index',
                  content: ({
                    'name': weekData[index]['name'] ?? '',
                    'occupation': weekData[index]['occupation'] ?? '',
                    'born_date': weekData[index]['date'] ?? '',
                  }),
                )),
        stepAvatar: (_, data) {
          final stepIndex = int.parse((data as StepperItemData).id ?? '0');
          bool isActive = stepIndex == _activeStep; // Check if it's the active step (current day)

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
          final stepIndex = int.parse(stepData.id ?? '0');
          bool isActive = stepIndex == _activeStep; // Current date is active

          return PreferredSize(
            preferredSize: const Size.fromWidth(40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Text(
                stepData.content['born_date'] ?? '',
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
          final stepIndex = int.parse(stepData.id ?? '0');
          bool isActive = stepIndex == _activeStep;

          return GestureDetector(
            onTap: () {
              setState(() {
                // No need to change _activeStep dynamically because we only highlight the current date
              });
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
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(stepData.content['occupation'] ?? ''),
                      ],
                    ),
                  ],
                ),
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
}
