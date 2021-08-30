import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/bao_cao_cong_no_respone.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:intl/intl.dart';

class AssetLiabilityReportDetail extends StatefulWidget {
  final String? customer;
  final String assetName;
  AssetLiabilityReportDetail({this.customer, required this.assetName});

  @override
  _AssetLiabilityReportDetailState createState() =>
      _AssetLiabilityReportDetailState();
}

class _AssetLiabilityReportDetailState
    extends State<AssetLiabilityReportDetail> {
  @override
  void initState() {
    DateTime now = DateTime.now();
    String currentDate = DateFormat('MMyy').format(now);
    String preDate =
        DateFormat('MMyy').format(DateTime(now.year, now.month - 1, now.day));

    String customerCode = widget.customer ?? Config().customerCode;
    String key = ["CNTS", customerCode, currentDate].join("-");
    String preKey = ["CNTS", customerCode, preDate].join("-");

//CNTS-00091-0821&previouskey=CNTS-00091-0821&assetname=Bình%20thép%

    locator<Api>()
        .getBaoCaoCongNoDetail(
            key: key, previouskey: preKey, assetname: widget.assetName)
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

  _buildHeaderListView() {
    final List<String> listTitle = ["Ngày", "Nhận", "Kg", "Trả", "Nợ"];
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

  _buildListItemView(BaoCaoCongNoDetail baoCaoCongNo) {
    final List<String> listRow = [
      baoCaoCongNo.date,
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
            child: Text(
              entry.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: (entry.key == 0 && entry.value == "Chuyển")
                      ? hexToColor("#FF0F00")
                      : null),
            ));
      }).toList()),
    );
  }

  _buildListContentView() {
    return listBaoCaoCongNoDetail.map((e) {
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
