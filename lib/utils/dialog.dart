import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';

class ConfirmDialog {
  static showConfirmDialog(
    BuildContext context, {
    required void Function() onCancel,
    required void Function() onConfirm,
    String? title,
    required String content,
  }) {
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: hexToColor('#0072BC'),
        minimumSize: Size(120, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      onPressed: onConfirm,
      child: Text(
        'Có',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );

    Widget confirmButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: hexToColor('#FF0F00'),
        minimumSize: Size(120, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      onPressed: onCancel,
      child: Text(
        'Không',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title ?? ""),
      content: Text(content),
      actions: [
        confirmButton,
        cancelButton,
      ],
    );

    Dialog customDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 250,
        width: MediaQuery.of(context).size.width - 27,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Alert',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [confirmButton, cancelButton],
            )
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return customDialog;
      },
    );
  }
}
