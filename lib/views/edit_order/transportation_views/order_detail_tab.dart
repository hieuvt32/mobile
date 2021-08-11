import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/components/list_product_view.dart';
import 'package:frappe_app/views/edit_order/components/list_shell_view.dart';
import 'package:frappe_app/views/edit_order/transportation_views/transportation_detail.dart';

import 'transportation_product_list.dart';

class OrderDetailTab extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final TransportationKey address;
  OrderDetailTab({Key? key, required this.address}) : super(key: key);

  @override
  _OrderDetailTabState createState() => _OrderDetailTabState();
}

class _OrderDetailTabState extends State<OrderDetailTab> {
  @override
  Widget build(BuildContext context) {
    var giaoViewSig =
        widget.model.getGiaoViecSignatureByAddress(widget.address.address);
    return SingleChildScrollView(
      child: Column(
        children: [
          TransportationProductList(
            "Danh sách sản phẩm",
            realOnly:
                giaoViewSig != null && giaoViewSig.status == "Đã giao hàng",
          ),
          ListShellView(
            'Danh sách vỏ bình nhập kho',
            realOnly:
                giaoViewSig != null && giaoViewSig.status == "Đã giao hàng",
          )
        ],
      ),
    );
  }
}
