import 'package:emp_app/app/app_custom_widget/custom_date_picker.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/notification/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedFilter = "Today"; // Default Selected Value

  final List<String> filterOptions = [
    "Today",
    "Last 7 days",
    "Last 15 days",
    "Last 30 days",
    "Last 50 days",
    "Last 70 days",
    "Last 90 days",
    "Date range" // Ye last wala BottomSheet open karega
  ];

  final List<String> tagFilters = ["Training", "Circular", "Notice"];

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            title: Text(AppString.filters, style: AppStyle.primaryplusw700),
            backgroundColor: AppColor.white,
            centerTitle: true,
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    AppString.cancel,
                    style: AppStyle.primaryplusw700.copyWith(
                      fontSize: getDynamicHeight(size: 0.018),
                    ),
                    // TextStyle(
                    //   color: AppColor.black,
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.w700,
                    //   fontFamily: CommonFontStyle.plusJakartaSans,
                    // ),
                  ))
            ],
          ),
          body: Column(
            children: [
              Divider(
                color: AppColor.black,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(getDynamicHeight(size: 0.018)), //16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.filterbydays,
                        style: TextStyle(
                          fontSize: getDynamicHeight(size: 0.018),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.011)), //10),
                      Column(
                        children: filterOptions.map((option) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFilter = option;
                              });
                              if (option == "Date range") {
                                _showDateRangeBottomSheet(context);
                              }
                            },
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: option,
                                  groupValue: selectedFilter,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFilter = value!;
                                    });

                                    if (value == "Date range") {
                                      _showDateRangeBottomSheet(context);
                                    }
                                  },
                                  activeColor: AppColor.black,
                                ),
                                Text(option,
                                    style: TextStyle(
                                      fontSize: getDynamicHeight(size: 0.018),
                                    )),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.010)), //10),
                      Divider(color: AppColor.black, thickness: 1),
                      Text(
                        AppString.filterbytags,
                        style: TextStyle(
                          fontSize: getDynamicHeight(size: 0.018),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.012)), //10),
                      Column(
                        children: tagFilters.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: AppColor.black, size: 20),
                                SizedBox(width: getDynamicHeight(size: 0.012)), //10),
                                Text(tag,
                                    style: TextStyle(
                                      fontSize: getDynamicHeight(size: 0.016),
                                    )),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                    ],
                  ),
                ),
              ),
              Container(
                color: AppColor.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.13,
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          AppString.apply,
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: getDynamicHeight(size: 0.022),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.13,
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppColor.primaryColor)),
                        ),
                        child: Text(
                          AppString.reset,
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: getDynamicHeight(size: 0.022),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void _showDateRangeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return GetBuilder<NotificationController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: getDynamicHeight(size: 0.032)), //30),
                    const Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Select Date",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: getDynamicHeight(size: 0.020),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomDatePicker(
                          dateController: controller.fromDateController,
                          hintText: AppString.from,
                          onDateSelected: () async => await controller.selectFromDate(context),
                        ),
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: CustomDatePicker(
                          dateController: controller.toDateController,
                          hintText: AppString.to,
                          onDateSelected: () async => await controller.selectToDate(context),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () => Navigator.pop(context),
                //     child: Text("Apply"),
                //     style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.13,
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: ElevatedButton(
                        onPressed: () async {
                          // // controller.isLoadingLogin ? null : controller.requestOTP(context);
                          // FocusScope.of(context).unfocus();
                          // // FocusManager.instance.primaryFocus?.unfocus();
                          // if (controller.passFormKey.currentState!.validate()) {
                          //   controller.requestOTP(context);
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            // controller.isLoadingLogin
                            //     ? const CircularProgressIndicator()
                            //     :
                            Text(
                          AppString.confirm,
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: getDynamicHeight(size: 0.022),
                            fontWeight: FontWeight.w700,
                            fontFamily: CommonFontStyle.plusJakartaSans,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.13,
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ElevatedButton(
                        onPressed: () {
                          // Get.offAll(const LoginScreen(), duration: const Duration(milliseconds: 700));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppColor.primaryColor)),
                        ),
                        child: Text(
                          AppString.cancel,
                          style: TextStyle(
                            color: AppColor.white,
                            // fontSize: 20,
                            fontSize: getDynamicHeight(size: 0.022),
                            fontWeight: FontWeight.w700,
                            fontFamily: CommonFontStyle.plusJakartaSans,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    },
  );
}


// import 'package:emp_app/app/core/util/app_color.dart';
// import 'package:emp_app/app/core/util/app_font_name.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class FilterScreen extends StatelessWidget {
//   FilterScreen({Key? key}) : super(key: key);

//   String selectedFilter = "Today"; // Default Selected Value

//   final List<String> filterOptions = [
//     "Today",
//     "Last 7 days",
//     "Last 15 days",
//     "Last 30 days",
//     "Last 50 days",
//     "Last 70 days",
//     "Last 90 days",
//     "Date range"
//   ];

//   final List<String> tagFilters = ["Training", "Circular", "Notice"];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Filter Screen',
//           style: TextStyle(
//             color: AppColor.primaryColor,
//             fontWeight: FontWeight.w700,
//             fontFamily: CommonFontStyle.plusJakartaSans,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(
//                   color: AppColor.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: CommonFontStyle.plusJakartaSans,
//                 ),
//               ))
//         ],
//       ),
//       body: Column(
//         children: [
//           Divider(
//             color: AppColor.originalgrey,
//             thickness: 1,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Filter by days /date range',
//                 style: TextStyle(
//                   color: AppColor.black,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: CommonFontStyle.plusJakartaSans,
//                 ),
//               ),
//             ),
//           ),
//           Column(
//             children: filterOptions.map((option) {
//               return RadioListTile<String>(
//                 title: Text(option, style: TextStyle(fontSize: 16)),
//                 value: option,
//                 groupValue: selectedFilter,
//                 onChanged: (value) {
//                   selectedFilter = value!;
//                   // updare lkhvanu
//                 },
//                 activeColor: Colors.black,
//               );
//             }).toList(),
//           ),
//           Divider(color: Colors.black, thickness: 1),
//           SizedBox(height: 10),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               "Filter by tags",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: tagFilters.map((tag) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.check_circle, color: Colors.black, size: 20),
//                       SizedBox(width: 10),
//                       Text(tag, style: TextStyle(fontSize: 18)),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ✅ **Bottom Sheet for Date Range**
//   void _showDateRangeBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Select Date Range", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {}, // Open Date Picker (Future Scope)
//                     child: Text("From Date"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {}, // Open Date Picker (Future Scope)
//                     child: Text("To Date"),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("Apply"),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
