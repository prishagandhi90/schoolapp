import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/IPD/admitted%20patient/controller/adpatient_controller.dart';
import 'package:flutter/material.dart';

WardsCheckBox({required AdPatientController controller}) {
  return GridView.builder(
      itemCount: controller.wardList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 4),
      itemBuilder: (context, i) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (controller.selectedWardsList.contains(controller.wardList[i].wardName)) {
                    controller.selectedWardsList.remove(controller.wardList[i].wardName);
                  } else {
                    controller.selectedWardsList.add(controller.wardList[i].wardName!);
                  }
                  controller.update();
                },
                child: Row(
                  children: [
                    controller.selectedWardsList.contains(controller.wardList[i].wardName)
                        ? Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: AppColor.originalgrey, border: Border.all(width: 1, color: AppColor.originalgrey), borderRadius: const BorderRadius.all(Radius.circular(3))),
                            child: Center(
                              child: Icon(Icons.check, color: AppColor.white, size: 16),
                            ),
                          )
                        : Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(border: Border.all(width: 1, color: AppColor.originalgrey), borderRadius: const BorderRadius.all(Radius.circular(3))),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      controller.wardList[i].wardName ?? '',
                      style: TextStyle(
                        // fontSize: 14,
                        fontSize: getDynamicHeight(size: 0.016),
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // AppText(
                    //   text: controller.wards[i].wardName ?? '',
                    //   fontSize: Sizes.px14,
                    //   fontColor: AppColor.black,
                    //   fontWeight: FontWeight.w600,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        );
      });
}
