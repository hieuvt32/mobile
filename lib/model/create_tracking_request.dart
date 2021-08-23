class CreateTrackingLocationRequest {
  late String order;
  late String address;
  late double? longitude;
  late double? latitude;

  CreateTrackingLocationRequest(
      {required this.address,
      required this.order,
      this.longitude,
      this.latitude});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["order"] = order;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;

    return data;
  }
}
