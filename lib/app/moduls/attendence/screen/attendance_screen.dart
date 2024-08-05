import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:emp_app/app/moduls/attendence/screen/details_screen.dart';
import 'package:emp_app/app/moduls/attendence/screen/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceScreen extends GetView<AttendenceController> {
  AttendanceScreen({super.key});

//   @override
//   State<AttendanceScreen> createState() => AttendanceScreenState();
// }

// class AttendanceScreenState extends State<AttendanceScreen> {
  final AttendenceController attendenceController = Get.put(AttendenceController());

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     attendenceController.setCurrentMonthYear();
  //     // attendenceController.showHideMsg();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendenceController>(
      builder: (controller) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            // onDrawerChanged: (isop) {
            //   var bottomBarController = Get.put(BottomBarController());
            //   hideBottomBar.value = isop;
            //   bottomBarController.update();
            // },
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                'Attendance',
                style: TextStyle(color: Color.fromARGB(255, 94, 157, 168), fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.clearData();
                  },
                  icon: const Icon(Icons.arrow_back)),
              actions: [
                CustomDropDown(
                  selValue: controller.YearSel_selIndex,
                  onPressed: (index) {
                    controller.upd_YearSelIndex(index);
                    attendenceController.showHideMsg();
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 223, 239, 241),
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColor.black,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 94, 157, 168)),
                      tabs: const [Tab(text: 'Summary'), Tab(text: 'Details')],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SummaryScreen(),
                      DetailsScreen(),
                    ],
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: CustomBottomBar(),
          ),
        );
      },
    );
  }
}



























// import 'package:emp_app/app/moduls/attendence/controller/attendence_controller.dart';
// import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
// import 'package:emp_app/app/app_custom_widget/custom_list_Scrollable.dart';
// import 'package:emp_app/app/core/model/dropdown_G_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AttendancdScreen extends StatefulWidget {
//   const AttendancdScreen({super.key});

//   @override
//   State<AttendancdScreen> createState() => _AttendancdScreenState();
// }

// class _AttendancdScreenState extends State<AttendancdScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final AttendenceController attendenceController = Get.put(AttendenceController());
//     attendenceController.getmonthyrempinfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AttendenceController>(
//       init: AttendenceController(),
//       builder: (controller) {
//         return Scaffold(
//           body: Padding(
//             padding: const EdgeInsets.all(10),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       const Text('Mnth Yr :'),
//                       SizedBox(width: MediaQuery.of(context).size.width * 0.01),
//                       CustomDropDown(
//                         selectedValue: controller.selectedMonthYear,
//                         items: controller.monthyr
//                             .map(
//                               (item) => DropdownMenuItem<Dropdown_Glbl>(
//                                 value: item,
//                                 child: Text(item.name.toString()),
//                               ),
//                             )
//                             .toList(),
//                         onChange: (Dropdown_Glbl? value) {
//                           controller.monthYr_OnClick1(value);
//                         },
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         style: ButtonStyle(
//                             backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(255, 179, 226, 238)),
//                             shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             )),
//                         child: const Text(
//                           'Fetch',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         onPressed: () async {
//                           await controller.getattendeceprsnttable();
//                           await controller.getattendeceinfotable();
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       if (controller.fixedColRowBuilderattprsnt().isNotEmpty)
//                         FixedColumnWidget(
//                           columns: const [
//                             DataColumn(label: Text('TTL \nPRSNT')),
//                             DataColumn(label: Text('TTL \nAB')),
//                             // DataColumn(label: Text('TTL \nDAYS')),
//                           ],
//                           rowBuilder: controller.fixedColRowBuilderattprsnt,
//                           headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 130, 240, 198)),
//                         ),
//                       if (controller.scrollableColRowBuilderattprsnt().isNotEmpty)
//                         ScrollableColumnWidget(
//                           columns: const [
//                             DataColumn(label: Text('TTL \nDAYS')),
//                             DataColumn(label: Text('PRSNT')),
//                             DataColumn(label: Text('AB')),
//                             DataColumn(label: Text('WO')),
//                             DataColumn(label: Text('CO')),
//                             DataColumn(label: Text('PL')),
//                             DataColumn(label: Text('SL')),
//                             DataColumn(label: Text('CL')),
//                             DataColumn(label: Text('HO')),
//                             DataColumn(label: Text('ML')),
//                             DataColumn(label: Text('CH')),
//                             DataColumn(label: Text('LC/EG \nMIN')),
//                             DataColumn(label: Text('LC/EG \nCNT')),
//                             DataColumn(label: Text('N TO \nHRS')),
//                             DataColumn(label: Text('C TO \nHRS')),
//                             DataColumn(label: Text('TTL OF \nHRS')),
//                             DataColumn(label: Text('DUTY \nHRS')),
//                             DataColumn(label: Text('DUTY \nST')),
//                           ],
//                           rowBuilder: controller.scrollableColRowBuilderattprsnt,
//                           headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 182, 235, 214)),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       if (controller.fixedColRowBuilderattndence().isNotEmpty)
//                         FixedColumnWidget(
//                           columns: const [
//                             DataColumn(label: Text('#')),
//                             DataColumn(label: Text('Att Date')),
//                           ],
//                           rowBuilder: controller.fixedColRowBuilderattndence,
//                           headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 130, 240, 198)),
//                         ),
//                       if (controller.scrollableColRowBuilderattndence().isNotEmpty)
//                         ScrollableColumnWidget(
//                           columns: const [
//                             DataColumn(label: Text('IN')),
//                             DataColumn(label: Text('OUT')),
//                             DataColumn(label: Text('PUNCH')), //overflow: TextOverflow.ellipsis, softWrap: false
//                             DataColumn(label: Text('SHIFT')),
//                             DataColumn(label: Text('LV')),
//                             DataColumn(label: Text('ST')),
//                             DataColumn(label: Text('OT ENT \nMIN')),
//                             DataColumn(label: Text('OT MIN')),
//                             DataColumn(label: Text('LC')),
//                             DataColumn(label: Text('EG')),
//                             DataColumn(label: Text('LC/EG \nMIN')),
//                           ],
//                           rowBuilder: controller.scrollableColRowBuilderattndence,
//                           headingRowColor: const WidgetStatePropertyAll(Color.fromARGB(255, 182, 235, 214)),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class CustomWidthCell extends StatelessWidget {
//   final Widget child;

//   const CustomWidthCell({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black), // Add border color
//       ),
//       child: child,
//     );
//   }
// }
