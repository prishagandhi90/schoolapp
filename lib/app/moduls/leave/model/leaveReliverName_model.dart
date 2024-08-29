class ResponseLeaveReliverName {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<LeaveReliverName>? data;

  ResponseLeaveReliverName({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseLeaveReliverName.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeaveReliverName>[];
      json['data'].forEach((v) {
        data!.add(new LeaveReliverName.fromJson(v));
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

class LeaveReliverName {
  String? id;
  String? name;

  LeaveReliverName({this.id, this.name});

  LeaveReliverName.fromJson(Map<String, dynamic> json) {
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
