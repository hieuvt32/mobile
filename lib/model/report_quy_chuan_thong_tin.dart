class ReportQuyChuanThongTin {
  late String barcode;
  late String company;
  late String product;
  late String material;
  late String serial;
  late String status;
  late int countByKG;
  late double kg;
  late int total;

  ReportQuyChuanThongTin({
    required this.barcode,
    required this.company,
    required this.product,
    required this.material,
    required this.serial,
    required this.status,
    required this.countByKG,
    required this.kg,
    required this.total,
  });

  ReportQuyChuanThongTin.fromJson(Map<dynamic, dynamic> json) {
    barcode = json['barcode'];
    company = json['company'];
    product = json['product'];
    material = json['material'];
    serial = json['serial'];
    status = json['status'];
    countByKG = json['count_by_kg'];
    kg =
        (json['kg'] == "" || json['kg'] == null) ? 0 : double.parse(json['kg']);
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['barcode'] = this.barcode;
    data['company'] = this.company;
    data['product'] = this.product;
    data['material'] = this.material;
    data['serial'] = this.serial;
    data['status'] = this.status;
    data['count_by_kg'] = this.countByKG;
    data['kg'] = this.kg;
    data['total'] = this.total;
    return data;
  }
}
