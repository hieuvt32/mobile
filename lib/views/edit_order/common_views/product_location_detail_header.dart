import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';
import 'package:frappe_app/views/edit_order/common_views/edit_order_viewmodel.dart';

class ProductLocationDetailHeader extends StatelessWidget {
  final String address;

  ProductLocationDetailHeader({required this.address});

  @override
  Widget build(BuildContext context) {
    return BaseView<EditOrderViewModel>(builder: (context, modal, child) {
      final int totalNhapKho = modal.nhapKhos
          .where((element) => element.address == this.address)
          .toList()
          .fold<int>(
              0, (currentTotal, element) => currentTotal + element.amount);

      final int totalTraVe = modal.traVes
          .where((element) => element.address == this.address)
          .toList()
          .fold<int>(
              0, (currentTotal, element) => currentTotal + element.amount);

      return Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng xe về',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$totalNhapKho',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sản phảm trả về ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$totalTraVe',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vỏ nhập',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$totalNhapKho',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vỏ trả khách ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$totalTraVe',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng nhập ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 0.65),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${totalNhapKho - totalTraVe}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: hexToColor('#FF2D1F'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
