import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/create_order/cylindered.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:signature/signature.dart';

class CreateOrderView extends StatefulWidget {
  const CreateOrderView({Key? key}) : super(key: key);

  @override
  _CreateOrderViewState createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView>
    with TickerProviderStateMixin {
  List<Cylindered> cylinders = [
    Cylindered(cylinderType: "123", amount: 30, id: 1),
    Cylindered(cylinderType: "123", amount: 30, id: 2),
    Cylindered(cylinderType: "123", amount: 30, id: 3),
    Cylindered(cylinderType: "123", amount: 30, id: 4),
    Cylindered(cylinderType: "123", amount: 30, id: 5),
  ];
  final bodyGlobalKey = GlobalKey();
  final List<Widget> myTabs = [
    Tab(
      child: Text('Vỏ nhận',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          )),
    ),
    Tab(
        child: Text('Sản phẩm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ))),
    Tab(
      child: Text(
        'Ký xác nhận',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ];
  late TabController _tabController;
  late TabController _secondTabController;
  late ScrollController _scrollController;
  late bool fixedScroll;
  bool isChecked = false;
  late SignatureController signatureCustomerController;
  late SignatureController signatureSupplierController;
  bool isReadOnly = false;
  bool isLocationEditable = false;
  var _productsForLocation = [1];
  GlobalKey _parentKey = GlobalKey();

  // final List<Store> stores = [
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0)
  //   // Tab(text: 'fixed'),
  // ];

  _CreateOrderViewState() {
    _scrollController = ScrollController();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_smoothScrollToTop);
    _secondTabController = TabController(length: 2, vsync: this);
    _secondTabController.addListener(_smoothScrollToTop);
    signatureSupplierController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    signatureCustomerController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );

    fixedScroll = true;

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _secondTabController.dispose();
    _scrollController.dispose();
    signatureSupplierController.dispose();
    signatureCustomerController.dispose();
    super.dispose();
  }

  _buildTabContext(int type) {
    switch (type) {
      case 1:
        return _buildReceivingShellContext();
      case 2:
        return _buildProductContext();
      case 3:
        return _buildSignatureContext();
      case 4:
        return _buildProductReadOnlyContext();
      case 5:
        return _buildReceivingShellReadOnlyContext();
    }
  }

  Widget _buildProductReadOnlyContext() {
    List<NewItem> productItems = <NewItem>[
      NewItem(
        false, // isExpanded ?
        'Danh sách sản phẩm', // header
        _buildProductContext(), // body
        // Icon(Icons.image) // iconPic
      ),
      NewItem(
        false, // isExpanded ?
        'Địa chỉ giao hàng', // header
        _buidLocationDeliveryList(), // body
        // Icon(Icons.image) // iconPic
      ),
    ];

    return ExpansionCustomPanel(items: productItems);
  }

  Widget _buildReceivingShellReadOnlyContext() {
    return Container();
  }

  Widget _buildSignatureContext() {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                height: 1,
                thickness: 1,
                indent: 1,
                endIndent: 1,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Ký xác nhận',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: hexToColor('#00478B'),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(border: Border.all()),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text('Khách hàng'),
                      SizedBox(
                        height: 12,
                      ),
                      Signature(
                        controller: signatureCustomerController,
                        backgroundColor: Colors.white,
                        height: 110,
                        width: MediaQuery.of(context).size.width - 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(border: Border.all()),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text('Nhà cung cấp'),
                      SizedBox(
                        height: 12,
                      ),
                      Signature(
                        controller: signatureSupplierController,
                        backgroundColor: Colors.white,
                        height: 110,
                        width: MediaQuery.of(context).size.width - 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 44,
              ),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Visibility(
      visible: !isReadOnly,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              side: BorderSide(
                width: 1.0,
              ),
              // minimumSize: Size(120, 40),
              padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: hexToColor('#0072BC'),
                ),
              ),
            ),
            onPressed: () {},
            child: Text(
              'Hủy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: hexToColor('#00478B'),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: hexToColor('#FF0F00'),
              side: BorderSide(
                width: 1.0,
              ),
              // minimumSize: Size(120, 40),
              padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: hexToColor('#FF0F00'),
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                isReadOnly = true;
              });
            },
            child: Text(
              'Hoàn thành',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Object? _mySelection = 1;

  Widget _buildProductContext() {
    var event = (newVal) {
      setState(() {
        _mySelection = newVal;
      });
    };
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              height: 1,
              thickness: 1,
              indent: 1,
              endIndent: 1,
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8, 8, 16),
              child: Visibility(
                visible: !isReadOnly && !isChecked,
                child: Text(
                  'Danh sách sản phẩm',
                  style: TextStyle(
                    color: hexToColor('#00478B'),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Tên',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Vật tư',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Số lượng',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Kg',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Đơn vị',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(''),
                    flex: !isReadOnly ? 1 : 0,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 300,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color.fromRGBO(0, 0, 0, 0.5))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 2, 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: !isReadOnly
                                    ? Container(
                                        height: 28,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.grey,
                                        )),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            items: [
                                              DropdownMenuItem<dynamic>(
                                                child: Text('Bình...'),
                                                value: 1,
                                              ),
                                              DropdownMenuItem<dynamic>(
                                                child: Text('Bình'),
                                                value: 2,
                                              ),
                                              DropdownMenuItem<dynamic>(
                                                child: Text('Bình'),
                                                value: 3,
                                              ),
                                              DropdownMenuItem<dynamic>(
                                                child: Text('Bình'),
                                                value: 4,
                                              ),
                                              DropdownMenuItem<dynamic>(
                                                child: Text(
                                                    'Bình 2132321313211232'),
                                                value: 5,
                                              )
                                            ],
                                            value: _mySelection,
                                            onChanged: event,

                                            // keyboardType: this.keyboardType,
                                            // decoration: InputDecoration(
                                            //   enabledBorder:
                                            //       const OutlineInputBorder(
                                            //     borderRadius: BorderRadius.all(
                                            //         Radius.circular(0.0)),
                                            //     borderSide: const BorderSide(
                                            //       color: Colors.grey,
                                            //     ),
                                            //   ),
                                            // ),

                                            style: TextStyle(
                                              fontSize: 13.0,
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                            // controller: controller,
                                            // height: 10,
                                          ),
                                        ),
                                      )
                                    : Text('Oxi lỏng'),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: !isReadOnly
                                    ? Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.grey,
                                        )),
                                        padding: EdgeInsets.only(left: 6),
                                        height: 28,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            items: [
                                              DropdownMenuItem<dynamic>(
                                                child: Text('Bình...'),
                                                value: 1,
                                              ),
                                              DropdownMenuItem<dynamic>(
                                                child: Text('Bình'),
                                                value: 2,
                                              ),
                                              DropdownMenuItem<dynamic>(
                                                child: Text('Bình'),
                                                value: 3,
                                              ),
                                              DropdownMenuItem<dynamic>(
                                                child: Text('Bình'),
                                                value: 4,
                                              ),
                                              DropdownMenuItem<dynamic>(
                                                child: Text(
                                                    'Bình 2132321313211232'),
                                                value: 5,
                                              )
                                            ],
                                            value: _mySelection,
                                            onChanged: event,

                                            // keyboardType: this.keyboardType,
                                            // decoration: InputDecoration(
                                            //   enabledBorder:
                                            //       const OutlineInputBorder(
                                            //     borderRadius: BorderRadius.all(
                                            //         Radius.circular(0.0)),
                                            //     borderSide: const BorderSide(
                                            //       color: Colors.grey,
                                            //     ),
                                            //   ),
                                            // ),

                                            style: TextStyle(
                                              fontSize: 13.0,
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                            // controller: controller,
                                            // height: 10,
                                          ),
                                        ),
                                      )
                                    : Text('Bình 175L'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: !isReadOnly
                                    ? Container(
                                        // width: 64,
                                        height: 28,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            // suffixIcon: Icon(Icons.search),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0.0)),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : Text('30', textAlign: TextAlign.center),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: !isReadOnly
                                    ? Container(
                                        // width: 64,
                                        height: 28,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            // suffixIcon: Icon(Icons.search),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0.0)),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        '150',
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text('Bình'),
                            ),
                            Expanded(
                              flex: !isReadOnly ? 1 : 0,
                              child: !isReadOnly
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          cylinders.removeAt(index);
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          FrappeIcon(
                                            FrappeIcons.trash,
                                            color: hexToColor('#FF0F00'),
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    )
                                  : Text(''),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 5,
              ),
            ),
            Visibility(
                visible: !isReadOnly,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: hexToColor('#0072BC'),
                          side: BorderSide(
                            width: 1.0,
                          ),
                          // minimumSize: Size(120, 40),
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              color: hexToColor('#0072BC'),
                            ),
                          ),
                        ),
                        child: Text('Thêm sản phẩm'),
                        onPressed: () {
                          // setState(() {
                          //   cylinders.add(Cylindered(
                          //       cylinderType: "123",
                          //       amount: 30,
                          //       id: cylinders.length + 1));
                          // });
                        },
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildReceivingShellContext() {
    return Container(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              height: 1,
              thickness: 1,
              indent: 1,
              endIndent: 1,
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Vỏ nhận',
              style: TextStyle(
                color: hexToColor(
                  '#00478B',
                ),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Vào',
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '',
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '70',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Trả về',
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '',
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '10',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                      flex: 2,
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Nhập kho:',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '',
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '60',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: hexToColor('#FF0F00')),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Trạng thái:',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '',
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            !isReadOnly ? 'Đã đặt hàng' : 'Đang giao hàng',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: hexToColor('#14142B'),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Danh sách vỏ bình nhập kho:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: hexToColor('#14142B'),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '',
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: !isReadOnly
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: hexToColor('#0072BC'),
                                    // minimumSize: Size(120, 40),
                                    padding:
                                        EdgeInsets.fromLTRB(28, 10, 28, 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                        color: hexToColor('#0072BC'),
                                      ),
                                    ),
                                  ),
                                  child: Text('Thêm bình'),
                                  onPressed: () {
                                    setState(() {
                                      cylinders.add(
                                        Cylindered(
                                            cylinderType: "123",
                                            amount: 30,
                                            id: cylinders.length + 1),
                                      );
                                    });
                                  },
                                )
                              : Text(''),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return !isReadOnly
                      ? _buildRowRecivingShellWareHouse(ctx, index)
                      : _buildRowRecivingShellWareHouseReadOnly(ctx, index);
                },
                itemCount: cylinders.length,
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Danh sách vỏ bình trả về:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: hexToColor('#14142B'),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '',
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: !isReadOnly
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: hexToColor('#0072BC'),
                                    // minimumSize: Size(120, 40),
                                    padding:
                                        EdgeInsets.fromLTRB(28, 10, 28, 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                        color: hexToColor('#0072BC'),
                                      ),
                                    ),
                                  ),
                                  child: Text('Thêm bình'),
                                  onPressed: () {
                                    setState(() {
                                      cylinders.add(Cylindered(
                                          cylinderType: "123",
                                          amount: 30,
                                          id: cylinders.length + 1));
                                    });
                                  },
                                )
                              : Text(''),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return !isReadOnly
                      ? _buildRowRecivingShellWareHouse(ctx, index)
                      : _buildRowRecivingShellWareHouseReadOnly(ctx, index);
                },
                itemCount: cylinders.length,
              ),
            )
          ],
        ),
      ),
    ));
  }

  _buildRowRecivingShellWareHouseReadOnly(ctx, index) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color.fromRGBO(0, 0, 0, 0.3),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text('Vỏ bình Oxi 40L'),
                ),
                flex: 3,
              ),
              Expanded(
                child: Text('30', textAlign: TextAlign.center),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRowRecivingShellWareHouse(ctx, index) {
    var event = (newVal) {
      setState(() {
        _mySelection = newVal;
      });
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 6, 6, 6),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  height: 28,
                  padding: EdgeInsets.only(left: 12),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      items: [
                        DropdownMenuItem<dynamic>(
                          child: Text('Bình...'),
                          value: 1,
                        ),
                        DropdownMenuItem<dynamic>(
                          child: Text('Bình'),
                          value: 2,
                        ),
                        DropdownMenuItem<dynamic>(
                          child: Text('Bình'),
                          value: 3,
                        ),
                        DropdownMenuItem<dynamic>(
                          child: Text('Bình'),
                          value: 4,
                        ),
                        DropdownMenuItem<dynamic>(
                          child: Text('Bình 2132321313211232'),
                          value: 5,
                        )
                      ],
                      value: _mySelection,
                      onChanged: event,

                      // keyboardType: this.keyboardType,
                      // decoration: InputDecoration(
                      //   enabledBorder:
                      //       const OutlineInputBorder(
                      //     borderRadius: BorderRadius.all(
                      //         Radius.circular(0.0)),
                      //     borderSide: const BorderSide(
                      //       color: Colors.grey,
                      //     ),
                      //   ),
                      // ),

                      style: TextStyle(
                        fontSize: 13.0,
                        height: 1,
                        color: Colors.black,
                      ),
                      // controller: controller,
                      // height: 10,
                    ),
                  ),
                ),
              ),
              flex: 3,
            ),
            Expanded(
              child: Container(
                height: 28,
                padding: EdgeInsets.all(3),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: TextField(
                  keyboardType: TextInputType.text,

                  // textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    // suffixIcon: Icon(Icons.search),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0),
                    ),
                    // labelText: 'Mã vạch, Mã chế tạo',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(20, 20, 43, 0.5),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.3,
                    color: Colors.black,
                  ),
                  // selectionHeightStyle: BoxHeightStyle.strut,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    cylinders.removeAt(index);
                  });
                },
                child: Column(
                  children: [
                    FrappeIcon(
                      FrappeIcons.trash,
                      color: hexToColor('#FF0F00'),
                      size: 18,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _scrollListener() {
    // if (fixedScroll) {
    //   _scrollController.jumpTo(0);
    // }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );

    setState(() {
      // fixedScroll = _tabController.index == 2;
    });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.black;
  }

  // TODO: Tên khách hàng nhâp có thể lui vào lề bên tay trái
  _buildHeaderContext() => Container(
        padding: EdgeInsets.fromLTRB(28, 12, 28, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tên khách hàng',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      !isReadOnly
                          ? Container(
                              height: 36,
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                // textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  // suffixIcon: Icon(Icons.search),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0),
                                  ),
                                  // labelText: 'Mã vạch, Mã chế tạo',
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(20, 20, 43, 0.5),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  height: 1,
                                  color: Colors.black,
                                ),
                                selectionHeightStyle: BoxHeightStyle.strut,
                              ),
                            )
                          : Text(
                              'Nguyễn Văn A',
                              style: TextStyle(fontSize: 14),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Bán Hàng Tại Kho',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            flex: 5,
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Expanded(
                            flex: 1,
                            child: Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(''),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã khách hàng',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text('T123'),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );

  Widget _buildOrderAtStore() => Padding(
        padding: const EdgeInsets.only(top: 0),
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              // Text('hieutest'),
              SliverToBoxAdapter(child: _buildHeaderContext()),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: hexToColor('#FF0F00'),
                  // isScrollable: true,
                  labelStyle: TextStyle(
                    color: hexToColor('#FF0F00'),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelColor: hexToColor('#00478B'),
                  indicatorColor: Colors.transparent,
                  tabs: myTabs,
                ),
              ),
            ];
          },
          body: Container(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContext(1),
                _buildTabContext(2),
                _buildTabContext(3)
              ],
            ),
          ),
        ),
      );

  Widget _buidLocationDeliveryList() {
    var event = (newVal) {
      setState(() {
        _mySelection = newVal;
      });
    };
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 11),
            child: Visibility(
              visible: !isReadOnly && !isChecked,
              child: Text(
                'Địa chỉ giao hàng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: hexToColor('#00478B'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8, 12, 8),
            child: Container(
              height: 240,
              child: ListView.builder(
                  itemCount: _productsForLocation.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Tổng: '),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '20',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3, left: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Địa chỉ: ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 28,
                                  ),
                                  !isReadOnly
                                      ? Container(
                                          height: 32,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              148,
                                          child: !isLocationEditable
                                              ? DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    items: [
                                                      DropdownMenuItem<dynamic>(
                                                        child: Text('Bình...'),
                                                        value: 1,
                                                      ),
                                                      DropdownMenuItem<dynamic>(
                                                        child: Text('Bình'),
                                                        value: 2,
                                                      ),
                                                      DropdownMenuItem<dynamic>(
                                                        child: Text('Bình'),
                                                        value: 3,
                                                      ),
                                                      DropdownMenuItem<dynamic>(
                                                        child: Text('Bình'),
                                                        value: 4,
                                                      ),
                                                      DropdownMenuItem<dynamic>(
                                                        child: Text(
                                                            'Bình 2132321313211232'),
                                                        value: 5,
                                                      )
                                                    ],
                                                    value: _mySelection,
                                                    onChanged: event,

                                                    // keyboardType: this.keyboardType,
                                                    // decoration: InputDecoration(
                                                    //   enabledBorder:
                                                    //       const OutlineInputBorder(
                                                    //     borderRadius: BorderRadius.all(
                                                    //         Radius.circular(0.0)),
                                                    //     borderSide: const BorderSide(
                                                    //       color: Colors.grey,
                                                    //     ),
                                                    //   ),
                                                    // ),

                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      height: 1,
                                                      color: Colors.black,
                                                    ),
                                                    // controller: controller,
                                                    // height: 10,
                                                  ),
                                                )
                                              : TextField(
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0.0)),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    height: 1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                        )
                                      : Text('Số 123 đường A, quận B'),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLocationEditable = true;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Opacity(
                                          opacity:
                                              !isReadOnly && !isLocationEditable
                                                  ? 1
                                                  : 0,
                                          child: FrappeIcon(
                                            FrappeIcons.adding,
                                            color: hexToColor('#FF0F00'),
                                            size: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            _buildProductByLocationContext()
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: !isReadOnly,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: hexToColor('#0072BC'),
                      side: BorderSide(
                        width: 1.0,
                      ),
                      // minimumSize: Size(120, 40),
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: hexToColor('#0072BC'),
                        ),
                      ),
                    ),
                    child: Text('Thêm địa chỉ'),
                    onPressed: () {
                      setState(() {
                        _productsForLocation.add(2);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 16),
            child: _buildBottomButton(),
          ),
          SizedBox(
            height: 22,
          )
        ],
      ),
    );
  }

  Widget _buildOrderNotAtTheStore() => Container(
        child: !isReadOnly
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeaderContext(),
                    _buildProductContext(),
                    _buidLocationDeliveryList(),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 0),
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, value) {
                    return [
                      // Text('hieutest'),
                      SliverToBoxAdapter(
                        child: _buildHeaderContext(),
                      ),
                      SliverToBoxAdapter(
                        child: TabBar(
                          controller: _secondTabController,
                          labelColor: hexToColor('#FF0F00'),
                          // isScrollable: true,
                          labelStyle: TextStyle(
                            color: hexToColor('#FF0F00'),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          unselectedLabelColor: hexToColor('#00478B'),
                          indicatorColor: Colors.transparent,
                          tabs: [
                            Tab(
                              child: Text(
                                'Sản phẩm',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Vỏ nhận',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ];
                  },
                  body: Container(
                    child: TabBarView(
                      controller: _secondTabController,
                      children: [
                        _buildTabContext(4),
                        _buildTabContext(5),
                      ],
                    ),
                  ),
                ),
              ),
      );

  Widget _buildProductByLocationContext() {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 28, 0),
            child: Container(
              width: MediaQuery.of(context).size.width - 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Tên',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Vật tư',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Số lượng',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Kg',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Đơn vị',
                      style: TextStyle(color: hexToColor('#14142B'))
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 120,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                var isLatestRow = index == 1;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 12),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 64,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: !isReadOnly
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: Container(
                                            height: 28,
                                            child: DropdownButtonFormField(
                                              items: [
                                                DropdownMenuItem<dynamic>(
                                                  child: Text('40L'),
                                                  value: 1,
                                                )
                                              ],
                                              // keyboardType: this.keyboardType,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(0.0)),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  height: 1,
                                                  color: Colors.black),
                                              // controller: controller,
                                              // height: 10,
                                            ),
                                          ),
                                        )
                                      : Text('Oxi lỏng'),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Text('Bình 175L'),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: !isReadOnly
                                        ? Container(
                                            // width: 64,
                                            height: 28,
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                // suffixIcon: Icon(Icons.search),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(0.0)),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                height: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        : Text('30'),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child:
                                      Text('180', textAlign: TextAlign.center),
                                ),
                                Expanded(
                                  flex: 2,
                                  child:
                                      Text('Bình', textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      isLatestRow
                          ? Visibility(
                              visible: !isReadOnly ? true : false,
                              child: GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   cylinders.removeAt(index);
                                  // });
                                },
                                child: Column(
                                  children: [
                                    FrappeIcon(
                                      FrappeIcons.adding,
                                      color: hexToColor('#FF0F00'),
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Text(''),
                    ],
                  ),
                );
              },
              itemCount: 2,
            ),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
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
            'Tạo đơn hàng',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          // bottom: ,
        ),
        // body: AnswerButton(),
        body: isChecked ? _buildOrderAtStore() : _buildOrderNotAtTheStore(),
      ),
    );
  }
}
