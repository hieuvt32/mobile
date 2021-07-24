import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/edit_order/components/list_shell_view.dart';
import 'package:frappe_app/views/edit_order/edit_order_viewmodel.dart';

class ReceivingShellTab extends StatefulWidget {
  final EditOrderViewModel model = locator<EditOrderViewModel>();
  ReceivingShellTab({Key? key}) : super(key: key);

  @override
  _ReceivingShellTabState createState() => _ReceivingShellTabState();
}

class _ReceivingShellTabState extends State<ReceivingShellTab> {
  @override
  Widget build(BuildContext context) {
    var totalNhapKho =
        widget.model.nhapKhos.fold<int>(0, (sum, item) => sum + item.amount);
    var totalTraVe =
        widget.model.traVes.fold<int>(0, (sum, item) => sum + item.amount);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(36.0, 0, 24.0, 0),
            child: Row(
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
          ),
          ListShellView(
            'Danh sách vỏ bình nhập kho',
          ),
          ListShellView(
            'Danh sách vỏ bình trả lại khách',
            type: 1,
          ),
        ],
      ),
    );
  }
}
