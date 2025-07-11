class OTPModel {
  String? is_valid_token;
  int? login_id;
  String? token;
  int? employeeId;
  String? employeeName;
  String? mobileNumber;
  String? emailAddress;
  String? dob;
  String? address;

  OTPModel(
      {this.is_valid_token,
      this.login_id,
      this.token,
      this.employeeId,
      this.employeeName,
      this.mobileNumber,
      this.emailAddress,
      this.dob,
      this.address});

  OTPModel.fromJson(Map<String, dynamic> json) {
    is_valid_token = json['is_valid_token'];
    login_id = json['login_id'];
    token = json['token'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    mobileNumber = json['mobileNumber'];
    emailAddress = json['emailAddress'];
    dob = json['dob'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_valid_token'] = is_valid_token;
    data['login_id'] = login_id;
    data['token'] = token;
    data['employeeId'] = employeeId;
    data['employeeName'] = employeeName;
    data['mobileNumber'] = mobileNumber;
    data['emailAddress'] = emailAddress;
    data['dob'] = dob;
    data['address'] = address;
    return data;
  }
}
