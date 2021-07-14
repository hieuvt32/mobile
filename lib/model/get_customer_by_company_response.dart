import 'customer.dart';

class GetCustomerByCompanyResponse {
  List<Customer>? customers;
  GetCustomerByCompanyResponse({this.customers});

  GetCustomerByCompanyResponse.fromJson(Map<String, dynamic> json) {
    customers = (json['message'] as List<dynamic>).map((e) {
      var castValue = e as Map<String, dynamic>;
      return Customer.fromJson(castValue);
    }).toList();
  }
}
