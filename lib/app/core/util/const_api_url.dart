import 'package:flutter/foundation.dart';

class ConstApiUrl {
  static const isMobile = kIsWeb ? false : true;
  // static const portNo = "44166"; //live
  static const portNo = "55555"; //"Backup";
  // static const baseURL = 'http://117.217.126.127:$portNo';
  static const baseURL = isMobile ? 'http://117.217.126.127:$portNo' : 'http://192.168.1.35:$portNo';
  static const baseSecondURL = 'http://103.251.17.214:$portNo';
  String initailUrl = isMobile ? 'http://117.217.126.127:$portNo/api' : 'http://192.168.1.35:$portNo/api';
  static const empUrl = isMobile ? 'http://117.217.126.127:$portNo/api/Employee' : 'http://192.168.1.35:$portNo/api/Employee';
  static const empLoginUrl = isMobile ? 'http://117.217.126.127:$portNo/api/EmpLogin' : 'http://192.168.1.35:$portNo/api/EmpLogin';

  //  ----------------    Prod  urls ---------------
  static const baseApiUrl = empLoginUrl;
  static const loginWithOTP_Pass = "$empUrl/authentication";
  static const validMobileNo = "$empLoginUrl/ValidateMobileNo";
  static const generateNewPass = "$empLoginUrl/GenerateNewPassword";
  static const empLoginUsernameAPI = "$empLoginUrl/GetLoginUserNames";
  static const empSuperLoginCred = "$empLoginUrl/GetLoginAsUserCreds";

  //-------------------Post Issues ---------------
  static const empPostIssue = "$empLoginUrl/PostIssue";
  //----------------Force Update ---------------
  static const empForceUpdateAPI = "$empLoginUrl/ForceUpdateYN";

  //  ----------------dashboard and payroll ---------------
  static const empAttendanceDtlAPI = "$empUrl/GetEmpAttendDtl_EmpInfo";
  static const empAttendanceSummaryAPI = "$empUrl/GetEmpAttendSumm_EmpInfo";
  static const empGetDashboardListAPI = "$empUrl/GetDashboardList";
  static const empSendEMPMobileOtpAPI = "$empLoginUrl/SendEMPMobileOTP";
  static const empMispunchDetailAPI = "$empUrl/GetMisPunchDtl_EmpInfo";
  static const empDashboardSummaryAPI = "$empUrl/GetEmpSummary_Dashboard";
  static const empAppModuleRights = "$empUrl/GetModuleRights";
  static const empAppScreenRights = "$empUrl/GetEmpAppScreenRights";
  static const empLeaveDaysAPI = "$empUrl/GetLeaveDays";
  static const empLeftLeavesAPI = "$empUrl/GetAvlLvCount";
  static const empLeaveNamesAPI = "$empUrl/GetLeaveNames";
  static const empLeaveReasonAPI = "$empUrl/GetLeaveReason";
  static const empLeaveDelayReasonAPI = "$empUrl/GetLeaveDelayReason";
  static const empLeaveReliverNameAPI = "$empUrl/EmpApp_GetLeaveRelieverNm";
  static const empLeaveHeaderList = "$empUrl/EmpApp_GetheaderList";
  static const empLeaveEntryListAPI = "$empUrl/EmpApp_GetLeaveEntryList";
  static const empSaveLeaveEntryList = "$empUrl/EmpApp_SaveLeaveEntryList";
  static const empDutyscheduledrpdwnList = "$empUrl/GetShiftWeekList";
  static const empDutyScheduleShiftReport = "$empUrl/GetEmpShiftReport";

  //pharmacy
  static const empPresViewerListAPI = "$empUrl/GetDrPrescriptionViewer";
  static const empPresDetailListAPI = "$empUrl/GetDrPrescriptionMedicines";
  static const empPharmaFilterDataApi = "$empUrl/GetPharmaDashboardFilters";
  static const empPatientsortDataApi = "$empUrl/SortDr_PrecriptionViewer";

  //  ----------------LV/OT Approval ---------------
  static const empLeaveOTapprovalList = "$empUrl/EmpApp_Get_LV_OT_Roles";
  static const empLeaveAppRejListData = "$empUrl/EmpApp_Appr_Rej_LV_OT_Entry";
  static const empGetLeaveRejectReason = "$empUrl/GetLeaveRejectReason";
  static const empAppRejLeaveOTEntryList = "$empUrl/EmpApp_Appr_Rej_LV_OT_Entry_List";

  //  ----------------Admitted patient ---------------
  static const empFilterpatientdataList = "$empUrl/GetFilteredPatientData";
  static const empPatientDashboardFilters = "$empUrl/GetPatientDashboardFilters";
  static const empGetLabReports = "$empUrl/GetPatientLabReports";
  static const empPatientSummaryLabData = "$empUrl/GetPatientSummaryLabData";
  static const empSortDeptPatientList = "$empUrl/SortDeptPatientList";

  //  ----------------Notification ---------------
  static const empNotificationListAPI = "$empUrl/GetEMPNotificationsList";
  static const empNotificationFileAPI = "$empUrl/GetNotificationFiles";
  static const empUpdateNotificationReadAPI = "$empUrl/UpdateNotification_Read";

  //  ----------------Voice Api ---------------
  static const empVoiceApi = "$empUrl/UploadPatientVoiceNote";

  //  ----------------Investigation Requisition ---------------
  static const empExternalLabList = "$empUrl/EmpApp_GetExternalLabName";
  static const empServiceGroupAPI = "$empUrl/EmpApp_InvReq_GetServiceGrp";
  static const empPatientNm_UHID_IPDAPI = "$empUrl/EmpApp_InvReq_GetPatientNm_UHID_IPD";
  static const empSearchServiceAPI = "$empUrl/EmpApp_InvReq_SearchService";
  static const empSearchDrnmAPI = "$empUrl/EmpApp_InvReq_SearchDrName";
  static const empGetQueryListAPI = "$empUrl/EmpApp_InvReq_Get_Query";
  static const empSaveSelSrvListAPI = "$empUrl/SaveRequestSheetIPD";
  static const empGetHistoryListAPI = "$empUrl/EmpApp_InvReq_Get_HistoryData";
  static const empSelReqHistoryDetailAPI = "$empUrl/EmpApp_InvReq_SelReq_HistoryDetail";
  static const empWebUserLoginCredsAPI = "$empUrl/WebUserLoginCreds";
  static const empDelReqDtlSrvAPI = "$empUrl/EmpApp_Delete_InvReq_DetailSrv";

  //   ---------------------------Medication Sheet----------------------------------
  static const empSpecialOrderListAPI = "$empUrl/EmpApp_GetSpecialOrderList";
  static const empGetTemplatesListAPI = "$empUrl/EmpApp_GetTemplates";
  static const empSaveDrTreatmentNoteAPI = "$empUrl/EmpApp_SaveDrTreatmentMaster";
  static const empDoctorTreatmentMasterAPI = "$empUrl/EmpApp_GetDrTreatmentMaster";
  static const empGetAdmIdFrmIPDAPI = "$empUrl/EmpApp_GetAdmissionIdFrmIPD";
}
