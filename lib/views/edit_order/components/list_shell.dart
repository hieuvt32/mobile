import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/don_nhap_kho.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/field_data.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';

class ListShellView extends StatefulWidget {
  final String title;
  const ListShellView(this.title, {Key? key}) : super(key: key);

  @override
  _ListShellViewState createState() => _ListShellViewState();
}

class _ListShellViewState extends State<ListShellView> {
  @override
  Widget build(BuildContext context) {
    List<ExpansionItem> headers = <ExpansionItem>[
      ExpansionItem(
        false, // isExpanded ?
        (isExpanded) => Container(
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
        ),
        [
          Text(
            'SL: 60',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          ListShellItem(),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            color: hexToColor('#F2F8FC'),
            height: 40,
            // onPressed: () {},
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
            // style: ElevatedButton.styleFrom(
            //   primary: hexToColor('#F2F8FC'),
            //   // shape: RoundedRectangleBorder(
            //   //   borderRadius: BorderRadius.circular(4.0),
            //   //   // side: BorderSide(
            //   //   //   color: Color.fromRGBO(0, 114, 188, 0.3),
            //   //   //   style: BorderStyle.
            //   //   // ),
            //   // ),
            // ),
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
      padding: EdgeInsets.all(10),
    );
    // return Container();
  }
}

class ListShellItem extends StatefulWidget {
  final List<int> donNhapKhos = [1, 2, 3, 4, 5, 6];
  ListShellItem({Key? key}) : super(key: key);

  @override
  _ListShellItemState createState() => _ListShellItemState();
}

class _ListShellItemState extends State<ListShellItem> {
  @override
  Widget build(BuildContext context) {
    var expansionItems = widget.donNhapKhos.map((e) {
      return ExpansionItem(
          false, // isExpanded ?
          (isExpanded) => Container(
                padding: EdgeInsets.only(right: 11),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Oxi lỏng, SL: 30',
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
                            )
                    ],
                  ),
                ),
              ),
          [
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
                    // title: 'Đơn vị tính ',
                    fieldType: 1,
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: FieldData(
                    value: 'Đơn vị tính: Bình',
                    fieldType: 3,
                  ),
                  flex: 3,
                ),
              ],
            )
          ]
          // Icon(Icons.image) // iconPic
          );
    }).toList();

    return ExpansionCustomPanel(
      items: expansionItems,
      backgroundBodyColor: Colors.white,
      backgroundTitleColor: hexToColor('#F2F8FC'),
    );
  }
}
