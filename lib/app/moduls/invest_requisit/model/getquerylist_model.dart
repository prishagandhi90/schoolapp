class ResponseGetQueryList {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<GetquerylistModel>? data;

  ResponseGetQueryList({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseGetQueryList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetquerylistModel>[];
      json['data'].forEach((v) {
        data!.add(new GetquerylistModel.fromJson(v));
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

class GetquerylistModel {
  String? name;
  int? id;
  int? cnt;
  String? value;
  String? txt;
  String? supName;

  GetquerylistModel({this.name, this.id, this.cnt, this.value, this.txt, this.supName});

  GetquerylistModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    cnt = json['cnt'];
    value = json['value'];
    txt = json['txt'];
    supName = json['sup_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['cnt'] = this.cnt;
    data['value'] = this.value;
    data['txt'] = this.txt;
    data['sup_name'] = this.supName;
    return data;
  }
}
