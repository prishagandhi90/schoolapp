import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/pharmacy/controller/pharmacy_controller.dart';
import 'package:flutter/material.dart';

FloorsCheckBoxes({required PharmacyController controller}) {
  return GridView.builder(
      itemCount: controller.floors.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 4),
      itemBuilder: (context, i) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (controller.selectedFloorList.contains(controller.floors[i].floorName)) {
                    controller.selectedFloorList.remove(controller.floors[i].floorName);
                  } else {
                    controller.selectedFloorList.add(controller.floors[i].floorName!);
                  }
                  controller.update();
                },
                child: Row(
                  children: [
                    controller.selectedFloorList.contains(controller.floors[i].floorName)
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
                     Text(
                            controller.floors[i].floorName ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    // AppText(
                    //   text: controller.floors[i].floorName ?? '',
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
