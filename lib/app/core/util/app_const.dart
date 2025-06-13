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

  static  List<Map<String, dynamic>> payrolllist = [
    {'image': AppImage.attendance, 'label': 'Attendance'},
    {'image': AppImage.mispunch, 'label': 'Mispunch Info'},
    {'image': AppImage.leave, 'label': 'Leave Entry'},
    {'image': AppImage.overtime, 'label': 'Over Time'},
  ];

  static const List<Map<String, dynamic>> bottomview = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.star, 'label': 'Attendence'},
    {'icon': Icons.settings, 'label': 'LV/OT'},
    {'icon': Icons.dashboard, 'label': 'Dashboard'},
  ];

  static  List<Map<String, dynamic>> payrollgrid = [
    {'image': AppImage.attendance, 'label': 'Attendance'},
    {'image':AppImage.mispunch, 'label': 'Mispunch Info'},
    {'image': AppImage.leave, 'label': 'Leave Entry'},
    {'image': AppImage.overtime, 'label': 'Over Time Entry'},
    {'image': AppImage.dutySchedule, 'label': 'Duty Schedule'},
    {'image': AppImage.lvotapproval, 'label': 'LV/OT Approval'},
  ];

  static const OTPTimer = 60;

  static  List<Map<String, dynamic>> pharmacygrid = [
    {'image': AppImage.prescription, 'label': 'Prescription Viewer'},
  ];

  static  List<Map<String, dynamic>> adpatientgrid = [
    {'image': AppImage.adpatient, 'label': 'Admitted Patients'},
    {'image': AppImage.investrequisite, 'label': 'Investigation Requisition'},
  ];
}
