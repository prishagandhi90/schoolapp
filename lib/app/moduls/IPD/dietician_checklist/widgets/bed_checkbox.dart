import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/IPD/dietician_checklist/controller/dietchecklist_controller.dart';
import 'package:flutter/material.dart';

dietBedsCheckBoxes({required DietchecklistController controller}) {
  return GridView.builder(
    itemCount: controller.beds.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 4,
    ),
    itemBuilder: (context, i) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (controller.selectedBedList.contains(controller.beds[i].bedName)) {
                  controller.selectedBedList.remove(controller.beds[i].bedName);
                } else {
                  controller.selectedBedList.add(controller.beds[i].bedName!);
                }
                controller.update();
              },
              child: Row(
                children: [
                  controller.selectedBedList.contains(controller.beds[i].bedName)
                      ? Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: AppColor.originalgrey,
                            border: Border.all(width: 1, color: AppColor.originalgrey),
                            borderRadius: const BorderRadius.all(Radius.circular(3)),
                          ),
                          child: Center(
                            child: Icon(Icons.check, color: AppColor.white, size: 16),
                          ),
                        )
                      : Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: AppColor.originalgrey),
                            borderRadius: const BorderRadius.all(Radius.circular(3)),
                          ),
                        ),
                  const SizedBox(width: 10),
                  // Wrap the text with Flexible and FittedBox for responsiveness
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        controller.beds[i].bedName ?? '',
                        style: TextStyle(
                          // fontSize: 14,
                          fontSize: getDynamicHeight(size: 0.016),
                          color: AppColor.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

// import 'package:schoolapp/app/core/util/app_color.dart';
// import 'package:schoolapp/app/moduls/pharmacy/controller/pharmacy_controller.dart';
// import 'package:flutter/material.dart';

// BedsCheckBoxes({required PharmacyController controller}) {
//   return GridView.builder(
//       itemCount: controller.beds.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 4),
//       itemBuilder: (context, i) {
//         return Row(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   if (controller.selectedBedList.contains(controller.beds[i].bedName)) {
//                     controller.selectedBedList.remove(controller.beds[i].bedName);
//                   } else {
//                     controller.selectedBedList.add(controller.beds[i].bedName!);
//                   }
//                   controller.update();
//                 },
//                 child: Row(
//                   children: [
//                     controller.selectedBedList.contains(controller.beds[i].bedName)
//                         ? Container(
//                             height: 20,
//                             width: 20,
//                             decoration: BoxDecoration(
//                                 color: AppColor.originalgrey,
//                                 border: Border.all(width: 1, color: AppColor.originalgrey),
//                                 borderRadius: const BorderRadius.all(Radius.circular(3))),
//                             child: Center(
//                               child: Icon(Icons.check, color: AppColor.white, size: 16),
//                             ),
//                           )
//                         : Container(
//                             height: 20,
//                             width: 20,
//                             decoration: BoxDecoration(
//                                 border: Border.all(width: 1, color: AppColor.originalgrey),
//                                 borderRadius: const BorderRadius.all(Radius.circular(3))),
//                           ),
//                     SizedBox(width: 10),
//                     Text(
//                       controller.beds[i].bedName ?? '',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: AppColor.black,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     // AppText(
//                     //   text: controller.beds[i].bedName ?? '',
//                     //   fontSize: Sizes.px14,
//                     //   fontColor: AppColor.black,
//                     //   fontWeight: FontWeight.w600,
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       });
// }
