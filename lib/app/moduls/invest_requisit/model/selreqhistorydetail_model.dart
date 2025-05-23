class ResponseSelReqHistoryDetailList {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<SelReqHistoryDetailModel>? data;

  ResponseSelReqHistoryDetailList(
      {this.statusCode, this.isSuccess, this.message, this.data});

  ResponseSelReqHistoryDetailList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SelReqHistoryDetailModel>[];
      json['data'].forEach((v) {
        data!.add(new SelReqHistoryDetailModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelReqHistoryDetailModel {
  int? id;
  int? requestID;
  String? serviceName;
  String? reqTyp;
  String? serviceGroup;
  String? investigationSource;
  int? testid;
  String? status;
  int? labflg;

  SelReqHistoryDetailModel(
      {this.id,
      this.requestID,
      this.serviceName,
      this.reqTyp,
      this.serviceGroup,
      this.investigationSource,
      this.testid,
      this.status,
      this.labflg});

  SelReqHistoryDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestID = json['requestID'];
    serviceName = json['serviceName'];
    reqTyp = json['reqTyp'];
    serviceGroup = json['serviceGroup'];
    investigationSource = json['investigationSource'];
    testid = json['testid'];
    status = json['status'];
    labflg = json['labflg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requestID'] = this.requestID;
    data['serviceName'] = this.serviceName;
    data['reqTyp'] = this.reqTyp;
    data['serviceGroup'] = this.serviceGroup;
    data['investigationSource'] = this.investigationSource;
    data['testid'] = this.testid;
    data['status'] = this.status;
    data['labflg'] = this.labflg;
    return data;
  }
}
