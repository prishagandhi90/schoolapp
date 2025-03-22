import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabSummaryScreen extends StatelessWidget {
  LabSummaryScreen({Key? key}) : super(key: key);

  final double rowHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    Get.put(AdPatientController());

    // Sync scrolling setup
    return GetBuilder<AdPatientController>(builder: (controller) {
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
                          // _buildFixedHeaderCell("Range", overflow: true),
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
                                  // _buildFixedCell("${item.normalRange.toString()}", height: maxHeight),
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
                                      return _buildDataCell(
                                        "${entry.value}",
                                        width: getDynamicHeight(size: 0.090),
                                        height: maxHeight,
                                      );
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
  double _getMaxRowHeight(int index, AdPatientController controller) {
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
    double baseHeight = 30.0; // base height for a cell
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

  Widget _buildFixedHeaderCell(String text, {bool overflow = false, bool isLast = false}) {
    return Container(
      width: 80,
      height: rowHeight,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        border: Border(
          bottom: BorderSide(color: Colors.black26, width: 1), // 👈 Bottom Divider
          right: isLast ? BorderSide.none : BorderSide(color: Colors.black26, width: 1), // 👈 Right Divider
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: overflow ? TextOverflow.ellipsis : TextOverflow.visible,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {double width = 100, bool isLast = false}) {
    return Container(
      width: width,
      height: rowHeight,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        border: Border(
          bottom: BorderSide(color: Colors.black26, width: 1), // 👈 Bottom Divider
          right: isLast ? BorderSide.none : BorderSide(color: Colors.black26, width: 1), // 👈 Right Divider
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFixedCell(String text, {bool isLast = false, required double height}) {
    return Container(
      width: 80,
      constraints: BoxConstraints(minHeight: height), // ✅ Dynamic Height
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
          right: isLast ? BorderSide.none : BorderSide(color: Colors.black26, width: 1),
        ),
        color: Colors.grey[200],
      ),
      child: Text(
        text,
        softWrap: true,
        maxLines: null,
      ),
    );
  }

  Widget _buildDataCell(String value, {double width = 100, required double height}) {
    List<String> lines = value.split("\n"); // ✅ Multi-line handling
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: height), // ✅ Dynamic Height
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) {
          List<String> parts = line.split("|");
          String text = parts.first;
          bool isHighlighted = parts.length > 1 && parts.last.trim() == "True";

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.pink.withOpacity(0.5) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              text,
              softWrap: true,
              maxLines: null,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// ✅ **Calculate max height for each row dynamically**
  List<double> calculateRowHeights(List<List<String>> data, double columnWidth) {
    return data.map((row) {
      return row.map((cell) => calculateTextHeight(cell, columnWidth)).reduce((a, b) => a > b ? a : b);
    }).toList();
  }

  /// ✅ **Calculate text height dynamically**
  double calculateTextHeight(String text, double width) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: 14)),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: width);
    return textPainter.height + 16; // Extra padding
  }

  // Widget buildRow(String fixedText, String dataText) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ Dono ko equal height karega
  //     children: [
  //       _buildFixedCell(fixedText),
  //       Expanded(child: _buildDataCell(dataText)),
  //     ],
  //   );
  // }
}
