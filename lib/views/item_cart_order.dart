import 'package:flutter/material.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/widgets/limit_text_length.dart';

class ItemCardOrder extends StatelessWidget {
  ItemCardOrder(
      {required this.cartContent,
      required this.leftHeaderText,
      required this.rightHeaderText});

  final String leftHeaderText;
  final String rightHeaderText;
  final Widget cartContent;

  Color getColorByType(int type) {
    switch (type) {
      case 0:
        return hexToColor('#0072BC');
      case 1:
        return hexToColor('#FF0F00');
      default:
        return hexToColor('#1BBD5C');
    }
  }

  Widget buildLimitTextLength(String content) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      strutStyle: StrutStyle(fontSize: 10.0),
      text: TextSpan(
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          text: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: hexToColor("#B3D5EB"),
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)),
                  color: getColorByType(0)),
              padding: const EdgeInsets.only(left: 12, right: 12),
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(this.leftHeaderText,
                      style: TextStyle(
                          color: hexToColor("#14142B"),
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  Text(this.rightHeaderText,
                      style: TextStyle(
                          color: hexToColor("#14142B"),
                          fontWeight: FontWeight.bold,
                          fontSize: 14))
                ],
              ),
            ),
            this.cartContent
          ],
        ));
  }
}
