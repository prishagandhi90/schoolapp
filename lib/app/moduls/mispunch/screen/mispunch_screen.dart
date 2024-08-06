import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';
import 'package:emp_app/app/app_custom_widget/custom_containerview.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/moduls/mispunch/controller/mispunch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MispunchScreen extends StatefulWidget {
  const MispunchScreen({super.key});

  @override
  State<MispunchScreen> createState() => _MispunchScreenState();
}

class _MispunchScreenState extends State<MispunchScreen> {
  final MispunchController mispunchController = Get.put(MispunchController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mispunchController.setCurrentMonthYear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MispunchController>(
      builder: (controller) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Mispunch',
                style: TextStyle(
                  color: const Color.fromARGB(255, 94, 157, 168),
                  fontWeight: FontWeight.w700,
                  // fontSize: 18,
                  fontFamily: CommonFontStyle.plusJakartaSans,
                ),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.clearData();
                  },
                  icon: const Icon(Icons.arrow_back)),
              // centerTitle: true,
              actions: [
                CustomDropDown(
                  selValue: controller.YearSel_selIndex,
                  onPressed: (index) {
                    controller.upd_YearSelIndex(index);
                    mispunchController.showHideMsg();
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  MonthSelectionScreen(
                    selectedMonthIndex: controller.MonthSel_selIndex.value,
                    scrollController: controller.monthScrollController,
                    onPressed: (index) {
                      controller.upd_MonthSelIndex(index);
                      mispunchController.showHideMsg();
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: controller.isLoading.value
                        ? const Center(child: ProgressWithIcon())
                        : controller.mispunchtable.isNotEmpty
                            ? ListView.builder(
                                itemCount: controller.mispunchtable.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.23,
                                      decoration:
                                          BoxDecoration(color: const Color.fromRGBO(211, 240, 243, 0.58), borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: double.infinity,
                                            height: 45,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.primaryColor),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    controller.mispunchtable[index].dt.toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w500, //20
                                                      fontFamily: CommonFontStyle.plusJakartaSans,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  CustomContainerview(text: 'TYPE', text1: controller.mispunchtable[index].misPunch.toString()),
                                                  CustomContainerview(
                                                      text: 'PUNCH TIME', text1: controller.mispunchtable[index].punchTime.toString()),
                                                  CustomContainerview(
                                                      text: 'SHIFT TIME', text1: controller.mispunchtable[index].shiftTime.toString()),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.all(15),
                                child: Center(
                                  child: Text('No Mispunch in this month'),
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
// import 'package:emp_app/app/app_custom_widget/custom_list_Scrollable.dart';
// import 'package:emp_app/app/core/model/dropdown_G_model.dart';
// import 'package:emp_app/app/moduls/mispunch/controller/mispunch_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class MispunchScreen extends StatefulWidget {
//   const MispunchScreen({super.key});

//   @override
//   State<MispunchScreen> createState() => _MispunchScreenState();
// }

// class _MispunchScreenState extends State<MispunchScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final MispunchController mispunchController = Get.put(MispunchController());
//     mispunchController.getmonthyrempinfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<MispunchController>(
//       init: MispunchController(),
//       builder: (controller) {
//         return Scaffold(
//           body: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   const Text('Mnth Yr :'),
//                   const SizedBox(width: 10),
//                   CustomDropDown(
//                     selValue: controller.selectedMonthYear,
//                     items: controller.monthyr
//                         .map(
//                           (item) => DropdownMenuItem<Dropdown_Glbl>(
//                             value: item,
//                             child: Text(item.name.toString()),
//                           ),
//                         )
//                         .toList(),
//                     onChange: (Dropdown_Glbl? value) {
//                       controller.monthYr_OnClick(value);
//                     },
//                   ),
//                   SizedBox(width: MediaQuery.of(context).size.width * 0.01),
//                   ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(255, 179, 226, 238)),
//                           shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//                           )),
//                       onPressed: () async {
//                         await controller.getmonthyrempinfotable();
//                       },
//                       child: const Text(
//                         'Fetch',
//                         style: TextStyle(color: Colors.black),
//                       ))
//                 ],
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 2,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 1,
//                   itemBuilder: (context, index) {
//                     if (controller.mispunchtable.isNotEmpty && index < controller.mispunchtable.length) {
//                       return Table(
//                         border: TableBorder.all(),
//                         children: [
//                           TableRow(children: [
//                             const Padding(padding: EdgeInsets.all(8.0), child: Text('Code')),
//                             Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].empCode}')),
//                           ]),
//                           TableRow(children: [
//                             const Padding(padding: EdgeInsets.all(8.0), child: Text('Name')),
//                             Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].empName}')),
//                           ]),
//                           TableRow(children: [
//                             const Padding(padding: EdgeInsets.all(8.0), child: Text('Dept')),
//                             Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].department}')),
//                           ]),
//                           TableRow(children: [
//                             const Padding(padding: EdgeInsets.all(8.0), child: Text('Designation')),
//                             Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].designation}')),
//                           ]),
//                           TableRow(children: [
//                             const Padding(padding: EdgeInsets.all(8.0), child: Text('Type')),
//                             Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].empType}')),
//                           ]),
//                         ],
//                       );
//                     } else {
//                       return const SizedBox();
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(height: 15),
//               Row(
//                 children: [
//                   if (controller.FixedColRowBuilder().isNotEmpty)
//                     FixedColumnWidget(
//                       columns: const [
//                         DataColumn(label: Text('#')),
//                         DataColumn(label: Text('Att Date')),
//                       ],
//                       rowBuilder: controller.FixedColRowBuilder,
//                       headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 130, 240, 198)),
//                     ),
//                   if (controller.ScrollableColRowBuilder().isNotEmpty)
//                     ScrollableColumnWidget(
//                       columns: const [
//                         DataColumn(label: Text('Mispunch')),
//                         DataColumn(label: Text('Punch Time')),
//                         DataColumn(label: Text('Shift time')),
//                       ],
//                       rowBuilder: controller.ScrollableColRowBuilder,
//                       headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 182, 235, 214)),
//                     ),
//                 ],
//               )
//             ]),
//           ),
//         );
//       },
//     );
//   }
// }
