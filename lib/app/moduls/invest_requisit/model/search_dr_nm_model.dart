class RespSearchDrNm {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<SearchDrNmModel>? data;

  RespSearchDrNm({this.statusCode, this.isSuccess, this.message, this.data});

  RespSearchDrNm.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SearchDrNmModel>[];
      json['data'].forEach((v) {
        data!.add(new SearchDrNmModel.fromJson(v));
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

class SearchDrNmModel {
  int? id;
  String? name;

  SearchDrNmModel({this.id, this.name});

  SearchDrNmModel.fromJson(Map<String, dynamic> json) {
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
