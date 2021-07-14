import 'package:frappe_app/model/address.dart';

class GetDeliveryAddressResponse {
  List<Address>? addresses;
  GetDeliveryAddressResponse({this.addresses});

  GetDeliveryAddressResponse.fromJson(Map<String, dynamic> json) {
    addresses = (json['message'] as List<dynamic>).map((e) {
      var castValue = e as Map<String, dynamic>;
      return Address.fromJson(castValue);
    }).toList();
  }
}
