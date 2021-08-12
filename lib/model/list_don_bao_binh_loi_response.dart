import 'package:flutter/cupertino.dart';
import 'package:frappe_app/model/don_bao_binh_loi.dart';

class ListDonBaoBinhLoiRespone {
  List<DonBaoBinhLoi>? listDonBaoBinhLoi;
  ListDonBaoBinhLoiRespone({this.listDonBaoBinhLoi});

  ListDonBaoBinhLoiRespone.fromJson(Map<String, dynamic> json) {
    dynamic jsonFromMessage = json['message'];
    var _listDonBaoBinhLoi =
        (jsonFromMessage['data'] as List<dynamic>).map((e) {
      var castValue = e as Map<String, dynamic>;
      return DonBaoBinhLoi.fromJson(castValue);
    }).toList();

    listDonBaoBinhLoi = _listDonBaoBinhLoi;
  }
}

class SingleDonBaoBinhLoiRespone {
  late String? name;
  late String? description;
  late String? feedback;
  late List<DonBaoLoiAddress>? listDonBaoLoiAddress;

  SingleDonBaoBinhLoiRespone(
      {this.name, this.description, this.feedback, this.listDonBaoLoiAddress});

  SingleDonBaoBinhLoiRespone.fromJson(Map<String, dynamic> json) {
    dynamic jsonFromMessage = json['message'];
    dynamic data = jsonFromMessage['data'];
    name = data['name'];
    description = data['description'];
    feedback = data['feedback'];
    listDonBaoLoiAddress = (data['address'] as List<dynamic>).map((e) {
      return DonBaoLoiAddress.fromJson(e);
    }).toList();
  }
}

class DonBaoLoiAddress {
  late String? address;
  late List<BinhLoi> listBinhloi;
  late bool isExpanded;

  DonBaoLoiAddress(
      {required this.address,
      required this.isExpanded,
      required this.listBinhloi});

  DonBaoLoiAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    listBinhloi = (json['error_list'] as List<dynamic>).map((e) {
      return BinhLoi.fromJson(e);
    }).toList();
    isExpanded = false;
  }
}

class BinhLoi {
  late String serial;
  late String description;
  late bool isExpanded;
  TextEditingController? serialController;
  TextEditingController? descriptionController;

  BinhLoi(
      {required this.serial,
      required this.description,
      required this.isExpanded,
      this.serialController,
      this.descriptionController});

  BinhLoi.fromJson(Map<String, dynamic> json) {
    serial = json['serial'];
    description = json['description'];
  }
}
