class Customer {
  late String name;
  late String realName;
  late String status;
  late String taxId;
  late String phone;
  late String email;

  Customer({
    required this.name,
    required this.realName,
    required this.status,
    required this.taxId,
    required this.phone,
    required this.email,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    realName = json['real_name'] != null ? json['real_name'] : '';
    status = json['status'];
    taxId = json['tax_id'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['real_name'] = this.realName;
    data['status'] = this.status;
    data['tax_id'] = this.taxId;
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }
}
