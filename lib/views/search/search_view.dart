import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
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
            },
          ),
          actions: [],
          title: Text(
            'Tra cứu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: TextField(
//    ...,other fields
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      labelText: 'Mã vạch, Mã chế tạo',
                      labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(20, 20, 43, 0.5)),
                    ),
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 0.5,
                      color: Colors.black,
                    )
                    // controller: controller,
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
                padding: const EdgeInsets.fromLTRB(26, 28, 0, 0),
                child: Row(
                  children: [
                    Text(
                      'Chi tiết sản phẩm',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Tên sản phẩm',
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Oxi khí',
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Loại vật tư',
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Bình thép 10L',
                            style: TextStyle(color: hexToColor('#14142B'))
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mã chế tạo',
                          style: TextStyle(color: hexToColor('#14142B'))
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                            // keyboardType: this.keyboardType,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 14.0,
                                height: 0.5,
                                color: Colors.black)
                            // controller: controller,
                            ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trạng thái',
                          style: TextStyle(color: hexToColor('#14142B'))
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 48,
                          child: DropdownButtonFormField(
                            items: [],
                            // keyboardType: this.keyboardType,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 11.0,
                                height: 0.5,
                                color: Colors.black),
                            // controller: controller,
                            // height: 10,
                          ),
                        ),
                      ],
                    )
                  ],
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
