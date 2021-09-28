class DoiTruThongKeKho {
  late String? product;
  late String? material;
  late double amount;
  // late String company;
  DoiTruThongKeKho({
    required this.product,
    required this.material,
    // required this.company,
    required this.amount,
  });

  DoiTruThongKeKho.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null ? json['product'] : '';
    // company = json['company'];
    amount = json['amount'];
    material = json['material'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product;
    data['material'] = this.material;
    data['amount'] = this.amount;
    // data['material'] = this.material;
    return data;
  }
}

class CongDonKho {
  late String? material;
  late double amount;
  // late String company;
  CongDonKho({
    required this.material,
    // required this.company,
    required this.amount,
  });

  CongDonKho.fromJson(Map<String, dynamic> json) {
    // company = json['company'];
    amount = json['amount'];
    material = json['material'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['material'] = this.material;
    data['amount'] = this.amount;
    // data['material'] = this.material;
    return data;
  }
}
