import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LvotapprovalController extends GetxController {
  final TextEditingController searchController = TextEditingController();
   bool isSearching = false; // To track search bar visibility

  void startSearch() {
    isSearching = true;
    update(); // Notify UI
  }

  void cancelSearch() {
    isSearching = false;
    searchController.clear();
    update(); // Notify UI
  }

  Future<void> lvotlistbottomsheet(BuildContext context, int index) async {
    showModalBottomSheet(
        backgroundColor: AppColor.white,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: Get.context!,
        // constraints: BoxConstraints(
        //   maxWidth: MediaQuery.of(context).size.width * 0.95,
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: AppColor.black),
        ),
        builder: (context) {
          return Column(children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 30),
                const Spacer(),
                Container(
                  width: 90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: Divider(height: 20, color: AppColor.originalgrey, thickness: 5),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              // height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: AppColor.lightblue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.primaryColor),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            AppString.punch,
                            style: AppStyle.w50018,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // controller.attendenceDetailTable.length > 0
                        //     ?
                        Text(
                          'IN',
                          // controller.attendenceDetailTable[index].punch.toString(),
                          style: AppStyle.fontfamilyplus,
                        )
                        // : Text('--:-- ', style: AppStyle.plus16w600),
                      ],
                    ),
                  )
                ],
              ),
            )
          ]);
        });
  }
}
