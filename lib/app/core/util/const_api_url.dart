class ConstApiUrl {
  static const empUrl = "http://117.217.126.127:44166/api/Employee";
  static const empLoginUrl = 'http://117.217.126.127:44166/api/EmpLogin';

  //  ----------------    Prod  urls ---------------
  static const baseApiUrl = empLoginUrl;
  static const loginWithOTP_Pass = "$empUrl/authentication";
  static const empAttendanceDtlAPI = "$empUrl/GetEmpAttendDtl_EmpInfo";
  static const empAttendanceSummaryAPI = "$empUrl/GetEmpAttendSumm_EmpInfo";
  static const empGetDashboardListAPI = "$empUrl/GetDashboardList";
  static const empSendEMPMobileOtpAPI = "$empLoginUrl/SendEMPMobileOTP";
  static const empMispunchDetailAPI = "$empUrl/GetMisPunchDtl_EmpInfo";
  static const empDashboardSummaryAPI = "$empUrl/GetEmpSummary_Dashboard";
  static const empLeaveDaysAPI = "$empUrl/GetLeaveDays";
  static const empLeaveNamesAPI = "$empUrl/GetLeaveNames";
  static const empLeaveReasonAPI = "$empUrl/GetLeaveReason";
  static const empLeaveDelayReasonAPI = "$empUrl/GetLeaveDelayReason";
  static const empLeaveReliverNameAPI = "$empUrl/EmpApp_GetLeaveRelieverNm";
}
