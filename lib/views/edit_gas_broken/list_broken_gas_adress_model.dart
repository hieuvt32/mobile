import 'package:flutter/cupertino.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/create_bao_binh_loi_request.dart';
import 'package:frappe_app/model/get_delivery_address_response.dart';
import 'package:frappe_app/model/list_don_bao_binh_loi_response.dart';
import 'package:frappe_app/model/update_bap_binh_loi_request.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/views/base_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';

@lazySingleton
class EditGasBrokenViewModel extends BaseViewModel {
  late SingleDonBaoBinhLoiRespone donBaoBinhLoi;
  late bool enableEdit;
  late bool isLoading = true;
  late List<Address> deliveryAddresses = [];
  late TextEditingController noteFieldController = TextEditingController();
  late TextEditingController feedbackController = TextEditingController();
  late String? customerCode;

  initData() {
    noteFieldController.clear();

    String? initDeliveryAddress =
        deliveryAddresses.length > 0 ? deliveryAddresses[0].diaChi : null;

    donBaoBinhLoi.listDonBaoLoiAddress = [
      DonBaoLoiAddress(
          address: initDeliveryAddress,
          isExpanded: true,
          listBinhloi: [
            BinhLoi(
                serial: "",
                description: "",
                isExpanded: true,
                serialController: TextEditingController(),
                descriptionController: TextEditingController())
          ])
    ];
  }

  Future<void> initState({String? id, String? customer}) async {
    customerCode = customer;
    donBaoBinhLoi = SingleDonBaoBinhLoiRespone();
    noteFieldController.clear();
    enableEdit = true;
    if (id != null) {
      enableEdit = false;
      fetchSingleDonbaoLoi(id);
    } else {
      isLoading = false;

      initData();
      fetchDeliveryAdresses().then((addresses) {
        donBaoBinhLoi.listDonBaoLoiAddress![0].address = addresses[0].diaChi;
        notifyListeners();
      });
    }
  }

  Future<List<Address>> fetchDeliveryAdresses() async {
    String customerCode = (Config().userId ?? "").split('@')[0];
    GetDeliveryAddressResponse response =
        await locator<Api>().getDeliveryAddress(customer: customerCode);

    deliveryAddresses = response.addresses ?? [];
    notifyListeners();

    return response.addresses ?? [];
  }

  Future fetchSingleDonbaoLoi(String id) async {
    locator<Api>().getSingleDonBaoLoi(id).then((value) {
      donBaoBinhLoi = value;
      isLoading = false;
      notifyListeners();
    });
  }

  addNewAddress() {
    donBaoBinhLoi.listDonBaoLoiAddress!.add(DonBaoLoiAddress(
        address: deliveryAddresses[0].diaChi,
        isExpanded: true,
        listBinhloi: [
          BinhLoi(
              serial: "",
              description: "",
              isExpanded: true,
              serialController: TextEditingController(),
              descriptionController: TextEditingController())
        ]));

    notifyListeners();
  }

  deleteAddress(int index) {
    donBaoBinhLoi.listDonBaoLoiAddress!.removeAt(index);

    notifyListeners();
  }

  changeAddress(int index, String value) {
    donBaoBinhLoi.listDonBaoLoiAddress![index].address = value;
  }

  deleteBinhLoiItem(int parentIndex, int childIndex) {
    donBaoBinhLoi.listDonBaoLoiAddress![parentIndex].listBinhloi
        .removeAt(childIndex);

    notifyListeners();
  }

  addBinhLoi(int parentIndex) {
    donBaoBinhLoi.listDonBaoLoiAddress![parentIndex].listBinhloi.add(BinhLoi(
        isExpanded: true,
        serial: "",
        description: "",
        descriptionController: TextEditingController(),
        serialController: TextEditingController()));

    notifyListeners();
  }

  Future<dynamic> createDonBaoBinhLoi() async {
    String customerCode = Config().customerCode;
    CreateBaoBinhLoiRequest request = new CreateBaoBinhLoiRequest(
        customerCode: customerCode,
        listDonBaoLoiAddress: donBaoBinhLoi.listDonBaoLoiAddress ?? [],
        notes: noteFieldController.value.text);

    return locator<Api>().createBaoBinhLoi(request);
  }

  Future<dynamic> updateDonBaoBinhLoi(BuildContext context) async {
    try {
      if (feedbackController.value.text.trim().length == 0) {
        FrappeAlert.warnAlert(title: "Hãy nhập phản hồi", context: context);
        return;
      }

      if (customerCode == null) {
        FrappeAlert.errorAlert(
            title: "Có lỗi xảy ra, vui lòng thử lại sau", context: context);
        return;
      }

      UpdateBaoBinhLoiRequest request = new UpdateBaoBinhLoiRequest(
          customerCode: customerCode ?? "",
          listDonBaoLoiAddress: donBaoBinhLoi.listDonBaoLoiAddress ?? [],
          notes: donBaoBinhLoi.description ?? "",
          name: donBaoBinhLoi.name ?? "",
          feedback: feedbackController.value.text,
          status: "Đã phản hồi");

      await locator<Api>().updateDonBaoBinhLoi(request);
      fetchSingleDonbaoLoi(donBaoBinhLoi.name ?? "");

      feedbackController.clear();
      FrappeAlert.successAlert(title: "Đã gửi phản hồi", context: context);
    } catch (err) {
      FrappeAlert.errorAlert(
          title: "Có lỗi xảy ra, vui lòng thử lại sau", context: context);
      return;
    }
  }

  Future<dynamic> deleteDonBinhBaoLoi(BuildContext context) async {
    String? name = donBaoBinhLoi.name;
    if (name != null && (donBaoBinhLoi.feedback ?? "").trim().length == 0) {
      locator<Api>().deleteDonBaoBinhLoi(name).then((value) {
        Navigator.pop(context, true);

        FrappeAlert.successAlert(title: "Xóa thành công.", context: context);
      }).catchError((err) {
        FrappeAlert.errorAlert(
            title: "Có lỗi xảy ra, vui lòng thử lại sau", context: context);
      });
    } else {
      FrappeAlert.errorAlert(
          title: "Không thể xóa đơn báo lỗi này.", context: context);
    }
  }
}
