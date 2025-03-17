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
    (index) => {
      'ID': index + 1,
      'Name': 'Person $index',
      'Age': 20 + index,
      'Salary': (index + 1) * 1000,
      'Department': 'Dept ${index % 5}',
      'City': 'City ${index % 3}'
    },
  );

  final double rowHeight = 50.0;

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
            // ✅ Correct way
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
                          _buildFixedHeaderCell("Normal Range", overflow: true),
                        ],
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          controller: controller.verticalScrollControllerLeft,
                          child: Column(
                            children: List.generate(controller.labdata.length, (index) {
                              var item = controller.labdata[index]; // API se aaya ek row
                              return Row(
                                children: [
                                  _buildFixedCell("${item.formattest.toString()}"),
                                  _buildFixedCell("${item.testName.toString()}"),
                                  _buildFixedCell("${item.normalRange.toString()}", overflow: true),
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
                              controller: controller.verticalScrollControllerRight, // Sync with left scroll
                              child: Column(
                                children: List.generate(controller.labdata.length, (index) {
                                  var item = controller.labdata[index]; // API se aaya ek row
                                  return Row(
                                    children: item.dateValues!.entries.map((entry) {
                                      return _buildDataCell("${entry.value}", width: getDynamicHeight(size: 0.090));
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

  Widget _buildFixedHeaderCell(String text, {bool overflow = false}) {
    return Container(
      width: 80,
      height: rowHeight,
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
      height: rowHeight,
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

  Widget _buildFixedCell(String text, {bool overflow = false}) {
    return Container(
      width: 80,
      height: rowHeight,
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

  Widget _buildDataCell(String text, {double width = 80}) {
    return Container(
      width: width,
      height: rowHeight,
      padding: EdgeInsets.only(
        left: 8.0,
        top: 8.0,
        bottom: 8.0,
      ),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
        color: Colors.white,
      ),
      child: Text(text),
    );
  }
}
