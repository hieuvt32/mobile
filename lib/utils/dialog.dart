import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';

class ConfirmDialog {
  static showEditingDialog(BuildContext context,
      {required void Function() onCancel,
      required void Function() onConfirm,
      required String title,
      required TextEditingController controller}) {
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
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: new InputDecoration(
                hintText: "Nhập nội dung",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
              ),
              autofocus: true,
              controller: controller,
              maxLines: 4,
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
              content,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
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
