import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';

class CustomizeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Function() leftAction;
  CustomizeAppBar(
    this.title, {
    Key? key,
    this.actions,
    required this.leftAction,
  }) : super(key: key);

  @override
  _CustomizeAppBarState createState() => _CustomizeAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

class _CustomizeAppBarState extends State<CustomizeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: hexToColor('#80B8DD'),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed: widget.leftAction,
      ),
      actions: widget.actions,
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      // bottom: ,
    );
  }
}
