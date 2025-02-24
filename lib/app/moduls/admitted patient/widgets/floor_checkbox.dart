import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:flutter/material.dart';

floorCheckBox({required AdpatientController controller}) {
  return GridView.builder(
      itemCount: controller.floorsList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4),
      itemBuilder: (context, i) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (controller.selectedFloorsList.contains(controller.floorsList[i].floorName)) {
                    controller.selectedFloorsList.remove(controller.floorsList[i].floorName);
                  } else {
                    controller.selectedFloorsList.add(controller.floorsList[i].floorName!);
                  }
                  controller.update();
                },
                child: Row(
                  children: [
                    controller.selectedFloorsList.contains(controller.floorsList[i].floorName)
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
                                border: Border.all(width: 1, color: AppColor.originalgrey),
                                borderRadius: const BorderRadius.all(Radius.circular(3))),
                          ),
                    SizedBox(
                      width: Sizes.crossLength * 0.010,
                    ),
                    Text(
                      controller.floorsList[i].floorName ?? '',
                      style: TextStyle(
                        fontSize: getDynamicHeight(size: 0.016),
                        color: AppColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // AppText(
                    //   text: controller.floorsList[i].floorName ?? '',
                    //   fontSize: Sizes.px14,
                    //   fontColor: ConstColor.blackTextColor,
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
