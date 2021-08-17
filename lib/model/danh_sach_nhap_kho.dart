class DanhSachNhapKho {
  late String type;
  late String? realName;
  late int amount;
  late String title;
  late String unit;
  late String address;
  late bool isExpanded;
  late DanhSachNhapKhoValidator validator;

  DanhSachNhapKho({
    required this.type,
    required this.realName,
    required this.amount,
    required this.title,
    required this.address,
    this.unit = 'Bình',
    this.isExpanded = false,
  }) {
    validator = DanhSachNhapKhoValidator();
  }

  DanhSachNhapKho.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    realName = json['real_name'] != null ? json['real_name'] : '';
    amount = json['amount'];
    title = json['title'];
    address = json['address'];
    isExpanded = false;
    unit = "Bình";
    validator = DanhSachNhapKhoValidator();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['real_name'] = this.realName;
    data['amount'] = this.amount;
    data['title'] = this.title;
    data['address'] = this.address;
    return data;
  }
}

class DanhSachNhapKhoValidator {
  late bool isMaterialRequired;
  late bool isQuantityRequired;

  bool get isSubmit => !isMaterialRequired && !isQuantityRequired;
  DanhSachNhapKhoValidator({
    this.isMaterialRequired = false,
    this.isQuantityRequired = false,
  });
}
