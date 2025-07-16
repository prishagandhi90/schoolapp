class ResponseRegisterModel {
  int? statusCode;
  String? isSuccess;
  String? message;
  RegistrationData? data;

  ResponseRegisterModel({this.statusCode, this.isSuccess, this.message, this.data});

  ResponseRegisterModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = json['data'] != null ? RegistrationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['statusCode'] = this.statusCode;
    map['isSuccess'] = this.isSuccess;
    map['message'] = this.message;
    if (this.data != null) {
      map['data'] = this.data!.toJson();
    }
    return map;
  }
}

class RegistrationData {
  int? id;
  String? name;
  String? fatherName;
  String? surname;
  String? dateOfBirth;
  String? gender;
  String? address;
  String? pincode;
  String? city;
  String? mobile1;
  String? mobile2;

  RegistrationData({
    this.id,
    this.name,
    this.fatherName,
    this.surname,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.pincode,
    this.city,
    this.mobile1,
    this.mobile2,
  });

  RegistrationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fatherName = json['fatherName'];
    surname = json['surname'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    address = json['address'];
    pincode = json['pincode'];
    city = json['city'];
    mobile1 = json['mobile1'];
    mobile2 = json['mobile2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = this.id;
    map['name'] = this.name;
    map['fatherName'] = this.fatherName;
    map['surname'] = this.surname;
    map['dateOfBirth'] = this.dateOfBirth;
    map['gender'] = this.gender;
    map['address'] = this.address;
    map['pincode'] = this.pincode;
    map['city'] = this.city;
    map['mobile1'] = this.mobile1;
    map['mobile2'] = this.mobile2;
    return map;
  }
}
