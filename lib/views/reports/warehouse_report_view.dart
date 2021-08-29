import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bang_thong_ke_kho.dart';
import 'package:frappe_app/model/get_kiem_kho_response.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';

class WarehouseReportView extends StatefulWidget {
  final String company;
  final String warehouse;

  const WarehouseReportView(
      {Key? key, required this.company, required this.warehouse})
      : super(key: key);

  @override
  _WarehouseReportViewState createState() {
    return _WarehouseReportViewState();
  }
}

class _WarehouseReportViewState extends State<WarehouseReportView> {
  List<BangThongKeKho> listThongKeKho = [];

  _buildHeaderListView() {
    final List<String> listTitle = [widget.warehouse, "Số lượng"];
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
            child: Text(
          entry.value,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
      }).toList()),
    );
  }

  _buildListContent() {
    return listThongKeKho.map((thongke) {
      final List<String> listRow = [
        thongke.realName,
        thongke.quantity.toString()
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
              flex: 1,
              child: Text(
                entry.value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ));
        }).toList()),
      );
    }).toList();
  }

  Future onGetKiemKho() async {
    int type = 0;
    if (widget.warehouse == "Thành phẩm") {
      type = 1;
    }

    try {
      GetKiemKhoResponse kiemKhoResponse =
          await locator<Api>().getKiemKho(type: type, company: widget.company);

      setState(() {
        listThongKeKho = kiemKhoResponse.thongKeKhos ?? [];
      });
    } catch (err) {}
  }

  @override
  void initState() {
    onGetKiemKho();
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
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Công ty", style: TextStyle(fontSize: 14)),
                          Text(widget.company,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kho", style: TextStyle(fontSize: 14)),
                          Text(widget.warehouse,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              _buildHeaderListView(),
              ..._buildListContent()
            ],
          ),
        ));
  }
}
