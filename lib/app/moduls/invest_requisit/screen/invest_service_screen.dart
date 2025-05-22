import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_style.dart';
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                        borderSide: BorderSide(color: AppColor.black, width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                    onChanged: (value) {
                      controller.searchservice(value, controller.ipdNo);
                      // controller.filterSearchAdPatientResults(value);
                    },
                  ),
                  SizedBox(height: 10),

                  // 👇 Suggested + Selected Services
                  Expanded(
                      child: controller.isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 100),
                                child: ProgressWithIcon(),
                              ),
                            )
                          : Column(
                              children: [
                                // SizedBox(height: 10),
                                Container(
                                  height: 40,
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
                                            SizedBox(height: 6),
                                            Container(
                                              height: 4,
                                              width: 60,
                                              color: isSelected ? AppColor.primaryColor : Colors.transparent,
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Divider(thickness: 1, height: 1),
                                Expanded(
                                    flex: 5,
                                    child: ListView.separated(
                                      itemCount: controller.getQueryList.length,
                                      separatorBuilder: (context, index) => Divider(
                                        height: 1,
                                        thickness: 0.8,
                                        color: AppColor.darkgery,
                                      ),
                                      itemBuilder: (context, index) {
                                        final service = controller.getQueryList[index];
                                        return ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                          title: Text(service.name.toString(), style: TextStyle(fontSize: 14)),
                                          trailing: IconButton(
                                            icon: Icon(Icons.add_circle, color: Colors.teal, size: 20),
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
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      "Selected Services",
                                      style: TextStyle(
                                        fontSize: 16,
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
                                        margin: EdgeInsets.symmetric(vertical: 4),
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColor.darkgery),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                service.serviceName.toString(),
                                                style: TextStyle(fontSize: 14),
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
              padding: const EdgeInsets.only(bottom: 40, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // controller.HistoryBottomSheet();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'History',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isSaveButtonEnabled()
                          ? () async {
                              await controller.saveSelectedServiceList(controller.ipdNo);
                              controller.selectedServices.clear();
                              controller.update();
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
                        padding: EdgeInsets.symmetric(vertical: 14),
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
