import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthSelectionScreen extends StatefulWidget {
  MonthSelectionScreen({super.key, required this.onPressed});

  final Function(int) onPressed;
  // final Function(int) onSelectedValue;

  @override
  State<MonthSelectionScreen> createState() => _MonthSelectionScreenState();
}

class _MonthSelectionScreenState extends State<MonthSelectionScreen> {
  final AttendenceController attendenceController = Get.put(AttendenceController());

  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  int selIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(months.length, (index) {
            return GestureDetector(
              onTap: () {
                widget.onPressed(index);
                setState(() {
                  selIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                // child: attendenceController.MonthSel_selIndex.value == index
                child: selIndex == index
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              const Color.fromRGBO(119, 229, 17, 0.37).withOpacity(0.2),
                              const Color.fromRGBO(7, 164, 178, 0.582).withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          months[index],
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    : Text(
                        months[index],
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
