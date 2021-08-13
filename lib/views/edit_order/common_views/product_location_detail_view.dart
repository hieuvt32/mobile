import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/edit_order/components/list_product_view.dart';
import 'package:frappe_app/views/edit_order/components/signature_view.dart';
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
  _buidChildExpansionItem(List<Product> products) {
    return ExpansionCustomPanel(
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
        }).toList());
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
        child: Column(
          children: [
            ExpansionCustomPanel(
                backgroundIconColor: hexToColor("#000000").withOpacity(0.1),
                backgroundBodyColor: hexToColor("#0072BC").withOpacity(0.3),
                items: [
                  ExpansionItem(true, (isExpanded) {
                    return Text(
                      "Danh sách sản phẩn",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  }, [
                    _buidChildExpansionItem(products),
                  ]),
                  ExpansionItem(true, (isExpanded) {
                    return Text(
                      "Ký xác nhận",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  }, [
                    SignatureView(),
                  ])
                ])
          ],
        ),
      ),
    );
  }
}
