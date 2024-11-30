import 'package:emp_app/app/app_custom_widget/common_text.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/pharmacy/controller/pharmacy_controller.dart';
import 'package:flutter/material.dart';

WardsCheckBoxes({required PharmacyController controller}) {
  return GridView.builder(
      itemCount: controller.wards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4),
      itemBuilder: (context, i) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (controller.selectedWardList.contains(controller.wards[i].wardName)) {
                    controller.selectedWardList.remove(controller.wards[i].wardName);
                  } else {
                    controller.selectedWardList.add(controller.wards[i].wardName!);
                  }
                  controller.update();
                },
                child: Row(
                  children: [
                    controller.selectedWardList.contains(controller.wards[i].wardName)
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
                    AppText(
                      text: controller.wards[i].wardName ?? '',
                      fontSize: Sizes.px14,
                      fontColor: AppColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      });
}
