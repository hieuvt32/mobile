import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bao_cao_san_xuat_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/reports/date_picker_view.dart';
import 'package:frappe_app/views/reports/manufacturing_report_detail_view.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ManufacturingReportView extends StatefulWidget {
  @override
  _ManufacturingReportViewState createState() {
    return _ManufacturingReportViewState();
  }
}

class _ManufacturingReportViewState extends State<ManufacturingReportView> {
  DateTime _seletedDate = DateTime.now();

  List<String> listHexColor = [
    "#f5222d",
    "#2f54eb",
    "#52c41a",
    "#d4380d",
    "#fa8c16",
    "#faad14",
    "#fadb14",
    "#a0d911",
    "#13c2c2",
    "#1890ff",
    "#722ed1",
    "#eb2f96",
  ];

  List<BaoCaoSanXuat> _listReport = [];

  void onSelectedDate(DateTime date) {
    onGetBaoCaoSanXuatGiamDoc(date);
    setState(() {
      _seletedDate = date;
    });
  }

  Widget buildNoteWidget(Color shapeColor, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2 - 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Flexible(
            child: Text(text),
          )
        ],
      ),
    );
  }

  handleChartColor(int listRpLength) {
    final int diff = listRpLength - listHexColor.length;
    if (diff > 0) {
      int num = 0;
      while (num < diff) {
        num++;

        listHexColor.add(generateRandomHexColor());
      }
    }
  }

  Future<void> onGetBaoCaoSanXuatGiamDoc(DateTime date) async {
    try {
      String formatedDate = DateFormat('yyyy-MM-dd').format(date);
      BaoCaoSanXuatResponse baoCaoSanXuatResponse =
          await locator<Api>().getBaoCaoSanXuatGiamDoc(formatedDate);

      List<BaoCaoSanXuat> listReport = baoCaoSanXuatResponse.listBaoCaoSanXuat;

      handleChartColor(listReport.length);

      setState(() {
        _listReport = listReport;
      });
    } catch (err) {}
  }

  List<charts.Series<BaoCaoSanXuat, String>> _createData() {
    String formatedDate = DateFormat('dd/MM').format(_seletedDate);
    return _listReport
        .asMap()
        .entries
        .map((e) => charts.Series<BaoCaoSanXuat, String>(
            id: e.value.company,
            domainFn: (BaoCaoSanXuat report, _) => formatedDate,
            measureFn: (BaoCaoSanXuat report, _) => report.value,
            data: [e.value],
            colorFn: (_, __) =>
                charts.Color.fromHex(code: listHexColor[e.key])))
        .toList();
  }

  @override
  void initState() {
    onGetBaoCaoSanXuatGiamDoc(_seletedDate);
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
              date: _seletedDate,
              onSelectedDate: onSelectedDate,
              onlyMonthPicker: false,
              reportName: "Báo cáo sản xuất",
              parentContext: context,
            ),
            SizedBox(
              height: 16,
            ),
            Wrap(
                spacing: 16,
                direction: Axis.horizontal,
                children: _listReport
                    .asMap()
                    .entries
                    .map((e) => buildNoteWidget(
                        hexToColor(listHexColor[e.key]), e.value.company))
                    .toList()),
            _listReport.length == 0
                ? Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 48),
                    child: Text("Không có báo cáo nào"),
                  )
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 360,
                        child: charts.BarChart(
                          _createData(),
                          animate: true,
                          barGroupingType: charts.BarGroupingType.grouped,
                          vertical: false,
                        ),
                      ),
                      SizedBox(
                        height: 36,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: hexToColor("#0072BC")),
                        height: 48,
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ManufacturingReportDetailView(
                                        date: _seletedDate,
                                      )));
                            },
                            child: Text(
                              "Xem báo cáo chi tiết",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
