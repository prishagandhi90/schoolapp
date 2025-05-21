class ResponseSearchService {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<SearchserviceModel>? data;

  ResponseSearchService({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseSearchService.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SearchserviceModel>[];
      json['data'].forEach((v) {
        data!.add(new SearchserviceModel.fromJson(v));
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

class SearchserviceModel {
  String? txt;
  String? name;
  String? value;

  SearchserviceModel({this.txt, this.name, this.value});

  SearchserviceModel.fromJson(Map<String, dynamic> json) {
    txt = json['txt'];
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['txt'] = this.txt;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
