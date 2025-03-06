import 'package:emp_app/app/app_custom_widget/common_text.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/labreport_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/widgets/ref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartingHeading extends StatelessWidget {
  final List allReportsData;
  final double height;
  final List dateLsiting;
  const StartingHeading({super.key, required this.allReportsData, required this.height, required this.dateLsiting});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LabReportsController>(builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColor.buttonColor,
            ),
            height: 90,
            child: Center(
              child: AppText(
                text: 'Test Name',
                fontSize: Sizes.px13,
                fontColor: AppColor.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: height,
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16.0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allReportsData.length + 1,
                itemBuilder: (item, i) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      i == allReportsData.length
                          ? const SizedBox()
                          : SizedBox(
                              height: getHeightOfWidget(
                                  allReportsData[i]['NormalRange'] != null && allReportsData[i]['NormalRange'] != ''
                                      ? allReportsData[i]['NormalRange']
                                      : '-',
                                  allReportsData[i]['Unit'] != null && allReportsData[i]['Unit'] != ''
                                      ? allReportsData[i]['Unit']
                                      : '-',
                                  allReportsData,
                                  dateLsiting,
                                  i),
                              child: Center(
                                child: AppText(
                                  text: allReportsData[i]['TestName'] ?? '',
                                  fontSize: Sizes.px13,
                                  fontColor: AppColor.buttonColor,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                  // maxLine: 2,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                      i == allReportsData.length
                          ? const SizedBox()
                          : Divider(
                              thickness: 1,
                              height: getDynamicHeight(size: 0.002),
                              color: AppColor.black.withOpacity(0.3),
                            ),
                      i == allReportsData.length
                          ? Container(
                              height: 10,
                            )
                          : const SizedBox()
                    ],
                  );
                }),
          )
        ],
      );
    });
  }
}

getHeightOfWidget1(String text1, String text2, List alldata, List datesListing, int index) {
  if ((text1.length + text2.length) > 14) {
    return getDynamicHeight(size: 0.125);
  } else {
    // for (int i = 0; i < alldata.length; i++) {
    //   if (index == i) {
    //     for (int j = 0; j < datesListing.length; j++) {
    //       if (alldata[i][datesListing[j]].toString().length > 14) {
    //         return getDynamicHeight(size: 0.115);
    //       }
    //     }
    //   }
    // }
    return getDynamicHeight(size: 0.055);
  }
}
