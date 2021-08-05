import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:frappe_app/model/doctype_response.dart';

class ErrorResponse {
  late String statusMessage;
  late String? userMessage;
  late int? statusCode;
  late String? stackTrace;

  ErrorResponse({
    this.stackTrace,
    this.statusCode,
    this.statusMessage = "Something went wrong",
    this.userMessage,
  });
}

class FilterOperator {
  late String label;
  late String value;

  FilterOperator({required this.label, required this.value});

  FilterOperator.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}

class Filter {
  late DoctypeField field;
  late FilterOperator filterOperator;
  late String? value;
  late bool isInit;

  Filter({
    required this.filterOperator,
    required this.field,
    this.value,
    this.isInit = false,
  });

  Filter.fromJson(Map<String, dynamic> json) {
    filterOperator = FilterOperator.fromJson(
      json['filterOperator'],
    );
    field = DoctypeField.fromJson(
      json['field'],
    );
    value = json['value'];
    isInit = json['isInit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filterOperator'] = this.filterOperator.toJson();
    data['field'] = this.field.toJson();
    data['value'] = this.value;
    data['isInit'] = this.isInit;
    return data;
  }
}

class FrappeFile {
  bool isPrivate;
  PlatformFile file;

  FrappeFile({
    this.isPrivate = true,
    required this.file,
  });
}

class GasFile {
  bool isPrivate;
  Uint8List file;
  String fileName;
  String fieldName;
  GasFile({
    this.isPrivate = false,
    required this.file,
    required this.fileName,
    required this.fieldName,
  });
}
