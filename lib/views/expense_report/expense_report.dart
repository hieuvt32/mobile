import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';
import 'package:frappe_app/views/expense_report/components/simpleChart.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ExpenseReportView extends StatefulWidget {
  @override
  _ExpenseReportViewState createState() => _ExpenseReportViewState();
}

class _ExpenseReportViewState extends State<ExpenseReportView> {
  DateTime? _date;

  ExpansionItem buildOverviewReport(BuildContext context) {
    return ExpansionItem(
        true,
        (isExpanded) => Container(
              child: Text("Báo cáo tổng quan"),
            ),
        [
          Row(
            children: [
              SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Báo cáo chi tiêu",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Text(DateFormat('MM/yyyy').format(_date ?? DateTime.now())),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down_outlined),
                onPressed: () async {
                  showMonthPicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 1, 5),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    locale: Locale("vi"),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        _date = date;
                      });
                    }
                  });
                },
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 180,
            child: SimpleTimeSeriesChart(
              [
                new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
                new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
                new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
                new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
              ],
              animate: true,
            ),
          ),
          buildColumnInfo("Tổng số đơn hàng", "50", "#000000"),
          buildColumnInfo("Tổng tiền hàng", "52.000.000", "#00478B"),
          buildColumnInfo("Tổng tiền đã trả", "30.000.000", "#1BBD5C"),
          buildColumnInfo("Tổng tiền còn nợ", "22.000.000", "#FF0F00"),
          SizedBox(
            height: 24,
          )
        ]);
  }

  Widget buildColumnInfo(String textLeft, String textRight, String colorText) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 2,
              child: Text(
                textLeft,
              )),
          Expanded(
              flex: 1,
              child: Text(
                textRight,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: hexToColor(colorText)),
              ))
        ],
      ),
    );
  }

  ExpansionItem buildDetailReport() {
    return ExpansionItem(
        false,
        (isExpanded) => Container(
              child: Text("Báo cáo chi tiết"),
            ),
        [
          DataTable(columns: const <DataColumn>[
            DataColumn(label: Text("data"))
          ], rows: <DataRow>[
            DataRow(cells: <DataCell>[
              DataCell(Text('William')),
            ])
          ])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Báo cáo chi tiêu")),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ExpansionCustomPanel(
              items: [buildOverviewReport(context), buildDetailReport()],
              backgroundBodyColor: Colors.white,
              backgroundTitleColor: hexToColor('#F2F8FC'),
              backgroundIconColor: hexToColor("#000000").withOpacity(0.18),
            )));
  }
}
