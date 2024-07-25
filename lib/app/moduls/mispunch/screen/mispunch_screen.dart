import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/moduls/bottombar/controller/bottom_bar_controller.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/app_custom_widget/custom_containerview.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/moduls/mispunch/controller/mispunch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MispunchScreen extends StatelessWidget {
  MispunchScreen({super.key});

  final MispunchController mispunchController = Get.put(MispunchController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MispunchController>(
      builder: (controller) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Mispunch Details',
                style: TextStyle(color: Color.fromARGB(255, 94, 157, 168), fontWeight: FontWeight.w600, fontSize: 20),
              ),
              actions: [
                CustomDropDown(
                  onPressed: (index) {
                    controller.upd_YearSelIndex(index);
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
                    onPressed: (index) {
                      controller.upd_MonthSelIndex(index);
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: controller.isLoading.value
                        ? const Padding(padding: EdgeInsets.symmetric(vertical: 100), child: Center(child: ProgressWithIcon()))
                        : controller.mispunchtable.isNotEmpty
                            ? ListView.builder(
                                itemCount: controller.mispunchtable.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.15,
                                      decoration:
                                          BoxDecoration(color: const Color.fromRGBO(211, 240, 243, 0.58), borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: double.infinity,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  const Color.fromRGBO(119, 229, 17, 0.37).withOpacity(0.2),
                                                  const Color.fromRGBO(7, 164, 178, 0.582).withOpacity(0.2),
                                                ],
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    controller.mispunchtable[index].dt.toString(),
                                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                                  )),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              CustomContainerview(text: 'TYPE', text1: controller.mispunchtable[index].misPunch.toString()),
                                              CustomContainerview(text: 'PUNCH TIME', text1: controller.mispunchtable[index].punchTime.toString()),
                                              CustomContainerview(text: 'SHIFT TIME', text1: controller.mispunchtable[index].shiftTime.toString()),
                                            ],
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
                                  child: Text('No attendance data available'),
                                ),
                              ),
                  ),
                ],
              ),
            ),
            // bottomNavigationBar: CustomBottomBar(),
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
