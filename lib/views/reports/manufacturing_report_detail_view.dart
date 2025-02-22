import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bao_cao_san_xuat_chi_tiet_response.dart';
import 'package:frappe_app/model/get_chi_nhanh_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/reports/dropdown_button_view.dart';
import 'package:intl/intl.dart';

class ManufacturingReportDetailView extends StatefulWidget {
  final DateTime date;

  ManufacturingReportDetailView({Key? key, required this.date})
      : super(key: key);

  @override
  _ManufacturingReportDetailViewState createState() {
    return _ManufacturingReportDetailViewState();
  }
}

class _ManufacturingReportDetailViewState
    extends State<ManufacturingReportDetailView> {
  String? _selectedBranch;
  List<String> _branchList = [];
  List<BaoCaoSanXuatChiTiet> listReport = [];

  void onSelectItem(String? value) {
    setState(() {
      _selectedBranch = value;
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

  Future onGetData() async {
    try {
      String formatteDate = DateFormat("yyyy-MM-dd").format(widget.date);

      BaoCaoSanXuatChiTietResponse baoCaoSanXuatChiTietResponse =
          await locator<Api>().getBaoCaoSanXuatChiTietGiamDoc(
              company: _selectedBranch ?? "", date: formatteDate);

      setState(() {
        listReport = baoCaoSanXuatChiTietResponse.listBaoCaoSanXuatChiTiet;
      });
    } catch (err) {}
  }

  _buildHeaderListView() {
    final List<String> listTitle = ["Chi nhánh", "Thành phẩm", "Số lượng"];
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
          flex: entry.key == listTitle.length - 1 ? 1 : 2,
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
    return listReport.map((element) {
      final List<String> listRow = [
        _selectedBranch ?? "",
        element.product,
        element.amount.toString(),
      ];

      return Container(
        height: 42,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: hexToColor("#0072BC").withOpacity(0.3), width: 1))),
        alignment: Alignment.center,
        child: Row(
            children: listRow.asMap().entries.map((entry) {
          return Expanded(
              flex: entry.key == listRow.length - 1 ? 1 : 2,
              child: Text(
                entry.value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ));
        }).toList()),
      );
    }).toList();
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
        title: Text("Báo cáo sản xuất chi tiết"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                      onPressed: onGetData,
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
              height: 24,
            ),
            listReport.length == 0
                ? Container(
                    margin: const EdgeInsets.only(top: 36),
                    child: Text("Không có báo cáo nào"),
                  )
                : Column(
                    children: [_buildHeaderListView(), ..._buildListContent()],
                  )
          ],
        ),
      ),
    );
  }
}
