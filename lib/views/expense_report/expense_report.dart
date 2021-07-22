import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseReportView extends StatefulWidget {
  @override
  _ExpenseReportViewState createState() => _ExpenseReportViewState();
}

class _ExpenseReportViewState extends State<ExpenseReportView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Báo cáo chi tiêu")),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ExpansionPanelList(
              children: [
                ExpansionPanel(
                    isExpanded: true,
                    headerBuilder: (context, isOpen) {
                      return Text("Context");
                    },
                    body: Text("data")),
                ExpansionPanel(
                    isExpanded: true,
                    headerBuilder: (context, isOpen) {
                      return Text("Context");
                    },
                    body: Text("data"))
              ],
            )));
  }
}
