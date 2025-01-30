class RsponseLeaveReason {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<LeaveReasonTable>? data;

  RsponseLeaveReason({this.statusCode, this.isSuccess, this.message, this.data});

  RsponseLeaveReason.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <LeaveReasonTable>[];
      json['data'].forEach((v) {
        data!.add(new LeaveReasonTable.fromJson(v));
      });
    } else {
      data = [];
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

class LeaveReasonTable {
  String? name;

  LeaveReasonTable({this.name});

  LeaveReasonTable.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
