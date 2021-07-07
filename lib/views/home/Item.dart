import 'package:flutter/material.dart';

class Item {
  String icon;
  Widget? view;
  List<Item>? childrens;
  Item({required this.icon, this.childrens, this.view});
}
