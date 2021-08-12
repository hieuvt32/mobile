import 'package:frappe_app/model/list_don_bao_binh_loi_response.dart';

class CreateBaoBinhLoiRequest {
  late String customerCode;
  late String notes;
  late List<DonBaoLoiAddress> listDonBaoLoiAddress;

  CreateBaoBinhLoiRequest(
      {required this.listDonBaoLoiAddress,
      required this.notes,
      required this.customerCode});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();

    List<Map<String, dynamic>> errorList = [];

    listDonBaoLoiAddress.forEach((addressItem) {
      addressItem.listBinhloi.forEach((childItem) {
        Map<String, dynamic> item = new Map<String, dynamic>();

        item['address'] = addressItem.address ?? "";
        item['barcode'] = childItem.serialController!.value.text;
        item['description'] = childItem.descriptionController!.value.text;

        errorList.add(item);
      });
    });

    data['customer'] = this.customerCode;
    data['notes'] = this.notes;
    data['error_list'] = errorList;

    return data;
  }
}
