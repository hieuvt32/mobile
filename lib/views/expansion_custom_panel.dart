import 'package:flutter/material.dart';

class ExpansionCustomPanel extends StatefulWidget {
  final List<NewItem> items;
  ExpansionCustomPanel({required this.items});
  ExpansionCustomPanelState createState() => ExpansionCustomPanelState();
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  Icon? iconpic;
  NewItem(this.isExpanded, this.header, this.body, {this.iconpic});
}

class ExpansionCustomPanelState extends State<ExpansionCustomPanel> {
  Widget build(BuildContext context) {
    ListView listCriteria = ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                widget.items[index].isExpanded =
                    !widget.items[index].isExpanded;
              });
            },
            expandedHeaderPadding: EdgeInsets.all(0),
            children: widget.items.map((NewItem item) {
              return ExpansionPanel(
                backgroundColor: Colors.white,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: item.iconpic,
                    title: Text(
                      item.header,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
                isExpanded: item.isExpanded,
                body: item.body,
              );
            }).toList(),
          ),
        ),
      ],
    );
    return listCriteria;
  }
}
