import 'package:emp_app/controller/attendence_controller.dart';
import 'package:emp_app/custom_widget/custom_dropdown.dart';
import 'package:emp_app/model/dropdown_G_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendancdScreen extends StatefulWidget {
  const AttendancdScreen({super.key});

  @override
  State<AttendancdScreen> createState() => _AttendancdScreenState();
}

class _AttendancdScreenState extends State<AttendancdScreen> {
  @override
  void initState() {
    super.initState();
    final AttendenceController attendenceController = Get.put(AttendenceController());
    attendenceController.getmonthyr_empinfo();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendenceController>(
      init: AttendenceController(),
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Mnth Yr :'),
                      const SizedBox(width: 10),
                      CustomDropDown(
                        selectedValue: controller.selectedMonthYear,
                        items: controller.monthyr
                            .map(
                              (item) => DropdownMenuItem<Dropdown_Glbl>(
                                value: item,
                                child: Text(item.name.toString()),
                              ),
                            )
                            .toList(),
                        onChange: (Dropdown_Glbl? value) {
                          controller.MonthYr_OnClick(value);
                        },
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(255, 179, 226, 238)),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              )),
                          onPressed: () {},
                          child: const Text(
                            'Fetch',
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Row(
                  //   children: [
                  //     FixedColumnWidget(
                  //       headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 216, 215, 215)),
                  //       columns: const [
                  //         DataColumn(label: Text('TTL \nPRSNT')),
                  //         DataColumn(label: Text('TTL \nAB')),
                  //         DataColumn(label: Text('TTL \nDAYS')),
                  //       ],
                  //       rows: [
                  //         ...teamsData.map((team) => DataRow(
                  //               cells: [
                  //                 DataCell(Text('${team.position.toString()} ', style: const TextStyle(fontWeight: FontWeight.bold))),
                  //                 DataCell(Text('${team.points}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  //                 DataCell(Text('${team.points}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  //               ],
                  //             ))
                  //       ],
                  //     ),
                  //     ScrollableColumnWidget(
                  //       headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 233, 232, 232)),
                  //       columns: const [
                  //         DataColumn(label: Text('PRSNT')),
                  //         DataColumn(label: Text('AB')),
                  //         DataColumn(label: Text('WO')),
                  //         DataColumn(label: Text('CO')),
                  //         DataColumn(label: Text('PL')),
                  //         DataColumn(label: Text('SL')),
                  //         DataColumn(label: Text('CL')),
                  //         DataColumn(label: Text('HO')),
                  //         DataColumn(label: Text('ML')),
                  //       ],
                  //       rows: [
                  //         ...teamsData.map((team) => DataRow(
                  //               cells: [
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.won.toString()),
                  //                 // )),
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.lost.toString()),
                  //                 // )),
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.drawn.toString()),
                  //                 // )),
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.against.toString()),
                  //                 // )),
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.gd.toString()),
                  //                 // )),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.won.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.lost.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.drawn.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.against.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //               ],
                  //             ))
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   children: [
                  //     FixedColumnWidget(
                  //       headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 172, 225, 238)),
                  //       columns: const [
                  //         DataColumn(label: Text('#')),
                  //         DataColumn(label: Text('ATT \nDATE')),
                  //       ],
                  //       rows: [
                  //         ...team1sData.map((team) => DataRow(
                  //               cells: [
                  //                 DataCell(Text('${team.position.toString()} ', style: const TextStyle(fontWeight: FontWeight.bold))),
                  //                 DataCell(Text(team.attdate, style: const TextStyle(fontWeight: FontWeight.bold))),
                  //               ],
                  //             ))
                  //       ],
                  //     ),
                  //     ScrollableColumnWidget(
                  //       headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 201, 229, 236)),
                  //       columns: const [
                  //         DataColumn(label: Text('IN')),
                  //         DataColumn(label: Text('OUT')),
                  //         DataColumn(label: Text('PUNCH')),
                  //         DataColumn(label: Text('WO')),
                  //         DataColumn(label: Text('CO')),
                  //         DataColumn(label: Text('PL')),
                  //         DataColumn(label: Text('SL')),
                  //         DataColumn(label: Text('CL')),
                  //         DataColumn(label: Text('HO')),
                  //         DataColumn(label: Text('ML')),
                  //       ],
                  //       rows: [
                  //         ...team1sData.map((team) => DataRow(
                  //               cells: [
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.won.toString()),
                  //                 // )),
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.lost.toString()),
                  //                 // )),
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.drawn.toString()),
                  //                 // )),
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.against.toString()),
                  //                 // )),
                  //                 // DataCell(Container(
                  //                 //   alignment: Alignment.center,
                  //                 //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //                 //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
                  //                 //   child: Text(team.gd.toString()),
                  //                 // )),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.in1.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.out.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.punch.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.drawn.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.against.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //                 DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
                  //               ],
                  //             ))
                  //       ],
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
