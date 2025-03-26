import 'dart:math';

import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:emp_app/app/moduls/admitted%20patient/model/patientsummary_labdata_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabSummaryScreen extends StatelessWidget {
  LabSummaryScreen({Key? key}) : super(key: key);

  final double rowHeight = getDynamicHeight(size: 0.0528);

  @override
  Widget build(BuildContext context) {
    Get.put(AdPatientController());

    return GetBuilder<AdPatientController>(builder: (controller) {
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
                  padding: EdgeInsets.only(
                    left: getDynamicHeight(size: 0.005),
                    right: getDynamicHeight(size: 0.005),
                    // bottom: getDynamicHeight(size: 0.003),
                  ),
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getDynamicHeight(size: 0.013),
                            ),
                          ),
                          Text(
                            "Status",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getDynamicHeight(size: 0.013),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getDynamicHeight(size: 0.005)),
                      TextFormField(
                        cursorColor: AppColor.black,
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.lightgrey1, width: getDynamicHeight(size: 0.0005)),
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
                          _buildFixedHeaderCell("Report", width: getDynamicHeight(size: 0.090)),
                          _buildFixedHeaderCell("Test", width: getDynamicHeight(size: 0.080)),
                          _buildFixedHeaderCell(
                            "Range",
                            width: getDynamicHeight(size: 0.085),
                          ),
                        ],
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          controller: controller.verticalScrollControllerLeft,
                          child: Column(
                            children: List.generate(controller.labdata.length, (index) {
                              var item = controller.labdata[index]; // API data
                              // double maxHeight = _getMaxRowHeight(index, controller);
                              List<LabData> singleItemList = [controller.labdata[index]];

                              String normalRange = controller.labdata[index].normalRange.toString();
                              String unit = controller.labdata[index].unit.toString();

                              double rowHeights = 0.00;
                              rowHeights = getLabRowHeights(
                                labData: controller.labdata[index],
                                rowIndex: index,
                              );

                              return Row(
                                children: [
                                  _buildFixedCell(
                                    "${item.formattest.toString()}",
                                    height: rowHeights,
                                    width: getDynamicHeight(size: 0.090),
                                  ),
                                  _buildFixedCell(
                                    "${item.testName.toString()}",
                                    height: rowHeights,
                                    width: getDynamicHeight(size: 0.080),
                                    // heightContainer: maxHeight_Container,
                                  ),
                                  _buildFixedCell(
                                    "${item.normalRange.toString()}",
                                    height: rowHeights,
                                    width: getDynamicHeight(size: 0.085),
                                    // heightContainer: maxHeight_Container,
                                  ),
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
                                    return _buildHeaderCell(date, width: getDynamicHeight(size: 0.130));
                                  }).toList()
                                : [],
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              controller: controller.verticalScrollControllerRight,
                              child: Column(
                                children: List.generate(controller.labdata.length, (index) {
                                  var item = controller.labdata[index]; // API data
                                  // double maxHeight = _getMaxRowHeight(index, controller);
                                  List<LabData> singleItemList = [controller.labdata[index]];

                                  String normalRange = controller.labdata[index].normalRange.toString();
                                  String unit = controller.labdata[index].unit.toString();

                                  double rowHeights = 0.00;
                                  rowHeights = getLabRowHeights(
                                    labData: controller.labdata[index],
                                    rowIndex: index,
                                  );

                                  return Row(
                                    children: item.dateValues!.entries.map((entry) {
                                      return _buildDataCell(
                                        "${entry.value}",
                                        width: getDynamicHeight(size: 0.130),
                                        height: rowHeights,
                                        // containerHeight: maxHeight_Container,
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

  double getLabRowHeights({
    required LabData labData, // List of LabData objects
    required int rowIndex, // Current row index
  }) {
    List<String> dateKeys = labData.dateValues?.keys.toList() ?? [];

    // ✅ Extract all column texts
    List<String> columnTexts = [
      labData.formattest ?? "",
      labData.testName ?? "",
      labData.normalRange ?? "",
      labData.unit ?? "",
      ...dateKeys.map((date) => labData.dateValues?[date] ?? "")
    ];

    List<double> rowHeights = [];
    double colWidth = 0;
    double padding = getDynamicHeight(size: 0.013); // ✅ Padding added

    for (int i = 0; i < columnTexts.length; i++) {
      if (i == 0) {
        colWidth = getDynamicHeight(size: 0.090);
      } else if (i == 1) {
        colWidth = getDynamicHeight(size: 0.080);
      } else if (i == 2) {
        colWidth = getDynamicHeight(size: 0.085);
      } else {
        colWidth = getDynamicHeight(size: 0.130);
      }

      // ✅ Adjust maxWidth for padding
      double adjustedColWidth = colWidth - (2 * padding);

      // ✅ Split text based on "|" to check for highlighting condition
      List<String> parts = columnTexts[i].split("|");
      String text = parts.first;
      bool isHighlighted = parts.length > 1 && parts.last.trim() == "True";

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: getDynamicHeight(size: 0.013),
            backgroundColor: isHighlighted ? Colors.pink.withOpacity(0.5) : Colors.transparent,
          ),
        ),
        maxLines: null,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: adjustedColWidth); // ✅ Adjust width to account for padding

      rowHeights.add(textPainter.height + (2 * padding)); // ✅ Add padding to final height
    }

    return rowHeights.isNotEmpty ? rowHeights.reduce(max) : 0;
  }

  Widget _buildFixedHeaderCell(
    String text, {
    double width = 100,
  }) {
    return Container(
      width: width,
      height: rowHeight,
      padding: EdgeInsets.symmetric(
        horizontal: getDynamicHeight(size: 0.007),
        vertical: getDynamicHeight(size: 0.007),
      ),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        border: Border(
          bottom: BorderSide(color: Colors.black26, width: 1), // 👈 Bottom Divider
          right: BorderSide(color: Colors.black26, width: 1), // 👈 Right Divider
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.visible,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {double width = 100}) {
    return Container(
      width: width,
      height: rowHeight,
      padding: EdgeInsets.symmetric(
        horizontal: getDynamicHeight(size: 0.007),
        vertical: getDynamicHeight(size: 0.007),
      ),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        border: Border(
          bottom: BorderSide(color: Colors.black26, width: 1), // 👈 Bottom Divider
          right: BorderSide(color: Colors.black26, width: 1), // 👈 Right Divider
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

  Widget _buildFixedCell(String text, {double width = 80, double height = 50}) {
    return Container(
      width: width,
      height: height,
      // padding: EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black26, width: 1), // ðŸ‘ˆ Bottom Divider
          right: BorderSide(color: Colors.black26, width: 1), // ðŸ‘ˆ Right Divider
        ),
        color: Colors.grey[200],
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: getDynamicHeight(size: 0.013)),
        maxLines: null,
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget _buildDataCell(String value, {double width = 80, double height = 50, double containerHeight = 50}) {
    List<String> lines = value.split("\n");

    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Table border
      ),
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: lines.map((line) {
          List<String> parts = line.split("|");
          String text = parts.first;
          bool isHighlighted = parts.length > 1 && parts.last.trim() == "True";

          return Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.pink.withOpacity(0.5) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: getDynamicHeight(size: 0.013)),
              textAlign: TextAlign.left,
            ),
          );
        }).toList(),
      ),
    );
  }
}
