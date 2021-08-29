class OrderLocationResponse {
  late List<OrderLocation> listLocations;
  OrderLocationResponse.fromJson(Map<String, dynamic> json) {
    dynamic data = json['message']['description'];

    listLocations =
        (data as List<dynamic>).map((e) => OrderLocation.fromJson(e)).toList();
  }
}

class OrderLocation {
  late String name;
  late String order;
  late String address;
  late String longitude;
  late String latitude;

  OrderLocation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    order = json['order'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }
}
