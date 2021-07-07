import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/production_report/product.dart';

class ProductionReportView extends StatefulWidget {
  const ProductionReportView({Key? key}) : super(key: key);

  @override
  _ProductionReportViewState createState() => _ProductionReportViewState();
}

class _ProductionReportViewState extends State<ProductionReportView> {
  var products = [
    Product(name: 'Oxi khí', amount: 10, mass: '150kg', type: 'Bình thép 10L'),
    Product(name: 'Oxi khí', amount: 10, mass: '150kg', type: 'Bình thép 10L'),
    Product(name: 'Oxi khí', amount: 10, mass: '150kg', type: 'Bình thép 10L'),
    Product(name: 'Oxi khí', amount: 10, mass: '150kg', type: 'Bình thép 10L'),
    Product(name: 'Oxi khí', amount: 10, mass: '150kg', type: 'Bình thép 10L')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            // Get.back();
            Navigator.pop(context);
          },
        ),
        actions: [],
        title: Text(
          'Báo cáo sản xuất (21/6/2021)',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // body: AnswerButton(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 16, 60, 0),
                child: Row(
                  children: [
                    Text(
                      'Tổng số sản phẩm',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: hexToColor('#00478B'),
                      ),
                    ),
                    Text(
                      '40',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: hexToColor('#FF0F00')),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: const Divider(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  height: 1,
                  thickness: 1,
                  indent: 1,
                  endIndent: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 6, 0, 0),
                child: Row(
                  children: [
                    Text(
                      'Danh sách sản phẩm',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: hexToColor('#00478B'),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(28.0, 0, 28, 12),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(0, 0, 0, 0.3))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 26, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: [
                                  Text(
                                    'Tên sản phẩm: ${products[index].name}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Loại vật tư: ${products[index].type}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Khối lượng: ${products[index].mass}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Số lượng',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '${products[index].amount}',
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: hexToColor('#FF0F00')),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
              )
            ],
          ),
        ), /* add child content here */
      ),
      backgroundColor: Colors.white,
    );
  }
}
