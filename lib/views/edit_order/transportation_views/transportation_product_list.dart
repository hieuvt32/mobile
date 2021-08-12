import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';

import '../../expansion_custom_panel.dart';
import 'product_view.dart';

class TransportationProductList extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  final String title;
  final int type;
  final bool realOnly;
  TransportationProductList(
    this.title, {
    Key? key,
    this.type = 0,
    this.realOnly = false,
  }) : super(key: key);

  @override
  _TransportationProductListState createState() =>
      _TransportationProductListState();
}

class _TransportationProductListState extends State<TransportationProductList> {
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
          ProductView(
            isReadOnly: widget.realOnly,
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
  }
}
