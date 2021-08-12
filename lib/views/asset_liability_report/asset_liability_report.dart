import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bao_cao_cong_no_respone.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/asset_liability_report/asset_liability_report_detail.dart';
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

  _buildListItemView(BaoCaoCongNo baoCaoCongNo) {
    final List<String> listRow = [
      baoCaoCongNo.sanpham,
      baoCaoCongNo.nhan,
      baoCaoCongNo.kg,
      baoCaoCongNo.tra,
      baoCaoCongNo.no
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
        print(entry.value);
        return Expanded(
            flex: entry.key == 0 ? 2 : 1,
            child: entry.key == 0
                ? GestureDetector(
                    onTap: () {
                      Navigator.of(this.context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return AssetLiabilityReportDetail();
                      }));
                    },
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: hexToColor("#007BFF"),
                          decoration: TextDecoration.underline,
                          decorationColor: hexToColor("#007BFF")),
                    ),
                  )
                : Text(
                    entry.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ));
      }).toList()),
    );
  }

  _buildListContentView() {
    return listBaoCaoCongNo.map((e) {
      return _buildListItemView(e);
    });
  }

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
            : ListView(
                padding: const EdgeInsets.only(left: 8, right: 8),
                children: [_buildHeaderListView(), ..._buildListContentView()],
              ));
  }
}