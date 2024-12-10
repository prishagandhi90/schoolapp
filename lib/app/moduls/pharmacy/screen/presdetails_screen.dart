import 'dart:ui';

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/moduls/pharmacy/controller/pharmacy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PresdetailsScreen extends StatelessWidget {
  PresdetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PharmacyController());
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    double availableHeight = MediaQuery.of(context).size.height - statusBarHeight - 270.0;
    return GetBuilder<PharmacyController>(
      builder: (controller) {
        void checkAllBlurred() {
          if (controller.blurState.every((blur) => blur)) {
            // Show alert when all items are blurred
            Get.defaultDialog(
              title: "COMPLETED!!!",
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
                  bottom: Radius.circular(40),
                ),
              ),
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                  top: statusBarHeight + 10, // Account for the status bar height
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: controller.presviewerList.isNotEmpty && controller.SelectedIndex >= 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.presviewerList[controller.SelectedIndex].patientName.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.presviewerList[controller.SelectedIndex].ipd.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: CommonFontStyle.plusJakartaSans,
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    controller.presviewerList[controller.SelectedIndex].bed.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.presviewerList[controller.SelectedIndex].mop.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: CommonFontStyle.plusJakartaSans,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      controller.presviewerList[controller.SelectedIndex].intercom.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.w500,
                                        fontFamily: CommonFontStyle.plusJakartaSans,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                  'assets/image/qr-code.png', // Replace with your image path
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(child: Text('No  data available')),
                      ),
              ),
            ),
          ),
          body: controller.presdetailList.isNotEmpty
              ? LayoutBuilder(builder: (context, constraints) {
                  // Check if content height exceeds available height
                  bool isScrollable = constraints.maxHeight > availableHeight;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: SingleChildScrollView(
                      controller: isScrollable ? controller.pharmacyScrollController : null,
                      // physics: isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight + 100.0, // Minimum height to force scrolling
                        ),
                        child: Scrollbar(
                          // controller: isScrollable ? controller.pharmacyScrollController : null,
                          thickness: 10, //According to your choice
                          thumbVisibility: false, //
                          radius: Radius.circular(5),
                          child: ListView.builder(
                              itemCount: controller.presdetailList.length,
                              // controller: isScrollable ? controller.pharmacyScrollController : null,
                              physics: isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
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
                                          width: double.infinity, // Centered container width
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(70),
                                          ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(70),
                                                        bottomLeft: Radius.circular(70),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                                                          // const SizedBox(height: 5),
                                                          Text.rich(
                                                            TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: 'Generic Drug: ',
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
                                                      color: AppColor.lightblue, // Replace with your blue color
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
                                                                  text: 'Quantity: ',
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
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Text.rich(
                                                            TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: 'Pkg: ',
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
                                      // Blur effect layer
                                      if (index < controller.blurState.length && controller.blurState[index])
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(70),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                              child: Container(
                                                color: Colors.black.withOpacity(0.2), // Add a slight overlay
                                              ),
                                            ),
                                          ),
                                        ),
                                      // Divider only below the last item
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
                              }),
                        ),
                      ),
                    ),
                  );
                })
              : const Center(child: Text('No data available')),
        );
      },
    );
  }
}
