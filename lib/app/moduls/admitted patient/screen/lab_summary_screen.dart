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
    Get.put(AdpatientController());

    return GetBuilder<AdpatientController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Lab Summary'),
          centerTitle: true,
        ),
        body: CustomScrollView(slivers: [
          SliverAppBar(
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
                              double maxHeight = _getMaxRowHeight(index, controller);
                              return Row(
                                children: [
                                  _buildFixedCell("${item.formattest.toString()}", height: maxHeight),
                                  _buildFixedCell("${item.testName.toString()}", height: maxHeight),
                                  _buildFixedCell("${item.normalRange.toString()}", height: maxHeight),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
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

  double _getMaxRowHeight(int index, AdpatientController controller) {
    var item = controller.labdata[index];
    double leftHeight = _calculateCellHeight(item.formattest ?? '') +
        _calculateCellHeight(item.testName ?? '') +
        _calculateCellHeight(item.normalRange ?? '');
    double rightHeight = item.dateValues!.entries.map((entry) {
      return _calculateCellHeight(entry.value ?? '');
    }).reduce((a, b) => a > b ? a : b); // Choose the max height from the right side columns
    return leftHeight > rightHeight ? leftHeight : rightHeight;
  }

  double _calculateCellHeight(String content) {
    double baseHeight = 30.0; // base height for a cell
    double extraHeight = _calculateTextHeight(content);
    return baseHeight + extraHeight;
  }

  double _calculateTextHeight(String content) {
    TextPainter painter = TextPainter(
      text: TextSpan(text: content, style: TextStyle(fontSize: 14.0)), // Adjust font size here if needed
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
    );

    painter.layout(maxWidth: double.infinity); // Measure the text layout
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

  /// **Calculate max height for each row dynamically**
  List<double> calculateRowHeights(List<List<String>> data, double columnWidth) {
    return data.map((row) {
      return row.map((cell) => calculateTextHeight(cell, columnWidth)).reduce((a, b) => a > b ? a : b);
    }).toList();
  }

  /// **Calculate text height dynamically**
  double calculateTextHeight(String text, double width) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: 14)),
      textDirection: TextDirection.ltr,
      maxLines: null, // ✅ Allow unlimited lines
    )..layout(maxWidth: width);
    return textPainter.height + 16; // Extra padding
  }

  Widget _buildFixedCell(String text, {bool isLast = false, required double height,double width = 100,}) {
    return Container(
      width: 80,
      height: height, // ✅ Fixed Height
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
          right: isLast ? BorderSide.none : BorderSide(color: Colors.black26, width: 1),
        ),
        color: Colors.grey[200],
      ),
      child: _buildSlidableText(text, width, height),
    );
  }

  Widget _buildDataCell(String value, {double width = 100, required double height}) {
    return Container(
      width: width,
      height: height, // ✅ Fixed Height
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: _buildSlidableText(value, width, height),
    );
  }

  Widget _buildSlidableText(String text, double maxWidth, double maxHeight) {
    ScrollController scrollController = ScrollController();

    return Container(
      width: maxWidth,
      decoration: BoxDecoration(color: Colors.transparent),
      child: LayoutBuilder(
        builder: (context, constraints) {
          TextPainter textPainter = TextPainter(
            text: TextSpan(text: text, style: TextStyle(fontSize: 14)),
            textDirection: TextDirection.ltr,
            maxLines: null,
          )..layout(maxWidth: maxWidth);

          int lineCount = textPainter.computeLineMetrics().length; // ✅ Line Count Check
          bool isOverflow = lineCount > 5; // ✅ 5 Lines Se Zyada Ho Toh Scroll Karega

          return isOverflow
              ? SizedBox(
                  height: maxHeight,
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: maxHeight),
                        child: Text(text, style: TextStyle(fontSize: 12),softWrap: true),
                      ),
                    ),
                  ),
                )
              : Text(text, style: TextStyle(fontSize: 12), softWrap: true);
        },
      ),
    );
  }
}
