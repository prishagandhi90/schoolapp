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
import 'package:emp_app/app/moduls/forgotpassword/binding/forgotpassword_binding.dart';
import 'package:emp_app/app/moduls/forgotpassword/screen/forgotpass_screen.dart';
import 'package:emp_app/app/moduls/internetconnection/binding/nointernet_binding.dart';
import 'package:emp_app/app/moduls/internetconnection/view/nointernet_screen.dart';
import 'package:emp_app/app/moduls/leave/bindings/leave_form_binding.dart';
import 'package:emp_app/app/moduls/leave/bindings/leave_main_screen_binding.dart';
import 'package:emp_app/app/moduls/leave/bindings/leave_view_binding.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_main_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_screen.dart';
import 'package:emp_app/app/moduls/leave/screen/leave_view_screen.dart';
import 'package:emp_app/app/moduls/login/bindings/login_binding.dart';
import 'package:emp_app/app/moduls/login/screen/login_screen.dart';
import 'package:emp_app/app/moduls/mispunch/bindings/mispunch_binding.dart';
import 'package:emp_app/app/moduls/mispunch/screen/mispunch_screen.dart';
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
import 'package:emp_app/app/moduls/verifyotp/bindings/verifyotp_binding.dart';
import 'package:emp_app/app/moduls/verifyotp/screen/otp_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static const initial = Routes.SPLASH;
  static String getInitialRoute(bool isLoggedIn) {
    return isLoggedIn ? _Paths.BOTTOMBAR : _Paths.LOGIN; // Redirect based on login status
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
      page: () => const Dashboard1Screen(),
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
      page: () => const ForgotpassScreen(mobileNumber: '',),
      binding: ForgotpasswordBinding(),
    ),
    
  ];
}
