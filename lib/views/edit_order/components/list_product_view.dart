import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';

class ListProductView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  // final int type;
  ListProductView({Key? key}) : super(key: key);

  @override
  _ListProductViewState createState() => _ListProductViewState();
}

class _ListProductViewState extends State<ListProductView> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(8, 11, 8, 11),
          decoration: BoxDecoration(
              color: Color.fromRGBO(
                0,
                114,
                188,
                0.3,
              ),
              borderRadius: BorderRadius.circular(4)),
          child: Column(
            children: [
              ListProductItem(),
              SizedBox(
                height: 10,
              ),
              Visibility(
                child: Container(
                  width: double.infinity,
                  color: hexToColor('#F2F8FC'),
                  height: 40,
                  // onPressed: () {},
                  child: GestureDetector(
                    child: DottedBorder(
                      color: Color.fromRGBO(0, 114, 188, 0.3),
                      strokeWidth: 2,
                      // borderType: BorderType.Circle,
                      radius: Radius.circular(4),
                      child: Center(
                          child: Text(
                        'Thêm sản phẩm',
                        style: TextStyle(fontSize: 16),
                      )),
                    ),
                    onTap: () {
                      widget.model.addSanPham();
                    },
                  ),
                ),
                visible: !widget.model.readOnlyView,
              ),
            ],
          ),
        )
      ],
    );
    // return Container();
  }
}

class ListProductItem extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  ListProductItem({Key? key}) : super(key: key);

  @override
  _ListProductItemState createState() => _ListProductItemState();
}

class _ListProductItemState extends State<ListProductItem> {
  List<Product> values = [];
  List<Map<String, TextEditingController>> controllers = [];
  @override
  Widget build(BuildContext context) {
    var total = values.fold<int>(0, (sum, item) => sum + item.quantity);
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
    values = widget.model.products;
    controllers = widget.model.productEditControllers;

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
                        !isExpanded
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
                        // value: 'Sản phẩm: ',
                        fieldType: 0,
                        values: widget.model.nguyenVatLieuSanPhams
                            .map((e) =>
                                FieldValue(text: e.realName, value: e.name))
                            .toList(),
                        value: values[i].product,
                        selectionHandler: (value) {
                          var firstItem = widget.model.nguyenVatLieuSanPhams
                              .where((element) {
                                return element.realName == value;
                              })
                              .toList()
                              .first;
                          setState(() {
                            values[i].product = value;
                            values[i].unit = firstItem.unit;
                          });
                        },
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
                        // value: 'Sản phẩm: ',
                        fieldType: 0,
                        values: widget.model.nguyenVatLieuVatTus
                            .map((e) =>
                                FieldValue(text: e.realName, value: e.name))
                            .toList(),
                        value: values[i].material,
                        selectionHandler: (value) {
                          var firstItem = widget.model.nguyenVatLieuVatTus
                              .where((element) {
                                return element.realName == value;
                              })
                              .toList()
                              .first;
                          setState(() {
                            values[i].material = value;
                            values[i].unit = firstItem.unit;
                          });
                        },
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
                          // title: 'Đơn vị tính ',
                          controller: controllers[i]['kgController'],
                          fieldType: 1,
                          selectionHandler: (text) {
                            if ([
                              "",
                              null,
                              false,
                              0
                            ].contains(controllers[i]['kgController']!.text)) {
                              // do sth
                              values[i].kg = 0;
                            } else {
                              values[i].kg = double.parse(
                                  controllers[i]['kgController']!.text);
                            }
                            widget.model.changeState();
                          }),
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
                          // title: 'Đơn vị tính ',
                          controller: controllers[i]['quantityController'],
                          fieldType: 1,
                          selectionHandler: (text) {
                            if (["", null, false, 0].contains(
                                controllers[i]['quantityController']!.text)) {
                              // do sth
                              values[i].quantity = 0;
                            } else {
                              values[i].quantity = int.parse(
                                  controllers[i]['quantityController']!.text);
                            }
                            widget.model.changeState();
                          }),
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
              ]
                  // Icon(Icons.image) // iconPic
                  ),
            );
          },
        )
        .values
        .toList();

    return expansionItems;
  }
}
