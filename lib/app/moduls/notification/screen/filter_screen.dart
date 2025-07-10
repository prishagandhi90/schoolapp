import 'package:schoolapp/app/app_custom_widget/custom_date_picker.dart';
import 'package:schoolapp/app/core/util/app_color.dart';
import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/core/util/app_style.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:schoolapp/app/moduls/notification/controller/notification_controller.dart';
import 'package:schoolapp/app/moduls/notification/screen/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedFilter = "Today"; // Default Selected Value

  final List<String> tagFilters = ["Training", "Circular", "Notice", "Minutes of Meeting"];

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
            leading: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  controller.fetchNotificationList(); // Fetch data from server
                  Navigator.pop(context); // UI ko refresh karna
                },
                icon: Icon(Icons.arrow_back_ios_new, color: AppColor.black)),
            actions: [
              TextButton(
                  onPressed: () async {
                    // FocusScope.of(context).unfocus();
                    // controller.searchFocusNode.unfocus();
                    if (controller.selectedTags.isEmpty && controller.fromDateController.text.isEmpty && controller.toDateController.text.isEmpty) {
                      await controller.fetchNotificationList();
                    }
                    Navigator.pop(context);
                    if (controller.selectedTags.isEmpty && controller.fromDateController.text.isEmpty && controller.toDateController.text.isEmpty) {
                      await controller.clearFilters();
                    }
                  },
                  child: Text(
                    AppString.cancel,
                    style: AppStyle.primaryplusw700.copyWith(
                      fontSize: getDynamicHeight(size: 0.018),
                    ),
                  ))
            ],
          ),
          body: Column(
            children: [
              Divider(color: AppColor.black),
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
                      // SizedBox(height: getDynamicHeight(size: 0.011)), //10),
                      Column(
                        children: controller.filterOptions.map((option) {
                          return GestureDetector(
                            onTap: () {
                              selectedFilter = option;
                              controller.update();
                              if (option == "Date range") {
                                _showDateRangeBottomSheet(context);
                              }
                            },
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: option,
                                  groupValue: selectedFilter,
                                  onChanged: (value) async {
                                    selectedFilter = option;
                                    controller.update();

                                    if (option == "Date range") {
                                      _showDateRangeBottomSheet(context);
                                    } else {
                                      final days = controller.filterOptionDaysMap[option] ?? 0;
                                      await controller.fetchNotificationList(days: days); // 👈 Pass the days to API call
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
                          final isSelected = controller.selectedTags.contains(tag);
                          return GestureDetector(
                            onTap: () {
                              print('Tag tapped: $tag');
                              if (isSelected) {
                                controller.selectedTags.remove(tag);
                              } else {
                                controller.selectedTags.add(tag);
                              }
                              controller.update();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: getDynamicHeight(size: 0.024),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColor.black, width: 2),
                                      borderRadius: BorderRadius.circular(4), // square corners
                                      color: isSelected ? AppColor.black : AppColor.transparent,
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            Icons.check,
                                            color: AppColor.white,
                                            size: getDynamicHeight(size: 0.018),
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: getDynamicHeight(size: 0.012)),
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(text: tag),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: TextStyle(
                                        fontSize: getDynamicHeight(size: 0.016),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                        onPressed: () async {
                          final controller = Get.find<NotificationController>();

                          final days = controller.filterOptionDaysMap[selectedFilter] ?? 0;
                          final tagString = controller.selectedTags.join(',');

                          print("Selected Days: $days"); // ✅ Check in console
                          print("Selected Tags: $tagString");
                          // await controller.clearFilters();
                          await controller.fetchNotificationList(days: days, tag: tagString);

                          Get.back();
                        },
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
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          controller.fetchNotificationList();
                          await controller.clearFilters();
                          Navigator.pop(context);
                          controller.update();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppColor.primaryColor)),
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
              padding: EdgeInsets.all(getDynamicHeight(size: 0.016)),
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
                          AppString.selectdate,
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: getDynamicHeight(size: 0.020),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          await controller.fetchNotificationList(
                            days: 0, // because we're using range
                            tag: "", // future scope: can add selected tags
                          );
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
                        SizedBox(width: 12.0),
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
                  SizedBox(height: getDynamicHeight(size: 0.020)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.13,
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: ElevatedButton(
                          onPressed: () async {
                            final controller = Get.find<NotificationController>();

                            final days = controller.filterOptionDaysMap[selectedFilter] ?? 0;
                            final tagString = controller.selectedTags.join(',');

                            print("Selected Days: $days"); // ✅ Check in console
                            print("Selected Tags: $tagString");
                            await controller.fetchNotificationList(
                              days: days,
                              tag: tagString,
                              fromDate: controller.fromDateController.text,
                              toDate: controller.toDateController.text,
                            );
                            // await controller.clearFilters();

                            Get.to(NotificationScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            AppString.confirm,
                            style: AppStyle.plusblack20w700.copyWith(
                              color: AppColor.white,
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
                            FocusScope.of(context).unfocus();
                            controller.fetchNotificationList();
                            controller.selectedTags.clear();
                            controller.filesList.clear();
                            controller.fromDateController.clear();
                            controller.toDateController.clear();
                            Navigator.pop(context);
                            controller.update();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppColor.primaryColor)),
                          ),
                          child: Text(
                            AppString.cancel,
                            style: AppStyle.plusblack20w700.copyWith(
                              color: AppColor.white,
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
}
