class QuyChuanThongTin {
  late String barcode;
  late String company;
  late String productContain;
  late String materialType;
  late String serial;
  late String status;
  late int countByKG;
  late double kg;
  late String name;

  QuyChuanThongTin({
    required this.barcode,
    required this.company,
    required this.productContain,
    required this.materialType,
    required this.serial,
    required this.status,
    required this.countByKG,
    required this.kg,
    required this.name,
  });

  QuyChuanThongTin.fromJson(Map<dynamic, dynamic> json) {
    barcode = json['barcode'];
    company = json['company'];
    productContain = json['product_contain'];
    materialType = json['material_type'];
    serial = json['serial'] == null ? "Không có mã chế tạo" : json['serial'];
    status = json['status'];
    countByKG = json['count_by_kg'];
    kg = json['kg'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barcode'] = this.barcode;
    data['company'] = this.company;
    data['product_contain'] = this.productContain;
    data['material_type'] = this.materialType;
    data['serial'] = this.serial;
    data['status'] = this.status;
    data['count_by_kg'] = this.countByKG;
    data['kg'] = this.kg;
    data['name'] = this.name;
    return data;
  }
}
