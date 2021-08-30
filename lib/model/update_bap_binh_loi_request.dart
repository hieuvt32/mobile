import 'package:frappe_app/model/list_don_bao_binh_loi_response.dart';

class UpdateBaoBinhLoiRequest {
  late String customerCode;
  late String notes;
  late List<DonBaoLoiAddress> listDonBaoLoiAddress;
  late String name;
  late String feedback;

  UpdateBaoBinhLoiRequest(
      {required this.listDonBaoLoiAddress,
      required this.notes,
      required this.customerCode,
      required this.name,
      required this.feedback});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();

    List<Map<String, dynamic>> errorList = [];

    listDonBaoLoiAddress.forEach((addressItem) {
      addressItem.listBinhloi.forEach((childItem) {
        Map<String, dynamic> item = new Map<String, dynamic>();

        item['address'] = addressItem.address ?? "";
        item['barcode'] = childItem.serial;
        item['description'] = childItem.description;

        errorList.add(item);
      });
    });

    data['customer'] = customerCode;
    data['notes'] = notes;
    data['error_list'] = errorList;
    data['feedback'] = feedback;
    data['name'] = name;

    return data;
  }
}
