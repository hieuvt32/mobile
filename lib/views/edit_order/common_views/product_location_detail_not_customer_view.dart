import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/views/edit_order/tabs/receiving_shell_delivered_tab.dart';

import '../../customize_app_bar.dart';
import 'edit_order_viewmodel.dart';

class ProductLocationDetailNoCustomerView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final String address;
  ProductLocationDetailNoCustomerView({required this.address, Key? key})
      : super(key: key);

  @override
  _ProductLocationDetailNoCustomerViewState createState() =>
      _ProductLocationDetailNoCustomerViewState();
}

class _ProductLocationDetailNoCustomerViewState
    extends State<ProductLocationDetailNoCustomerView> {
  @override
  Widget build(BuildContext context) {
    List<Product> products = widget.model.order!.products
        .where((p) => p.address == widget.address)
        .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomizeAppBar(
        products[0].diaChi,
        leftAction: () {
          Navigator.pop(context);
        },
        actions: [],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ReceivingShellDeliveredTab(
            address: widget.address,
          )),
    );
  }
}
