import 'package:flutter/material.dart';

class LimitTextLength extends StatelessWidget {
  LimitTextLength({
    required this.text,
    this.style,
  });

  final TextStyle? style;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      strutStyle: StrutStyle(fontSize: 10.0),
      text: TextSpan(
          style: style == null
              ? TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
              : style,
          text: text),
    );
  }
}
