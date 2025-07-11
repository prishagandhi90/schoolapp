// import 'package:schoolapp/app/app_custom_widget/common_text.dart';
// import 'package:schoolapp/app/app_custom_widget/custom_apptextform_field.dart';
// import 'package:schoolapp/app/core/util/app_color.dart';
// import 'package:schoolapp/app/core/util/custom_color.dart';
// import 'package:schoolapp/app/core/util/sizer_constant.dart';
// import 'package:schoolapp/app/moduls/medication_sheet/controller/medicationsheet_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class OperationListView extends StatelessWidget {
//   const OperationListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<MedicationsheetController>(builder: (controller) {
//       return Container(
//         decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(10)),
//         height: getDynamicHeight(size: 0.395),
//         child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: getDynamicHeight(size: 0.015),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     AppText(
//                       text: 'Select Surgery',
//                       fontSize: Sizes.px16,
//                       fontWeight: FontWeight.w600,
//                       fontColor: AppColor.black,
//                     ),
//                     // GestureDetector(
//                     //   onTap: () {
//                     //     Get.back();
//                     //   },
//                     //   child: AppText(
//                     //     text: controller.selectedDropdnOptionId.isEmpty
//                     //         ? 'Close'
//                     //         : 'Done',
//                     //     fontSize: Sizes.px16,
//                     //     fontWeight: FontWeight.w600,
//                     //     fontColor: ConstColor.buttonColor,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 AppTextField(
//                   hintText: 'Enter surgery name',
//                   onTapOutside: (event) {
//                     FocusScope.of(context).unfocus();
//                   },
//                   onChanged: (text) {
//                     controller.searchOperationName(text.trim());
//                   },
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Expanded(
//                   child: controller.searchDropdnMultifieldsData != null
//                       ? controller.searchDropdnMultifieldsData!.isEmpty
//                           ? Center(
//                               child: AppText(
//                                 text: "No data found",
//                                 fontSize: Sizes.px16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             )
//                           : ListView.builder(
//                               padding: EdgeInsets.only(bottom: Sizes.crossLength * 0.020),
//                               itemCount: controller.searchDropdnMultifieldsData!.length,
//                               itemBuilder: (item, index) {
//                                 return GestureDetector(
//                                   behavior: HitTestBehavior.opaque,
//                                   onTap: () {
//                                     if (controller.selectedDropdnOptionId.contains(controller.searchDropdnMultifieldsData![index].value.toString())) {
//                                       controller.selectedDropdnOptionId.remove(controller.searchDropdnMultifieldsData![index].value.toString());
//                                       controller.selectedDropdownList.remove(controller.searchDropdnMultifieldsData![index]);
//                                     } else {
//                                       controller.selectedDropdnOptionId.add(controller.searchDropdnMultifieldsData![index].value!.toString());
//                                       controller.selectedDropdownList.add(controller.searchDropdnMultifieldsData![index]);
//                                     }
//                                     controller.update();
//                                   },
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       const SizedBox(
//                                         height: 15,
//                                       ),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: AppText(text: controller.searchDropdnMultifieldsData![index].name ?? ''),
//                                           ),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           controller.selectedDropdnOptionId.contains(controller.searchDropdnMultifieldsData![index].value.toString())
//                                               ? GestureDetector(
//                                                   onTap: () {
//                                                     FocusScope.of(context).unfocus();
//                                                     controller.selectedDropdnOptionId.remove(controller.searchDropdnMultifieldsData![index].value.toString());
//                                                     controller.selectedDropdownList.remove(controller.searchDropdnMultifieldsData![index]);
//                                                     controller.update();
//                                                   },
//                                                   child: Icon(
//                                                     Icons.cancel_outlined,
//                                                     color: ConstColor.buttonColor,
//                                                   ))
//                                               : const SizedBox()
//                                         ],
//                                       ),
//                                       index == controller.searchDropdnMultifieldsData!.length - 1
//                                           ? const SizedBox()
//                                           : const SizedBox(
//                                               height: 15,
//                                             ),
//                                       index == controller.searchDropdnMultifieldsData!.length - 1
//                                           ? const SizedBox()
//                                           : const Divider(
//                                               thickness: 1,
//                                               height: 1,
//                                               color: ConstColor.greyACACAC,
//                                             )
//                                     ],
//                                   ),
//                                 );
//                               })
//                       : controller.dropdownMultifieldsTable.isEmpty
//                           ? Center(
//                               child: AppText(
//                                 text: "No data found for selected surgeon",
//                                 fontSize: Sizes.px16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             )
//                           : ListView.builder(
//                               padding: EdgeInsets.only(bottom: Sizes.crossLength * 0.020),
//                               itemCount: controller.dropdownMultifieldsTable.length,
//                               itemBuilder: (item, index) {
//                                 return GestureDetector(
//                                   behavior: HitTestBehavior.opaque,
//                                   onTap: () {
//                                     if (controller.selectedDropdnOptionId.contains(controller.dropdownMultifieldsTable[index].value.toString())) {
//                                       controller.selectedDropdnOptionId.remove(controller.dropdownMultifieldsTable[index].value.toString());
//                                       controller.selectedDropdownList.remove(controller.dropdownMultifieldsTable[index]);
//                                     } else {
//                                       controller.selectedDropdnOptionId.add(controller.dropdownMultifieldsTable[index].value!.toString());
//                                       controller.selectedDropdownList.add(controller.dropdownMultifieldsTable[index]);
//                                     }
//                                     controller.update();
//                                   },
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       const SizedBox(height: 15),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: AppText(text: controller.dropdownMultifieldsTable[index].name ?? ''),
//                                           ),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           controller.selectedDropdnOptionId.contains(controller.dropdownMultifieldsTable[index].value.toString())
//                                               ? GestureDetector(
//                                                   onTap: () {
//                                                     FocusScope.of(context).unfocus();
//                                                     controller.selectedDropdnOptionId.remove(controller.dropdownMultifieldsTable[index].value.toString());
//                                                     controller.selectedDropdownList.remove(controller.dropdownMultifieldsTable[index]);
//                                                     controller.update();
//                                                   },
//                                                   child: const Icon(
//                                                     Icons.cancel_outlined,
//                                                     color: ConstColor.buttonColor,
//                                                   ))
//                                               : const SizedBox()
//                                         ],
//                                       ),
//                                       index == controller.dropdownMultifieldsTable.length - 1
//                                           ? const SizedBox()
//                                           : const SizedBox(
//                                               height: 15,
//                                             ),
//                                       index == controller.dropdownMultifieldsTable.length - 1
//                                           ? const SizedBox()
//                                           : const Divider(
//                                               thickness: 1,
//                                               height: 1,
//                                               color: ConstColor.greyACACAC,
//                                             )
//                                     ],
//                                   ),
//                                 );
//                               }),
//                 ),
//               ],
//             )),
//       );
//     });
//   }
// }
