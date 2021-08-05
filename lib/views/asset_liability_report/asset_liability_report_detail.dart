import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bao_cao_cong_no_respone.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:intl/intl.dart';

class AssetLiabilityReportDetail extends StatefulWidget {
  @override
  _AssetLiabilityReportDetailState createState() =>
      _AssetLiabilityReportDetailState();
}

class _AssetLiabilityReportDetailState
    extends State<AssetLiabilityReportDetail> {
  @override
  void initState() {
    DateTime now = DateTime.now();
    String formarttedDate = DateFormat('MMyy').format(now);

    String customerCode = Config().customerCode;
    String key = ["CNTS", customerCode, formarttedDate].join("-");

//CNTS-00091-0821&previouskey=CNTS-00091-0821&assetname=Bình%20thép%

    locator<Api>()
        .getBaoCaoCongNoDetail(
            key: key, previouskey: key, assetname: "Bình thép 10L")
        .then((respone) {
      setState(() {
        listBaoCaoCongNoDetail = respone.listBaocaoCongNoDetail ?? [];
        isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  List<BaoCaoCongNoDetail> listBaoCaoCongNoDetail = [];
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
                      columnSpacing: 60,
                      headingRowColor: MaterialStateProperty.all(
                          hexToColor("#0072BC").withOpacity(0.3)),
                      horizontalMargin: 8,
                      columns: <DataColumn>[
                        DataColumn(
                          numeric: true,
                          label: Text(
                            'Ngày',
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
                      rows: listBaoCaoCongNoDetail.map<DataRow>((value) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(value.date),
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
