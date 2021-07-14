import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/doctype_response.dart';

class CreateNewDeliveryAddressResponse {
  CreateNewDeliveryAddressResponse({required this.address});

  late Address address;

  CreateNewDeliveryAddressResponse.fromJson(Map<String, dynamic> json) {
    address = Address.fromJson(json['message'] as Map<String, dynamic>);
  }
}
