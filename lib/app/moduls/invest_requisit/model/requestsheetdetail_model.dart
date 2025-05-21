class RequestSheetDetailsIPD {
  int? mReqId;
  String serviceName;
  int serviceId;
  String username;
  String invSrc;
  String reqTyp;
  String rowState;
  String action;
  int? drInstId;
  int? billDetailId;
  String uhidNo;
  String ipdNo;
  int? drId;
  String drName;

  RequestSheetDetailsIPD({
    required this.serviceName,
    required this.serviceId,
    required this.username,
    required this.invSrc,
    required this.reqTyp,
    required this.rowState,
    required this.action,
    this.mReqId,
    this.drInstId,
    this.billDetailId,
    required this.uhidNo,
    required this.ipdNo,
    this.drId,
    required this.drName,
  });

  Map<String, dynamic> toJson() => {
        "MReqId": mReqId,
        "ServiceName": serviceName,
        "ServiceId": serviceId,
        "Username": username,
        "InvSrc": invSrc,
        "ReqTyp": reqTyp,
        "RowState": rowState,
        "Action": action,
        "Dr_Inst_Id": drInstId,
        "Bill_Detail_Id": billDetailId,
        "UHIDNo": uhidNo,
        "IPDNo": ipdNo,
        "DrID": drId,
        "DrNAME": drName,
      };
}
