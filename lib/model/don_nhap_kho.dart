import 'package:frappe_app/model/danh_sach_nhap_kho.dart';

class DonNhapKho {
  late String name;
  late String codeOrders;
  late String company;
  late List<DanhSachNhapKho> listShell;
  late String title;
  late String status;

  DonNhapKho({
    required this.codeOrders,
    required this.name,
    required this.company,
    required this.title,
    required this.status,
    required this.listShell,
  });

  DonNhapKho.fromJson(Map<String, dynamic> json) {
    codeOrders = json['code_orders'];
    name = json['name'] != null ? json['name'] : '';
    company = json['company'];
    title = json['title'];
    status = json['status'];
    listShell = (json['list_shell'] as List<dynamic>).map((item) {
      return DanhSachNhapKho.fromJson(item);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    var listShell = this.listShell.map((item) {
      return item.toJson();
    }).toList();
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code_orders'] = this.codeOrders;
    data['name'] = this.name;
    data['company'] = this.company;
    data['title'] = this.title;
    data['status'] = this.status;
    data['list_shell'] = listShell;
    return data;
  }
}
