import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/get_bao_cao_thu_chi_response.dart';
import 'package:frappe_app/model/get_chi_nhanh_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/reports/dropdown_button_view.dart';
import 'package:frappe_app/views/reports/incoming_and_spending_chart_view.dart';
import 'package:frappe_app/views/reports/date_picker_view.dart';
import 'package:intl/intl.dart';

class IncomingAndSpendingView extends StatefulWidget {
  @override
  _IncomingAndSpendingViewState createState() {
    return _IncomingAndSpendingViewState();
  }
}

class _IncomingAndSpendingViewState extends State<IncomingAndSpendingView> {
  DateTime _seletedDate = DateTime.now();

  String? _selectedBranch;

  List<String> _branchList = [];

  List<IncomingAndSpending> _listNoNCC = [];
  List<IncomingAndSpending> _listKHNo = [];
  List<IncomingAndSpending> _listIncoming = [];
  List<IncomingAndSpending> _listSpending = [];

  Widget buildNoteWidget(Color shapeColor, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2 - 32),
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
          Expanded(
            child: Text(text),
          )
        ],
      ),
    );
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

  Future onGetBaoCaoThuChiGiamDoc() async {
    try {
      String reportDate = DateFormat('MMyy').format(_seletedDate);

      String date = DateFormat('yyyy-MM-dd')
          .format(DateTime(_seletedDate.year, _seletedDate.month, 1));

      String company = _selectedBranch ?? "";

      BaoCaoThuChiResponse baoCaoThuChiResponse = await locator<Api>()
          .getBaoCaoThuChiGiamDoc(
              reportDate: reportDate, date: date, company: company);

      List<IncomingAndSpending> listNoNCC = [];
      List<IncomingAndSpending> listKHNo = [];
      List<IncomingAndSpending> listIncoming = [];
      List<IncomingAndSpending> listSpending = [];

      baoCaoThuChiResponse.listBaoCaoThuChi.forEach((thuChi) {
        DateFormat inputFormat = DateFormat("yyyy-MM-dd");

        String formatedDate =
            DateFormat('dd/MM').format(inputFormat.parse(thuChi.date));

        listNoNCC.add(IncomingAndSpending(formatedDate, thuChi.noNhaCungCap));
        listKHNo.add(IncomingAndSpending(formatedDate, thuChi.khNo));
        listIncoming.add(IncomingAndSpending(formatedDate, thuChi.thu));
        listSpending.add(IncomingAndSpending(formatedDate, thuChi.chi));
      });

      setState(() {
        _listNoNCC = listNoNCC;
        _listKHNo = listKHNo;
        _listIncoming = listIncoming;
        _listSpending = listSpending;
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
        title: Text("Báo cáo thu chi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: hexToColor("#0072BC").withOpacity(0.3)),
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
                      onPressed: onGetBaoCaoThuChiGiamDoc,
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
              height: 8,
            ),
            Wrap(
              children: [
                buildNoteWidget(hexToColor("#FF0F00"), "Thu"),
                SizedBox(
                  width: 16,
                ),
                buildNoteWidget(hexToColor("#0072BC"), "Chi"),
                SizedBox(
                  width: 16,
                ),
                buildNoteWidget(hexToColor("#1BBD5C"), "Nợ nhà cung cấp"),
                SizedBox(
                  width: 16,
                ),
                buildNoteWidget(hexToColor("#FFEC44"), "Khác hàng nợ")
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text("Đơn vị tính: Triệu đồng (VNĐ)"),
            Container(
              height: 300,
              width: double.infinity,
              child: PatternForwardHatchBarChart(
                listNoNCC: _listNoNCC,
                listKHNo: _listKHNo,
                listIncoming: _listIncoming,
                listSpending: _listSpending,
              ),
            )
          ],
        ),
      ),
    );
  }
}
