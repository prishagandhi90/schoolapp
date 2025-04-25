// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
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
          title: Text(
            AppString.labsummary,
            style: AppStyle.primaryplusw700,
          ),
          leading: IconButton(
              onPressed: () {
                controller.labSummarySearchController.clear(); // Search text clear karna
                controller.sortBySelected = null;
                controller.update();
                controller.fetchDeptwisePatientList();
                Navigator.pop(context); // UI ko refresh karna
              },
              icon: Icon(Icons.arrow_back_ios, color: AppColor.black)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline_rounded, color: AppColor.black),
              onPressed: () {
                controller.showInfoDialog(context);
              },
            ),
          ],
        ),
        body: controller.isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getDynamicHeight(size: 0.102),
                ),
                child: Center(child: ProgressWithIcon()),
              )
            : CustomScrollView(slivers: [
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
                                  controller.patientName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getDynamicHeight(size: 0.013),
                                  ),
                                ),
                                Text(
                                  controller.bedNo,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getDynamicHeight(size: 0.013),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: getDynamicHeight(size: 0.005)),
                            SizedBox(
                              height: getDynamicHeight(size: 0.050),
                              child: TextFormField(
                                cursorColor: AppColor.black,
                                controller: controller.labSummarySearchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(getDynamicHeight(size: 0.012)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.lightgrey1,
                                      width: getDynamicHeight(size: 0.00105),
                                    ),
                                    borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(getDynamicHeight(size: 0.012)),
                                    borderSide: BorderSide(
                                      color: AppColor.black,
                                    ),
                                  ),
                                  suffixIcon: controller.labSummarySearchController.text.trim().isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            controller.labSummarySearchController.clear();
                                            controller.fetchsummarylabdata();
                                          },
                                          child: const Icon(Icons.cancel_outlined))
                                      : const SizedBox(),
                                  prefixIcon: Icon(Icons.search, color: AppColor.lightgrey1),
                                  hintText: AppString.search,
                                  hintStyle: AppStyle.plusgrey,
                                  filled: true,
                                  fillColor: AppColor.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(getDynamicHeight(size: 0.027))),
                                  ),
                                ),
                                onTap: () {
                                  controller.update();
                                },
                                onChanged: (value) {
                                  controller.filterLabSummarySearchResults(value);
                                  // controller.searchController.clear();
                                },
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                  Future.delayed(const Duration(milliseconds: 300));
                                  controller.update();
                                },
                                onFieldSubmitted: (v) {
                                  if (controller.labSummarySearchController.text.trim().isNotEmpty) {
                                    controller.fetchsummarylabdata();
                                    controller.labSummarySearchController.clear();
                                  }
                                  Future.delayed(const Duration(milliseconds: 800));
                                  controller.update();
                                },
                              ),
                            ),
                            SizedBox(height: getDynamicHeight(size: 0.005)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchsummarylabdata();
                    },
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
                                  // _buildFixedHeaderCell(
                                  //   "Range",
                                  //   width: getDynamicHeight(size: 0.085),
                                  // ),
                                ],
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  controller: controller.verticalScrollControllerLeft,
                                  child: Column(
                                    children: List.generate(controller.filterlabdata.length, (index) {
                                      var item = controller.filterlabdata[index]; // API data
                                      // double maxHeight = _getMaxRowHeight(index, controller);
                                      double rowHeights = 0.00;
                                      rowHeights = getLabRowHeights(
                                        labData: controller.filterlabdata[index],
                                        rowIndex: index,
                                        context: context,
                                      );
                                      return Row(
                                        children: [
                                          _buildFixedCell(
                                            "${item.formattest.toString()}",
                                            context,
                                            index,
                                            height: rowHeights,
                                            width: getDynamicHeight(size: 0.090),
                                          ),
                                          _buildFixedCell(
                                            "${item.testName.toString()}", context,
                                            height: rowHeights, index,
                                            width: getDynamicHeight(size: 0.080),
                                            // heightContainer: maxHeight_Container,
                                          ),
                                          // _buildFixedCell(
                                          //   "${item.normalRange.toString()}", context, index,
                                          //   height: rowHeights,
                                          //   width: getDynamicHeight(size: 0.085),
                                          //   // heightContainer: maxHeight_Container,
                                          // ),
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
                                    children: controller.filterlabdata.isNotEmpty
                                        ? controller.filterlabdata[0].dateValues!.keys.map((date) {
                                            return _buildHeaderCell(date, width: getDynamicHeight(size: 0.130));
                                          }).toList()
                                        : [],
                                  ),
                                  Flexible(
                                    child: SingleChildScrollView(
                                      controller: controller.verticalScrollControllerRight,
                                      child: Column(
                                        children: List.generate(controller.filterlabdata.length, (index) {
                                          var item = controller.filterlabdata[index]; // API data
                                          double rowHeights = 0.00;
                                          rowHeights = getLabRowHeights(
                                            labData: controller.filterlabdata[index],
                                            rowIndex: index,
                                            context: context,
                                          );

                                          return Row(
                                            children: item.dateValues!.entries.map((entry) {
                                              return _buildDataCell(
                                                "${entry.value}", context, index,
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
                ),
              ]),
      );
    });
  }

  double getLabRowHeights({
    required LabData labData,
    required int rowIndex,
    BuildContext? context,
  }) {
    List<String> dateKeys = labData.dateValues?.keys.toList() ?? [];

    List<String> columnTexts = [labData.formattest ?? "", labData.testName ?? "", labData.unit ?? "", ...dateKeys.map((date) => labData.dateValues?[date] ?? "")];

    List<double> rowHeights = [];
    double colWidth = 0;
    double padding = getDynamicHeight(size: 0.0178);

    for (int i = 0; i < columnTexts.length; i++) {
      if (i == 0) {
        colWidth = getDynamicHeight(size: 0.090);
      } else if (i == 1) {
        colWidth = getDynamicHeight(size: 0.080);
      } else {
        colWidth = getDynamicHeight(size: 0.130);
      }

      // Split by newline first (CHAR(10) or \n)
      List<String> lines = columnTexts[i].split('\n');
      List<double> lineHeights = [];
      String textPart = "";

      for (String line in lines) {
        if (line.isEmpty) continue; // Skip empty lines

        // Split each line by "|"
        List<String> parts = line.split("|");
        textPart += parts.isNotEmpty ? parts[0].trim() : ""; // Get the part before "|"
        bool isHighlighted = false;
        bool isFontColorRed = false;

        // Process the part after "|" for highlighting and color
        if (parts.length > 1) {
          List<String> labStatusParts = parts[1].trim().split("~");
          isHighlighted = labStatusParts.length > 1 && labStatusParts.last.trim().toLowerCase() == "provisional";
          isFontColorRed = labStatusParts.isNotEmpty && labStatusParts[0].trim() == "True";
        }

        double normalPadding = 0.012;
        if (i > 2 && textPart.length <= 24 && MediaQuery.of(context!).size.height > 680) {
          normalPadding = 0.012;
        } else if (i > 2 && textPart.length > 24 && MediaQuery.of(context!).size.height > 680) {
          normalPadding = 0.0182;
        }

        double adaptivePadding = getDynamicHeight(
          size: MediaQuery.of(context!).size.height < 680 ? 0.029 : normalPadding,
        );
        padding = adaptivePadding;
        double adjustedColWidth = colWidth - (getDynamicHeight(size: 0.0021) * padding);

        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: textPart,
            style: TextStyle(
              fontSize: getDynamicHeight(size: 0.013),
              backgroundColor: isHighlighted ? Colors.lightBlueAccent.withOpacity(0.5) : AppColor.transparent,
              color: isFontColorRed ? AppColor.red1 : AppColor.black,
            ),
          ),
          maxLines: null,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: adjustedColWidth);

        if (lines.length > 1) {
          lineHeights.add(textPainter.height + getDynamicHeight(size: 0.005) + (getDynamicHeight(size: 0.0022) * padding));
        } else {
          lineHeights.add(textPainter.height + (getDynamicHeight(size: 0.0022) * padding));
        }
      }

      // Add the maximum height for this column's lines
      rowHeights.add(lineHeights.isNotEmpty ? lineHeights.reduce((a, b) => a > b ? a : b) : 0);
    }

    return rowHeights.isNotEmpty ? rowHeights.reduce((a, b) => a > b ? a : b) : 0;
  }

  Widget _buildFixedHeaderCell(String text, {double width = 100}) {
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
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.visible,
        style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.white),
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
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.white),
        ),
      ),
    );
  }

  Widget _buildFixedCell(
    String text,
    BuildContext context,
    int index, {
    double width = 80,
    double height = 50,
  }) {
    return GetBuilder<AdPatientController>(
      builder: (controller) {
        return GestureDetector(
          onLongPress: () {
            if (controller.filterlabdata[index].normalRange == null || controller.filterlabdata[index].normalRange == "") {
              return;
            }
            controller.showSimpleDialog(context, index);
          },
          child: Container(
            width: width,
            height: height,
            // padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: index % 2 == 0 ? AppColor.white : Colors.grey[200],
              border: Border.all(
                color: Colors.grey,
              ),
              // color: Colors.grey[200],
            ),
            child: Text.rich(
              highlightText(text, controller.searchQuery.value),
              style: TextStyle(fontSize: getDynamicHeight(size: 0.013)),
              maxLines: null,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataCell(String value, BuildContext context, int index, {double width = 80, double height = 50}) {
    List<String> lines = value.split("\n");
    return GetBuilder<AdPatientController>(
      builder: (controller) {
        return GestureDetector(
          onLongPress: () {
            if (controller.filterlabdata[index].normalRange == null || controller.filterlabdata[index].normalRange == "") {
              return;
            }
            controller.showSimpleDialog(context, index);
          },
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: index % 2 == 0 ? AppColor.white : Colors.grey[200], // Alternating row colors
              border: Border.all(color: AppColor.originalgrey), // Table border
            ),
            height: height,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: lines.asMap().entries.map((entry) {
                int idx = entry.key;
                String line = entry.value;
                List<String> parts = line.split("|");
                String textPart = parts.first;
                List<String> labStatusParts = parts.length > 1 ? parts.last.trim().split("~") : [];
                bool isFontColorRed = false;
                bool isHighlighted = false;
                if (labStatusParts.length > 1) {
                  isHighlighted = labStatusParts.length > 1 && labStatusParts.last.trim().toLowerCase() == AppString.provisional;
                }

                isFontColorRed = parts.length > 1 && labStatusParts.first.trim() == AppString.true1;

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(
                        getDynamicHeight(size: 0.00417),
                      ),
                      decoration: BoxDecoration(
                        color: isHighlighted ? Colors.lightBlueAccent.withOpacity(0.5) : AppColor.transparent,
                        borderRadius: BorderRadius.circular(
                          getDynamicHeight(size: 0.00417),
                        ),
                      ),
                      child: Text(
                        textPart,
                        style: TextStyle(
                          fontSize: getDynamicHeight(size: 0.013),
                          color: isFontColorRed ? AppColor.red1 : AppColor.black,
                          // fontWeight: isFontColorRed ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    if (idx < lines.length - 1) SizedBox(height: getDynamicHeight(size: 0.005)),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  TextSpan highlightText(String text, String query) {
    if (query.isEmpty) {
      return TextSpan(text: text, style: TextStyle(color: Colors.black));
    }

    List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int startIndex = 0;
    int index = lowerText.indexOf(lowerQuery);
    while (index != -1) {
      if (index > startIndex) {
        spans.add(TextSpan(text: text.substring(startIndex, index), style: TextStyle(color: Colors.black)));
      }
      spans.add(TextSpan(text: text.substring(index, index + query.length), style: TextStyle(color: Colors.black, backgroundColor: Colors.yellow)));
      startIndex = index + query.length;
      index = lowerText.indexOf(lowerQuery, startIndex);
    }

    if (startIndex < text.length) {
      spans.add(TextSpan(text: text.substring(startIndex), style: TextStyle(color: Colors.black)));
    }

    return TextSpan(children: spans);
  }
}
