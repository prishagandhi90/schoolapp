import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabSummaryScreen_test extends StatelessWidget {
  LabSummaryScreen_test({Key? key}) : super(key: key);

  final double rowHeight = 50.0;

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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(label: Text("Report")),
                    DataColumn(label: Text("Test")),
                    DataColumn(label: Text("Range")),
                    ...controller.labdata.first.dateValues!.keys.toList().map((date) => DataColumn(label: Text(date))).toList(),
                  ],
                  rows: controller.labdata.map((row) {
                    return DataRow(cells: [
                      DataCell(_buildDataCell(row.formattest.toString())),
                      DataCell(_buildDataCell(row.testName.toString())),
                      DataCell(_buildDataCell(row.normalRange.toString())),
                      ...controller.labdata.first.dateValues!.keys.map((date) {
                        return DataCell(_buildDataCell(row.dateValues?[date] ?? "-"));
                      }).toList(),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ]),
      );
    });
  }

  Widget _buildDataCell(String value, {double width = 100}) {
    List<String> lines = value.split("\n"); // ✅ Multi-line handling

    return SizedBox(
      width: width, // ✅ Fixed Width
      child: IntrinsicHeight(
        // ✅ Auto adjust height
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines.map((line) {
              List<String> parts = line.split("|");
              String text = parts.first;
              bool isHighlighted = parts.length > 1 && parts.last.trim() == "True";

              return Flexible(
                child: Container(
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: isHighlighted ? Colors.pink.withOpacity(0.5) : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    text,
                    // softWrap: true,
                    // overflow: TextOverflow.visible, // ✅ Text wrap allow
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  //
}
