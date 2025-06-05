import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/invest_requisit/controller/invest_requisit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvestServiceScreen extends StatelessWidget {
  const InvestServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InvestRequisitController());
    return GetBuilder<InvestRequisitController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () async {
            // FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside of text fields
            await controller.clearSrvScreenSearchFilters();
          },
          behavior: HitTestBehavior.opaque,
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: AppColor.white,
              appBar: AppBar(
                backgroundColor: AppColor.white,
                title: Text(AppString.investigationservices, style: AppStyle.primaryplusw700),
                centerTitle: true,
              ),
              body: Padding(
                padding: EdgeInsets.all(
                  getDynamicHeight(size: 0.007),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(
                          color: AppColor.black,
                          width: getDynamicHeight(size: 0.0015),
                        ),
                        borderRadius: BorderRadius.circular(
                          getDynamicHeight(size: 0.008),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(getDynamicHeight(size: 0.010)),
                        child: Text(
                          controller.patientName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: CommonFontStyle.plusJakartaSans,
                            fontSize: getDynamicHeight(size: 0.013),
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getDynamicHeight(size: 0.004),
                    ),
                    TextFormField(
                      focusNode: controller.focusNode,
                      onTap: () => controller.update(),
                      onTapOutside: (event) async {
                        Future.delayed(const Duration(milliseconds: 300));
                        await controller.clearSrvScreenSearchFilters();
                      },
                      cursorColor: AppColor.grey,
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.black,
                            width: getDynamicHeight(size: 0.0008),
                          ),
                          borderRadius: BorderRadius.circular(
                            getDynamicHeight(size: 0.008),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            getDynamicHeight(size: 0.008),
                          ),
                          borderSide: BorderSide(
                            color: AppColor.black,
                          ),
                        ),
                        prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1, size: getDynamicHeight(size: 0.020)),
                        suffixIcon: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            if (controller.searchController.text.trim().isNotEmpty) {
                              controller.searchservice('', controller.ipdNo);
                            }
                            controller.focusNode.unfocus();
                            // FocusScope.of(context).unfocus();
                            controller.searchController.clear();
                            controller.update();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.cancel,
                              color: Colors.black,
                              size: getDynamicHeight(size: 0.024),
                            ), // ✅ Cancel button color
                          ),
                        ),
                        hintText: AppString.searchtest,
                        hintStyle: TextStyle(
                          color: AppColor.lightgrey1,
                          fontFamily: CommonFontStyle.plusJakartaSans,
                        ),
                        filled: true,
                        focusColor: AppColor.originalgrey,
                        fillColor: AppColor.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              getDynamicHeight(size: 0.023),
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        controller.searchservice(value, controller.ipdNo);
                      },
                      onFieldSubmitted: (v) async {
                        // if (controller.searchController.text.trim().isNotEmpty) {
                        //   controller.fetchNotificationList();
                        //   controller.searchController.clear();
                        // }
                        await controller.clearSrvScreenSearchFilters();
                      },
                    ),
                    SizedBox(
                      height: getDynamicHeight(size: 0.009),
                    ),
                    // 👇 Suggested + Selected Services
                    Expanded(
                        child: controller.isLoading
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: getDynamicHeight(size: 0.097),
                                  ),
                                  child: ProgressWithIcon(),
                                ),
                              )
                            : Column(
                                children: [
                                  // SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.only(bottom: getDynamicHeight(size: 0.004)),
                                    height: getDynamicHeight(size: 0.045),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: controller.topOptions.map((top) {
                                        final isSelected = controller.selectedTop == top;
                                        return InkWell(
                                          onTap: () async {
                                            await controller.changeTop(top);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: (Sizes.w * 0.7) / controller.topOptions.length, // 👈 half screen width divided equally
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: isSelected ? AppColor.primaryColor : AppColor.lightblue,
                                              borderRadius: BorderRadius.circular(10), // 👈 no rounding
                                            ),
                                            child: Text(
                                              'Top $top',
                                              style: AppStyle.black.copyWith(
                                                color: isSelected ? Colors.white : AppColor.black,
                                              ),
                                              // style: TextStyle(
                                              //   fontWeight: FontWeight.w600,
                                              //   color: isSelected ? Colors.white : AppColor.black,
                                              //   fontFamily: CommonFontStyle.plusJakartaSans,
                                              // ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                      height: 0.3, // very thin divider
                                      color: AppColor.darkgery,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: ListView.separated(
                                        itemCount: controller.getQueryList.length,
                                        separatorBuilder: (context, index) => SizedBox(
                                          height: 0.3, // almost no space
                                          child: Container(
                                            color: AppColor.darkgery,
                                          ),
                                        ),
                                        itemBuilder: (context, index) {
                                          final service = controller.getQueryList[index];
                                          return ListTile(
                                            dense: true,
                                            visualDensity: VisualDensity(vertical: -4), // Reduce vertical height
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: getDynamicHeight(size: 0.003),
                                              vertical: 0,
                                            ),
                                            title: Text(
                                              service.name.toString(),
                                              style: AppStyle.black.copyWith(
                                                fontSize: getDynamicHeight(size: 0.0135),
                                              ),
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.add_circle,
                                                color: AppColor.teal,
                                                size: getDynamicHeight(size: 0.025),
                                              ),
                                              onPressed: () async {
                                                if (controller.typeController.text.toLowerCase() == 'other investigation') {
                                                  bool isDuplicateService = true;
                                                  isDuplicateService = controller.isDuplicateService(service.id.toString());
                                                  if (isDuplicateService) {
                                                    Get.snackbar(
                                                      AppString.notice,
                                                      AppString.servicealreadyadded,
                                                      backgroundColor: Colors.orange.shade100,
                                                      colorText: Colors.black,
                                                      snackPosition: SnackPosition.TOP,
                                                      duration: Duration(seconds: 1),
                                                    );
                                                    return;
                                                  }
                                                  controller.suggestions_DrNm.clear();
                                                  controller.drNameController.text = '';
                                                  controller.drIdController.text = '';
                                                  controller.update();
                                                  await controller.otherInvestDialog(context, service);
                                                  return;
                                                }
                                                await controller.addService(service);
                                              },
                                            ),
                                          );
                                        },
                                      )),
                                  Divider(),
                                  // 🔹 Selected Services Title
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: getDynamicHeight(size: 0.008),
                                      ),
                                      child: Text(
                                        AppString.selectedservices,
                                        style: TextStyle(
                                          fontSize: getDynamicHeight(size: 0.015),
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.teal,
                                          // decorationColor: AppColor.lightblue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 🔹 Selected Services List
                                  Expanded(
                                    flex: 4,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: controller.selectedServices.length,
                                      itemBuilder: (context, index) {
                                        final service = controller.selectedServices[index];
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: getDynamicHeight(size: 0.002), // thodi si spacing upar neeche
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: getDynamicHeight(size: 0.004), // thoda side space
                                            vertical: getDynamicHeight(size: 0.005), // thoda vertical padding for height
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColor.darkgery, width: 0.5),
                                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.005)),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      service.serviceName.toString(),
                                                      style: TextStyle(
                                                        fontSize: getDynamicHeight(size: 0.0125),
                                                      ),
                                                    ),
                                                    if (service.drName.trim().isNotEmpty) ...[
                                                      SizedBox(height: getDynamicHeight(size: 0.004)),
                                                      Text(
                                                        service.drName, // Replace as needed
                                                        style: TextStyle(
                                                          fontSize: getDynamicHeight(size: 0.010),
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  controller.selectedServices.removeAt(index);
                                                  controller.update();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(getDynamicHeight(size: 0.002)),
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: AppColor.black,
                                                    size: getDynamicHeight(size: 0.020),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ))
                  ],
                ),
              ),
              // 🔽 Bottom Navigation Bar (3 Buttons)
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                  bottom: getDynamicHeight(size: 0.002),
                  left: getDynamicHeight(size: 0.007),
                  right: getDynamicHeight(size: 0.007),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: getDynamicHeight(size: 0.05), // 👈 Fixed height for all buttons
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 167, 166, 166),
                            foregroundColor: AppColor.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 0), // 👈 Remove vertical padding
                          ),
                          child: Center(
                            child: Text(
                              controller.webUserName,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: getDynamicHeight(size: 0.013),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getDynamicHeight(size: 0.0085)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // FocusScope.of(context).unfocus();
                          if (controller.isHistorySheetOpen) return;
                          controller.isHistorySheetOpen = true;
                          await controller.fetchGetHistoryList(controller.ipdNo);
                          await controller.HistoryBottomSheet();
                          await controller.clearSrvScreenSearchFilters();
                          controller.isHistorySheetOpen = false;
                          controller.update();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: getDynamicHeight(size: 0.0125),
                          ),
                        ),
                        child: Text(
                          AppString.history,
                          style: TextStyle(color: AppColor.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getDynamicHeight(size: 0.0085),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (controller.isSaveButtonClicked) return;
                          controller.isSaveButtonClicked = true;
                          if (controller.isSaveButtonEnabled()) {
                            await controller.saveSelectedServiceList(controller.ipdNo);
                          } else {
                            if (controller.isSaveButtonClicked) return;
                            controller.isSaveButtonClicked = false;
                            controller.update();
                            return null;
                          }
                          controller.isSaveButtonClicked = false;
                          controller.update();
                        },
                        // onPressed: () {
                        //   controller.saveSelectedServiceList(controller.ipdNo);
                        // },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: getDynamicHeight(size: 0.0125),
                          ),
                        ),
                        child: Text(
                          AppString.save,
                          style: TextStyle(color: AppColor.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
