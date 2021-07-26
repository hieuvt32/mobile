import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/customize_app_bar.dart';
import 'package:frappe_app/views/edit_order/edit_order_not_sell_in_ware_house.dart';
import 'package:frappe_app/views/edit_order/edit_order_sell_in_warehouse.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';

class EditOrderView extends StatefulWidget {
  final String name;
  final bool haveDelivery;
  EditOrderView({
    Key? key,
    this.name = '',
    this.haveDelivery = false,
  }) : super(key: key);

  @override
  _EditOrderViewState createState() => _EditOrderViewState();
}

class _EditOrderViewState extends State<EditOrderView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseView<EditOrderViewModel>(
      onModelReady: (model) {
        model.setName(widget.name);
        model.init();
        model.initPreData();
        model.setHaveDelivery(widget.haveDelivery);
        // this.initTab();
      },
      onModelClose: (model) {
        model.disposed();
        // _tabController.dispose();
        // _secondTabController.dispose();
        // _scrollController.dispose();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomizeAppBar(
          model.title,
          leftAction: () {
            Navigator.pop(context);
          },
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Center(
                child: Text(
                  model.orderStatus,
                  style: TextStyle(
                    color: hexToColor('#0072BC'),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
        body: _buidMainView(model),
      ),
    );
  }

  Widget _buidMainView(EditOrderViewModel model) {
    if (model.sellInWarehouse) {
      return EditOrderSellInWareHouse();
    }
    return EditOrderSellNotInWareHouse();
  }
}
