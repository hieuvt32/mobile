import 'package:frappe_app/model/product.dart';

class Order {
  late String vendorName;
  late DateTime creation;
  late DateTime modified;
  late String status;
  late String name;
  late String employeeName;
  late String plate;
  late List<Product> products;
  late List<DiaChiTongTien> totalAmountByAddress;

  late bool coGiaoVanVien;

  late int sellInWarehouse;
  late int? isRated;

  late String company;
  // late String orderStatus;
  late String paymentStatus;
  late String vendor;
  late String phone;
  late String email;
  late String taxId;
  late String vendorAddress;
  late double totalCost;

  late String attachSignatureSupplierImage;
  late String attachSignatureCustomerImage;

  late String cancelPerson;
  late DateTime? cancelDate;
  late String cancelReason;

  late String type;

  Order(
      {required this.vendorName,
      // required this.creation,
      required this.status,
      required this.name,
      required this.employeeName,
      required this.plate,
      required this.products,
      required this.sellInWarehouse,
      required this.company,
      // required this.orderStatus,
      required this.paymentStatus,
      required this.vendor,
      required this.phone,
      required this.taxId,
      required this.email,
      required this.vendorAddress,
      required this.totalCost,
      required this.attachSignatureSupplierImage,
      required this.attachSignatureCustomerImage,
      required this.type,
      this.cancelDate,
      required this.cancelPerson,
      required this.cancelReason,
      required this.totalAmountByAddress,
      this.isRated}) {
    coGiaoVanVien = false;
    creation = DateTime.now();
    modified = DateTime.now();
  }

  Order.fromJson(Map<String, dynamic> json) {
    var date = json['creation'] != null
        ? DateTime.tryParse(json['creation'])
        : DateTime.now();

    vendorName = json['vendor_name'];
    type = json['type'];
    sellInWarehouse = json['sell_in_warehouse'];
    creation = date != null ? date : DateTime.now();
    status = json['order_status'];
    name = json['name'];
    employeeName = json['employee_name'] == null ? '' : json['employee_name'];
    plate = json['plate'] == null ? '' : json['plate'];
    products = json['product_list'] != null
        ? (json['product_list'] as List<dynamic>).map((e) {
            return Product.fromJson(e);
          }).toList()
        : [];

    totalAmountByAddress = json['total_amount_by_address'] != null
        ? (json['total_amount_by_address'] as List<dynamic>).map((e) {
            return DiaChiTongTien.fromJson(e);
          }).toList()
        : [];

    company = json['company'] == null ? '' : json['company'];
    paymentStatus =
        json['payment_status'] == null ? '' : json['payment_status'];
    vendor = json['vendor'] == null ? '' : json['vendor'];
    phone = json['phone'] == null ? '' : json['phone'];
    taxId = json['tax_id'] == null ? '' : json['tax_id'];
    email = json['email'] == null ? '' : json['email'];
    vendorAddress =
        json['vendor_address'] == null ? '' : json['vendor_address'];
    totalCost = json['total_cost'] == null ? '' : json['total_cost'];
    attachSignatureSupplierImage =
        json['attach_signature_supplier_image'] == null
            ? ''
            : json['attach_signature_supplier_image'];
    attachSignatureCustomerImage =
        json['attach_signature_customer_image'] == null
            ? ''
            : json['attach_signature_customer_image'];

    isRated = json['is_rating'] ?? 0;

    coGiaoVanVien = employeeName != '' && plate != '';
    type = json['type'] == null ? 'B' : json['type'];
    var modifiedDate = json['modified'] != null
        ? DateTime.tryParse(json['modified'])
        : DateTime.now();
    modified = modifiedDate != null ? modifiedDate : DateTime.now();

    cancelDate = (json['cancle_date'] != null
            ? DateTime.tryParse(json['cancle_date'])
            : DateTime.now()) ??
        DateTime.now();

    cancelPerson = json['cancel_person'];
    cancelReason = json['cancel_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_name'] = this.vendorName;
    data['name'] = this.name;
    data['sell_in_warehouse'] = sellInWarehouse;
    data['company'] = company;
    data['order_status'] = status;
    data['payment_status'] = paymentStatus;
    data['vendor'] = vendor;
    data['type'] = type;
    data['phone'] = phone;
    data['email'] = email;
    data['tax_id'] = taxId;
    data['vendor_address'] = vendorAddress;
    data['total_cost'] = totalCost;
    data['type'] = type;
    final List<Map<String, dynamic>> lstProduct =
        products != null ? products.map((e) => e.toJson()).toList() : [];
    data['product_list'] = lstProduct;
    data['attach_signature_customer_image'] = attachSignatureCustomerImage;
    data['attach_signature_supplier_image'] = attachSignatureSupplierImage;

    data['cancel_person'] = cancelPerson;
    data['cancel_date'] = cancelDate.toString();
    data['cancel_reason'] = cancelReason;

    // data['plate'] = this.plate;
    // data['employee_name'] = this.employeeName;
    return data;
  }
}

class DiaChiTongTien {
  late String diaChi;
  late double tongTien;

  DiaChiTongTien(this.diaChi, this.tongTien);

  DiaChiTongTien.fromJson(Map<dynamic, dynamic> json) {
    diaChi = json['dia_chi'];
    tongTien = json['Tong tien'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Dia chi'] = this.diaChi;
    data['Tong tien'] = this.tongTien;
    return data;
  }
}
