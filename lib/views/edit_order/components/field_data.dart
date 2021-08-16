import 'package:flutter/material.dart';

class FieldData extends StatefulWidget {
  final int? fieldType;
  final dynamic value;
  final List<FieldValue> values;
  final TextEditingController? controller;
  final Function(dynamic)? selectionHandler;
  final bool haveTextChange;
  final TextInputType keyboardType;
  final bool enabled;
  final String? errorText;
  const FieldData({
    Key? key,
    this.fieldType = 0,
    this.value,
    this.errorText,
    this.values = const [],
    this.controller,
    this.selectionHandler,
    this.haveTextChange = true,
    this.keyboardType = TextInputType.number,
    this.enabled = true,
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
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              items: widget.values
                  .map((e) => DropdownMenuItem<dynamic>(
                        child: Text(e.text),
                        value: e.value,
                      ))
                  .toList(),
              value: widget.value,

              // widget.customers.map((e) {
              //   return DropdownMenuItem<dynamic>(
              //     child: Text(e.realName),
              //     value: e.name,
              //   );
              // }).toList(),
              // value: widget.customerValue,
              onChanged: widget.enabled ? widget.selectionHandler : null,

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
                height: 1,
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
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              // suffixIcon: Icon(Icons.search),
              errorText: widget.errorText,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                ),
              ),
            ),
            style: TextStyle(
              fontSize: 14.0,
              height: 1,
              color: Colors.black,
            ),
            controller: widget.controller,
            onChanged: widget.haveTextChange ? widget.selectionHandler : null,
            // onSubmitted: widget.selectionHandler,
            //(text) {
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
            //}

            textAlign: TextAlign.start,
            // controller: controllers[index]
            //     ['quantityController'],
          ),
        );
      default:
        return Text(widget.value);
    }
  }
}

class FieldValue {
  String text;
  String value;
  FieldValue({this.text = '', this.value = ''});
}
