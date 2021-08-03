import 'package:frappe_app/model/common.dart';

class UploadFileResponse {
  Attachments? attachments;
  ErrorResponse? errorResponse;
  UploadFileResponse({this.attachments, this.errorResponse});

  UploadFileResponse.fromJson(Map<String, dynamic> json) {
    attachments = Attachments.fromJson(json['message']);
  }
}

class Attachments {
  late String name;
  late String fileName;
  late String fileUrl;
  late int isPrivate;

  Attachments({
    required this.name,
    required this.fileName,
    required this.fileUrl,
    required this.isPrivate,
  });

  Attachments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fileName = json['file_name'];
    fileUrl = json['file_url'];
    isPrivate = json['is_private'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['file_url'] = this.fileUrl;
    data['is_private'] = this.isPrivate;
    return data;
  }
}
