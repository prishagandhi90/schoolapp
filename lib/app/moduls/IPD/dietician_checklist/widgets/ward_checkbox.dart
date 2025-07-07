import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/IPD/dietician_checklist/controller/dietchecklist_controller.dart';
import 'package:flutter/material.dart';

dietWardsCheckBoxes({required DietchecklistController controller}) {
  return GridView.builder(
      itemCount: controller.wards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 4),
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
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: AppColor.originalgrey,
                                border: Border.all(width: 1, color: AppColor.originalgrey),
                                borderRadius: const BorderRadius.all(Radius.circular(3))),
                            child: Center(
                              child: Icon(Icons.check, color: AppColor.white, size: 16),
                            ),
                          )
                        : Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: AppColor.originalgrey),
                                borderRadius: const BorderRadius.all(Radius.circular(3))),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          controller.wards[i].wardName ?? '',
                          style: TextStyle(
                            // fontSize: 14,
                            fontSize: getDynamicHeight(size: 0.016),
                            color: AppColor.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
