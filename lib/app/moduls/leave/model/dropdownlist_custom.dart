class DropdownlstTable {
  String? value;
  String? name;

  DropdownlstTable({this.value, this.name});

  DropdownlstTable.fromJson(Map<String, dynamic> json) {
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
