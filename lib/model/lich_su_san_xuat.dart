class LichSuSanXuat {
  late String barcode;
  late String company;
  late String product;
  late String material;
  late String kg;
  late int countByKG;

  LichSuSanXuat({
    required this.barcode,
    required this.company,
    required this.product,
    required this.material,
    required this.kg,
    required this.countByKG,
  });

  LichSuSanXuat.fromJson(Map<dynamic, dynamic> json) {
    barcode = json['barcode'];
    company = json['company'];
    product = json['product'];
    material = json['material'];
    kg = json['kg'];
    countByKG = json['count_by_kg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barcode'] = this.barcode;
    data['company'] = this.company;
    data['product'] = this.product;
    data['material'] = this.material;
    data['kg'] = this.kg;
    data['count_by_kg'] = this.countByKG;
    return data;
  }
}
