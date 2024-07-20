import 'package:emp_app/app/app_custom_widget/custom_list_Scrollable.dart';
import 'package:emp_app/app/app_custom_widget/custom_month_picker.dart';
import 'package:emp_app/app/app_custom_widget/custom_progressloader.dart';
import 'package:emp_app/app/app_custom_widget/emp_att_dtl_extra_data.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({super.key});
  final AttendenceController attendenceController = Get.put(AttendenceController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendenceController>(
      builder: (controller) {
        return Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              MonthSelectionScreen(
                onPressed: (index) {
                  controller.upd_MonthSelIndex(index);
                },
              ),
              const SizedBox(height: 20),
              controller.isLoading1.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Center(child: ProgressWithIcon()),
                    )
                  : Row(children: [
                      (controller.attendencetable.isNotEmpty)
                          ? SingleChildScrollView(
                              child: DataTable(
                                  columnSpacing: Get.width * 0.06,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        const Color.fromRGBO(119, 229, 17, 0.37).withOpacity(0.2),
                                        const Color.fromRGBO(7, 164, 178, 0.582).withOpacity(0.2),
                                      ],
                                    ),
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('DATE')),
                                    DataColumn(label: Text('IN')),
                                    DataColumn(label: Text('OUT')),
                                    DataColumn(label: Text('LC/EG \nMIN')),
                                    DataColumn(label: Text('')),
                                  ],
                                  rows: List.generate(
                                      controller.attendencetable.length,
                                      (index) => DataRow(cells: [
                                            DataCell(
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 199, 199, 199),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [Text(controller.attendencetable[index].atTDATE.toString())],
                                                ),
                                              ),
                                            ),
                                            DataCell(Text(controller.attendencetable[index].iN.toString())),
                                            DataCell(Text(controller.attendencetable[index].out.toString())),
                                            DataCell(Text(controller.attendencetable[index].lCEGMIN.toString())),
                                            DataCell(IconButton(
                                              icon: const Icon(Icons.arrow_drop_down_circle),
                                              onPressed: () {
                                                // controller.detailbottomsheet(context);
                                                Get.to(
                                                  EmpAttDtlExtraData(
                                                    punch: controller.attendencetable[index].punch!,
                                                    shift: controller.attendencetable[index].shift!,
                                                    lv: controller.attendencetable[index].lv!,
                                                    st: controller.attendencetable[index].st!,
                                                    oTENTMIN: controller.attendencetable[index].oTENTMIN!,
                                                    oTMIN: controller.attendencetable[index].oTMIN!,
                                                    lc: controller.attendencetable[index].lc!,
                                                    eg: controller.attendencetable[index].eg!,
                                                  ),
                                                );
                                              },
                                            )),
                                          ]))),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(15),
                              child: Center(child: Text('No attendance data available')),
                            )
                      // if (attendenceController.scrollableColRowBuilderattprsnt().isNotEmpty)
                      //   ScrollableColumnWidget(
                      //     columns: const [
                      //       DataColumn(label: Text('TTL \nDAYS')),
                      //       DataColumn(label: Text('PRSNT')),
                      //       DataColumn(label: Text('AB')),
                      //       DataColumn(label: Text('WO')),
                      //       // DataColumn(label: Text('CO')),
                      //       // DataColumn(label: Text('PL')),
                      //       // DataColumn(label: Text('SL')),
                      //       // DataColumn(label: Text('CL')),
                      //       // DataColumn(label: Text('HO')),
                      //       // DataColumn(label: Text('ML')),
                      //       // DataColumn(label: Text('CH')),
                      //       // DataColumn(label: Text('LC/EG \nMIN')),
                      //       // DataColumn(label: Text('LC/EG \nCNT')),
                      //       // DataColumn(label: Text('N TO \nHRS')),
                      //       // DataColumn(label: Text('C TO \nHRS')),
                      //       // DataColumn(label: Text('TTL OF \nHRS')),
                      //       // DataColumn(label: Text('DUTY \nHRS')),
                      //       // DataColumn(label: Text('DUTY \nST')),
                      //     ],
                      //     rowBuilder: attendenceController.scrollableColRowBuilderattprsnt,
                      //     headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 182, 235, 214)),
                      //   ),
                    ]),
            ],
          ),
        ));
      },
    );
  }
}
