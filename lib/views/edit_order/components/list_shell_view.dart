import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/danh_sach_nhap_kho.dart';
import 'package:frappe_app/model/don_nhap_kho.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';

class ListShellView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final String title;
  final int type;
  final bool realOnly;
  ListShellView(
    this.title, {
    Key? key,
    this.type = 0,
    this.realOnly = false,
  }) : super(key: key);

  @override
  _ListShellViewState createState() => _ListShellViewState();
}

class _ListShellViewState extends State<ListShellView> {
  bool isParentExpanded = false;
  @override
  Widget build(BuildContext context) {
    List<ExpansionItem> headers = <ExpansionItem>[
      ExpansionItem(
        isParentExpanded, // isExpanded ?
        (isExpanded) {
          isParentExpanded = isExpanded;
          return Container(
            padding: EdgeInsets.zero,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          );
        },
        [
          ListShellItem(
            type: widget.type,
            realOnly: widget.realOnly,
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
                    'Thêm vật tư',
                    style: TextStyle(fontSize: 16),
                  )),
                ),
                onTap: () {
                  switch (widget.type) {
                    case 0:
                      widget.model.addNhapKho();
                      break;
                    case 1:
                      widget.model.addTraVe();
                      break;
                    default:
                  }
                },
              ),
            ),
            visible: !widget.realOnly,
          )
        ],
        // Icon(Icons.image) // iconPic
      ),
    ];

    return ExpansionCustomPanel(
      items: headers,
      backgroundBodyColor: Color.fromRGBO(0, 114, 188, 0.3),
      backgroundTitleColor: Colors.white,
      backgroundIconColor: Color.fromRGBO(0, 0, 0, 0.1),
    );
    // return Container();
  }
}

class ListShellItem extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final int type;
  final bool realOnly;
  ListShellItem({
    Key? key,
    this.type = 0,
    this.realOnly = false,
  }) : super(key: key);

  @override
  _ListShellItemState createState() => _ListShellItemState();
}

class _ListShellItemState extends State<ListShellItem> {
  List<DanhSachNhapKho> values = [];
  List<Map<String, TextEditingController>> controllers = [];
  @override
  Widget build(BuildContext context) {
    var expansionItems = _buildExpansionItems();
    var total = values.fold<int>(0, (sum, item) => sum + item.amount);
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
    switch (widget.type) {
      case 0:
        values = widget.model.nhapKhos;
        controllers = widget.model.donNhapKhoEditControllers;
        break;
      case 1:
        values = widget.model.traVes;
        controllers = widget.model.donTraVeEditControllers;
        break;
      case 2:
        values = widget.model.traVes;
        controllers = widget.model.donTraVeEditControllers;
        break;
      default:
    }

    var expansionItems = values
        .asMap()
        .map(
          (i, e) {
            return MapEntry(
              i,
              ExpansionItem(e.isExpanded, // isExpanded ?
                  (isExpanded) {
                e.isExpanded = isExpanded;
                return Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${values[i].realName != null ? values[i].realName : 'Chọn vỏ bình'}, SL: ${values[i].amount}',
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
                                          if (values[i].realName == null ||
                                              values[i].realName!.isEmpty) {
                                            values[i]
                                                .validator
                                                .isMaterialRequired = true;
                                          } else {
                                            values[i]
                                                .validator
                                                .isMaterialRequired = false;
                                          }

                                          if (values[i].amount <= 0) {
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
                                          values[i].realName = null;
                                          values[i].amount = 0;
                                          values[i].unit = '';
                                          widget.model.changeState();
                                        },
                                      )
                                    ],
                                  ),
                            visible: !widget.model.readOnlyView)
                      ],
                    ),
                  ),
                );
              }, [
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
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !widget.realOnly
                              ? FieldData(
                                  // value: 'Sản phẩm: ',
                                  fieldType: 0,
                                  values: widget.model.nguyenVatLieuVatTus
                                      .map((e) => FieldValue(
                                          text: e.realName, value: e.name))
                                      .toList(),
                                  value: values[i].realName,
                                  selectionHandler: (value) {
                                    var firstItem =
                                        widget.model.nguyenVatLieuVatTus
                                            .where((element) {
                                              return element.realName == value;
                                            })
                                            .toList()
                                            .first;
                                    setState(() {
                                      values[i].realName = value;
                                      values[i].unit = firstItem.unit;
                                      values[i].validator.isMaterialRequired =
                                          false;
                                    });
                                  },
                                )
                              : FieldData(
                                  value: '${values[i].realName}',
                                  fieldType: 3,
                                ),
                          Visibility(
                              visible: values[i].validator.isMaterialRequired,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Chọn vật tư",
                                  style: TextStyle(
                                      color: Colors.redAccent.shade700,
                                      fontSize: 12.0),
                                ),
                              ))
                        ],
                      ),
                    )
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !widget.realOnly
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
                                      values[i].amount = 0;
                                    } else {
                                      values[i].amount = int.parse(
                                          controllers[i]['quantityController']!
                                              .text);
                                      values[i].validator.isQuantityRequired =
                                          false;
                                    }
                                    widget.model.changeState();
                                  })
                              : FieldData(
                                  value: '${values[i].amount}',
                                  fieldType: 3,
                                ),
                          Visibility(
                              visible: values[i].validator.isQuantityRequired,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Chọn sản phẩm",
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
