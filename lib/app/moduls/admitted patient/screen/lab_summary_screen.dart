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
                          _buildFixedHeaderCell("Range", width: getDynamicHeight(size: 0.085), overflow: true),
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
                              double maxHeight_Container = getHeight(controller.labdata, singleItemList, controller.labdata[index].dateValues!.keys.toList());
                              String normalRange = controller.labdata[index].normalRange.toString();
                              String unit = controller.labdata[index].unit.toString();
                              double maxHeight = getHeightOfWidget(normalRange, unit, singleItemList, controller.labdata[index].dateValues!.keys.toList(), index);

                              return Row(
                                children: [
                                  _buildFixedCell("${item.formattest.toString()}", height: maxHeight, width: getDynamicHeight(size: 0.090)),
                                  _buildFixedCell(
                                    "${item.testName.toString()}",
                                    height: maxHeight,
                                    width: getDynamicHeight(size: 0.080),
                                    // heightContainer: maxHeight_Container,
                                  ),
                                  _buildFixedCell(
                                    "${item.normalRange.toString()}",
                                    height: maxHeight,
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
                                  double maxHeight_Container = getHeight(controller.labdata, singleItemList, controller.labdata[index].dateValues!.keys.toList());
                                  String normalRange = controller.labdata[index].normalRange.toString();
                                  String unit = controller.labdata[index].unit.toString();
                                  double maxHeight = getHeightOfWidget(normalRange, unit, singleItemList, controller.labdata[index].dateValues!.keys.toList(), index);

                                  return Row(
                                    children: item.dateValues!.entries.map((entry) {
                                      return _buildDataCell(
                                        "${entry.value}",
                                        width: getDynamicHeight(size: 0.130),
                                        height: maxHeight,
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

  getHeight(List wholeData, List alldata, List datesListing) {
    int formatTest_index = 0;
    int normalRange_index = 0;
    int index2 = 0;
    int index3 = 0;
    int testName_index = 0;
    int index5 = 0;
    int index6 = 0;
    List indexList = [];

    for (int i = 0; i < alldata.length; i++) {
      for (int j = 0; j < datesListing.length; j++) {
        String? value = alldata[i].dateValues![datesListing[j]];
        if (value != null) {
          if (value.length > 70) {
            // print('yes..${alldata[i][datesListing[j]].toString()}');
            if (indexList.contains(i)) {
            } else {
              indexList.add(i);
              index6++;
            }
          } else if (value.length > 50) {
            // print('yes..${alldata[i][datesListing[j]].toString()}');
            if (indexList.contains(i)) {
            } else {
              indexList.add(i);
              index5++;
            }
          } else if (value.length > 25) {
            // print('yes..${alldata[i][datesListing[j]].toString()}');
            if (indexList.contains(i)) {
            } else {
              indexList.add(i);
              index3++;
            }
          } else if (value.length > 14) {
            if (indexList.contains(i)) {
            } else {
              index2++;
            }
          }
        }
      }

      if (alldata[i].formattest.toString().length > 14 && alldata[i].formattest.toString().length <= 28) {
        formatTest_index++;
      } else if (alldata[i].formattest.toString().length > 28 && alldata[i].formattest.toString().length <= 42) {
        formatTest_index++;
      } else if (alldata[i].formattest.toString().length > 42) {
        formatTest_index++;
      }

      if (alldata[i].normalRange.toString().length > 14 && alldata[i].normalRange.toString().length <= 28) {
        normalRange_index++;
      } else if (alldata[i].normalRange.toString().length > 28 && alldata[i].normalRange.toString().length <= 42) {
        normalRange_index++;
      } else if (alldata[i].normalRange.toString().length > 42) {
        normalRange_index++;
      }

      if (alldata[i].testName.toString().length > 14 && alldata[i].testName.toString().length <= 28) {
        testName_index++;
      } else if (alldata[i].testName.toString().length > 28 && alldata[i].testName.toString().length <= 42) {
        testName_index++;
      } else if (alldata[i].testName.toString().length > 42) {
        testName_index++;
      }
    }
    double height_formatTest = formatTest_index * (Sizes.crossLength * .055);
    double height_normalRange = normalRange_index * (Sizes.crossLength * .080);
    double height_index2 = index2 * (Sizes.crossLength * .0381);
    double height_index3 = index3 * (Sizes.crossLength * .0531);
    double height_testName = testName_index * (Sizes.crossLength * .051);
    double height_index5 = index5 * (Sizes.crossLength * .0756);
    double height_index6 = index6 * (Sizes.crossLength * .1056);

    /// Sab values me se highest nikalna
    double highestValue = [height_formatTest, height_normalRange, height_index2, height_index3, height_testName, height_index5, height_index6]
        .reduce((value, element) => value > element ? value : element);

    // height_default ko highestValue se multiply karna
    double height_default = (1) * (Sizes.crossLength * .063) + 10;
    double finalHeight = highestValue + height_default;

    return finalHeight;
    // return (formatTest_index * (Sizes.crossLength * .040) +
    //     normalRange_index * (Sizes.crossLength * .080) +
    //     index2 * (Sizes.crossLength * .0381) +
    //     index3 * (Sizes.crossLength * .0531) +
    //     testName_index * (Sizes.crossLength * .051) +
    //     index5 * (Sizes.crossLength * .0756) +
    //     index6 * (Sizes.crossLength * .1056) +
    //     // (((((((alldata.length - 0) - normalRange_index) - index2) - index3) - index4) - index5) - index6) * (Sizes.crossLength * .057) +
    //     // (((((((formatTest_index - 0) - normalRange_index) - index2) - index3) - index4) - index5) - index6) * (Sizes.crossLength * .057) +
    //     (1) * (Sizes.crossLength * .057) +
    //     10);
  }

  getHeightOfWidget(String text1, String text2, List alldata, List datesListing, int index) {
    // print((text1.length + text2.length));
    // if ((text1.length + text2.length) > 14) {
    //   return getDynamicHeight(size: 0.125);
    // } else {
    double height_testName = 0;
    double height_normalRange = 0;
    double height_formatTest = 0;
    double height_index2 = 0;
    double height_index3 = 0;
    double height_index5 = 0;
    double height_index6 = 0;
    for (int i = 0; i < alldata.length; i++) {
      for (int j = 0; j < datesListing.length; j++) {
        String? value = alldata[i].dateValues![datesListing[j]];
        if (value != null) {
          if (value.length > 70) {
            height_index2 = getDynamicHeight(size: 0.350);
          } else if (value.length > 50) {
            height_index3 = getDynamicHeight(size: 0.250);
          } else if (value.length > 25) {
            height_index5 = getDynamicHeight(size: 0.175);
          } else if (value.length > 14) {
            height_index6 = getDynamicHeight(size: 0.125);
          } else {
            if (alldata[i].formattest.length > 21) {
              height_formatTest = getDynamicHeight(size: 0.150);
            } else if (alldata[i].formattest.length > 14) {
              height_formatTest = getDynamicHeight(size: 0.100);
            } else if (alldata[i].formattest.length > 7) {
              height_formatTest = getDynamicHeight(size: 0.050);
            }

            if (alldata[i].testName.toString().length > 25) {
              height_testName = getDynamicHeight(size: 0.10);
            } else if (alldata[i].testName.toString().length > 14) {
              height_testName = getDynamicHeight(size: 0.125);
            } else if (alldata[i].testName.toString().length > 7) {
              height_testName = getDynamicHeight(size: 0.085);
            }

            if ((text1.length + text2.length) > 25) {
              height_normalRange = getDynamicHeight(size: 0.185);
            } else if ((text1.length + text2.length) > 14) {
              height_normalRange = getDynamicHeight(size: 0.125);
            } else if ((text1.length + text2.length) > 7) {
              height_normalRange = getDynamicHeight(size: 0.065);
            }
          }

          double highestValue = [height_formatTest, height_normalRange, height_index2, height_index3, height_testName, height_index5, height_index6]
              .reduce((value, element) => value > element ? value : element);
          if (highestValue > 0.0) {
            return highestValue;
          } else {
            return getDynamicHeight(size: 0.055);
          }
        }
      }
    }
    return getDynamicHeight(size: 0.055);
  }

  // getHeightOfWidget(String text1, String text2, List alldata, List datesListing, int index) {
  //   // print((text1.length + text2.length));
  //   // if ((text1.length + text2.length) > 14) {
  //   //   return getDynamicHeight(size: 0.125);
  //   // } else {
  //   double height_testName = 0;
  //   double height_normalRange = 0;
  //   double height_formatTest = 0;
  //   double height_index2 = 0;
  //   double height_index3 = 0;
  //   double height_index5 = 0;
  //   double height_index6 = 0;
  //   for (int i = 0; i < alldata.length; i++) {
  //     for (int j = 0; j < datesListing.length; j++) {
  //       String? value = alldata[i].dateValues![datesListing[j]];
  //       if (value != null) {
  //         if (value.length > 70) {
  //           height_index2 = getDynamicHeight(size: 0.350);
  //         } else if (value.length > 50) {
  //           height_index3 = getDynamicHeight(size: 0.250);
  //         } else if (value.length > 25) {
  //           height_index5 = getDynamicHeight(size: 0.175);
  //         } else if (value.length > 14) {
  //           height_index6 = getDynamicHeight(size: 0.125);
  //         } else {
  //           if (alldata[i].formattest.length > 25) {
  //             height_formatTest = getDynamicHeight(size: 0.185);
  //           } else if (alldata[i].formattest.length > 14) {
  //             height_formatTest = getDynamicHeight(size: 0.125);
  //           } else if (alldata[i].formattest.length > 7) {
  //             height_formatTest = getDynamicHeight(size: 0.065);
  //           }

  //           if (alldata[i].testName.toString().length > 25) {
  //             height_testName = getDynamicHeight(size: 0.10);
  //           } else if (alldata[i].testName.toString().length > 14) {
  //             height_testName = getDynamicHeight(size: 0.125);
  //           } else if (alldata[i].testName.toString().length > 7) {
  //             height_testName = getDynamicHeight(size: 0.085);
  //           }

  //           if ((text1.length + text2.length) > 25) {
  //             height_normalRange = getDynamicHeight(size: 0.185);
  //           } else if ((text1.length + text2.length) > 14) {
  //             height_normalRange = getDynamicHeight(size: 0.125);
  //           } else if ((text1.length + text2.length) > 7) {
  //             height_normalRange = getDynamicHeight(size: 0.065);
  //           }
  //         }

  //         double highestValue = [height_formatTest, height_normalRange, height_index2, height_index3, height_testName, height_index5, height_index6]
  //             .reduce((value, element) => value > element ? value : element);
  //         return highestValue;
  //       }
  //     }
  //   }
  //   return getDynamicHeight(size: 0.055);
  // }

  Widget _buildFixedHeaderCell(String text, {double width = 100, bool overflow = false, bool isLast = false}) {
    return Container(
      width: width,
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

  Widget _buildFixedCell(String text, {bool overflow = false, double width = 80, double height = 50, double heightContainer = 50}) {
    return Container(
      width: 80,
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
        maxLines: null,
        overflow: overflow ? TextOverflow.ellipsis : TextOverflow.visible,
      ),
    );
  }

  Widget _buildDataCell(String value, {double width = 80, double height = 50, double containerHeight = 50}) {
    List<String> lines = value.split("\n");

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Table border
      ),
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) {
          List<String> parts = line.split("|");
          String text = parts.first;
          bool isHighlighted = parts.length > 1 && parts.last.trim() == "True";

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.pink.withOpacity(0.5) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.left,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget _buildSlidableText(String text, double maxWidth, double maxHeight, double maxHeightContainer) {
  //   List<String> lines = text.split("\n");

  //   return Container(
  //       width: maxWidth,
  //       // height: maxHeight,
  //       decoration: BoxDecoration(color: Colors.transparent),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: lines.map((line) {
  //           List<String> parts = line.split("|");
  //           String textPart = parts.first;
  //           List<String> labStatusParts = parts.length > 1 ? parts.last.trim().split("~") : [];
  //           bool isFontColorRed = false;
  //           bool isHighlighted = false;
  //           if (labStatusParts.length > 1) {
  //             isHighlighted = labStatusParts.length > 1 && labStatusParts.last.trim().toLowerCase() == "provisional";
  //           }

  //           isFontColorRed = parts.length > 1 && labStatusParts.first.trim() == "True";

  //           return Container(
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               color: isHighlighted ? Colors.lightBlueAccent.withOpacity(0.5) : Colors.transparent,
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //             child: Text(
  //               textPart,
  //               style: TextStyle(
  //                 fontSize: Sizes.px13,
  //                 color: isFontColorRed ? Colors.red : Colors.black,
  //                 fontWeight: isFontColorRed ? FontWeight.bold : FontWeight.normal,
  //               ),
  //               // softWrap: true,
  //             ),
  //           );
  //         }).toList(),
  //       ));
  // }
}
