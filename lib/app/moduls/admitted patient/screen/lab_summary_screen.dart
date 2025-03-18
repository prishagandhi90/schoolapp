import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabSummaryScreen extends StatelessWidget {
  LabSummaryScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> data = List.generate(
    20,
    (index) => {'ID': index + 1, 'Name': 'Person $index', 'Age': 20 + index, 'Salary': (index + 1) * 1000, 'Department': 'Dept ${index % 5}', 'City': 'City ${index % 3}'},
  );

  // final double rowHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    Get.put(AdpatientController());

    // Sync scrolling setup
    return GetBuilder<AdpatientController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          // backgroundColor: AppColor.white,
          title: Text('Lab Summary'),
          centerTitle: true,
        ),
        body: CustomScrollView(slivers: [
          SliverAppBar(
            // backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            expandedHeight: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.105 // Portrait Mode Height
                : MediaQuery.of(context).size.height * 0.24, // Dynamic Height
            pinned: false,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(left: 12, right: 12, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Patient Name",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "Status",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        cursorColor: AppColor.black,
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.lightgrey1, width: 1.0),
                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                            borderSide: BorderSide(color: AppColor.black),
                          ),
                          prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                          hintText: AppString.searchpatient,
                          hintStyle: AppStyle.plusgrey,
                          filled: true,
                          fillColor: AppColor.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(getDynamicHeight(size: 0.027))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: SizedBox(
              height: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side (ID & Name) - Independent vertical scroll
                  Column(
                    children: [
                      Row(
                        children: [
                          _buildFixedHeaderCell("Report"),
                          _buildFixedHeaderCell("Test"),
                          _buildFixedHeaderCell("Range", overflow: true),
                        ],
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          controller: controller.verticalScrollControllerLeft,
                          child: Column(
                            children: List.generate(controller.labdata.length, (index) {
                              var item = controller.labdata[index]; // API data

                              // Track maximum height for the row (left & right side)
                              double maxHeight = _getMaxRowHeight(index, controller);

                              // Use maxHeight for both left & right columns
                              return Row(
                                children: [
                                  _buildFixedCell("${item.formattest.toString()}", height: maxHeight),
                                  _buildFixedCell("${item.testName.toString()}", height: maxHeight),
                                  _buildFixedCell("${item.normalRange.toString()}", overflow: true, height: maxHeight),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Right side (Data Table) - Horizontal & Vertical Scroll
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller.horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Row(
                            children: controller.labdata.isNotEmpty
                                ? controller.labdata[0].dateValues!.keys.map((date) {
                                    return _buildHeaderCell(date, width: getDynamicHeight(size: 0.090));
                                  }).toList()
                                : [],
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              controller: controller.verticalScrollControllerRight,
                              child: Column(
                                children: List.generate(controller.labdata.length, (index) {
                                  var item = controller.labdata[index]; // API data

                                  // Track maximum height for the row (left & right side)
                                  double maxHeight = _getMaxRowHeight(index, controller);

                                  return Row(
                                    children: item.dateValues!.entries.map((entry) {
                                      return _buildDataCell("${entry.value}", width: getDynamicHeight(size: 0.090), height: maxHeight);
                                    }).toList(),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      );
    });
  }

  // Method to calculate max height for a given row (left and right sync)
  double _getMaxRowHeight(int index, AdpatientController controller) {
    var item = controller.labdata[index];

    // Calculate left side height
    double leftHeight = _calculateCellHeight(item.formattest ?? '') + _calculateCellHeight(item.testName ?? '') + _calculateCellHeight(item.normalRange ?? '');

    // Calculate right side height (maximum height of the date columns)
    double rightHeight = item.dateValues!.entries.map((entry) {
      return _calculateCellHeight(entry.value ?? '');
    }).reduce((a, b) => a > b ? a : b); // Choose the max height from the right side columns

    // Return the max height between left and right columns for sync
    return leftHeight > rightHeight ? leftHeight : rightHeight;
  }

// Helper function to calculate the height of each cell's content
  double _calculateCellHeight(String content) {
    // Logic to estimate the height based on content length (you can adjust this)
    double baseHeight = 40.0; // base height for a cell
    // double extraHeight = content.length > 20 ? content.length * 0.5 : 0; // Adjust based on content length
    double extraHeight = _calculateTextHeight(content);
    return baseHeight + extraHeight;
  }

  // Helper function to calculate the height based on content using TextPainter
  double _calculateTextHeight(String content) {
    // Create a TextPainter object to measure the text height
    TextPainter painter = TextPainter(
      text: TextSpan(text: content, style: TextStyle(fontSize: 14.0)), // Adjust font size here if needed
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
    );

    painter.layout(maxWidth: double.infinity); // Measure the text layout

    // Return the height of the text
    return painter.height;
  }

  Widget _buildFixedHeaderCell(String text, {bool overflow = false}) {
    return Container(
      width: 80,
      height: 50.0,
      padding: EdgeInsets.only(
        left: 8.0,
        top: 8.0,
        bottom: 8.0,
      ),
      alignment: Alignment.centerLeft,
      color: Colors.grey[400],
      child: Text(
        text,
        maxLines: 1,
        overflow: overflow ? TextOverflow.ellipsis : TextOverflow.visible,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {double width = 100}) {
    return Container(
      width: width,
      height: 50.0,
      padding: EdgeInsets.only(
        left: 8.0,
        top: 8.0,
        bottom: 8.0,
      ),
      alignment: Alignment.centerLeft,
      color: Colors.blueGrey,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildFixedCell(String text, {bool overflow = false, double height = 80}) {
    return Container(
      width: 80,
      height: height,
      padding: EdgeInsets.only(
        left: 8.0,
        top: 8.0,
        bottom: 8.0,
      ),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
        color: Colors.grey[200],
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: overflow ? TextOverflow.ellipsis : TextOverflow.visible,
      ),
    );
  }

  // Widget _buildDataCell(String text, {double width = 80}) {
  //   return Container(
  //     width: width,
  //     height: rowHeight,
  //     padding: EdgeInsets.only(
  //       left: 8.0,
  //       top: 8.0,
  //       bottom: 8.0,
  //     ),
  //     alignment: Alignment.centerLeft,
  //     decoration: BoxDecoration(
  //       border: Border(bottom: BorderSide(color: Colors.black12)),
  //       color: Colors.white,
  //     ),
  //     child: Text(text),
  //   );
  // }

  Widget _buildDataCell(String value, {double width = 100, double height = 50}) {
    List<String> lines = value.split("\n"); // Split into multiple lines

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Table border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) {
          List<String> parts = line.split("|"); // Split by '|'
          String text = parts.first; // The actual value (e.g., "Blood 1")
          bool isHighlighted = parts.length > 1 && parts.last.trim() == "True"; // Check if 'True'

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.pink.withOpacity(0.5) : Colors.transparent, // Background color logic
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              text,
              style: TextStyle(color: Colors.black), // Text color
            ),
          );
        }).toList(),
      ),
    );
  }
}
