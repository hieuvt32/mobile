import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DropDownButtonView extends StatelessWidget {
  final String? selectedItem;
  final List<String> data;
  final void Function(String? seletedValue) onSelectItem;
  final String hintText;

  const DropDownButtonView(
      {Key? key,
      this.selectedItem,
      required this.data,
      required this.onSelectItem,
      this.hintText = "Chọn"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: hexToColor("#0072BC").withOpacity(0.3)),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 48,
      child: DropdownButtonFormField<String>(
        style: TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 14),
            contentPadding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            border: InputBorder.none,
            hintText: hintText),
        value: selectedItem,
        onChanged: onSelectItem,
        items: data.map((e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          );
        }).toList(),
      ),
    );
  }
}
