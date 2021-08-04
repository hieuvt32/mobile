import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';

class AssetLiabilityReport extends StatefulWidget {
  @override
  _AssetLiabilityReportState createState() => _AssetLiabilityReportState();
}

class _AssetLiabilityReportState extends State<AssetLiabilityReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Báo cáo chi tiết"),
        ),
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(16),
          child: IgnorePointer(
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                  hexToColor("#0072BC").withOpacity(0.3)),
              columnSpacing: 25,
              horizontalMargin: 8,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Sản phẩm',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Nhận',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Trả nợ',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Kg',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: const <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text('Oxi lỏng- Bình thép 15L'),
                    ),
                    DataCell(Text('19')),
                    DataCell(Text('Student')),
                    DataCell(Text('2')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Oxi lỏng- Bình thép 15L')),
                    DataCell(Text('43')),
                    DataCell(Text('Professor')),
                    DataCell(Text('2')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Oxi lỏng- Bình thép 15L')),
                    DataCell(Text('27')),
                    DataCell(Text('Associate ')),
                    DataCell(Text('2')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text('Oxi lỏng- Bình thép 15L'),
                    ),
                    DataCell(Text('19')),
                    DataCell(Text('Student')),
                    DataCell(Text('2')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Oxi lỏng- Bình thép 15L')),
                    DataCell(Text('43')),
                    DataCell(Text('Professor')),
                    DataCell(Text('2')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Oxi lỏng- Bình thép 15L')),
                    DataCell(Text('27')),
                    DataCell(Text('Associate ')),
                    DataCell(Text('2')),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text('Oxi lỏng- Bình thép 15L'),
                    ),
                    DataCell(Text('19')),
                    DataCell(Text('Student')),
                    DataCell(Text('2')),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
