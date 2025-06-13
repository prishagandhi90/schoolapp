import 'package:emp_app/app/core/util/app_image.dart';
import 'package:flutter/material.dart';

class AppConst {
  static  List<Map<String, dynamic>> listItems = [
    {'image': AppImage.HIMS, 'label': 'HIMS'},
    {'image': AppImage.opd, 'label': 'OPD'},
    {'image': AppImage.ipd, 'label': 'IPD'},
    {'image': AppImage.store, 'label': 'Store'},
    {'image': AppImage.radio, 'label': 'Radiology'},
    {'image': AppImage.patho, 'label': 'Pathology'},
    {'image': AppImage.pharma, 'label': 'Pharmacy'},
    {'image': AppImage.payroll, 'label': 'Payroll'},
    {'image': AppImage.OT, 'label': 'Operation Theater'},
  ];

  static  List<Map<String, dynamic>> gridview = [
    {'image': AppImage.HIMS, 'label': 'HIMS'},
    {'image': AppImage.opd, 'label': 'OPD'},
    {'image': AppImage.ipd, 'label': 'IPD'},
    {'image': AppImage.store, 'label': 'STORE'},
    {'image': AppImage.radio, 'label': 'RADIOLOGY'},
    {'image': AppImage.patho, 'label': 'PATHOLOGY'},
    {'image': AppImage.pharma, 'label': 'PHARMACY'},
    {'image': AppImage.payroll, 'label': 'PAYROLL'},
    {'image': AppImage.OT, 'label': 'OT'},
    {'image': AppImage.nabh, 'label': 'NABH'},
  ];

  static const List<Map<String, dynamic>> payrolllist = [
    {'image': 'assets/image/attendence.png', 'label': 'Attendance'},
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
    {'image': 'assets/image/attendence.png', 'label': 'Attendance'},
    {'image': 'assets/image/mispunch.png', 'label': 'Mispunch Info'},
    {'image': 'assets/image/leave.png', 'label': 'Leave Entry'},
    {'image': 'assets/image/overtime.png', 'label': 'Over Time Entry'},
    {'image': 'assets/image/dutySchedule.png', 'label': 'Duty Schedule'},
    {'image': 'assets/image/lvotapp.png', 'label': 'LV/OT Approval'},
  ];

  static const OTPTimer = 60;

  static const List<Map<String, dynamic>> pharmacygrid = [
    {'image': 'assets/image/prescription.png', 'label': 'Prescription Viewer'},
  ];

  static const List<Map<String, dynamic>> adpatientgrid = [
    {'image': 'assets/image/AdPatient.png', 'label': 'Admitted Patients'},
    {'image': 'assets/image/invest_requisite.png', 'label': 'Investigation Requisition'},
  ];
}
