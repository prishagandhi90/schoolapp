class ResponseLeaveDelayReason {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<LeaveDelayReason>? data;

  ResponseLeaveDelayReason({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseLeaveDelayReason.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <LeaveDelayReason>[];
      json['data'].forEach((v) {
        data!.add(new LeaveDelayReason.fromJson(v));
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

class LeaveDelayReason {
  String? id;
  String? name;

  LeaveDelayReason({this.id, this.name});

  LeaveDelayReason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
