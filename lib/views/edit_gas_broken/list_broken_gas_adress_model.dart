import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/list_don_bao_binh_loi_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/views/base_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';

@lazySingleton
class EditGasBrokenViewModel extends BaseViewModel {
  late SingleDonBaoBinhLoiRespone donBaoBinhLoi;
  late bool enableEdit;
  late bool isLoading = true;
  late List<Address> deliveryAddresses = [];

  initData(String? id) {
    enableEdit = true;
    if (id != null) {
      enableEdit = false;
      fetchSingleDonbaoLoi(id);
    } else {
      fetchDeliveryAdresses();

      isLoading = false;
      donBaoBinhLoi = SingleDonBaoBinhLoiRespone();
      donBaoBinhLoi.listDonBaoLoiAddress = [
        DonBaoLoiAddress(address: null, isExpanded: true, listBinhloi: [
          BinhLoi(serial: "", description: "", isExpanded: true)
        ])
      ];
      notifyListeners();
    }
  }

  Future fetchDeliveryAdresses() async {
    String customerCode = (Config().userId ?? "").split('@')[0];
    locator<Api>().getDeliveryAddress(customer: customerCode).then((response) {
      deliveryAddresses = response.addresses ?? [];
      notifyListeners();
    });
  }

  Future fetchSingleDonbaoLoi(String id) async {
    locator<Api>().getSingleDonBaoLoi(id).then((value) {
      donBaoBinhLoi = value;
      isLoading = false;
      notifyListeners();
    });
  }
}
