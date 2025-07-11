class Resp_dropdown_multifields {
  int? statusCode;
  String? isSuccess;
  String? message;
  List<DropdownMultifieldsTable>? data;

  Resp_dropdown_multifields({this.statusCode, this.isSuccess, this.message, this.data});

  Resp_dropdown_multifields.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DropdownMultifieldsTable>[];
      json['data'].forEach((v) {
        data!.add(new DropdownMultifieldsTable.fromJson(v));
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

class DropdownMultifieldsTable {
  int? id;
  String? name;
  String? value;
  int? sort;
  String? txt;
  int? parentId;
  String? supName;
  DateTime? dateValue;

  DropdownMultifieldsTable({this.id, this.name, this.value, this.sort, this.txt, this.parentId, this.supName, this.dateValue});

  DropdownMultifieldsTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    sort = json['sort'];
    txt = json['txt'];
    parentId = json['parentId'];
    supName = json['sup_name'];
    dateValue = json['dateValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['sort'] = this.sort;
    data['txt'] = this.txt;
    data['parentId'] = this.parentId;
    data['sup_name'] = this.supName;
    data['dateValue'] = this.dateValue;
    return data;
  }
}
