import 'package:emp_app/app/app_custom_widget/custom_date_picker.dart';
import 'package:emp_app/app/core/util/app_string.dart';
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
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Filters"),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ **Filter by Days / Date Range (TOP)**
                Text(
                  "Filter by days / date range",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // ✅ **Radio Button List**
                Column(
                  children: filterOptions.map((option) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = option;
                        });

                        // ✅ If "Date range" is selected, open BottomSheet
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
                            activeColor: Colors.black,
                          ),
                          Text(option, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                // ✅ **Divider**
                SizedBox(height: 10),
                Divider(color: Colors.black, thickness: 1),

                // ✅ **Filter by Tags (BOTTOM)**
                Text(
                  "Filter by tags",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // ✅ **Column-Wise Tag List**
                Column(
                  children: tagFilters.map((tag) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.black, size: 20),
                          SizedBox(width: 10),
                          Text(tag, style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  Text("Select Date Range", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Apply"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
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
