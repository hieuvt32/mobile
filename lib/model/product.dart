class Product {
  late String address;
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
  late bool hiddenVatTu;
  late bool hiddenKG;
  late bool isExpanded;
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
    required this.hiddenVatTu,
    required this.hiddenKG,
    this.isExpanded = false,
  });

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
    hiddenKG = ["", null, false, 0].contains(json['kg']);
    hiddenVatTu = ["", null, false, 0].contains(json['material']);
    isExpanded = false;
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
