class ListDonGiaMuaBanResponse {
  List<DonGiaMuaBan>? donGiaMuaBans;
  ListDonGiaMuaBanResponse({this.donGiaMuaBans});

  ListDonGiaMuaBanResponse.fromJson(Map<String, dynamic> json) {
    donGiaMuaBans = (json['data'] as List<dynamic>).map((e) {
      var castValue = e as Map<String, dynamic>;
      return DonGiaMuaBan.fromJson(castValue);
    }).toList();
  }
}

class DonGiaMuaBan {
  late String company;
  late String realName;
  late String type;
  late int priceByKg;
  late double unitPrice;
  late String status;

  DonGiaMuaBan({
    required this.company,
    // required this.creation,
    required this.status,
    required this.realName,
    required this.type,
    required this.priceByKg,
    required this.unitPrice,
  });

  DonGiaMuaBan.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    type = json['type'];
    realName = json['_name'];
    priceByKg = int.tryParse("${json['price_by_kg']}") ?? 0;
    status = json['status'];
    unitPrice = double.tryParse("${json['unit_price']}") ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company'] = this.company;
    data['type'] = this.type;
    data['_name'] = this.realName;
    data['price_by_kg'] = priceByKg;
    data['status'] = status;
    data['unit_price'] = this.unitPrice;
    return data;
  }
}

// class SingleOrderResponse {
//   Order? order;
//   SingleOrderResponse({this.order});

//   SingleOrderResponse.fromJson(Map<String, dynamic> json) {
//     order = Order.fromJson(json['message']);
//   }
// }
