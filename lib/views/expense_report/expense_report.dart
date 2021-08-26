import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bao_cao_chi_tieu_kh_response.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';
import 'package:frappe_app/views/expense_report/components/simpleChart.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class ExpenseReportView extends StatefulWidget {
  @override
  _ExpenseReportViewState createState() => _ExpenseReportViewState();
}

class _ExpenseReportViewState extends State<ExpenseReportView> {
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
              Text(DateFormat('MM/yyyy').format(_date)),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down_outlined),
                onPressed: () async {
                  showMonthPicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 1, 5),
                    lastDate: DateTime.now(),
                    initialDate: _date,
                    locale: Locale("vi"),
                  ).then((date) {
                    if (date != null) {
                      onGetBaoCaoChiTieu(date);
                      onGetTimeChartChiTieu(date);
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
              seriesList,
              animate: true,
            ),
          ),
          buildColumnInfo("Tổng số đơn hàng",
              baocaoChiTieu.totalOrder.toString(), "#000000"),
          buildColumnInfo("Tổng tiền hàng",
              baocaoChiTieu.totalAmount.toString(), "#00478B"),
          buildColumnInfo("Tổng tiền đã trả",
              baocaoChiTieu.totalPaidAmount.toString(), "#1BBD5C"),
          buildColumnInfo("Tổng tiền còn nợ",
              baocaoChiTieu.totalOwedAmount.toString(), "#FF0F00"),
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

  _buildHeaderListView() {
    final List<String> listTitle = ["Ngày", "Tổng nợ", "Chi", "Dư nợ"];
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: hexToColor("#0072BC").withOpacity(0.3),
          border: Border(
              bottom: BorderSide(
                  color: hexToColor("#0072BC").withOpacity(0.3), width: 1))),
      child: Row(
          children: listTitle.asMap().entries.map((entry) {
        return Expanded(
          flex: 1,
          child: Text(
            entry.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }).toList()),
    );
  }

  _buildListContent() {
    return chiTieuDetailList.map((e) {
      List<String> values = [e.ngay, e.tongNo, e.chi, e.duNo];

      return Container(
        height: 42,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: hexToColor("#0072BC").withOpacity(0.3), width: 1))),
        alignment: Alignment.center,
        child: Row(
            children: values.asMap().entries.map((entry) {
          print(entry.value);
          return Expanded(
              flex: 1,
              child: Text(entry.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: (entry.key == 0 && entry.value == "Chuyển")
                          ? hexToColor("#FF0F00")
                          : null)));
        }).toList()),
      );
    });
  }

  ExpansionItem buildDetailReport() {
    return ExpansionItem(
        true,
        (isExpanded) => Container(
              child: Text("Báo cáo chi tiết"),
            ),
        [
          _buildHeaderListView(),
          ..._buildListContent(),
        ]);
  }

  BaoCaoChiTieuKhachHang baocaoChiTieu = BaoCaoChiTieuKhachHang(
      totalAmount: 0, totalOrder: 0, totalOwedAmount: 0, totalPaidAmount: 0);

  DateTime _date = DateTime.now();

  List<TimeSeriesData> seriesList = [];

  List<ChiTieuDetailModel> chiTieuDetailList = [];

  onGetBaoCaoChiTieu(DateTime date) {
    String reportDate = DateFormat('MMyy').format(date);
    String customer = Config().customerCode;

    locator<Api>()
        .getBaoCaoChiTietKH(reportDate: reportDate, customer: customer)
        .then((value) {
      setState(() {
        baocaoChiTieu = value;
      });
    }).catchError((er) {
      setState(() {
        baocaoChiTieu = BaoCaoChiTieuKhachHang(
            totalAmount: 0,
            totalOrder: 0,
            totalOwedAmount: 0,
            totalPaidAmount: 0);
      });
    });
  }

  Future<void> onGetTimeChartChiTieu(DateTime date) async {
    try {
      String dateFormat1 = DateFormat('MMyy').format(date);

      String dateFormat2 =
          DateFormat('yyyy-MM-dd').format(DateTime(date.year, date.month, 1));

      String customer = Config().customerCode;

      String code = "CNT-$customer-$dateFormat1";

      ChartChiTieuKHResponse response = await locator<Api>()
          .getKHChartDataChiTieu(code: code, date: dateFormat2);

      List<TimeSeriesData> chartData = response.chiTieuReportData.map((e) {
        DateFormat inputFormat = DateFormat("yyyy-MM-dd");

        DateTime time = inputFormat.parse(e.accountingDate);

        return TimeSeriesData(time, e.amount);
      }).toList();

      setState(() {
        seriesList = chartData;
      });
    } catch (er) {
      setState(() {
        seriesList = [];
      });
    }
  }

  Future onGetChiTieuDetailKH() async {
    try {
      DateTime now = DateTime.now();
      DateFormat formater = DateFormat('MMyy');

      String currentDate = formater.format(now);
      String preDate =
          formater.format(DateTime(now.year, now.month - 1, now.day));

      String customer = Config().customerCode;

      ChiTieuDetailKHResponse response = await locator<Api>()
          .getChiTietChiTieuKH(
              preReportDate: preDate,
              reportDate: currentDate,
              customer: customer);

      setState(() {
        chiTieuDetailList = response.listChiTieuDetail;
      });
    } catch (err) {
      setState(() {
        chiTieuDetailList = [];
      });
    }
  }

  @override
  void initState() {
    onGetBaoCaoChiTieu(_date);
    onGetTimeChartChiTieu(_date);
    onGetChiTieuDetailKH();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Báo cáo chi tiêu")),
      body: ExpansionCustomPanel(
        padding: const EdgeInsets.all(16),
        items: [
          buildOverviewReport(context),
          buildDetailReport(),
        ],
        backgroundBodyColor: Colors.white,
        backgroundTitleColor: hexToColor('#F2F8FC'),
        backgroundIconColor: hexToColor("#000000").withOpacity(0.18),
      ),
    );
  }
}
