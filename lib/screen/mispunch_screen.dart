import 'package:emp_app/controller/attendence_controller.dart';
import 'package:emp_app/custom_widget/custom_dropdown.dart';
import 'package:emp_app/custom_widget/custom_list_Scrollable.dart';
import 'package:emp_app/model/dropdown_G_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MispunchScreen extends StatefulWidget {
  const MispunchScreen({super.key});

  @override
  State<MispunchScreen> createState() => _MispunchScreenState();
}

class _MispunchScreenState extends State<MispunchScreen> {
  @override
  void initState() {
    super.initState();
    final AttendenceController attendenceController = Get.put(AttendenceController());
    attendenceController.getmonthyrempinfo();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendenceController>(
      init: AttendenceController(),
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
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
                      controller.monthYr_OnClick(value);
                    },
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(255, 179, 226, 238)),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          )),
                      onPressed: () async {
                        await controller.getmonthyrempinfotable();
                      },
                      child: const Text(
                        'Fetch',
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 2,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    if (controller.mispunchtable.isNotEmpty && index < controller.mispunchtable.length) {
                      return Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            const Padding(padding: EdgeInsets.all(8.0), child: Text('Code')),
                            Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].empCode}')),
                          ]),
                          TableRow(children: [
                            const Padding(padding: EdgeInsets.all(8.0), child: Text('Name')),
                            Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].empName}')),
                          ]),
                          TableRow(children: [
                            const Padding(padding: EdgeInsets.all(8.0), child: Text('Dept')),
                            Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].department}')),
                          ]),
                          TableRow(children: [
                            const Padding(padding: EdgeInsets.all(8.0), child: Text('Designation')),
                            Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].designation}')),
                          ]),
                          TableRow(children: [
                            const Padding(padding: EdgeInsets.all(8.0), child: Text('Type')),
                            Padding(padding: const EdgeInsets.all(8.0), child: Text('${controller.mispunchtable[index].empType}')),
                          ]),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  if (controller.FixedColRowBuilder().isNotEmpty)
                    FixedColumnWidget(
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Att Date')),
                      ],
                      rowBuilder: controller.FixedColRowBuilder,
                      headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 130, 240, 198)),
                    ),
                  if (controller.ScrollableColRowBuilder().isNotEmpty)
                    ScrollableColumnWidget(
                      columns: const [
                        DataColumn(label: Text('Mispunch')),
                        DataColumn(label: Text('Punch Time')),
                        DataColumn(label: Text('Shift time')),
                      ],
                      rowBuilder: controller.ScrollableColRowBuilder,
                      headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 182, 235, 214)),
                    ),
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
