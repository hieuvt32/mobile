import 'package:flutter/material.dart';

class FieldData extends StatefulWidget {
  final int? fieldType;
  final dynamic value;
  final List<dynamic> values;
  const FieldData({
    Key? key,
    this.fieldType = 0,
    this.value,
    this.values = const [],
  }) : super(key: key);

  @override
  _FieldDataState createState() => _FieldDataState();
}

class _FieldDataState extends State<FieldData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: resolveControlByFieldType(),
    );
  }

  Widget resolveControlByFieldType() {
    switch (widget.fieldType) {
      case 0:
        return Container(
          height: 32,
          // padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              items: [],

              // widget.customers.map((e) {
              //   return DropdownMenuItem<dynamic>(
              //     child: Text(e.realName),
              //     value: e.name,
              //   );
              // }).toList(),
              // value: widget.customerValue,
              // onChanged: widget.customerSelection,

              // keyboardType: this.keyboardType,
              // decoration: InputDecoration(
              //   enabledBorder:
              //       const OutlineInputBorder(
              //     borderRadius: BorderRadius.all(
              //         Radius.circular(0.0)),
              //     borderSide: const BorderSide(
              //       color: Colors.grey,
              //     ),
              //   ),
              // ),

              style: TextStyle(
                fontSize: 12.0,
                height: 2,
                color: Colors.black,
              ),
              // controller: controller,
              // height: 10,
            ),
          ),
        );
      case 1:
        return Container(
          height: 32,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              // suffixIcon: Icon(Icons.search),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            style: TextStyle(
              fontSize: 14.0,
              height: 1,
              color: Colors.black,
            ),
            onChanged: (text) {
              // if (["", null, false, 0].contains(
              //     controllers[index]['quantityController']!
              //         .text)) {
              //   // do sth
              //   products[index].quantity = 0;
              // } else {
              //   products[index].quantity = int.parse(
              //       controllers[index]['quantityController']!
              //           .text);
              // }
            },
            textAlign: TextAlign.center,
            // controller: controllers[index]
            //     ['quantityController'],
          ),
        );
      default:
        return Text(widget.value);
    }
  }
}
