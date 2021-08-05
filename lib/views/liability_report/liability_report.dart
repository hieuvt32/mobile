import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/asset_liability_report/asset_liability_report.dart';
import 'package:frappe_app/views/expense_report/expense_report.dart';
import 'package:frappe_app/views/report_mistake/report_mistake_view.dart';

class LiabilityReportView extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Báo cáo công nợ"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tổng quan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            buildColumnInfo("Tổng số đơn hàng", "50", "#000000"),
            buildColumnInfo("Tổng tiền hàng", "52.000.000", "#00478B"),
            buildColumnInfo("Tổng tiền đã trả", "30.000.000", "#1BBD5C"),
            buildColumnInfo("Tổng tiền còn nợ", "22.000.000", "#0072BC"),
            SizedBox(
              height: 24,
            ),
            Text(
              "Chi tiết",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hexToColor("#0072BC"),
              ),
              height: 48,
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ExpenseReportView();
                    }));
                  },
                  child: Text(
                    "Báo cáo chi tiêu",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hexToColor("#1BBD5C"),
              ),
              height: 48,
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AssetLiabilityReport();
                    }));
                  },
                  child: Text(
                    "Báo cáo công nợ tài sản",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hexToColor("#FF0F00"),
              ),
              height: 48,
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ReportMistakeView();
                    }));
                  },
                  child: Text(
                    "Báo nhầm lẫn",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
