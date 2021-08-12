class BienBanKiemKho {
  late String company;
  late String checkDate;
  late String status;
  late String statusMaterial;
  late List<KiemKhoDanhSach> materialList;
  late String statusProduct;
  late List semiProductList;

  BienBanKiemKho({
    required this.company,
    required this.checkDate,
    required this.status,
    required this.statusMaterial,
    required this.materialList,
    required this.statusProduct,
    required this.semiProductList,
  });

  BienBanKiemKho.fromJson(Map<dynamic, dynamic> json) {
    company = json['company'];
    checkDate = json['check_date'];
    status = json['status'];
    statusMaterial = json['status_material'];
    materialList = json['material_list'] != null
        ? (json['material_list'] as List<dynamic>).map((e) {
            return KiemKhoDanhSach.fromJson(e);
          }).toList()
        : [];
    statusProduct = json['status_product'];
    semiProductList = json['semi_product_list'] != null
        ? (json['semi_product_list'] as List<dynamic>).map((e) {
            return KiemKhoDanhSach.fromJson(e);
          }).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['custom_name'] = this.customName;
    // data['real_name'] = this.realName;
    // data['quantity'] = this.quantity;
    // data['type'] = this.type;
    // data['status'] = this.status;
    // data['name'] = this.name;

    // data['system_count'] = this.quantity;
    // data['actual_count'] = this.actualCount;
    return data;
  }
}

class KiemKhoDanhSach {
  late String realName;

  late int systemCount;
  late int actualCount;

  KiemKhoDanhSach({
    required this.realName,
    required this.systemCount,
    required this.actualCount,
  });

  KiemKhoDanhSach.fromJson(Map<dynamic, dynamic> json) {
    realName = json['real_name'];
    systemCount =
        json['system_count'] != null ? int.parse(json['system_count']) : 0;
    actualCount =
        json['actual_count'] != null ? int.parse(json['actual_count']) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['real_name'] = this.realName;
    data['system_count'] = this.systemCount;
    data['actual_count'] = this.actualCount;
    return data;
  }
}
