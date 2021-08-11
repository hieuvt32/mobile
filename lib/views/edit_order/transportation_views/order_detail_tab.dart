import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/components/list_product_view.dart';
import 'package:frappe_app/views/edit_order/components/list_shell_view.dart';

import 'transportation_product_list.dart';

class OrderDetailTab extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  OrderDetailTab({Key? key}) : super(key: key);

  @override
  _OrderDetailTabState createState() => _OrderDetailTabState();
}

class _OrderDetailTabState extends State<OrderDetailTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TransportationProductList(
            "Danh sách sản phẩm",
            realOnly: false,
          ),
          ListShellView(
            'Danh sách vỏ bình nhập kho',
            realOnly: widget.model.readOnlyView,
          )
        ],
      ),
    );
  }
}
