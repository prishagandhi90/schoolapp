import 'package:flutter/foundation.dart';

class ConstApiUrl {
  static const isMobile = kIsWeb ? false : true;
  // static const portNo = "44166"; //live
  static const portNo = "80"; //"Backup";

  static String initailUrl = isMobile ? 'http://prishatechnologies.site:$portNo/api' : 'http://192.168.1.35:$portNo/api';

  static String get empUrl => '$initailUrl/Employee';
  static String get empLoginUrl => '$initailUrl/EmpLogin';
  static String get studUrl => '$initailUrl/Student';

  // 🔁 Base URL fallback ke liye
  static const baseURL = isMobile ? 'http://prishatechnologies.site:$portNo' : 'http://192.168.1.35:$portNo';
  static const baseSecondURL = 'http://103.251.17.214:$portNo';

// -------------------- Auth --------------------
  static String get baseApiUrl => empLoginUrl;
  static String get loginWithOTP_Pass => "$empUrl/authentication";
  static String get validMobileNo => "$empLoginUrl/ValidateMobileNo";
  static String get generateNewPass => "$empLoginUrl/GenerateNewPassword";
  static String get empLoginUsernameAPI => "$empLoginUrl/GetLoginUserNames";
  static String get empSuperLoginCred => "$empLoginUrl/GetLoginAsUserCreds";

// -------------------- Student Registration --------------------
  static String get stud_InsUpd_Registration => "$studUrl/InsUpdRegistration";

  // -------------------- Post Issues --------------------
  static String get empPostIssue => "$empLoginUrl/PostIssue";

  // -------------------- Force Update --------------------
  static String get empForceUpdateAPI => "$empLoginUrl/ForceUpdateYN";

  // -------------------- Dashboard & Payroll --------------------
  static String get empAttendanceDtlAPI => "$empUrl/GetEmpAttendDtl_EmpInfo";
  static String get empAttendanceSummaryAPI => "$empUrl/GetEmpAttendSumm_EmpInfo";
  static String get empGetDashboardListAPI => "$empUrl/GetDashboardList";
  static String get empSendEMPMobileOtpAPI => "$empLoginUrl/SendEMPMobileOTP";
  static String get empMispunchDetailAPI => "$empUrl/GetMisPunchDtl_EmpInfo";
  static String get empDashboardSummaryAPI => "$empUrl/GetEmpSummary_Dashboard";
  static String get empAppModuleRights => "$empUrl/GetModuleRights";
  static String get empAppScreenRights => "$empUrl/GetEmpAppScreenRights";
  static String get empLeaveDaysAPI => "$empUrl/GetLeaveDays";
  static String get empLeftLeavesAPI => "$empUrl/GetAvlLvCount";
  static String get empLeaveNamesAPI => "$empUrl/GetLeaveNames";
  static String get empLeaveReasonAPI => "$empUrl/GetLeaveReason";
  static String get empLeaveDelayReasonAPI => "$empUrl/GetLeaveDelayReason";
  static String get empLeaveReliverNameAPI => "$empUrl/EmpApp_GetLeaveRelieverNm";
  static String get empLeaveHeaderList => "$empUrl/EmpApp_GetheaderList";
  static String get empLeaveEntryListAPI => "$empUrl/EmpApp_GetLeaveEntryList";
  static String get empSaveLeaveEntryList => "$empUrl/EmpApp_SaveLeaveEntryList";
  static String get empDutyscheduledrpdwnList => "$empUrl/GetShiftWeekList";
  static String get empDutyScheduleShiftReport => "$empUrl/GetEmpShiftReport";

  // -------------------- Pharmacy --------------------
  static String get empPresViewerListAPI => "$empUrl/GetDrPrescriptionViewer";
  static String get empPresDetailListAPI => "$empUrl/GetDrPrescriptionMedicines";
  static String get empPharmaFilterDataApi => "$empUrl/GetPharmaDashboardFilters";
  static String get empPatientsortDataApi => "$empUrl/SortDr_PrecriptionViewer";

  // -------------------- LV/OT Approval --------------------
  static String get empLeaveOTapprovalList => "$empUrl/EmpApp_Get_LV_OT_Roles";
  static String get empLeaveAppRejListData => "$empUrl/EmpApp_Appr_Rej_LV_OT_Entry";
  static String get empGetLeaveRejectReason => "$empUrl/GetLeaveRejectReason";
  static String get empAppRejLeaveOTEntryList => "$empUrl/EmpApp_Appr_Rej_LV_OT_Entry_List";

  // -------------------- Admitted patient --------------------
  static String get empFilterpatientdataList => "$empUrl/GetFilteredPatientData";
  static String get empPatientDashboardFilters => "$empUrl/GetPatientDashboardFilters";
  static String get empGetLabReports => "$empUrl/GetPatientLabReports";
  static String get empPatientSummaryLabData => "$empUrl/GetPatientSummaryLabData";
  static String get empSortDeptPatientList => "$empUrl/SortDeptPatientList";

  // -------------------- Notification --------------------
  static String get empNotificationListAPI => "$empUrl/GetEMPNotificationsList";
  static String get empNotificationFileAPI => "$empUrl/GetNotificationFiles";
  static String get empUpdateNotificationReadAPI => "$empUrl/UpdateNotification_Read";

  // -------------------- Voice API --------------------
  static String get empVoiceApi => "$empUrl/UploadPatientVoiceNote";

  // -------------------- Investigation Requisition --------------------
  static String get empExternalLabList => "$empUrl/EmpApp_GetExternalLabName";
  static String get empServiceGroupAPI => "$empUrl/EmpApp_InvReq_GetServiceGrp";
  static String get empPatientNm_UHID_IPDAPI => "$empUrl/EmpApp_InvReq_GetPatientNm_UHID_IPD";
  static String get empSearchServiceAPI => "$empUrl/EmpApp_InvReq_SearchService";
  static String get empGetDoseValueAPI => "$empUrl/EmpApp_MedicationSheet_DoseValue";
  static String get empSearchDrnmAPI => "$empUrl/EmpApp_InvReq_SearchDrName";
  static String get empGetQueryListAPI => "$empUrl/EmpApp_InvReq_Get_Query";
  static String get empSaveSelSrvListAPI => "$empUrl/SaveRequestSheetIPD";
  static String get empGetHistoryListAPI => "$empUrl/EmpApp_InvReq_Get_HistoryData";
  static String get empSelReqHistoryDetailAPI => "$empUrl/EmpApp_InvReq_SelReq_HistoryDetail";
  static String get empWebUserLoginCredsAPI => "$empUrl/WebUserLoginCreds";
  static String get empDelReqDtlSrvAPI => "$empUrl/EmpApp_Delete_InvReq_DetailSrv";

  // -------------------- Medication Sheet --------------------
  static String get empSpecialOrderListAPI => "$empUrl/EmpApp_GetSpecialOrderList";
  static String get empGetTemplatesListAPI => "$empUrl/EmpApp_GetTemplates";
  static String get empGetMedicationTypeAPI => "$empUrl/EmpApp_GetMedicationType";
  static String get empGetInstructionTypeAPI => "$empUrl/EmpApp_GetInstructionType";
  static String get empGetDrTreatRouteAPI => "$empUrl/EmpApp_GetDrTreatmentRoute";
  static String get empGetDrTreatFrequencyAPI => "$empUrl/EmpApp_GetDrTreatmentFrequency";
  static String get empSaveDrTreatmentNoteAPI => "$empUrl/EmpApp_SaveDrTreatmentMaster";
  static String get empDoctorTreatmentMasterAPI => "$empUrl/EmpApp_GetDrTreatmentMaster";
  static String get empDoctorTreatmentMasterCopyAPI => "$empUrl/EmpApp_CopyDrTData";
  static String get empGetAdmIdFrmIPDAPI => "$empUrl/EmpApp_GetAdmissionIdFrmIPD";
  static String get empMedicationSheet_SearchMedicinesAPI => "$empUrl/EmpApp_MedicationSheet_SearchMedicines";
  static String get empSaveAddMedicationSheetAPI => "$empUrl/EmpApp_SaveAddMedicinesSheet";
  static String get empDeleteMedicationSheetAPI => "$empUrl/EmpApp_MedicationSheet_DeleteMedicines";

  // -------------------- Dietician Checklist --------------------
  static String get empDieticianChecklistListAPI => "$empUrl/EMPApp_Getdata_DieticianChecklist";
  static String get empDieticianFilterWardNameAPI => "$empUrl/EMPApp_GetWardNm_Cnt_DieticianChecklist";
  static String get empDietSaveChecklistMasterAPI => "$empUrl/EmpApp_SaveDietChecklistMaster";
  static String get empDietPlanDropDownAPI => "$empUrl/EmpApp_GetDietPlanList";

  static String get empGetCollectionTypesAPI => "$empUrl/EmpApp_GetCollectionType";
  static String get empGetRBSChartDataAPI => "$empUrl/EmpApp_GetRBSChartData";
}
