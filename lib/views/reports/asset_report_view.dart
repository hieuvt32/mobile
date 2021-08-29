import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bao_cao_tai_san_response.dart';
import 'package:frappe_app/model/get_chi_nhanh_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/reports/dropdown_button_view.dart';

class AssetReportView extends StatefulWidget {
  @override
  _AssetReportViewState createState() {
    return _AssetReportViewState();
  }
}

class _AssetReportViewState extends State<AssetReportView> {
  String? _selectedBranch;
  List<String> _branchList = [];

  List<BaoCaoTaiSan> _listReport = [];

  _buildHeaderListView() {
    final List<String> listTitle = ["Sản phẩm", "Nhận", "Kg", "Trả", "Nợ"];
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
          flex: entry.key == 0 ? 2 : 1,
          child: Text(
            entry.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }).toList()),
    );
  }

  _buildListContentView() {
    return _listReport.asMap().entries.map((entry) {
      BaoCaoTaiSan baoCaoTaiSan = entry.value;

      final List<String> listRow = [
        baoCaoTaiSan.name,
        baoCaoTaiSan.nhan,
        baoCaoTaiSan.kg,
        baoCaoTaiSan.tra,
        baoCaoTaiSan.no
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
              flex: entry.key == 0 ? 2 : 1,
              child: Text(
                entry.value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ));
        }).toList()),
      );
    }).toList();
  }

  void onSelectItem(String? value) {
    setState(() {
      _selectedBranch = value ?? "";
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

  Future onGetBaoCaoTaiSan() async {
    try {
      BaoCaoTaiSanResponse baoCaoTaiSanResponse =
          await locator<Api>().getBaoCaoTaiSanGiamDoc(_selectedBranch ?? "");

      setState(() {
        _listReport = baoCaoTaiSanResponse.listBaoCao;
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
        title: Text("Báo cáo tài sản"),
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
                      onPressed: onGetBaoCaoTaiSan,
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
            Column(
              children: [_buildHeaderListView(), ..._buildListContentView()],
            )
          ],
        ),
      ),
    );
  }
}
