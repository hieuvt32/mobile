import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DatePickerView extends StatelessWidget {
  final String reportName;
  final DateTime date;
  final bool onlyMonthPicker;
  final void Function(DateTime date) onSelectedDate;
  final BuildContext parentContext;

  DatePickerView(
      {required this.reportName,
      required this.date,
      required this.onlyMonthPicker,
      required this.onSelectedDate,
      required this.parentContext,
      Key? key})
      : super(key: key);

  onSelectDate() {
    if (onlyMonthPicker) {
      showMonthPicker(
        context: parentContext,
        firstDate: DateTime(DateTime.now().year - 1, 5),
        lastDate: DateTime.now(),
        initialDate: date,
        locale: Locale("vi"),
      ).then((date) {
        if (date != null) {
          onSelectedDate(date);
        }
      });

      return;
    }

    showDatePicker(
      context: parentContext,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime.now(),
      initialDate: date,
      locale: Locale("vi"),
    ).then((date) {
      if (date != null) {
        onSelectedDate(date);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectDate,
      child: Container(
        height: 48,
        padding: const EdgeInsets.only(left: 10, right: 8),
        decoration: BoxDecoration(
            border: Border.all(color: hexToColor("#0072BC").withOpacity(0.3)),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat(onlyMonthPicker ? 'MM/yy' : 'dd/MM/yyyy')
                .format(date)),
            Icon(Icons.arrow_drop_down_outlined),
          ],
        ),
      ),
    );
  }
}
