// import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
// import 'package:emp_app/app/moduls/verifyotp/controller/otp_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomTabbar extends StatefulWidget {
//   const CustomTabbar({super.key});

//   @override
//   State<CustomTabbar> createState() => _CustomTabbarState();
// }

// class _CustomTabbarState extends State<CustomTabbar> {
//   final LoginController loginController = Get.find<LoginController>();
//   final OtpController otpController = Get.put(OtpController());

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         length: 2,
//         child: Column(children: [
//           Container(
//             height: 60,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey[200],
//               ),
//               child: TabBar(
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.black,
//                 indicator: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.pink,
//                 ),
//                 tabs: const [
//                   Tab(
//                     text: 'Basic',
//                   ),
//                   Tab(
//                     text: 'Advanced',
//                   )
//                 ],
//               ),
//             ),
//           ),
//           // TabBarView
//           const Expanded(
//             child: TabBarView(
//               children: [
//                 Center(
//                   child: Text('Basic Tab Content'),
//                 ),
//                 Center(
//                   child: Text('Advanced Tab Content'),
//                 ),
//               ],
//             ),
//           ),
//         ]));
//   }
// }
