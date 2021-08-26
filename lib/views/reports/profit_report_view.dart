import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bao_cao_loi_nhuan_response.dart';
import 'package:frappe_app/model/get_chi_nhanh_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/reports/dropdown_button_view.dart';
import 'package:frappe_app/views/reports/profit_report_chart_view.dart';
import 'package:frappe_app/views/reports/date_picker_view.dart';
import 'package:intl/intl.dart';

class ProfitReportView extends StatefulWidget {
  @override
  _ProfitReportViewState createState() {
    return _ProfitReportViewState();
  }
}

class _ProfitReportViewState extends State<ProfitReportView> {
  DateTime _seletedDate = DateTime.now();
  String? _selectedBranch;

  List<String> _branchList = [];
  List<BaoCaoLoiNhuan> _listProfitReport = [];

  Future onGetBaoCaoLoiNhuanGiamDoc() async {
    try {
      String reportDate = DateFormat('MMyy').format(_seletedDate);

      String date = DateFormat('yyyy-MM-dd')
          .format(DateTime(_seletedDate.year, _seletedDate.month, 1));

      String company = _selectedBranch ?? "";

      BaoCaoLoiNhuanResponse baoCaoLoiNhuanResponse = await locator<Api>()
          .getBaoCaoLoiNhuanGiamDoc(
              reportDate: reportDate, date: date, company: company);
      DateFormat inputFormat = DateFormat('yyyy-MM-dd');

      var listProfitReport = baoCaoLoiNhuanResponse.listProfitReport.map((e) {
        String date = DateFormat('dd/MM').format(inputFormat.parse(e.date));
        return BaoCaoLoiNhuan(date: date, profit: e.profit);
      }).toList();

      setState(() {
        _listProfitReport = listProfitReport;
      });
    } catch (err) {}
  }

  void onSelectItem(value) {
    setState(() {
      _selectedBranch = value;
    });
  }

  void onSelectedDate(DateTime date) {
    setState(() {
      _seletedDate = date;
    });
  }

  Future onGetChiNhanh() async {
    try {
      DanhSachChiNhanhResponse danhSachChiNhanhResponse =
          await locator<Api>().getDanhSachChiNhanh();

      setState(() {
        _branchList = danhSachChiNhanhResponse.listChiNhanh;
      });
    } catch (err) {}
  }

  @override
  void initState() {
    onGetChiNhanh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Báo cáo lợi nhuận"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: hexToColor("#0072BC").withOpacity(0.3)),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chi nhánh",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    DropDownButtonView(
                        selectedItem: _selectedBranch,
                        data: _branchList,
                        onSelectItem: onSelectItem),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Ngày tháng",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    DatePickerView(
                      onlyMonthPicker: true,
                      date: _seletedDate,
                      parentContext: context,
                      reportName: "Báo cáo thu chi",
                      onSelectedDate: onSelectedDate,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: hexToColor('#0072BC'),
                          minimumSize: Size(120, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        onPressed: onGetBaoCaoLoiNhuanGiamDoc,
                        child: Text(
                          'Tìm báo cáo',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2 - 16),
                child: Row(
                  children: [
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Lợi nhuận"),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text("Đơn vị tính: Triệu đồng (VNĐ)"),
              Container(
                height: 300,
                child:
                    ProfitReportBarChart(listProfitReport: _listProfitReport),
              )
            ],
          ),
        ));
  }
}
