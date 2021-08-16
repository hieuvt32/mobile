class Product {
  late String address;
  late String diaChi;
  late String? product;
  late int quantity;
  late int actualQuantity;
  late double kg;
  late double actualKg;
  late double unitPrice;
  late String status;
  late String type;
  late String? material;
  late String unit;
  late bool enabledVatTu;
  late bool enabledKG;
  late bool isExpanded;
  late ProductValidator validator;
  Product({
    required this.address,
    required this.product,
    required this.quantity,
    required this.actualQuantity,
    required this.kg,
    required this.actualKg,
    required this.unitPrice,
    required this.status,
    required this.type,
    required this.material,
    required this.unit,
    required this.enabledVatTu,
    required this.enabledKG,
    required this.diaChi,
    this.isExpanded = false,
  }) {
    validator = new ProductValidator();
  }

  Product.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    product = json['product'] != null ? json['product'] : '';
    status = json['status'];
    quantity = json['quantity'];
    actualQuantity = json['actual_quantity'];
    kg = json['kg'];
    actualKg = json['actual_kg'];
    unitPrice = json['unit_price'];
    type = json['type'];
    material = json['material'];
    unit = json['unit'] ?? 'Bình';
    enabledKG = ["", null, false, 0].contains(json['kg']);
    enabledVatTu = ["", null, false, 0].contains(json['material']);
    diaChi = json['dia_chi'];
    isExpanded = false;
    diaChi = json['dia_chi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['product'] = this.product;
    data['status'] = this.status;
    data['quantity'] = this.quantity;
    data['actual_quantity'] = this.actualQuantity;
    data['kg'] = this.kg;
    data['actual_kg'] = this.actualKg;
    data['unit_price'] = this.unitPrice;
    data['type'] = this.type;
    data['material'] = this.material;
    data['unit'] = this.unit;
    return data;
  }
}

class ProductValidator {
  late bool isProductRequired;
  late bool isMaterialRequired;
  late bool isQuantityRequired;
  late bool isKgRequired;

  bool get isSubmit =>
      !isProductRequired &&
      !isMaterialRequired &&
      !isQuantityRequired &&
      !isKgRequired;

  ProductValidator({
    this.isProductRequired = false,
    this.isMaterialRequired = false,
    this.isQuantityRequired = false,
    this.isKgRequired = false,
  });
}
