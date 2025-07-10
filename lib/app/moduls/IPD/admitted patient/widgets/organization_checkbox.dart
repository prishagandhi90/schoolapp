import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/IPD/admitted%20patient/controller/adpatient_controller.dart';
import 'package:flutter/material.dart';

organizationCheckBoxes({required AdPatientController controller}) {
  return GridView.builder(
      itemCount: controller.orgsList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4),
      itemBuilder: (context, i) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (controller.selectedOrgsList.contains(controller.orgsList[i].organization)) {
                    controller.selectedOrgsList.remove(controller.orgsList[i].organization);
                  } else {
                    controller.selectedOrgsList.add(controller.orgsList[i].organization!);
                  }
                  controller.update();
                },
                child: Row(
                  children: [
                    controller.selectedOrgsList.contains(controller.orgsList[i].organization)
                        ? Container(
                            height: getDynamicHeight(size: 0.020),
                            width: getDynamicHeight(size: 0.020),
                            decoration: BoxDecoration(
                                color: AppColor.originalgrey,
                                border: Border.all(width: 1, color: AppColor.originalgrey),
                                borderRadius: const BorderRadius.all(Radius.circular(3))),
                            child: Center(
                              child: Icon(Icons.check, color: AppColor.white, size: getDynamicHeight(size: 0.016)),
                            ),
                          )
                        : Container(
                            height: getDynamicHeight(size: 0.020),
                            width: getDynamicHeight(size: 0.020),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: AppColor.originalgrey), borderRadius: const BorderRadius.all(Radius.circular(3))),
                          ),
                    SizedBox(
                      width: Sizes.crossLength * 0.010,
                    ),
                    Text(
                      controller.orgsList[i].organization ?? '',
                      style: TextStyle(
                        fontSize: getDynamicHeight(size: 0.016),
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      });
}
