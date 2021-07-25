import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';

class ListProductLocationView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  ListProductLocationView({Key? key}) : super(key: key);

  @override
  _ListProductLocationViewState createState() =>
      _ListProductLocationViewState();
}

class _ListProductLocationViewState extends State<ListProductLocationView> {
  bool isParentExpanded = false;

  late Timer _debounce;

  @override
  void initState() {
    _debounce = Timer(const Duration(milliseconds: 0), () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionItem> headers = _buildExpansionItems();

    return ExpansionCustomPanel(
      items: headers,
      backgroundBodyColor: Color.fromRGBO(0, 114, 188, 0.3),
      backgroundTitleColor: Colors.white,
      backgroundIconColor: Color.fromRGBO(0, 0, 0, 0.1),
    );
    // return Container();
  }

  @override
  void dispose() {
    if (_debounce != null) _debounce.cancel();
    super.dispose();
  }

  Future updateAddress(text, i) async {
    if (["", null, false, 0].contains(widget.model.customerValue)) {
      FrappeAlert.errorAlert(
          title: 'Lỗi xảy ra',
          context: context,
          subtitle: 'Xin hãy chọn một khách hàng');
      return;
    }

    if (["", null, false, 0].contains(widget.model.editAddresses[i].name)) {
      var response = await locator<Api>().updateDeliveryAddress(
        text,
        widget.model.customerValue as String,
        null,
      );
      widget.model.editAddresses[i].name =
          response != null && response.address != null
              ? response.address.name
              : "";

      widget.model.editAddresses[i].diaChi = text;
      widget.model.editAddresses[i].isEnable = true;
      widget.model.changeState();
    } else {
      var response = await locator<Api>().updateDeliveryAddress(
        text,
        widget.model.customerValue as String,
        widget.model.editAddresses[i].name,
      );
      widget.model.editAddresses[i].name =
          response != null && response.address != null
              ? response.address.name
              : "";
      widget.model.editAddresses[i].diaChi = text;
      widget.model.editAddresses[i].isEnable = true;
      widget.model.changeState();
    }
  }

  List<ExpansionItem> _buildExpansionItems() {
    var values = widget.model.editAddresses;
    var expansionItems = values.asMap().map(
          (i, e) => MapEntry(
            i,
            ExpansionItem(
              isParentExpanded, // isExpanded ?
              (isExpanded) {
                isParentExpanded = isExpanded;
                return Container(
                  // padding: EdgeInsets.zero,
                  // child: Center(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         widget.title,
                  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  //         textAlign: TextAlign.left,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: isExpanded
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  'Địa chỉ: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                flex: 2,
                              ),
                              // SizedBox(
                              //   width: 28,
                              // ),
                              Expanded(
                                child: values[i].isEditable
                                    ? FieldData(
                                        // value: 'Sản phẩm: ',
                                        fieldType: 0,
                                        values: widget.model.addresses
                                            .map((e) => FieldValue(
                                                text: e.diaChi, value: e.name!))
                                            .toList(),
                                        value: values[i].name,
                                        selectionHandler: (value) {
                                          setState(() {
                                            values[i].name = value;
                                          });
                                        },
                                      )
                                    : FieldData(
                                        // title: 'Đơn vị tính ',
                                        controller: TextEditingController(
                                            text: values[i].diaChi),
                                        //     ['kgController'],
                                        fieldType: 1,
                                        // haveTextChange: false,
                                        keyboardType: TextInputType.text,
                                        selectionHandler: (text) async {
                                          if (_debounce != null &&
                                              _debounce.isActive)
                                            _debounce.cancel();
                                          _debounce = Timer(
                                              const Duration(milliseconds: 600),
                                              () async {
                                            // do something with query
                                            await updateAddress(text, i);
                                          });
                                        },
                                      ),
                                flex: 8,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.model.editAddresses[i].isEditable =
                                          false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Opacity(
                                        opacity: !widget.model.editAddresses[i]
                                                .isEditable
                                            ? 0
                                            : 1,
                                        child: FrappeIcon(
                                          FrappeIcons.add_no_border,
                                          color: Color.fromRGBO(0, 0, 0, 0.5),
                                          size: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                flex: 1,
                              )
                            ],
                          )
                        : Text('${widget.model.editAddresses[i].diaChi}'),
                  ),
                );
              },
              [
                ListProductLocationItemView(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: hexToColor('#0072BC'),
                        // side: BorderSide(
                        //   width: 1.0,
                        // ),

                        minimumSize: Size(120, 32),
                        // padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          // side: BorderSide(
                          //   color: hexToColor('#FF0F00'),
                          // ),
                        ),
                      ),
                      onPressed: () {
                        if (!["", null, false, 0]
                            .contains(widget.model.editAddresses[i].name))
                          widget.model.addSanPhamByLocation(
                              widget.model.editAddresses[i].name!);
                      },
                      child: Text(
                        'Thêm sản phẩm',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 23,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: hexToColor('#FF0F00'),
                        // side: BorderSide(
                        //   width: 1.0,
                        // ),
                        minimumSize: Size(120, 32),
                        // padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          // side: BorderSide(
                          //   color: hexToColor('#0072BC'),
                          // ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Xóa địa chỉ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
              // Icon(Icons.image) // iconPic
            ),
          ),
        );

    return expansionItems.values.toList();
  }
}

class ListProductLocationItemView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  ListProductLocationItemView({Key? key}) : super(key: key);

  @override
  _ListProductLocationItemViewState createState() =>
      _ListProductLocationItemViewState();
}

class _ListProductLocationItemViewState
    extends State<ListProductLocationItemView> {
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
