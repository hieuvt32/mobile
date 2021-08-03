import 'package:flutter/material.dart';
import 'package:frappe_app/views/edit_order/components/list_product_view.dart';

class ProductTab extends StatefulWidget {
  const ProductTab({Key? key}) : super(key: key);

  @override
  _ProductTabState createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  @override
  Widget build(BuildContext context) {
    return ListProductView();
  }
}
