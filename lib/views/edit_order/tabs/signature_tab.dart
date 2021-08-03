import 'package:flutter/material.dart';
import 'package:frappe_app/views/edit_order/components/signature_view.dart';

class SignatureTab extends StatefulWidget {
  const SignatureTab({Key? key}) : super(key: key);

  @override
  _SignatureTabState createState() => _SignatureTabState();
}

class _SignatureTabState extends State<SignatureTab> {
  @override
  Widget build(BuildContext context) {
    return SignatureView();
  }
}
