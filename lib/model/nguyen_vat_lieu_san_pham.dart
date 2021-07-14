class NguyenVatLieuSanPham {
  late String code;
  late String realName;
  late String type;
  late String unit;
  late String kg;
  late String name;

  NguyenVatLieuSanPham({
    required this.code,
    required this.realName,
    required this.name,
    required this.type,
    required this.unit,
    required this.kg,
  });

  NguyenVatLieuSanPham.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    realName = json['_name'] != null ? json['_name'] : '';
    code = json['code'];
    type = json['type'];
    unit = json['unit'];
    kg = json['kg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['_name'] = this.realName;
    data['code'] = this.code;
    data['type'] = this.type;
    data['unit'] = this.unit;
    data['kg'] = this.kg;
    return data;
  }
}
