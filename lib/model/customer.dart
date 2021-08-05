import 'package:frappe_app/model/address.dart';

class Customer {
  late String code;
  late String name;
  late String realName;
  late String status;
  late String taxId;
  late String phone;
  late String email;
  late List<Address>? address;

  Customer(
      {required this.code,
      required this.name,
      required this.realName,
      required this.status,
      required this.taxId,
      required this.phone,
      required this.email,
      this.address});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['_name'];
    code = json['name'];
    realName = json['real_name'] != null ? json['real_name'] : '';
    status = json['status'];
    taxId = json['tax_id'];
    phone = json['phone'];
    email = json['email'];
    address = (json['recieve_address'] as List<dynamic>?)!.map((e) {
      var cast = e as Map<String, dynamic>;

      return Address.fromJson(cast);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['real_name'] = this.realName;
    data['status'] = this.status;
    data['tax_id'] = this.taxId;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['_name'] = this.code;
    data['recive_address'] = this.address;
    return data;
  }
}
