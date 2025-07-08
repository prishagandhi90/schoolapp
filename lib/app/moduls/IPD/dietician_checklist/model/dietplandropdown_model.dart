class ResponseDietPlanDropdown {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<DietPlanDropDown>? data;

  ResponseDietPlanDropdown({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseDietPlanDropdown.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DietPlanDropDown>[];
      json['data'].forEach((v) {
        data!.add(new DietPlanDropDown.fromJson(v));
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

class DietPlanDropDown {
  String? value;
  String? name;

  DietPlanDropDown({this.value, this.name});

  DietPlanDropDown.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['name'] = this.name;
    return data;
  }
}
