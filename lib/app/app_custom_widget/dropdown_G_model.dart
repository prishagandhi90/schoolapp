class Rsponsedropdown {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<Dropdown_G>? data;

  Rsponsedropdown({this.statusCode, this.isSuccess, this.message, this.data});

  Rsponsedropdown.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Dropdown_G>[];
      json['data'].forEach((v) {
        data!.add(new Dropdown_G.fromJson(v));
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

class Dropdown_G {
  String? id;
  String? name;

  Dropdown_G({this.id, this.name});

  Dropdown_G.fromJson(Map<String, dynamic> json) {
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



// // ignore_for_file: camel_case_types

// class Dropdown_G {
//   String? value;
//   String? name;


//   Dropdown_G({this.value, this.name});

//   Dropdown_G.fromJson(Map<String, dynamic> json) {
//     value = json['value'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data1 = <String, dynamic>{};
//     data1['value'] = value as String;
//     data1['name'] = name as String;
//     return data1;
//   }

//   @override
//   String toString() {
//     return '{value: $value, name: $name}';
//   }
// }
