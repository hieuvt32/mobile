import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bao_cao_cong_no_respone.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:intl/intl.dart';

class AssetLiabilityReport extends StatefulWidget {
  @override
  _AssetLiabilityReportState createState() => _AssetLiabilityReportState();
}

class _AssetLiabilityReportState extends State<AssetLiabilityReport> {
  @override
  void initState() {
    DateTime now = DateTime.now();
    String formarttedDate = DateFormat('MMyy').format(now);

    String customerCode = Config().customerCode;
    String key = ["CNTS", customerCode, formarttedDate].join("-");

    locator<Api>().getBaoCaoCongNoChoKH(key).then((respone) {
      setState(() {
        listBaoCaoCongNo = respone.listBaoCaoCongNo ?? [];
        isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  List<BaoCaoCongNo> listBaoCaoCongNo = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Báo cáo công nợ tài sản"),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: IgnorePointer(
                    child: Container(
                  child: DataTable(
                      columnSpacing: 46,
                      headingRowColor: MaterialStateProperty.all(
                          hexToColor("#0072BC").withOpacity(0.3)),
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
                            'Trả',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nợ',
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
                      rows: listBaoCaoCongNo.map<DataRow>((value) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(value.sanpham),
                            ),
                            DataCell(Text(value.nhan)),
                            DataCell(Text(value.tra)),
                            DataCell(Text(value.no)),
                            DataCell(Text(value.kg)),
                          ],
                        );
                      }).toList()),
                )),
              )));
  }
}
