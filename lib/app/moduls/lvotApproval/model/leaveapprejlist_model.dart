class ResponseLeaveAppRejList {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<SaveAppRejLeaveList>? data;

  ResponseLeaveAppRejList(
      {this.statusCode, this.isSuccess, this.message, this.data});

  ResponseLeaveAppRejList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SaveAppRejLeaveList>[];
      json['data'].forEach((v) {
        data!.add(new SaveAppRejLeaveList.fromJson(v));
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

class SaveAppRejLeaveList {
  String? savedYN;

  SaveAppRejLeaveList({this.savedYN});

  SaveAppRejLeaveList.fromJson(Map<String, dynamic> json) {
    savedYN = json['savedYN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['savedYN'] = this.savedYN;
    return data;
  }
}
