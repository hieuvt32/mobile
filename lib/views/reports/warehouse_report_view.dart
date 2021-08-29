import 'package:flutter/material.dart';
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
              _buildHeaderListView()
            ],
          ),
        ));
  }
}
