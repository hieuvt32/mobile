import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';

class ProductLocationDetailHeader extends StatelessWidget {
  final int totalNhapKho;
  final int totalTraVe;

  ProductLocationDetailHeader(
      {required this.totalNhapKho, required this.totalTraVe});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng xe về',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(0, 0, 0, 0.65),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$totalNhapKho',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sản phảm trả về ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(0, 0, 0, 0.65),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$totalTraVe',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vỏ nhập',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(0, 0, 0, 0.65),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$totalNhapKho',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vỏ trả khách ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(0, 0, 0, 0.65),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$totalTraVe',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng nhập ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(0, 0, 0, 0.65),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${totalNhapKho - totalTraVe}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: hexToColor('#FF2D1F'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
