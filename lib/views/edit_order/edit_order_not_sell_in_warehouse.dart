import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/views/edit_order/edit_order_not_sell_in_warehouse_tab.dart';
import 'package:frappe_app/views/edit_order/edit_order_not_sell_in_warehouse_normal.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';

class EditOrderSellNotInWareHouse extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  EditOrderSellNotInWareHouse({Key? key}) : super(key: key);

  @override
  _EditOrderSellNotInWareHouseState createState() =>
      _EditOrderSellNotInWareHouseState();
}

class _EditOrderSellNotInWareHouseState
    extends State<EditOrderSellNotInWareHouse> {
  @override
  Widget build(BuildContext context) {
    return _buidStateView();
  }

  Widget _buidStateView() {
    if (widget.model.orderState == OrderState.Delivered) {
      return EditOrderSellNotInWareHouseTab();
    }

    return EditOrderNotSellInWareHouseNormal();
  }
}
