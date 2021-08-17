import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/common_views/product_location_detail_header.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/edit_order/components/list_product_return.dart';
import 'package:frappe_app/views/edit_order/components/list_product_view.dart';
import 'package:frappe_app/views/edit_order/components/list_shell_view.dart';
import 'package:frappe_app/views/edit_order/components/signature_view.dart';
import 'package:frappe_app/views/edit_order/tabs/receiving_shell_delivered_tab.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';

class ProductLocationDetailView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final String address;

  ProductLocationDetailView({
    required this.address,
    Key? key,
  }) : super(key: key);

  @override
  _ProductLocationDetailViewState createState() =>
      _ProductLocationDetailViewState();
}

class _ProductLocationDetailViewState extends State<ProductLocationDetailView> {
  _buildExpansionView(List<Product> products) {
    return ExpansionCustomPanel(
        backgroundIconColor: hexToColor("#000000").withOpacity(0.1),
        backgroundBodyColor: hexToColor("#0072BC").withOpacity(0.3),
        items: [
          ExpansionItem(true, (isExpanded) {
            return Text(
              "Danh sách sản phẩn",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          }, [
            ExpansionCustomPanel(
                backgroundTitleColor: hexToColor("#F2F8FC"),
                items: products.map((value) {
                  return ExpansionItem(
                    true,
                    (isExpanded) {
                      return Text(products[0].product ?? "");
                    },
                    [
                      Row(
                        children: [
                          Expanded(
                            child: FieldData(
                              value: 'Vật tư: ',
                              fieldType: 3,
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            flex: 2,
                            child: FieldData(
                              fieldType: 3,
                              value: '${value.material}',
                            ),
                          ),
                          Expanded(
                            child: FieldData(
                              value: 'Kg:',
                              fieldType: 3,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: FieldData(
                              fieldType: 3,
                              value: '${value.kg}',
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FieldData(
                              value: 'Số lượng: ',
                              fieldType: 3,
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: FieldData(
                              fieldType: 3,
                              value: '${value.quantity}',
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: FieldData(
                              value: 'Đơn vị tính: ${value.unit}',
                              fieldType: 3,
                            ),
                            flex: 3,
                          ),
                        ],
                      )
                    ],
                  );
                }).toList()),
          ]),
          ExpansionItem(true, (isExpanded) {
            return Text(
              "Ký xác nhận",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          }, [
            SignatureView(),
          ])
        ]);
  }

  _buildProductLocationDetailView() {
    return Column(
      children: [
        ProductLocationDetailHeader(totalNhapKho: 0, totalTraVe: 0),
        ListProductReturnView(
          'Danh sách hoàn trả',
          realOnly: true,
        ),
        ListShellView(
          'Danh sách vỏ bình nhập kho',
          realOnly: true,
        ),
        ListShellView(
          'Danh sách vỏ bình trả lại khách',
          type: 1,
          realOnly: true,
        ),
      ],
    );
  }

  _buildMainView(List<Product> list) {
    if (OrderState.Delivered == widget.model.orderState) {
      return _buildProductLocationDetailView();
    } else if (OrderState.Delivering == widget.model.orderState) {
      return _buildExpansionView(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = widget.model.order!.products
        .where((p) => p.address == widget.address)
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(products[0].diaChi),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _buildMainView(products)));
  }
}
