import 'package:emp_app/app/moduls/admitted%20patient/bindings/admittedPatientBinding.dart';
import 'package:emp_app/app/moduls/admitted%20patient/bindings/ipdDashboardBinding.dart';
import 'package:emp_app/app/moduls/admitted%20patient/bindings/labReportsViewBinding.dart';
import 'package:emp_app/app/moduls/admitted%20patient/bindings/labSummaryScreenBinding.dart';
import 'package:emp_app/app/moduls/admitted%20patient/bindings/voiceScreenBinding.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/adpatient_screen.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/ipd_dashboard_screen.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/lab_reports_view.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/lab_summary_screen.dart';
import 'package:emp_app/app/moduls/admitted%20patient/screen/speechtotext_screen.dart';
import 'package:emp_app/app/moduls/attendence/bindings/attendance_detail_binding.dart';
import 'package:emp_app/app/moduls/attendence/bindings/attendance_summary_binding.dart';
import 'package:emp_app/app/moduls/attendence/bindings/attendance_screen_binding.dart';
import 'package:emp_app/app/moduls/attendence/screen/attendance_screen.dart';
import 'package:emp_app/app/moduls/attendence/screen/details_screen.dart';
import 'package:emp_app/app/moduls/attendence/screen/summary_screen.dart';
import 'package:emp_app/app/moduls/bottombar/bindings/bottombar_binding.dart';
import 'package:emp_app/app/moduls/bottombar/screen/bottom_bar_screen.dart';
import 'package:emp_app/app/moduls/dashboard/bindings/DashboardBinding.dart';
import 'package:emp_app/app/moduls/dashboard/screen/dashboard1_screen.dart';
import 'package:emp_app/app/moduls/force_update/bindings/force_update_binding.dart';
import 'package:emp_app/app/moduls/force_update/screen/force_update_screen.dart';
import 'package:emp_app/app/moduls/forgotpassword/binding/forgotpassword_binding.dart';
import 'package:emp_app/app/moduls/forgotpassword/screen/forgotpass_screen.dart';
import 'package:emp_app/app/moduls/internetconnection/binding/nointernet_binding.dart';
import 'package:emp_app/app/moduls/internetconnection/view/nointernet_screen.dart';
import 'package:emp_app/app/moduls/invest_requisit/bindings/investRequisitScreenBinding.dart';
import 'package:emp_app/app/moduls/invest_requisit/bindings/investServiceScreenBinding.dart';
import 'package:emp_app/app/moduls/invest_requisit/screen/invest_requisit_screen.dart';
import 'package:emp_app/app/moduls/invest_requisit/screen/invest_service_screen.dart';
import 'package:emp_app/app/moduls/leave/bindings/leave_form_binding.dart';
import 'package:emp_app/app/moduls/leave/bindings/leave_main_screen_binding.dart';
import 'package:emp_app/app/moduls/leave/bindings/leave_view_binding.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_main_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_view_screen.dart';
import 'package:emp_app/app/moduls/login/bindings/login_binding.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/lvotApproval/binding/lv_screen_Binding.dart';
import 'package:emp_app/app/moduls/lvotApproval/binding/lvot_appr_screen_Binding.dart';
import 'package:emp_app/app/moduls/lvotApproval/binding/otList_screen_Binding.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/lvlist_screen.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/lvotapproval_screen.dart';
import 'package:emp_app/app/moduls/lvotApproval/screen/otlist_screen.dart';
import 'package:emp_app/app/moduls/mispunch/bindings/mispunch_binding.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
import 'package:emp_app/app/moduls/notification/bindings/filterScreenBinding.dart';
import 'package:emp_app/app/moduls/notification/bindings/filterTagScreenBinding.dart';
import 'package:emp_app/app/moduls/notification/bindings/notificationScreenBinding.dart';
import 'package:emp_app/app/moduls/notification/screen/filter_screen.dart';
import 'package:emp_app/app/moduls/notification/screen/filter_tag_screen.dart';
import 'package:emp_app/app/moduls/notification/screen/notification_screen.dart';
import 'package:emp_app/app/moduls/overtime/bindings/overtime_form_binding.dart';
import 'package:emp_app/app/moduls/overtime/bindings/overtime_main_screen_binding.dart';
import 'package:emp_app/app/moduls/overtime/bindings/overtime_view_binding.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_view_screen.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtime_main_screen.dart';
import 'package:emp_app/app/moduls/overtime/screens/overtimedemo.dart';
import 'package:emp_app/app/moduls/payroll/bindings/payroll_binding.dart';
import 'package:emp_app/app/moduls/payroll/screen/payroll_screen.dart';
import 'package:emp_app/app/moduls/resetpassword/binding/reset_password_binding.dart';
import 'package:emp_app/app/moduls/resetpassword/screen/resetpass_screen.dart';
import 'package:emp_app/app/moduls/superlogin/binding/superlogin_binding.dart';
import 'package:emp_app/app/moduls/superlogin/screen/superlogin_screen.dart';
import 'package:emp_app/app/moduls/verifyotp/bindings/verifyotp_binding.dart';
import 'package:emp_app/app/moduls/verifyotp/screen/otp_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String getInitialRoute(bool isLoggedIn, bool isForceUpdate) {
    if (isForceUpdate) {
      return _Paths.Force_update;
    } else {
      return isLoggedIn ? _Paths.BOTTOMBAR : _Paths.LOGIN;
    }
  }

  static final routes = [
    GetPage(
      name: _Paths.NoInterNet,
      page: () => const NoInternetView(),
      binding: NoInternetBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.Force_update,
      page: () => ForceUpdateScreen(),
      binding: ForceUpdateBinding(),
    ),
    GetPage(
      name: _Paths.VERIFYOTP,
      // page: () => const OtpScreen(),
      page: () {
        // You can retrieve parameters from the route here
        final arguments = Get.arguments; // This will get any arguments passed
        return OtpScreen(
          mobileNumber: arguments['mobileNumber'],
          deviceToken: arguments['deviceToken'],
          fromLogin: true,
        ); // Pass the required parameter
      },
      binding: VerifyotpBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => Dashboard1Screen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOMBAR,
      page: () => BottomBarView(),
      binding: BottomBarBinding(),
    ),
    GetPage(
      name: _Paths.PAYROLL,
      page: () => PayrollScreen(),
      binding: PayrollBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCESCREEN,
      page: () => AttendanceScreen(),
      binding: AttendanceScreenBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCESUMMARY,
      page: () => const SummaryScreen(),
      binding: AttendanceSummaryBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCEDETAIL,
      page: () => const DetailsScreen(),
      binding: AttendanceDetailBinding(),
    ),
    GetPage(
      name: _Paths.MISPUNCHSCREEN,
      page: () => const MispunchScreen(),
      binding: MispunchBinding(),
    ),
    GetPage(
      name: _Paths.LEAVEMAINSCREEN,
      page: () => LeaveMainScreen(),
      binding: LeaveMainScreenBinding(),
    ),
    GetPage(
      name: _Paths.LEAVEENTRY,
      page: () => LeaveScreen(),
      binding: LeaveFormBinding(),
    ),
    GetPage(
      name: _Paths.LEAVEVIEW,
      page: () => const LeaveViewScreen(),
      binding: LeaveViewBinding(),
    ),
    GetPage(
      name: _Paths.OVERTIMEMAINSCREEN,
      page: () => OvertimeMainScreen(),
      binding: OvertimeMainScreenBinding(),
    ),
    GetPage(
      name: _Paths.OVERTIMEENTRY,
      page: () => OvertimeScreen(),
      binding: OvertimeFormBinding(),
    ),
    GetPage(
      name: _Paths.OVERTIMEVIEW,
      page: () => const OvertimeViewScreen(),
      binding: OvertimeViewBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetpassScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOTPASSWORD,
      page: () => const ForgotpassScreen(
        mobileNumber: '',
      ),
      binding: ForgotpasswordBinding(),
    ),
    GetPage(
      name: _Paths.SuperLogin,
      page: () => const SuperloginScreen(
        mobileNo: '',
      ),
      binding: SuperLoginBinding(),
    ),
    GetPage(
      name: _Paths.LVOTApprovalScreen,
      page: () => const LvotapprovalScreen(),
      binding: lvot_appr_screen_Binding(),
    ),
    GetPage(
      name: _Paths.LVListScreen,
      page: () => LvList(),
      binding: lv_screen_Binding(),
    ),
    GetPage(
      name: _Paths.OTListScreen,
      page: () => const OtlistScreen(),
      binding: otList_screen_Binding(),
    ),
    GetPage(
      name: _Paths.IPDDASHBOARDSCREEN,
      page: () => IpdDashboardScreen(),
      binding: IPDDashboardBinding(),
    ),
    GetPage(
      name: _Paths.IPDADMITTEDPATIENTS,
      page: () => AdpatientScreen(),
      binding: AdmittedPatientBinding(),
    ),
    GetPage(
      name: _Paths.LABREPORTSSCREEN,
      page: () {
        // You can retrieve parameters from the route here
        final arguments = Get.arguments; // This will get any arguments passed
        return LabReportsView(
          bedNumber: arguments['bedNumber'],
          ipdNo: arguments['ipdNo'],
          patientName: arguments['patientName'],
          uhidNo: arguments['uhidNo'],
        ); // Pass the required parameter
      },
      binding: LabReportsViewBinding(),
    ),
    GetPage(
      name: _Paths.LABSUMMARYSCREEN,
      page: () => LabSummaryScreen(),
      binding: LabSummaryScreenBinding(),
    ),
    GetPage(
      name: _Paths.VOICESCREEN,
      page: () => VoiceScreen(),
      binding: VoiceScreenBinding(),
    ),
    GetPage(
      name: _Paths.INVESTIGATIONREQUISITIONSCREEN,
      page: () => InvestRequisitScreen(),
      binding: InvestRequisitScreenBinding(),
    ),
    GetPage(
      name: _Paths.INVESTIGATIONREQUISITIONSERVICE,
      page: () => InvestServiceScreen(),
      binding: InvestServiceScreenBinding(),
    ),
    GetPage(
      name: _Paths.FILTERSCREEN,
      page: () => FilterScreen(),
      binding: FilterScreenBinding(),
    ),
    GetPage(
      name: _Paths.FILTERTAGSCREEN,
      page: () {
        // You can retrieve parameters from the route here
        final arguments = Get.arguments; // This will get any arguments passed
        return FilterTagScreen(
          index: arguments['index'],
        ); // Pass the required parameter
      },
      binding: FilterTagScreenBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONSCREEN,
      page: () => NotificationScreen(),
      binding: NotificationScreenBinding(),
    )
  ];
}
