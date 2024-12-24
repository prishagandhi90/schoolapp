class Dropdown_G {
  String? value;
  String? name;

  Dropdown_G({this.value, this.name});

  Dropdown_G.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data1 = <String, dynamic>{};
    data1['value'] = value as String;
    data1['name'] = name as String;
    return data1;
  }

  @override
  String toString() {
    return '{value: $value, name: $name}';
  }
}
