import 'package:frappe_app/model/customer.dart';

class GetCustomerByCodeResponse {
  Customer? customer;
  GetCustomerByCodeResponse({this.customer});

  GetCustomerByCodeResponse.fromJson(Map<String, dynamic> json) {
    dynamic jsonFromMessage = json['message'];
    customer = Customer.fromJson(jsonFromMessage['data']);
  }
}
