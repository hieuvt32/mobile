import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/list_order_response.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/views/base_viewmodel.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TransportationViewModel extends BaseViewModel {
  bool isLoading = true;

  List<Order> orders = [];

  ListOrderResponse? _responseDaDatHang;

  ListOrderResponse? _responseDangGiaoHang;

  ListOrderResponse? _responseDaGiaoHang;

  init() async {
    orders = [];
    isLoading = true;
    var userId = Config().userId ?? "";
    _responseDaDatHang = await locator<Api>()
        .getListOrder(0, sellInWareHouse: 0, employeeAccount: userId);

    _responseDangGiaoHang = await locator<Api>()
        .getListOrder(1, sellInWareHouse: 0, employeeAccount: userId);

    _responseDaGiaoHang = await locator<Api>()
        .getListOrder(2, sellInWareHouse: 0, employeeAccount: userId);

    if (_responseDaDatHang != null &&
        _responseDaGiaoHang != null &&
        _responseDangGiaoHang != null) {
      isLoading = false;
      notifyListeners();
      if (_responseDangGiaoHang!.orders != null) {
        orders.addAll(_responseDangGiaoHang!.orders!);
      }
      if (_responseDaDatHang!.orders != null) {
        orders.addAll(_responseDaDatHang!.orders!);
      }
      if (_responseDaGiaoHang!.orders != null) {
        orders.addAll(_responseDaGiaoHang!.orders!);
      }
    }
  }
}
