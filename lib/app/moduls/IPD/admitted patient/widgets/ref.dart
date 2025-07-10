import 'package:schoolapp/app/app_custom_widget/common_text.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/IPD/admitted%20patient/controller/labreport_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferenceWidget extends StatelessWidget {
  final List allReportsData;
  final List dateLsiting;
  final double height;
  const ReferenceWidget({
    super.key,
    required this.allReportsData,
    required this.dateLsiting,
    required this.height,
  });

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
                text: 'Normal Range',
                fontSize: Sizes.px13,
                fontColor: AppColor.white,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: height,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: allReportsData.length + 1,
                shrinkWrap: true,
                // controller: controller.scrollController1,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (item, i) {
                  return Column(
                    children: [
                      i == allReportsData.length
                          ? const SizedBox()
                          : SizedBox(
                              height: getHeightOfWidget(
                                  allReportsData[i]['NormalRange'] != null && allReportsData[i]['NormalRange'] != ''
                                      ? allReportsData[i]['NormalRange']
                                      : '-',
                                  allReportsData[i]['Unit'] != null && allReportsData[i]['Unit'] != '' ? allReportsData[i]['Unit'] : '-',
                                  allReportsData,
                                  dateLsiting,
                                  i),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppText(
                                      text: allReportsData[i]['NormalRange'] != null && allReportsData[i]['NormalRange'] != ''
                                          ? allReportsData[i]['NormalRange']
                                          : '-',
                                      fontSize: Sizes.px13,
                                      fontColor: AppColor.black6B6B6B,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLine: 10,
                                    ),
                                    AppText(
                                      text: allReportsData[i]['Unit'] != null && allReportsData[i]['Unit'] != '' ? allReportsData[i]['Unit'] : '-',
                                      fontSize: Sizes.px9,
                                      fontColor: AppColor.black6B6B6B,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                      maxLine: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      i == allReportsData.length
                          ? const SizedBox()
                          : Divider(
                              thickness: 1,
                              height: getDynamicHeight(size: 0.002),
                              // ignore: deprecated_member_use
                              color: AppColor.black.withOpacity(0.3),
                            ),
                      i == allReportsData.length
                          ? Container(
                              color: Colors.white,
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

getHeightOfWidget(String text1, String text2, List alldata, List datesListing, int index) {
  // print((text1.length + text2.length));
  // if ((text1.length + text2.length) > 14) {
  //   return getDynamicHeight(size: 0.125);
  // } else {
  for (int i = 0; i < alldata.length; i++) {
    if (index == i) {
      for (int j = 0; j < datesListing.length; j++) {
        if (alldata[i][datesListing[j]].toString().length > 70) {
          return getDynamicHeight(size: 0.350);
        } else if (alldata[i][datesListing[j]].toString().length > 50) {
          return getDynamicHeight(size: 0.250);
        } else if (alldata[i][datesListing[j]].toString().length > 25) {
          return getDynamicHeight(size: 0.175);
        } else if (alldata[i][datesListing[j]].toString().length > 14) {
          return getDynamicHeight(size: 0.125);
        } else {
          if ((text1.length + text2.length) > 14) {
            return getDynamicHeight(size: 0.125);
          } else if (alldata[i]["TestName"].toString().length > 25) {
            return getDynamicHeight(size: 0.10);
          }
        }
      }
    }
  }
  return getDynamicHeight(size: 0.055);
}

dynamic getWidthOfWidget(String text1, String text2, List alldata, List datesListing, int index) {
  for (int i = 0; i < alldata.length; i++) {
    if (index == i) {
      for (int j = 0; j < datesListing.length; j++) {
        if (i == 0) {
          alldata[i][datesListing[j]] =
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
        }
        if (alldata[i][datesListing[j]].toString().length > 50) {
          return getDynamicHeight(size: 0.250);
        }
        // else if (alldata[i][datesListing[j]].toString().length > 25) {
        //   return getDynamicHeight(size: 0.175);
        // } else if (alldata[i][datesListing[j]].toString().length > 14) {
        //   return getDynamicHeight(size: 0.125);
        // } else {
        //   if ((text1.length + text2.length) > 14) {
        //     return getDynamicHeight(size: 0.125);
        //   } else if (alldata[i]["TestName"].toString().length > 25) {
        //     return getDynamicHeight(size: 0.10);
        //   }
        // }
      }
    }
  }
  return getDynamicHeight(size: 0.055);
}
// }
