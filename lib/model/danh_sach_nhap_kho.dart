class DanhSachNhapKho {
  late String type;
  late String? realName;
  late int amount;
  late String title;
  late String unit;
  late bool isExpanded;
  late DanhSachNhapKhoValidator validator;

  DanhSachNhapKho({
    required this.type,
    required this.realName,
    required this.amount,
    required this.title,
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
    isExpanded = false;
    unit = "Bình";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['real_name'] = this.realName;
    data['amount'] = this.amount;
    data['title'] = this.title;
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
