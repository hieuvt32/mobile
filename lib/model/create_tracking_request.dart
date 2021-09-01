class CreateTrackingLocationRequest {
  late String order;
  late String address;
  late double? longitude;
  late double? latitude;
  late String employeeAccount;

  CreateTrackingLocationRequest(
      {required this.address,
      required this.order,
      required this.employeeAccount,
      this.longitude,
      this.latitude});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["order"] = order;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['employee_account'] = employeeAccount;

    return data;
  }
}
