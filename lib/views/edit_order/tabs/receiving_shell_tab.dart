import 'package:flutter/material.dart';
import 'package:frappe_app/views/edit_order/components/list_shell.dart';

class ReceivingShellTab extends StatefulWidget {
  const ReceivingShellTab({Key? key}) : super(key: key);

  @override
  _ReceivingShellTabState createState() => _ReceivingShellTabState();
}

class _ReceivingShellTabState extends State<ReceivingShellTab> {
  @override
  Widget build(BuildContext context) {
    return ListShellView('Danh sách vỏ bình nhập kho');
  }
}
