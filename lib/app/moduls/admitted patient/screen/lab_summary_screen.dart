import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
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

  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final double rowHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    Get.put(AdpatientController());
    return GetBuilder<AdpatientController>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          title: Text(
            'Lab Summary',
            style: TextStyle(
              color: AppColor.primaryColor,
              fontWeight: FontWeight.w700,
              fontFamily: CommonFontStyle.plusJakartaSans,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1),
              ),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Patient Name", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: rowHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                            borderSide: BorderSide(
                              color: AppColor.black,
                            ),
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
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _verticalScrollController,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFixedHeaderCell("ID"),
                        ...data.map((item) => _buildFixedCell("${item['ID']}")),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFixedHeaderCell("Name", overflow: true),
                        ...data.map((item) => _buildFixedCell(item['Name'], overflow: true)),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                _buildHeaderCell("Age"),
                                _buildHeaderCell("Salary"),
                                _buildHeaderCell("Department"),
                                _buildHeaderCell("City"),
                              ],
                            ),
                            Column(
                              children: data.map((item) {
                                return Row(
                                  children: [
                                    _buildDataCell("${item['Age']}", width: 100),
                                    _buildDataCell("${item['Salary']}", width: 100),
                                    _buildDataCell(item['Department'], width: 120),
                                    _buildDataCell(item['City'], width: 100),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFixedHeaderCell(String text, {bool overflow = false}) {
    return Container(
      width: 80,
      height: rowHeight,
      padding: EdgeInsets.all(8.0),
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

  Widget _buildHeaderCell(String text) {
    return Container(
      width: 100,
      height: rowHeight,
      padding: EdgeInsets.all(8.0),
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
      padding: EdgeInsets.all(8.0),
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
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
        color: Colors.white,
      ),
      child: Text(text),
    );
  }
}
