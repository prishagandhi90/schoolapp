// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/pharmacy/controller/pharmacy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PresdetailsScreen extends StatelessWidget {
  PresdetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PharmacyController());

    double fullScreenHeight = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    print('\n');
    print('Full Screen Height: $fullScreenHeight');
    print('Status Bar Height: $statusBarHeight');

    double fullScreenWidth = MediaQuery.of(context).size.width;
    print('Full Screen Width: $fullScreenWidth');

    // double appBarHeight = AppBar().preferredSize.height;

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

        String patientName = controller.presviewerList[controller.SelectedIndex].patientName.toString();
        TextStyle textStyle = TextStyle(
          color: AppColor.black,
          // fontSize: 20,
          fontSize: getDynamicHeight(size: 0.022),
          fontWeight: FontWeight.bold,
        );

        Size textSize = calculateTextSize(patientName, textStyle, fullScreenWidth * 0.9); // 90% width max
        // double textHeight = textSize.height;
        double textWidth = textSize.width;

        bool isWrapped = textWidth > (fullScreenWidth * 0.8);
        print("textWidth: $textWidth");
        print("patientName: $patientName");
        print("isWrapped: $isWrapped");

        double appBarHeight =
            isWrapped == false ? (fullScreenHeight * (16.0 / 100)).toDouble() : (fullScreenHeight * (19.0 / 100)).toDouble();
        print('appbar height: $appBarHeight');

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight), // Ensure sufficient height
            child: AppBar(
              backgroundColor: AppColor.lightblue,
              automaticallyImplyLeading: false,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.vertical(
              //     bottom: Radius.circular(30),
              //   ),
              // ),
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                  top: statusBarHeight + 2.0, // Account for the status bar height
                  left: fullScreenWidth * (4.73 / 100),
                  right: fullScreenWidth * (4.73 / 100),
                  bottom: 0,
                ),
                child: controller.presviewerList.isNotEmpty && controller.SelectedIndex >= 0
                    ? Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    controller.presviewerList[controller.SelectedIndex].patientName.toString(),
                                    style: TextStyle(
                                      color: AppColor.black,
                                      // fontSize: 20,
                                      fontSize: getDynamicHeight(size: 0.022),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2, // Allow wrapping in 2 lines
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.presviewerList[controller.SelectedIndex].ipd.toString(),
                                            style: AppStyle.plus16,
                                          ),
                                          SizedBox(height: fullScreenWidth * (1.1 / 100)), // Space between IPD and MOP
                                          Text(
                                            controller.presviewerList[controller.SelectedIndex].mop.toString(),
                                            style: TextStyle(
                                              // fontSize: 16,
                                              fontSize: getDynamicHeight(size: 0.018),
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                              fontWeight: FontWeight.w700,
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
                                              // fontSize: 16,
                                              fontSize: getDynamicHeight(size: 0.018),
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                            ),
                                          ),
                                          SizedBox(height: fullScreenWidth * (1.1 / 100)), // Space between Bed and Intercom
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: AppString.intercom, // Bold label
                                                  style: TextStyle(
                                                    // fontSize: 16,
                                                    fontSize: getDynamicHeight(size: 0.018),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: controller.presviewerList[controller.SelectedIndex].intercom.toString(),
                                                  style: TextStyle(
                                                    // fontSize: 16,
                                                    fontSize: getDynamicHeight(size: 0.018),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Column for Date and Doctor
                                    Expanded(
                                      child: Text(
                                        controller.presviewerList[controller.SelectedIndex].dte.toString(),
                                        style: TextStyle(
                                          // fontSize: 16,
                                          fontSize: getDynamicHeight(size: 0.018),
                                          fontFamily: CommonFontStyle.plusJakartaSans,
                                        ),
                                      ),
                                    ),
                                    // Token No and QR Code Image
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: AppString.tokenNo, // Bold label
                                              style: TextStyle(
                                                // fontSize: 16,
                                                fontSize: getDynamicHeight(size: 0.018),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
                                            TextSpan(
                                              text: controller.presviewerList[controller.SelectedIndex].tokenNo.toString(),
                                              style: TextStyle(
                                                // fontSize: 18,
                                                fontSize: getDynamicHeight(size: 0.020),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: CommonFontStyle.plusJakartaSans,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Column for Date and Doctor
                                        Expanded(
                                          child: Text(
                                            // 'lfkjdslkfjsdlkjflkjsdlkfjlksdjflksdlkjflksdjlkfjsdlkjflkjsdlk',
                                            controller.presviewerList[controller.SelectedIndex].doctor.toString(),
                                            style: TextStyle(
                                              // fontSize: 16,
                                              fontSize: getDynamicHeight(size: 0.018),
                                              fontFamily: CommonFontStyle.plusJakartaSans,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: fullScreenWidth * (1.1 / 100)),
                                      ],
                                    ),
                                    // Positioned(
                                    //   // top: 0, // Move QR code upwards
                                    //   right: 10, // Adjust alignment if needed
                                    //   child: Image.asset(
                                    //     AppImage.qrcode, // Replace with your image path
                                    //     height: 50,
                                    //     width: 50,
                                    //     fit: BoxFit.contain,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.all(fullScreenWidth * (1.1 / 100)),
                        child: Center(child: Text(AppString.nodataavailable)),
                      ),
              ),
            ),
          ),
          body: controller.isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: Center(child: ProgressWithIcon()),
                )
              : controller.presdetailList.isNotEmpty
                  ? Stack(
                      children: [
                        LayoutBuilder(builder: (context, constraints) {
                          double ConstraintsHeight = constraints.maxHeight; // Ensure scrolling
                          print('Constraints Height: $ConstraintsHeight');
                          // int listItemsCount = controller.presdetailList.length; // Ensure scrolling
                          // bool isScrollable = (ConstraintsHeight) > availableHeight;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 9), // Adjust as needed
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
                                                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                "${index + 1}.", // Serial number starts from 1
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  // fontSize: 16,
                                                                  fontSize: getDynamicHeight(size: 0.018),
                                                                  color: AppColor.black,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 2,
                                                              ),
                                                              SizedBox(width: 8),
                                                              Expanded(
                                                                child: Text(
                                                                  controller.presdetailList[index].formBrand.toString(),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    // fontSize: 15,
                                                                    fontSize: getDynamicHeight(size: 0.017),
                                                                  ),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 20),
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: controller.presdetailList[index].genericName.toString(),
                                                                    style: TextStyle(
                                                                      // fontSize: 14,
                                                                      fontSize: getDynamicHeight(size: 0.016),
                                                                      fontStyle: FontStyle.italic,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              softWrap: true, // Allow text to wrap
                                                              overflow: TextOverflow.visible, // Prevent text clipping
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColor.lightblue,
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(70),
                                                      bottomRight: Radius.circular(70),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
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
                                                                  // fontSize: 14,
                                                                  fontSize: getDynamicHeight(size: 0.016),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: controller.presdetailList[index].qty.toString(),
                                                                style: TextStyle(
                                                                  // fontSize: 14,
                                                                  fontSize: getDynamicHeight(size: 0.016),
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
                                                                  // fontSize: 14,
                                                                  fontSize: getDynamicHeight(size: 0.016),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: controller.presdetailList[index].pkg.toString(),
                                                                style: TextStyle(
                                                                  // fontSize: 14,
                                                                  fontSize: getDynamicHeight(size: 0.016),
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
                                                )
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
                                              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                                              child: Container(
                                                color: Colors.black.withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (isLastItem)
                                        Positioned(
                                          bottom: -5,
                                          left: 0,
                                          right: 0,
                                          child: Divider(
                                            color: AppColor.red,
                                            thickness: 2,
                                          ),
                                        ),
                                      // Add Down Arrow
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                        (controller.showScrollDownArrow.value)
                            ? Positioned(
                                right: 10,
                                bottom: fullScreenHeight * (3.83 / 100), // Adjust the position of the arrow
                                child: GestureDetector(
                                  onTap: () {
                                    // Scroll to the bottom when the arrow is tapped
                                    // controller.pharmacyScrollController
                                    //     .jumpTo(controller.pharmacyScrollController.position.maxScrollExtent);
                                    controller.pharmacyScrollController.animateTo(
                                      controller.pharmacyScrollController.position.maxScrollExtent, // Target position
                                      duration: Duration(milliseconds: 500), // Duration of the scroll
                                      curve: Curves.easeInOut, // Animation curve
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Background color
                                      shape: BoxShape.circle, // Circle shape
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1), // Shadow effect
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_downward,
                                        color: AppColor.black, // Arrow color
                                        size: 28, // Arrow size
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        (controller.showScrollUpArrow.value)
                            ? Positioned(
                                right: 10,
                                top: 20,
                                // bottom: fullScreenHeight * (10.83 / 100), // Adjust the position of the arrow
                                child: GestureDetector(
                                  onTap: () {
                                    // Scroll to the bottom when the arrow is tapped
                                    // controller.pharmacyScrollController
                                    //     .jumpTo(controller.pharmacyScrollController.position.maxScrollExtent);
                                    controller.pharmacyScrollController.animateTo(
                                      0, // Target position
                                      duration: Duration(milliseconds: 500), // Duration of the scroll
                                      curve: Curves.easeInOut, // Animation curve
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Background color
                                      shape: BoxShape.circle, // Circle shape
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1), // Shadow effect
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_upward,
                                        color: AppColor.black, // Arrow color
                                        size: 28, // Arrow size
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    )
                  : Center(child: Text(AppString.nodataavailable)),
        );
      },
    );
  }
}

Size calculateTextSize(String text, TextStyle style, double maxWidth) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1, // Tumhare case me max 2 lines allowed hai
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  return textPainter.size;
}
