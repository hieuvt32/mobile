import 'package:flutter/material.dart';
import 'package:frappe_app/model/bao_cao_san_xuat_response.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/reports/date_picker_view.dart';
import 'package:hive/hive.dart';

class ManufacturingReportView extends StatefulWidget {
  @override
  _ManufacturingReportViewState createState() {
    return _ManufacturingReportViewState();
  }
}

class _ManufacturingReportViewState extends State<ManufacturingReportView> {
  DateTime date = DateTime.now();

  static List<String> listHexColor = [
    "#f5222d",
    "#d4380d",
    "#fa8c16",
    "#faad14",
    "#fadb14",
    "#a0d911",
    "#52c41a",
    "#13c2c2",
    "#1890ff",
    "#2f54eb",
    "#722ed1",
    "#eb2f96",
  ];

  List<BaoCaoSanXuat> listReport = [];

  void onSelectedDate(DateTime date) {
    setState(() {
      date = date;
    });
  }

  Widget buildNoteWidget(Color shapeColor, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2 - 16),
      child: Row(
        children: [
          Container(
            height: 16,
            width: 16,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: shapeColor),
          ),
          SizedBox(
            width: 8,
          ),
          Text(text)
        ],
      ),
    );
  }

  getColorFromIndex(int index) {
    return hexToColor(listHexColor[index]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Báo cáo sản xuất"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatePickerView(
              date: date,
              onSelectedDate: onSelectedDate,
              onlyMonthPicker: false,
              reportName: "Báo cáo sản xuất",
              parentContext: context,
            ),
            SizedBox(
              height: 16,
            ),
            Wrap(
                direction: Axis.horizontal,
                children: listReport
                    .asMap()
                    .entries
                    .map((e) => buildNoteWidget(
                        getColorFromIndex(e.key), e.value.company))
                    .toList()),
          ],
        ),
      ),
    );
  }
}
