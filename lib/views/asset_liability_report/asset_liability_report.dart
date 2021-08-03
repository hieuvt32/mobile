import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/asset_liability_report/detail_report.dart';

class AssetLiabilityReport extends StatefulWidget {
  @override
  _AssetLiabilityReportState createState() => _AssetLiabilityReportState();
}

class _AssetLiabilityReportState extends State<AssetLiabilityReport> {
  final fakeList = [
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1'
  ];

  Widget buildItem() {
    return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
            border: Border.all(color: hexToColor("#0072BC").withOpacity(0.3)),
            borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              "Loại bình: ",
                              style: TextStyle(fontSize: 14),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              "Oxi khí",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ))
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Số bình đã nhận:",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(
                              "60 bình",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: hexToColor("#00478B")),
                            ))
                      ],
                    ))
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              "Số còn nợ:",
                              style: TextStyle(fontSize: 14),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              "30 Bình",
                              style: TextStyle(
                                  color: hexToColor("#FF0F00"),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Số đã trả:",
                              style: TextStyle(fontSize: 14),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              "60 bình",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: hexToColor("#1BBD5C")),
                            ))
                      ],
                    ))
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Báo cáo công nợ tài sản"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView.builder(
            itemCount: fakeList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return DetailReportView();
                  }));
                },
                child: buildItem(),
              );
            }),
      ),
    );
  }
}
