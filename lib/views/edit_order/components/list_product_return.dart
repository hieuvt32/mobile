import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/danh_sach_nhap_kho.dart';
import 'package:frappe_app/model/don_nhap_kho.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';

class ListProductReturnView extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final String title;
  final int type;
  final bool realOnly;
  final String? address;

  ListProductReturnView(this.title,
      {Key? key, this.type = 0, this.realOnly = false, this.address})
      : super(key: key);

  @override
  _ListProductReturnViewState createState() => _ListProductReturnViewState();
}

class _ListProductReturnViewState extends State<ListProductReturnView> {
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
          ListProductReturnItem(
            type: widget.type,
            realOnly: widget.realOnly,
            address: widget.address,
          ),
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

class ListProductReturnItem extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final int type;
  final bool realOnly;
  final String? address;
  ListProductReturnItem(
      {Key? key, this.type = 0, this.realOnly = false, this.address})
      : super(key: key);

  @override
  _ListProductReturnItemState createState() => _ListProductReturnItemState();
}

class _ListProductReturnItemState extends State<ListProductReturnItem> {
  List<MapEntry<ProductReturnKey, List<Product>>> values = [];
  @override
  Widget build(BuildContext context) {
    var expansionItems = _buildExpansionItems();
    var total = values.fold<int>(0, (sum, item) => sum + item.key.total);
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
    Iterable<Product> filteredList = widget.model.productForLocations.where(
        (element) =>
            element.actualQuantity != null &&
            element.actualQuantity != 0 &&
            element.actualQuantity != element.quantity);
    print(widget.address);
    if (widget.address != null && widget.address!.length > 0) {
      //print(widget.address);
      filteredList =
          filteredList.where((element) => element.address == widget.address);
    }

    groupBy<Product, String>(filteredList, (obj) => obj.product!)
        .map((key, value) {
      var total = value.fold<int>(0, (sum, item) => sum + item.actualQuantity);
      values.add(MapEntry(ProductReturnKey(key, total, false), value));
      return MapEntry(key, value);
    });

    var expansionItems = values
        .asMap()
        .map(
          (i, e) {
            return MapEntry(
              i,
              ExpansionItem(e.key.isExpanded, // isExpanded ?
                  (isExpanded) {
                e.key.isExpanded = isExpanded;
                return Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${values[i].key.product != null ? values[i].key.product : 'Chọn sản phẩm'}, SL: ${values[i].key.total}',
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
                      child: FieldData(
                        value: '${values[i].key.product}',
                        fieldType: 3,
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
                      child: FieldData(
                        value: '${values[i].key.total}',
                        fieldType: 3,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: FieldData(
                        // value: 'Đơn vị tính: ${values[i].unit}',
                        value: 'Đơn vị tính: Bình',
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

class ProductReturnKey {
  String product;
  int total;
  bool isExpanded;
  ProductReturnKey(this.product, this.total, this.isExpanded);
}
