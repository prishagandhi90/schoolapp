import 'package:emp_app/app/core/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:stepper_list_view/stepper_list_view.dart';

class CustomStepper extends StatelessWidget {
  CustomStepper({Key? key}) : super(key: key);

  final _stepperData = List.generate(
      5,
      (index) => StepperItemData(
            id: '$index',
            content: ({
              'name': 'Subhash Chandra Shukla',
              'occupation': 'Flutter Development',
              'born_date': '12\nAug',
            }),
          )).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: StepperListView(
        showStepperInLast: true,
        stepperData: _stepperData,
        stepAvatar: (_, data) {
          return PreferredSize(
            preferredSize: const Size.fromRadius(10),
            child: CircleAvatar(
              backgroundColor: AppColor.black,
              radius: 10,
              child: CircleAvatar(
                radius: 5,
                backgroundColor: AppColor.grey,
              ),
            ),
          );
        },
        stepWidget: (_, data) {
          final stepData = data as StepperItemData;
          return PreferredSize(
            preferredSize: const Size.fromWidth(40),
            child: Text(
              stepData.content['born_date'] ?? '',
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        stepContentWidget: (_, data) {
          final stepData = data as StepperItemData;
          return Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(5),
              visualDensity: VisualDensity(
                vertical: -1,
                horizontal: -1,
              ),
              title: Text(stepData.content['name'] ?? ''),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: theme.dividerColor,
                  width: 0.8,
                ),
              ),
            ),
          );
        },
        stepperThemeData: StepperThemeData(
          lineColor: theme.primaryColor,
          lineWidth: 5,
        ),
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
