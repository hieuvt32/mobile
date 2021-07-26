class Address {
  late String? name;
  late String customer;
  late String diaChi;
  late bool isEnable;
  late bool isEditable;

  Address({
    required this.name,
    required this.diaChi,
    required this.customer,
    required this.isEnable,
    this.isEditable = false,
  });

  Address.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    diaChi = json['dia_chi'] != null ? json['dia_chi'] : '';
    customer = json['parent'] != null ? json['parent'] : '';
    isEnable = false;
    isEditable = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.diaChi;
    data['customer'] = this.customer;
    return data;
  }
}
