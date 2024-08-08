import 'package:flutter/material.dart';

class AppConst {
  static const List<Map<String, dynamic>> listItems = [
    {'image': 'assets/image/HIMS.png', 'label': 'HIMS'},
    {'image': 'assets/image/OPD.png', 'label': 'OPD'},
    {'image': 'assets/image/IPD.png', 'label': 'IPD'},
    {'image': 'assets/image/stores.png', 'label': 'STORE'},
    {'image': 'assets/image/radio.png', 'label': 'RADIOLOGY'},
    {'image': 'assets/image/patho.png', 'label': 'PATHOLOGY'},
    {'image': 'assets/image/pharma.png', 'label': 'PHARMACY'},
    {'image': 'assets/image/payroll.png', 'label': 'PAYROLL'},
    {'image': 'assets/image/OT.png', 'label': 'OPERATION THEATER'},
  ];

  static const List<Map<String, dynamic>> gridview = [
    {'image': 'assets/image/HIMS.png', 'label': 'HIMS'},
    {'image': 'assets/image/OPD.png', 'label': 'OPD'},
    {'image': 'assets/image/IPD.png', 'label': 'IPD'},
    {'image': 'assets/image/stores.png', 'label': 'STORE'},
    {'image': 'assets/image/radio.png', 'label': 'RADIOLOGY'},
    {'image': 'assets/image/patho.png', 'label': 'PATHOLOGY'},
    {'image': 'assets/image/pharma.png', 'label': 'PHARMACY'},
    {'image': 'assets/image/payroll.png', 'label': 'PAYROLL'},
    {'image': 'assets/image/OT.png', 'label': 'OT'},
    {'image': 'assets/image/NABH.png', 'label': 'NABH'},
  ];

  static const List<Map<String, dynamic>> payrolllist = [
    {'image': 'assets/image/attendence.png', 'label': 'Attendence'},
    {'image': 'assets/image/mispunch.png', 'label': 'Mispunch Info'},
    {'image': 'assets/image/leave.png', 'label': 'Leave Entry'},
    {'image': 'assets/image/overtime.png', 'label': 'Over Time'},
  ];

  static const List<Map<String, dynamic>> bottomview = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.star, 'label': 'Attendence'},
    {'icon': Icons.settings, 'label': 'LV/OT'},
    {'icon': Icons.dashboard, 'label': 'Dashboard'},
  ];

  static const List<Map<String, dynamic>> payrollgrid = [
    {'image': 'assets/image/attendence.png', 'label': 'Attendence'},
    {'image': 'assets/image/mispunch.png', 'label': 'Mispunch Info'},
    {'image': 'assets/image/leave.png', 'label': 'Leave Entry'},
    {'image': 'assets/image/overtime.png', 'label': 'Over Time Entry'},
  ];
}
