class MispunchTable {
  String? empCode;
  String? empName;
  String? department;
  String? designation;
  String? empType;
  String? dt;
  String? misPunch;
  String? punchTime;
  String? shiftTime;
  String? note;

  MispunchTable(
      {this.empCode,
      this.empName,
      this.department,
      this.designation,
      this.empType,
      this.dt,
      this.misPunch,
      this.punchTime,
      this.shiftTime,
      this.note});

  MispunchTable.fromJson(Map<String, dynamic> json) {
    empCode = json['empCode'];
    empName = json['empName'];
    department = json['department'];
    designation = json['designation'];
    empType = json['emp_Type'];
    dt = json['dt'];
    misPunch = json['mis_Punch'];
    punchTime = json['punch_Time'];
    shiftTime = json['shiftTime'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empCode'] = empCode;
    data['empName'] = empName;
    data['department'] = department;
    data['designation'] = designation;
    data['emp_Type'] = empType;
    data['dt'] = dt;
    data['mis_Punch'] = misPunch;
    data['punch_Time'] = punchTime;
    data['shiftTime'] = shiftTime;
    data['note'] = note;
    return data;
  }
}
