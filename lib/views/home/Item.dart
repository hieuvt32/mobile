import 'package:flutter/material.dart';

class Item {
  String icon;
  WidgetBuilder? view;
  List<Item>? childrens;
  String? text;
  List<String>? roles;
  bool visible;
  Item(
      {required this.icon,
      this.childrens,
      this.view,
      this.text,
      this.roles,
      required this.visible});
}
