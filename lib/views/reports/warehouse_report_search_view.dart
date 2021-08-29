import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/get_chi_nhanh_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/reports/dropdown_button_view.dart';
import 'package:frappe_app/views/reports/warehouse_report_view.dart';

class WarehouseReportSearchView extends StatefulWidget {
  @override
  _WarehouseReportViewState createState() {
    return _WarehouseReportViewState();
  }
}

class _WarehouseReportViewState extends State<WarehouseReportSearchView> {
  String? _selectedBranch;
  List<String> _branchList = [];

  String? _selectedWarehouse = "Vật tư";

  onSelectBranch(String? value) {
    setState(() {
      _selectedBranch = value;
    });
  }

  onSelectWarehouse(String? value) {
    setState(() {
      _selectedWarehouse = value;
    });
  }

  Future onGetChiNhanh() async {
    try {
      DanhSachChiNhanhResponse danhSachChiNhanhResponse =
          await locator<Api>().getDanhSachChiNhanh();

      setState(() {
        _branchList = danhSachChiNhanhResponse.listChiNhanh;
        _selectedBranch = danhSachChiNhanhResponse.listChiNhanh[0];
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
        title: Text("Báo cáo kho"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: hexToColor("#0072BC").withOpacity(0.3)),
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
                  onSelectItem: onSelectBranch),
              SizedBox(
                height: 16,
              ),
              Text(
                "Kho",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              DropDownButtonView(
                  selectedItem: _selectedWarehouse,
                  data: ["Vật tư", "Thành phẩm"],
                  onSelectItem: onSelectWarehouse),
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
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WarehouseReportView(
                              company: _selectedBranch ?? "",
                              warehouse: _selectedWarehouse ?? "",
                            )));
                  },
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
      ),
    );
  }
}
