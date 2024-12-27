import 'dart:ui';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_image.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/moduls/pharmacy/controller/pharmacy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PresdetailsScreen extends StatelessWidget {
  PresdetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PharmacyController());
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    double availableHeight = MediaQuery.of(context).size.height - statusBarHeight - 280.0;
    return GetBuilder<PharmacyController>(
      builder: (controller) {
        void checkAllBlurred() {
          if (controller.blurState.every((blur) => blur)) {
            // Show alert when all items are blurred
            Get.defaultDialog(
              title: AppString.completed,
              middleText: "All items have been collected! \nJust go back and continue with other patients!",
              onConfirm: () => Get.back(), // Close the dialog
            );
          }
        }

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(200), // Ensure sufficient height
            child: AppBar(
              backgroundColor: AppColor.lightblue,
              automaticallyImplyLeading: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                  top: statusBarHeight + 10, // Account for the status bar height
                  left: 20,
                  right: 20,
                  bottom: 0,
                ),
                child: controller.presviewerList.isNotEmpty && controller.SelectedIndex >= 0
                    ? Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.presviewerList[controller.SelectedIndex].patientName.toString(),
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(controller.presviewerList[controller.SelectedIndex].ipd.toString(), style: AppStyle.plus16
                                              // TextStyle(
                                              //   fontSize: 16,
                                              //   fontFamily: CommonFontStyle.plusJakartaSans,
                                              // ),
                                              ),
                                          SizedBox(height: 5), // Space between IPD and MOP
                                          Text(
                                            controller.presviewerList[controller.SelectedIndex].mop.toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.presviewerList[controller.SelectedIndex].bed.toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                            ),
                                          ),
                                          SizedBox(height: 5), // Space between Bed and Intercom
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: AppString.intercom, // Bold label
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: controller.presviewerList[controller.SelectedIndex].intercom.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.presviewerList[controller.SelectedIndex].dte.toString(),
                                            style: TextStyle(fontSize: 16, fontFamily: CommonFontStyle.plusJakartaSans),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            controller.presviewerList[controller.SelectedIndex].doctor.toString(),
                                            style: TextStyle(fontSize: 16, fontFamily: CommonFontStyle.plusJakartaSans),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        AppImage.qrcode, // Replace with your image path
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text(AppString.nodataavailable)),
                      ),
              ),
            ),
          ),
          body: controller.presdetailList.isNotEmpty
              ? LayoutBuilder(builder: (context, constraints) {
                  double ConstraintsHeight = constraints.maxHeight; // Ensure scrolling
                  int listItemsCount = controller.presdetailList.length; // Ensure scrolling
                  print("Screen Height: ${MediaQuery.of(context).size.height}");
                  print("ConstraintsHeight: ${ConstraintsHeight.toString()}");
                  // print("RealListHeight: ${controller.presdetailList.length * 100.0}");
                  // print("statusBarHeight: ${MediaQuery.of(context).padding.top}");
                  // print("List Height: ${listHeight}");
                  print("Available Height: ${availableHeight}");
                  print("ListItemsCount height: ${listItemsCount.toString()}");
                  bool isScrollable = (ConstraintsHeight) > availableHeight;
                  print("isScrollable height: ${isScrollable.toString()}");
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10), // Adjust as needed
                    // child: SingleChildScrollView(
                    // controller: isScrollable ? controller.pharmacyScrollController : null,
                    // physics:
                    //     isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                    // controller: controller.pharmacyScrollController,
                    // physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: ConstraintsHeight - 80.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: controller.pharmacyScrollController,
                        physics: const AlwaysScrollableScrollPhysics(), // Disable internal scrolling
                        itemCount: controller.presdetailList.length,
                        itemBuilder: (context, index) {
                          bool isLastItem = index == controller.presdetailList.length - 1;
                          return GestureDetector(
                            onTap: () {
                              controller.toggleBlur(index);
                              checkAllBlurred();
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColor.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(70),
                                                  bottomLeft: Radius.circular(70),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      controller.presdetailList[index].formBrand.toString(),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.genericdrug,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: controller.presdetailList[index].genericName.toString(),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      softWrap: true, // Allow text to wrap
                                                      overflow: TextOverflow.visible, // Prevent text clipping
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColor.lightblue,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(70),
                                                  bottomRight: Radius.circular(70),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.quantity,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: controller.presdetailList[index].qty.toString(),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      softWrap: true,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.pkg,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: controller.presdetailList[index].pkg.toString(),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      softWrap: true,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (index < controller.blurState.length && controller.blurState[index])
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(70),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (isLastItem)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Divider(
                                      color: AppColor.red,
                                      thickness: 2,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                })
              : Center(child: Text(AppString.nodataavailable)),
        );
      },
    );
  }
}
