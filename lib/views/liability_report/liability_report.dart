import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/expense_report/expense_report.dart';

class LiabilityReportView extends StatelessWidget {
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
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(
                        "Tổng số đơn hàng",
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "50",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 2, child: Text("Tổng tiền hàng")),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "52.000.000",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hexToColor("#00478B")),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 2, child: Text("Tổng tiền đã trả")),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "30.000.000",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hexToColor("#1BBD5C")),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 2, child: Text("Tổng tiền còn nợ")),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "22.000.000",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hexToColor("#FF0F00")),
                      ))
                ],
              ),
            ),
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
                  onPressed: () {},
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
                color: hexToColor("#FF0F00"),
              ),
              height: 48,
              width: double.infinity,
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Báo cáo chi tiêu",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
