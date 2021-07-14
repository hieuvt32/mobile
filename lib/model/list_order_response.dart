import 'package:frappe_app/model/order.dart';

class ListOrderResponse {
  List<Order>? orders;
  ListOrderResponse({this.orders});

  ListOrderResponse.fromJson(Map<String, dynamic> json) {
    orders = (json['message'] as List<dynamic>).map((e) {
      var castValue = e as Map<String, dynamic>;
      return Order.fromJson(castValue);
    }).toList();
  }
}

class SingleOrderResponse {
  Order? order;
  SingleOrderResponse({this.order});

  SingleOrderResponse.fromJson(Map<String, dynamic> json) {
    order = Order.fromJson(json['message']);
  }
}
