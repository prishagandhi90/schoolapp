import 'package:emp_app/app/core/util/app_string.dart';
import 'package:emp_app/app/core/util/app_style.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';
import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/app_font_name.dart';

class CircularScreen extends StatelessWidget {
  const CircularScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        title: Text(AppString.circularScreen, style: AppStyle.primaryplusw700),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Divider(color: AppColor.originalgrey, thickness: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.all(getDynamicHeight(size: 0.010)),//8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.hr,
                          style: TextStyle(
                            color: AppColor.black,
                            // fontSize: 18,
                            fontSize: getDynamicHeight(size: 0.020),
                            fontWeight: FontWeight.bold,
                            fontFamily: CommonFontStyle.plusJakartaSans,
                          ),
                        ),
                        Text(
                          '12/12/2021',
                          style: TextStyle(
                            color: AppColor.black,
                            // fontSize: 14,
                            fontSize: getDynamicHeight(size: 0.016),
                            fontWeight: FontWeight.w400,
                            fontFamily: CommonFontStyle.plusJakartaSans,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getDynamicHeight(size: 0.012)),//10),
                    Text(
                      'data',
                      style: TextStyle(
                        color: AppColor.black,
                        // fontSize: 14,
                        fontSize: getDynamicHeight(size: 0.016),
                        fontWeight: FontWeight.w400,
                        fontFamily: CommonFontStyle.plusJakartaSans,
                      ),
                    ),
                    Divider(color: AppColor.black, thickness: 1),
                    Text('data'),
                  ],
                ),
              ),
            ),
          ),

          /// ✅ Ye part bottom pe fixed rahega
          Padding(
            padding: const EdgeInsets.only(bottom: 25, left: 15),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 150, // Width like your image
                height: 100, // Height like your image
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Rounded edges
                  border: Border.all(color: Colors.black), // Black border
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, -2), // Light shadow
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'FFG.pdf',
                    style: TextStyle(
                      color: Colors.black,
                      // fontSize: 16,
                      fontSize: getDynamicHeight(size: 0.018),
                      fontWeight: FontWeight.w500,
                      fontFamily: CommonFontStyle.plusJakartaSans,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:emp_app/app/core/util/app_color.dart';
// import 'package:emp_app/app/core/util/app_font_name.dart';
// import 'package:flutter/material.dart';

// class CircularScreen extends StatelessWidget {
//   const CircularScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       appBar: AppBar(
//         backgroundColor: AppColor.white,
//         title: Text(
//           'Circular Screen',
//           style: TextStyle(
//             color: AppColor.primaryColor,
//             fontWeight: FontWeight.w700,
//             fontFamily: CommonFontStyle.plusJakartaSans,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Divider(
//             color: AppColor.originalgrey,
//             thickness: 1,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'HR',
//                   style: TextStyle(
//                     color: AppColor.black,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: CommonFontStyle.plusJakartaSans,
//                   ),
//                 ),
//                 Text('12/12/2021',
//                     style: TextStyle(
//                       color: AppColor.black,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: CommonFontStyle.plusJakartaSans,
//                     )),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: Text('data',
//                   style: TextStyle(
//                     color: AppColor.black,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     fontFamily: CommonFontStyle.plusJakartaSans,
//                   )),
//             ),
//           ),
//           Divider(
//             color: AppColor.black,
//             thickness: 1,
//           ),
//           Text('data')
//         ],
//       ),
      
//     );
//   }
// }
