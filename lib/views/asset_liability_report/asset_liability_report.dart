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
  final String? customer;
  final String? customerName;

  const AssetLiabilityReport({Key? key, this.customer, this.customerName})
      : super(key: key);

  @override
  _AssetLiabilityReportState createState() => _AssetLiabilityReportState();
}

class _AssetLiabilityReportState extends State<AssetLiabilityReport> {
  Future onGetBaoCaoCongNoKH() async {
    try {
      DateTime now = DateTime.now();
      String formarttedDate = DateFormat('MMyy').format(now);

      String customerCode = widget.customer ?? Config().customerCode;

      String key = ["CNTS", customerCode, formarttedDate].join("-");

      var response = await locator<Api>().getBaoCaoCongNoChoKH(key);
      setState(() {
        listBaoCaoCongNo = response.listBaoCaoCongNo ?? [];
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    onGetBaoCaoCongNoKH();
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
        return Expanded(
            flex: entry.key == 0 ? 2 : 1,
            child: entry.key == 0
                ? GestureDetector(
                    onTap: () {
                      Navigator.of(this.context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return AssetLiabilityReportDetail(
                          customer: widget.customer,
                          assetName: baoCaoCongNo.sanpham,
                        );
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
          title: Text(widget.customerName ?? "Báo cáo công nợ tài sản"),
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
