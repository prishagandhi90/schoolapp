import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
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
        return Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              backgroundColor: AppColor.white,
              title: Text('Investigation Services', style: AppStyle.primaryplusw700),
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
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 300));
                      controller.update();
                    },
                    cursorColor: AppColor.grey,
                    controller: controller.searchController,
                    decoration: InputDecoration(
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
                      prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                      suffixIcon: controller.hasFocus
                          ? IconButton(
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: AppColor.black,
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (controller.searchController.text.trim().isNotEmpty) {
                                  controller.searchservice('', controller.ipdNo);
                                }
                                controller.searchController.clear();
                                controller.update();
                              },
                            )
                          : null,
                      hintText: 'Search Test',
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
                      // controller.filterSearchAdPatientResults(value);
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
                                  height: getDynamicHeight(size: 0.038),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: controller.topOptions.map((top) {
                                      final isSelected = controller.selectedTop == top;
                                      return InkWell(
                                        onTap: () async {
                                          await controller.changeTop(top);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Top $top',
                                              style: TextStyle(
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: getDynamicHeight(size: 0.005),
                                            ),
                                            Container(
                                              height: getDynamicHeight(size: 0.0035),
                                              width: getDynamicHeight(size: 0.058),
                                              color: isSelected ? AppColor.primaryColor : Colors.transparent,
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Divider(
                                  thickness: getDynamicHeight(size: 0.0008),
                                  height: getDynamicHeight(size: 0.0008),
                                ),
                                Expanded(
                                    flex: 5,
                                    child: ListView.separated(
                                      itemCount: controller.getQueryList.length,
                                      separatorBuilder: (context, index) => Divider(
                                        height: getDynamicHeight(size: 0.0008),
                                        thickness: 0.8,
                                        color: AppColor.darkgery,
                                      ),
                                      itemBuilder: (context, index) {
                                        final service = controller.getQueryList[index];
                                        return ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: getDynamicHeight(size: 0.007),
                                          ),
                                          title: Text(
                                            service.name.toString(),
                                            style: TextStyle(
                                              fontSize: getDynamicHeight(size: 0.0125),
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.add_circle,
                                              color: Colors.teal,
                                              size: getDynamicHeight(size: 0.018),
                                            ),
                                            onPressed: () async {
                                              if (controller.typeController.text.toLowerCase() == 'other investigation') {
                                                bool isDuplicateService = true;
                                                isDuplicateService = controller.isDuplicateService(service.id.toString());
                                                if (isDuplicateService) {
                                                  Get.snackbar(
                                                    'Notice',
                                                    'Service already added',
                                                    backgroundColor: Colors.orange.shade100,
                                                    colorText: Colors.black,
                                                    snackPosition: SnackPosition.BOTTOM,
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
                                      "Selected Services",
                                      style: TextStyle(
                                        fontSize: getDynamicHeight(size: 0.015),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                ),
                                // 🔹 Selected Services List
                                Expanded(
                                  flex: 4,
                                  child: ListView.builder(
                                    itemCount: controller.selectedServices.length,
                                    itemBuilder: (context, index) {
                                      final service = controller.selectedServices[index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: getDynamicHeight(size: 0.003),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: getDynamicHeight(size: 0.007),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColor.darkgery),
                                          borderRadius: BorderRadius.circular(
                                            getDynamicHeight(size: 0.007),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                service.serviceName.toString(),
                                                style: TextStyle(
                                                  fontSize: getDynamicHeight(size: 0.0125),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.cancel, color: Colors.black),
                                              onPressed: () {
                                                controller.selectedServices.removeAt(index);
                                                controller.update();
                                              },
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
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                bottom: getDynamicHeight(size: 0.0375),
                left: getDynamicHeight(size: 0.007),
                right: getDynamicHeight(size: 0.007),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 167, 166, 166), // Same as ElevatedButton
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // No border radius
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: getDynamicHeight(size: 0.0135),
                        ), // Same vertical padding
                      ),
                      child: Text(
                        controller.webUserName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: getDynamicHeight(size: 0.013),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  SizedBox(width: getDynamicHeight(size: 0.0085)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.fetchGetHistoryList(controller.ipdNo);
                        controller.HistoryBottomSheet();
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
                        'History',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getDynamicHeight(size: 0.0085),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isSaveButtonEnabled()
                          ? () async {
                              await controller.saveSelectedServiceList(controller.ipdNo);
                            }
                          : null,
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
                        'Save',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
