import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';

class ListProductView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final bool isNhaCungCap;
  // final int type;
  ListProductView({
    Key? key,
    this.isNhaCungCap = false,
  }) : super(key: key);

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
              ListProductItem(
                isNhaCungCap: widget.isNhaCungCap,
              ),
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
                visible: !widget.model.readOnlyView && !widget.isNhaCungCap,
              ),
              Visibility(
                child: ElevatedButton(
                  child: Text(
                    'Thêm sản phẩm',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    widget.model.addSanPham();
                  },
                ),
                visible: !widget.model.readOnlyView && widget.isNhaCungCap,
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

  final bool isNhaCungCap;
  ListProductItem({
    Key? key,
    this.isNhaCungCap = false,
  }) : super(key: key);

  @override
  _ListProductItemState createState() => _ListProductItemState();
}

class _ListProductItemState extends State<ListProductItem> {
  List<Product> values = [];
  List<Map<String, TextEditingController>> controllers = [];
  @override
  Widget build(BuildContext context) {
    var expansionItems = _buildExpansionItems();
    var total = values.fold<int>(0, (sum, item) => sum + item.quantity);
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
                        Visibility(
                          child: !isExpanded
                              ? GestureDetector(
                                  child: FrappeIcon(
                                    FrappeIcons.delete,
                                    size: 16,
                                  ),
                                  onTap: () {
                                    values.removeAt(i);
                                    widget.model.changeState();
                                  },
                                )
                              : Row(
                                  children: [
                                    GestureDetector(
                                      child: FrappeIcon(
                                        FrappeIcons.check,
                                        size: 16,
                                      ),
                                      onTap: () {
                                        if (values[i].product == null ||
                                            values[i].product!.isEmpty) {
                                          values[i]
                                              .validator
                                              .isProductRequired = true;
                                        } else {
                                          values[i]
                                              .validator
                                              .isProductRequired = false;
                                        }

                                        if ((values[i].material == null ||
                                                values[i].material!.isEmpty) &&
                                            values[i].enabledVatTu) {
                                          values[i]
                                              .validator
                                              .isMaterialRequired = true;
                                        } else {
                                          values[i]
                                              .validator
                                              .isMaterialRequired = false;
                                        }

                                        if (values[i].kg <= 0 &&
                                            values[i].enabledKG) {
                                          values[i].validator.isKgRequired =
                                              true;
                                        } else {
                                          values[i].validator.isKgRequired =
                                              false;
                                        }

                                        if (values[i].quantity <= 0) {
                                          values[i]
                                              .validator
                                              .isQuantityRequired = true;
                                        } else {
                                          values[i]
                                              .validator
                                              .isQuantityRequired = false;
                                        }

                                        widget.model.changeState();
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                      child: FrappeIcon(
                                        FrappeIcons.close_x,
                                        size: 16,
                                      ),
                                      onTap: () {
                                        values[i].product = null;
                                        values[i].material = null;
                                        values[i].unit = '';
                                        values[i].quantity = 0;
                                        values[i].kg = 0;
                                        controllers[i]['quantityController']!
                                            .text = "";
                                        controllers[i]['kgController']!.text =
                                            "";
                                        widget.model.changeState();
                                      },
                                    )
                                  ],
                                ),
                          visible: !widget.model.readOnlyView,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            !widget.model.readOnlyView
                                ? FieldData(
                                    // value: 'Sản phẩm: ',
                                    fieldType: 0,
                                    values: widget.model.nguyenVatLieuSanPhams
                                        .map((e) => FieldValue(
                                            text: e.realName, value: e.name))
                                        .toList(),
                                    value: values[i].product,
                                    selectionHandler: (value) {
                                      var firstItem = widget
                                          .model.nguyenVatLieuSanPhams
                                          .where((element) {
                                            return element.realName == value;
                                          })
                                          .toList()
                                          .first;
                                      setState(() {
                                        values[i].product = value;
                                        values[i].unit = firstItem.unit;
                                        values[i].enabledVatTu =
                                            firstItem.type != "Vật tư";
                                        values[i].enabledKG =
                                            firstItem.unit == "Kg";
                                        values[i].validator.isProductRequired =
                                            false;
                                      });
                                    },
                                  )
                                : FieldData(
                                    value: values[i].product,
                                    fieldType: 3,
                                  ),
                            Visibility(
                                visible: values[i].validator.isProductRequired,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Chọn sản phẩm",
                                    style: TextStyle(
                                        color: Colors.redAccent.shade700,
                                        fontSize: 12.0),
                                  ),
                                ))
                          ],
                        ))
                  ],
                ),
                Visibility(
                    child: Row(
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
                          child: Column(
                            children: [
                              !widget.model.readOnlyView
                                  ? FieldData(
                                      // value: 'Sản phẩm: ',
                                      enabled: values[i].enabledVatTu,
                                      fieldType: 0,
                                      values: widget.model.nguyenVatLieuVatTus
                                          .map((e) => FieldValue(
                                              text: e.realName, value: e.name))
                                          .toList(),
                                      value: values[i].material,
                                      selectionHandler: (value) {
                                        var firstItem = widget
                                            .model.nguyenVatLieuVatTus
                                            .where((element) {
                                              return element.realName == value;
                                            })
                                            .toList()
                                            .first;
                                        setState(() {
                                          values[i].material = value;
                                          values[i].unit = firstItem.unit;
                                          values[i].enabledKG =
                                              firstItem.unit == "Kg";
                                          values[i]
                                              .validator
                                              .isMaterialRequired = false;
                                        });
                                      },
                                    )
                                  : FieldData(
                                      value: values[i].material ?? "",
                                      fieldType: 3,
                                    ),
                              Visibility(
                                  visible:
                                      values[i].validator.isMaterialRequired,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Chọn vật tư",
                                      style: TextStyle(
                                          color: Colors.redAccent.shade700,
                                          fontSize: 12.0),
                                    ),
                                  ))
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: Column(
                            children: [
                              !widget.model.readOnlyView
                                  ? FieldData(
                                      // title: 'Đơn vị tính ',
                                      errorText:
                                          values[i].validator.isKgRequired
                                              ? "Nhập Kg"
                                              : null,
                                      enabled: false,
                                      controller: controllers[i]
                                          ['kgController'],
                                      fieldType: 1,
                                      selectionHandler: (text) {
                                        if (["", null, false, 0].contains(
                                            controllers[i]['kgController']!
                                                .text)) {
                                          // do sth
                                          values[i].kg = 0;
                                        } else {
                                          values[i].kg = double.parse(
                                              controllers[i]['kgController']!
                                                  .text);

                                          values[i].validator.isKgRequired =
                                              false;
                                        }
                                        widget.model.changeState();
                                      })
                                  : FieldData(
                                      value: '${values[i].kg}',
                                      fieldType: 3,
                                    ),
                              Visibility(
                                  visible: values[i].validator.isKgRequired,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Nhập kg",
                                      style: TextStyle(
                                          color: Colors.redAccent.shade700,
                                          fontSize: 12.0),
                                    ),
                                  ))
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                    visible: !widget.isNhaCungCap),
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
                      child: Column(
                        children: [
                          !widget.model.readOnlyView
                              ? FieldData(
                                  // errorText: values[i].validator.isQuantityRequired
                                  //     ? "Nhập só lượng"
                                  //     : null,
                                  // title: 'Đơn vị tính ',
                                  controller: controllers[i]
                                      ['quantityController'],
                                  fieldType: 1,
                                  selectionHandler: (text) {
                                    if (["", null, false, 0].contains(
                                        controllers[i]['quantityController']!
                                            .text)) {
                                      // do sth
                                      values[i].quantity = 0;
                                    } else {
                                      values[i].quantity = int.parse(
                                          controllers[i]['quantityController']!
                                              .text);
                                      values[i].validator.isQuantityRequired =
                                          false;
                                    }
                                    widget.model.changeState();
                                  })
                              : FieldData(
                                  value: '${values[i].quantity}',
                                  fieldType: 3,
                                ),
                          Visibility(
                              visible: values[i].validator.isQuantityRequired,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "Nhập số lượng",
                                  style: TextStyle(
                                      color: Colors.redAccent.shade700,
                                      fontSize: 12.0),
                                ),
                              ))
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
