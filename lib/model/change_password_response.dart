import 'package:frappe_app/model/doctype_response.dart';

class ChangePasswordResponse {
  ChangePasswordResponse({required this.doctypeDoc});

  late DoctypeDoc doctypeDoc;

  ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    doctypeDoc = DoctypeDoc.fromJson(json['data'] as Map<String, dynamic>);
  }
}
