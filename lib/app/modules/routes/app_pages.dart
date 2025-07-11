import 'package:schoolapp/app/modules/IPD/admitted%20patient/bindings/admittedPatientBinding.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/bindings/ipdDashboardBinding.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/bindings/labReportsViewBinding.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/bindings/labSummaryScreenBinding.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/bindings/voiceScreenBinding.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/screen/adpatient_screen.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/screen/ipd_dashboard_screen.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/screen/lab_reports_view.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/screen/lab_summary_screen.dart';
import 'package:schoolapp/app/modules/IPD/admitted%20patient/screen/speechtotext_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/bindings/attendance_detail_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/bindings/attendance_summary_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/bindings/attendance_screen_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/screen/attendance_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/screen/details_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/attendence/screen/summary_screen.dart';
import 'package:schoolapp/app/modules/bottombar/bindings/bottombar_binding.dart';
import 'package:schoolapp/app/modules/bottombar/screen/bottom_bar_screen.dart';
import 'package:schoolapp/app/modules/dashboard/bindings/DashboardBinding.dart';
import 'package:schoolapp/app/modules/dashboard/screen/dashboard1_screen.dart';
import 'package:schoolapp/app/modules/force_update/bindings/force_update_binding.dart';
import 'package:schoolapp/app/modules/force_update/screen/force_update_screen.dart';
import 'package:schoolapp/app/modules/forgotpassword/binding/forgotpassword_binding.dart';
import 'package:schoolapp/app/modules/forgotpassword/screen/forgotpass_screen.dart';
import 'package:schoolapp/app/modules/internetconnection/binding/nointernet_binding.dart';
import 'package:schoolapp/app/modules/internetconnection/view/nointernet_screen.dart';
import 'package:schoolapp/app/modules/IPD/invest_requisit/bindings/investRequisitScreenBinding.dart';
import 'package:schoolapp/app/modules/IPD/invest_requisit/bindings/investServiceScreenBinding.dart';
import 'package:schoolapp/app/modules/IPD/invest_requisit/screen/invest_requisit_screen.dart';
import 'package:schoolapp/app/modules/IPD/invest_requisit/screen/invest_service_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/bindings/leave_form_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/bindings/leave_main_screen_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/bindings/leave_view_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/screen/leave_main_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/screen/leave_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/leave/screen/leave_view_screen.dart';
import 'package:schoolapp/app/modules/login/bindings/login_binding.dart';
import 'package:schoolapp/app/modules/login/screen/login_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/lvotApproval/binding/lv_screen_Binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/lvotApproval/binding/lvot_appr_screen_Binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/lvotApproval/binding/otList_screen_Binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/lvotApproval/screen/lvlist_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/lvotApproval/screen/lvotapproval_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/lvotApproval/screen/otlist_screen.dart';
import 'package:schoolapp/app/modules/IPD/medication_sheet/bindings/addMedicationScreenBinding.dart';
import 'package:schoolapp/app/modules/IPD/medication_sheet/bindings/medicationScreenBinding.dart';
import 'package:schoolapp/app/modules/IPD/medication_sheet/bindings/viewMedicationScreenBinding.dart';
import 'package:schoolapp/app/modules/IPD/medication_sheet/screen/addmedication_screen.dart';
import 'package:schoolapp/app/modules/IPD/medication_sheet/screen/medication_screen.dart';
import 'package:schoolapp/app/modules/IPD/medication_sheet/screen/view_medication_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/mispunch/bindings/mispunch_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/mispunch/screen/mispunch_screen.dart';
import 'package:schoolapp/app/modules/notification/bindings/filterScreenBinding.dart';
import 'package:schoolapp/app/modules/notification/bindings/filterTagScreenBinding.dart';
import 'package:schoolapp/app/modules/notification/bindings/notificationScreenBinding.dart';
import 'package:schoolapp/app/modules/notification/screen/filter_screen.dart';
import 'package:schoolapp/app/modules/notification/screen/filter_tag_screen.dart';
import 'package:schoolapp/app/modules/notification/screen/notification_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/overtime/bindings/overtime_form_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/overtime/bindings/overtime_main_screen_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/overtime/bindings/overtime_view_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/overtime/screens/overtime_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/overtime/screens/overtime_view_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/overtime/screens/overtime_main_screen.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/payroll/bindings/payroll_binding.dart';
import 'package:schoolapp/app/modules/PAYROLL_MAIN/payroll/screen/payroll_screen.dart';
import 'package:schoolapp/app/modules/pharmacy/bindings/pharmacyScreenBinding.dart';
import 'package:schoolapp/app/modules/pharmacy/bindings/presdetailsScreenBinding.dart';
import 'package:schoolapp/app/modules/pharmacy/bindings/presviewerScreenBinding.dart';
import 'package:schoolapp/app/modules/pharmacy/screen/pharmacy_screen.dart';
import 'package:schoolapp/app/modules/pharmacy/screen/presdetails_screen.dart';
import 'package:schoolapp/app/modules/pharmacy/screen/presviewer_screen.dart';
import 'package:schoolapp/app/modules/registration/bindings/registration_binding.dart';
import 'package:schoolapp/app/modules/registration/screens/registration_view.dart';
import 'package:schoolapp/app/modules/resetpassword/binding/reset_password_binding.dart';
import 'package:schoolapp/app/modules/resetpassword/screen/resetpass_screen.dart';
import 'package:schoolapp/app/modules/superlogin/binding/superlogin_binding.dart';
import 'package:schoolapp/app/modules/superlogin/screen/superlogin_screen.dart';
import 'package:schoolapp/app/modules/verifyotp/bindings/verifyotp_binding.dart';
import 'package:schoolapp/app/modules/verifyotp/screen/otp_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String getInitialRoute(bool isLoggedIn, bool isForceUpdate) {
    if (isForceUpdate) {
      return Paths.Force_update;
    } else {
      // return isLoggedIn ? Paths.BOTTOMBAR : Paths.LOGIN;
      return Paths.REGISTRATIONSCREEN;
    }
  }

  static final routes = [
    GetPage(
      name: Paths.NoInterNet,
      page: () => const NoInternetView(),
      binding: NoInternetBinding(),
    ),
    GetPage(
      name: Paths.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Paths.Force_update,
      page: () => ForceUpdateScreen(),
      binding: ForceUpdateBinding(),
    ),
    GetPage(
      name: Paths.VERIFYOTP,
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
      name: Paths.REGISTRATIONSCREEN,
      page: () => RegistrationScreen(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: Paths.DASHBOARD,
      page: () => Dashboard1Screen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Paths.BOTTOMBAR,
      page: () => BottomBarView(),
      binding: BottomBarBinding(),
    ),
    GetPage(
      name: Paths.PAYROLL,
      page: () => PayrollScreen(),
      binding: PayrollBinding(),
    ),
    GetPage(
      name: Paths.ATTENDANCESCREEN,
      page: () => AttendanceScreen(),
      binding: AttendanceScreenBinding(),
    ),
    GetPage(
      name: Paths.ATTENDANCESUMMARY,
      page: () => const SummaryScreen(),
      binding: AttendanceSummaryBinding(),
    ),
    GetPage(
      name: Paths.ATTENDANCEDETAIL,
      page: () => const DetailsScreen(),
      binding: AttendanceDetailBinding(),
    ),
    GetPage(
      name: Paths.MISPUNCHSCREEN,
      page: () => const MispunchScreen(),
      binding: MispunchBinding(),
    ),
    GetPage(
      name: Paths.LEAVEMAINSCREEN,
      page: () => LeaveMainScreen(),
      binding: LeaveMainScreenBinding(),
    ),
    GetPage(
      name: Paths.LEAVEENTRY,
      page: () => LeaveScreen(),
      binding: LeaveFormBinding(),
    ),
    GetPage(
      name: Paths.LEAVEVIEW,
      page: () => const LeaveViewScreen(),
      binding: LeaveViewBinding(),
    ),
    GetPage(
      name: Paths.OVERTIMEMAINSCREEN,
      page: () => OvertimeMainScreen(),
      binding: OvertimeMainScreenBinding(),
    ),
    GetPage(
      name: Paths.OVERTIMEENTRY,
      page: () => OtScreen(),
      binding: OvertimeFormBinding(),
    ),
    GetPage(
      name: Paths.OVERTIMEVIEW,
      page: () => const OvertimeViewScreen(),
      binding: OvertimeViewBinding(),
    ),
    GetPage(
      name: Paths.RESET_PASSWORD,
      page: () => const ResetpassScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: Paths.FORGOTPASSWORD,
      page: () => const ForgotpassScreen(
        mobileNumber: '',
      ),
      binding: ForgotpasswordBinding(),
    ),
    GetPage(
      name: Paths.SuperLogin,
      page: () => const SuperloginScreen(
        mobileNo: '',
      ),
      binding: SuperLoginBinding(),
    ),
    GetPage(
      name: Paths.LVOTApprovalScreen,
      page: () => const LvotapprovalScreen(),
      binding: lvot_appr_screen_Binding(),
    ),
    GetPage(
      name: Paths.LVListScreen,
      page: () => LvList(),
      binding: lv_screen_Binding(),
    ),
    GetPage(
      name: Paths.OTListScreen,
      page: () => const OtlistScreen(),
      binding: otList_screen_Binding(),
    ),
    GetPage(
      name: Paths.IPDDASHBOARDSCREEN,
      page: () => IpdDashboardScreen(),
      binding: IPDDashboardBinding(),
    ),
    GetPage(
      name: Paths.IPDADMITTEDPATIENTS,
      page: () => AdpatientScreen(),
      binding: AdmittedPatientBinding(),
    ),
    GetPage(
      name: Paths.LABREPORTSSCREEN,
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
      name: Paths.LABSUMMARYSCREEN,
      page: () => LabSummaryScreen(),
      binding: LabSummaryScreenBinding(),
    ),
    GetPage(
      name: Paths.VOICESCREEN,
      page: () => VoiceScreen(),
      binding: VoiceScreenBinding(),
    ),
    GetPage(
      name: Paths.INVESTIGATIONREQUISITIONSCREEN,
      page: () => InvestRequisitScreen(),
      binding: InvestRequisitScreenBinding(),
    ),
    GetPage(
      name: Paths.INVESTIGATIONREQUISITIONSERVICE,
      page: () => InvestServiceScreen(),
      binding: InvestServiceScreenBinding(),
    ),
    GetPage(
      name: Paths.FILTERSCREEN,
      page: () => FilterScreen(),
      binding: FilterScreenBinding(),
    ),
    GetPage(
      name: Paths.FILTERTAGSCREEN,
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
      name: Paths.NOTIFICATIONSCREEN,
      page: () => NotificationScreen(),
      binding: NotificationScreenBinding(),
    ),
    GetPage(
      name: Paths.PHARMACYSCREEN,
      page: () => PharmacyScreen(),
      binding: PharmacyScreenBinding(),
    ),
    GetPage(
      name: Paths.PRESCRIPTIONDETAILSSCREEN,
      page: () => PresdetailsScreen(),
      binding: PresdetailsScreenBinding(),
    ),
    GetPage(
      name: Paths.PRESCRIPTIONVIEWERSCREEN,
      page: () => PresviewerScreen(),
      binding: PresviewerScreenBinding(),
    ),
    GetPage(
      name: Paths.MEDICATIONSCREEN,
      page: () => MedicationScreen(),
      binding: MedicationScreenbinding(),
    ),
    GetPage(
      name: Paths.AddMEDICATIONSCREEN,
      // page: () => MedicationScreen(),
      page: () {
        final args = Get.arguments;
        return AddMedicationScreen(
          selectedMasterIndex: args['selectedMasterIndex'],
          selectedDetailIndex: args['selectedDetailIndex'],
        );
      },
      binding: AddMedicationScreenBinding(),
    ),
    GetPage(
      name: Paths.VIEWMEDICATIONSCREEN,
      page: () {
        final args = Get.arguments;
        return ViewMedicationScreen(
          selectedMasterIndex: args['selectedMasterIndex'],
        );
      },
      binding: ViewMedicationScreenbinding(),
    ),
  ];
}
