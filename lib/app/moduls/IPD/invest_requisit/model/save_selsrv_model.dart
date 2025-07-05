class ResponseSaveSelSrvList {
  String? status;
  int? reqId;
  int? drInstId;
  int? billDetailId;

  ResponseSaveSelSrvList({this.status, this.reqId, this.drInstId, this.billDetailId});

  ResponseSaveSelSrvList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    reqId = json['reqId'];
    drInstId = json['drInstId'];
    billDetailId = json['billDetailId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['reqId'] = this.reqId;
    data['drInstId'] = this.drInstId;
    data['billDetailId'] = this.billDetailId;
    return data;
  }
}
