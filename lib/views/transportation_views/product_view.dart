import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';

class ProductView extends StatefulWidget {
  final bool isReadOnly;
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  ProductView({
    Key? key,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          // padding: EdgeInsets.fromLTRB(8, 11, 8, 11),
          // decoration: BoxDecoration(
          //     color: Color.fromRGBO(
          //       0,
          //       114,
          //       188,
          //       0.3,
          //     ),
          //     borderRadius: BorderRadius.circular(4)),
          child: Column(
            children: [
              ProductItem(
                isReadOnly: widget.isReadOnly,
              ),
            ],
          ),
        )
      ],
    );
    // return Container();
  }
}

class ProductItem extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final bool isReadOnly;
  ProductItem({
    Key? key,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  List<Product> values = [];
  List<Map<String, TextEditingController>> controllers = [];
  @override
  Widget build(BuildContext context) {
    var total = values.fold<int>(0, (sum, item) => sum + item.actualQuantity);
    var expansionItems = _buildExpansionItems();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SL: $total',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        ExpansionCustomPanel(
          items: expansionItems,
          backgroundBodyColor: Colors.white,
          backgroundTitleColor: hexToColor('#F2F8FC'),
        ),
      ],
    );
  }

  List<ExpansionItem> _buildExpansionItems() {
    values = widget.model.productForLocations;
    controllers = widget.model.productForLocationEditControllers;

    var expansionItems = values
        .asMap()
        .map(
          (i, e) {
            return MapEntry(
              i,
              ExpansionItem(e.isExpanded, (isExpanded) {
                e.isExpanded = isExpanded;
                return Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${values[i].product != null ? values[i].product : 'Chọn sản phẩm'}, SL: ${values[i].quantity}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Visibility(
                          child: !isExpanded
                              ? GestureDetector(
                                  child: FrappeIcon(
                                    FrappeIcons.delete,
                                    size: 16,
                                  ),
                                  onTap: () {},
                                )
                              : Row(
                                  children: [
                                    GestureDetector(
                                      child: FrappeIcon(
                                        FrappeIcons.check,
                                        size: 16,
                                      ),
                                      onTap: () {},
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                      child: FrappeIcon(
                                        FrappeIcons.close_x,
                                        size: 16,
                                      ),
                                      onTap: () {},
                                    )
                                  ],
                                ),
                          visible: !widget.isReadOnly,
                        )
                      ],
                    ),
                  ),
                );
              }, [
                Row(
                  children: [
                    Expanded(
                      child: FieldData(
                        value: 'Sản phẩm: ',
                        fieldType: 3,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      flex: 5,
                      child: FieldData(
                        value: values[i].product,
                        fieldType: 3,
                      ),
                    )
                  ],
                ),
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
                        value: values[i].material ?? '',
                        fieldType: 3,
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
                      child: Row(
                        children: [
                          Expanded(
                            child: !widget.isReadOnly
                                ? FieldData(
                                    // title: 'Đơn vị tính ',
                                    // enabled: false,
                                    controller: controllers[i]['kgController'],
                                    fieldType: 1,
                                    selectionHandler: (text) {
                                      if (["", null, false, 0].contains(
                                          controllers[i]['kgController']!
                                              .text)) {
                                        // do sth
                                        values[i].actualKg = 0;
                                      } else {
                                        values[i].actualKg = double.parse(
                                            controllers[i]['kgController']!
                                                .text);
                                      }
                                      widget.model.changeState();
                                    })
                                : FieldData(
                                    value: '${values[i].actualKg}',
                                    fieldType: 3,
                                  ),
                            flex: 5,
                          ),
                          Expanded(
                            child: FieldData(
                              value: '/',
                              fieldType: 3,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: FieldData(
                              value: '${values[i].kg}',
                              fieldType: 3,
                            ),
                            flex: 4,
                          )
                        ],
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
                      child: Row(
                        children: [
                          Expanded(
                            child: !widget.isReadOnly
                                ? FieldData(
                                    // title: 'Đơn vị tính ',
                                    controller: controllers[i]
                                        ['quantityController'],
                                    fieldType: 1,
                                    selectionHandler: (text) {
                                      if (["", null, false, 0].contains(
                                          controllers[i]['quantityController']!
                                              .text)) {
                                        // do sth
                                        values[i].actualQuantity = 0;
                                      } else {
                                        values[i].actualQuantity = int.parse(
                                            controllers[i]
                                                    ['quantityController']!
                                                .text);
                                      }
                                      widget.model.changeState();
                                    },
                                  )
                                : FieldData(
                                    value: '${values[i].actualQuantity}',
                                    fieldType: 3,
                                  ),
                            flex: 5,
                          ),
                          Expanded(
                            child: FieldData(
                              value: '/',
                              fieldType: 3,
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: FieldData(
                              value: '${values[i].quantity}',
                              fieldType: 3,
                            ),
                            flex: 4,
                          )
                        ],
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: FieldData(
                        value: 'Đơn vị tính: ${values[i].unit}',
                        fieldType: 3,
                      ),
                      flex: 3,
                    ),
                  ],
                )
              ]),
            );
          },
        )
        .values
        .toList();

    return expansionItems;
  }
}
