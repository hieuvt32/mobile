import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/create_new_delivery_address_response.dart';
import 'package:frappe_app/model/customer.dart';
import 'package:frappe_app/model/danh_sach_nhap_kho.dart';
import 'package:frappe_app/model/don_nhap_kho.dart';
import 'package:frappe_app/model/get_customer_by_company_response.dart';
import 'package:frappe_app/model/get_delivery_address_response.dart';
import 'package:frappe_app/model/get_guyen_vat_lieu_san_pham_response.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:signature/signature.dart';

class EditOrderView extends StatefulWidget {
  String? name;
  bool? coGiaoVanVien = false;
  EditOrderView({Key? key, this.name, this.coGiaoVanVien}) : super(key: key);

  @override
  _EditOrderViewState createState() => _EditOrderViewState();
}

class _EditOrderViewState extends State<EditOrderView>
    with TickerProviderStateMixin {
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
  // late bool fixedScroll;
  bool isChecked = false;
  late SignatureController signatureCustomerController;
  late SignatureController signatureSupplierController;
  bool _isReadOnly = false;
  Order? _order;
  // bool isLocationEditable = false;

  GetCustomerByCompanyResponse? _responseGetCustomers;

  GetNguyenVatLieuSanPhamResponse? _responseGetNguyenVatLieuSanPham;

  GetNguyenVatLieuSanPhamResponse? _responseGetVatTus;

  GetDeliveryAddressResponse? _responseGetDeliveryAddress;

  CreateNewDeliveryAddressResponse? _responseCreateNewDeliveryAddress;
  // final List<Store> stores = [
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0),
  //   Store(name: 'Van A', system: 30, reality: 0)
  //   // Tab(text: 'fixed'),
  // ];

  _EditOrderViewState() {
    _scrollController = ScrollController();
  }

  List<Map<String, TextEditingController>> _productEditControllers = [];
  List<Map<String, TextEditingController>> _productForLocationEditControllers =
      [];
  List<Map<String, TextEditingController>> donNhapKhoEditControllers = [];
  List<Map<String, TextEditingController>> donTraVeEditControllers = [];

  List<Product> _products = [];

  List<Product> _productForLocations = [];

  List<DanhSachNhapKho> nhapKhos = [];

  List<DanhSachNhapKho> traVes = [];

  DonNhapKho? _donNhapKho;

  List<Address> addresses = [];

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

    // fixedScroll = true;

    super.initState();

    _responseGetCustomers = null;
    _khSelection = null;
    _diaChiSelect = null;

    _order = Order(
        company: '',
        email: '',
        employeeName: '',
        name: '',
        paymentStatus: '',
        phone: '',
        plate: '',
        products: [],
        sellInWarehouse: 0,
        status: '',
        taxId: '',
        totalCost: 0,
        vendor: '',
        vendorAddress: '',
        vendorName: '');

    _donNhapKho = DonNhapKho(
      codeOrders: widget.name != null ? widget.name! : '',
      name: '',
      company: '',
      title: '',
      status: '',
      listShell: [],
    );

    locator<Api>().getCustomerByCompany().then((value) {
      setState(() {
        _responseGetCustomers = value;
      });
    });

    locator<Api>().getNguyenVatLieuSanPham(type: 0).then((value) {
      setState(() {
        _responseGetNguyenVatLieuSanPham = value;
      });
    });

    locator<Api>().getNguyenVatLieuSanPham(type: 1).then((value) {
      setState(() {
        _responseGetVatTus = value;
      });
    });

    if (!["", null, false, 0].contains(widget.name)) {
      locator<Api>().getSingleHoaDonBanHang(widget.name!).then((value) {
        setState(() {
          var response = value;

          if (response != null && response.order != null) {
            _order = response.order;
            if (_order!.products != null && _order!.products.length > 0) {
              if (_order!.sellInWarehouse == 0) {
                for (var product in _order!.products) {
                  _products.add(product);
                  _productEditControllers.add({
                    "kgController":
                        TextEditingController(text: "${product.kg}"),
                    "quantityController":
                        TextEditingController(text: "${product.quantity}")
                  });
                }
              } else {
                for (var product in _order!.products) {
                  _productForLocations.add(product);
                  _productForLocationEditControllers.add({
                    "kgController":
                        TextEditingController(text: "${product.kg}"),
                    "quantityController":
                        TextEditingController(text: "${product.quantity}")
                  });
                }
              }
            }
            _khSelection = _order!.vendor;
            isChecked = _order!.sellInWarehouse == 1;
          }
        });
      });

      locator<Api>().getSingleDonNhapKho(widget.name!).then((value) {
        setState(() {
          var response = value;
          if (response != null && response.donNhapKho != null) {
            _donNhapKho = response.donNhapKho;

            if (response != null && response.donNhapKho != null) {
              _donNhapKho = response.donNhapKho;
              if (_donNhapKho!.listShell != null &&
                  _donNhapKho!.listShell.length > 0) {
                for (var shell in _donNhapKho!.listShell) {
                  if (shell.type == "Nhập kho") {
                    nhapKhos.add(shell);
                    donNhapKhoEditControllers.add({
                      "quantityController":
                          TextEditingController(text: "${shell.amount}")
                    });
                  } else {
                    traVes.add(shell);
                    donTraVeEditControllers.add({
                      "quantityController":
                          TextEditingController(text: "${shell.amount}")
                    });
                  }
                }
              }
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _secondTabController.dispose();
    _scrollController.dispose();
    signatureSupplierController.dispose();
    signatureCustomerController.dispose();
    for (var productEditController in _productEditControllers) {
      productEditController["kgController"]!.dispose();
      productEditController["quantityController"]!.dispose();
    }

    for (var productForLocationEditController
        in _productForLocationEditControllers) {
      productForLocationEditController["kgController"]!.dispose();
      productForLocationEditController["quantityController"]!.dispose();
    }

    for (var donNhapKhoEditController in donNhapKhoEditControllers) {
      donNhapKhoEditController["quantityController"]!.dispose();
    }

    for (var donTraVeEditController in donTraVeEditControllers) {
      donTraVeEditController["quantityController"]!.dispose();
    }
    super.dispose();
  }

  _buildTabContext(int type) {
    switch (type) {
      case 1:
        return _buildReceivingShellContext();
      case 2:
        return _buildProductContext(_productEditControllers, _products, false);
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
        _buildProductContext(_productEditControllers, _products, true), // body
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
      visible: !_isReadOnly,
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
                //_isReadOnly = true;
              });

              if (["", null, false, 0].contains(widget.name)) {
                List<Customer>? customers = _responseGetCustomers != null &&
                        _responseGetCustomers!.customers != null
                    ? _responseGetCustomers!.customers
                    : [];

                var elements = customers!
                    .where((element) => element.name == _khSelection)
                    .toList();

                if (elements != null && elements.length > 0) {
                  _order!.email = elements[0].email;
                  _order!.paymentStatus = 'Chưa thanh toán';
                  _order!.phone = elements[0].phone;
                  _order!.products =
                      isChecked ? _products : _productForLocations;
                  _order!.sellInWarehouse = isChecked ? 1 : 0;
                  _order!.status = isChecked ? "Đã đặt hàng" : "Đã giao hàng";
                  _order!.taxId = elements[0].taxId;
                  _order!.totalCost = 0;
                  _order!.vendor = elements[0].name;

                  _order!.vendorAddress = '';

                  _order!.vendorName = elements[0].realName;

                  locator<Api>().createHoaDonMuaBan(_order!).then((value) {
                    setState(() {
                      var response = value;

                      if (response != null && response.responseData != null) {
                        _donNhapKho!.codeOrders = response.responseData.data;
                        _donNhapKho!.status = _order!.status;
                        _donNhapKho!.listShell = [...nhapKhos, ...traVes];
                        widget.name = response.responseData.data;
                        locator<Api>()
                            .createDonNhapKho(_donNhapKho!)
                            .then((value) {
                          setState(() {
                            var responseCreateDonNhapKho = value;
                            if (responseCreateDonNhapKho != null &&
                                responseCreateDonNhapKho.responseData != null) {
                              FrappeAlert.successAlert(
                                  title: 'Tạo đơn thành công',
                                  context: context,
                                  subtitle: 'Tạo đơn hàng thành công.');
                            }
                          });
                        });

                        locator<Api>()
                            .getSingleHoaDonBanHang(widget.name!)
                            .then((value) {
                          setState(() {
                            var response = value;

                            if (response != null && response.order != null) {
                              _order = response.order;
                            }
                          });
                        });

                        locator<Api>()
                            .getSingleDonNhapKho(widget.name!)
                            .then((value) {
                          setState(() {
                            var response = value;
                            if (response != null &&
                                response.donNhapKho != null) {
                              _donNhapKho = response.donNhapKho;
                            }
                          });
                        });
                      } else {
                        FrappeAlert.errorAlert(
                            title: 'Lỗi xảy ra',
                            context: context,
                            subtitle: 'Không tạo được đơn hàng!');
                      }
                    });
                  });
                } else {
                  FrappeAlert.errorAlert(
                      title: 'Lỗi xảy ra',
                      context: context,
                      subtitle:
                          'Không có khách hàng, xin hãy chọn khách hàng!');
                }
              } else {
                List<Customer>? customers = _responseGetCustomers != null &&
                        _responseGetCustomers!.customers != null
                    ? _responseGetCustomers!.customers
                    : [];

                var elements = customers!
                    .where((element) => element.name == _order!.vendor)
                    .toList();

                if (elements != null && elements.length > 0) {
                  _order!.email = elements[0].email;
                  _order!.paymentStatus = 'Chưa thanh toán';
                  _order!.phone = elements[0].phone;
                  _order!.products =
                      isChecked ? _products : _productForLocations;
                  _order!.sellInWarehouse = isChecked ? 1 : 0;
                  _order!.status = isChecked ? "Đã đặt hàng" : "Đã giao hàng";
                  _order!.taxId = elements[0].taxId;
                  _order!.totalCost = 0;
                  _order!.vendor = elements[0].name;

                  _order!.vendorAddress = '';

                  _order!.vendorName = elements[0].realName;

                  locator<Api>().updateHoaDonMuaBan(_order!).then((value) {
                    setState(() {
                      var response = value;

                      if (response != null && response.responseData != null) {
                        _donNhapKho!.codeOrders = widget.name!;
                        _donNhapKho!.status = _order!.status;
                        _donNhapKho!.listShell = [...nhapKhos, ...traVes];
                        locator<Api>()
                            .updateDonNhapKho(_donNhapKho!)
                            .then((value) {
                          setState(() {
                            var responseUpdateDonNhapKho = value;
                            if (responseUpdateDonNhapKho != null &&
                                responseUpdateDonNhapKho.responseData != null) {
                              FrappeAlert.successAlert(
                                  title: 'Cập nhật thành công',
                                  context: context,
                                  subtitle: 'Cập nhật đơn hàng thành công.');
                            }
                          });
                        });
                      } else {
                        FrappeAlert.errorAlert(
                            title: 'Lỗi xảy ra',
                            context: context,
                            subtitle: 'Không tạo được đơn hàng!');
                      }
                    });
                  });
                } else {
                  FrappeAlert.errorAlert(
                      title: 'Lỗi xảy ra',
                      context: context,
                      subtitle:
                          'Không có khách hàng, xin hãy chọn khách hàng!');
                }
              }
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

  Object? _diaChiSelect;

  Object? _khSelection;

  Widget _buildProductContext(productEditControllers, products, isReadOnly,
      {String? address, bool? isEnable}) {
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
                visible: !_isReadOnly,
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
                    flex: !_isReadOnly ? 1 : 0,
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
                  return Visibility(
                    child: _buildListProduct(
                        ctx, index, productEditControllers, products, false),
                    visible: calculateVisibleProduct(index, products, address),
                  );
                },
                itemCount: products.length,
              ),
            ),
            Visibility(
              visible: !_isReadOnly,
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
                        if (isEnable == null) {
                          setState(() {
                            products.add(Product(
                              actualKg: 0,
                              actualQuantity: 0,
                              address: address != null ? address : "",
                              kg: 0,
                              material: null,
                              product: null,
                              quantity: 0,
                              status: "",
                              type: "",
                              unit: "Bình",
                              unitPrice: 0,
                              hiddenVatTu: false,
                              hiddenKG: false,
                            ));
                          });
                        } else {
                          if (isEnable) {
                            setState(() {
                              products.add(Product(
                                actualKg: 0,
                                actualQuantity: 0,
                                address: address != null ? address : "",
                                kg: 0,
                                material: null,
                                product: null,
                                quantity: 0,
                                status: "",
                                type: "",
                                unit: "Bình",
                                unitPrice: 0,
                                hiddenVatTu: false,
                                hiddenKG: false,
                              ));
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool calculateVisibleProduct(index, products, address) {
    if (products[index].address == null && address == "") {
      return true;
    } else {
      if (products[index].address == "" && address == null) {
        return true;
      } else {
        return products[index].address == address;
      }
    }
  }

  Widget _buildListProduct(ctx, index, controllers, products, isReadOnly) {
    controllers.add({
      "kgController": TextEditingController(),
      "quantityController": TextEditingController()
    });

    var selectProductEvent = (newVal) {
      setState(() {
        var nguyenVatLieuSPs = _responseGetNguyenVatLieuSanPham != null &&
                _responseGetNguyenVatLieuSanPham!.nguyenVatLieuSanPhams != null
            ? _responseGetNguyenVatLieuSanPham!.nguyenVatLieuSanPhams
            : [];
        var elements = nguyenVatLieuSPs!
            .where((element) => element.name == newVal)
            .toList();

        if (elements != null && elements.length > 0) {
          products[index].product = elements[0].name;
          products[index].unit = elements[0].unit;

          if (elements[0].type == 'Vật tư') {
            products[index].hiddenVatTu = true;
          } else {
            products[index].hiddenVatTu = false;
          }

          if (elements[0].unit == 'Kg') {
            products[index].hiddenKG = false;
          } else {
            products[index].hiddenKG = true;
          }
        }
      });
    };

    var selectVatTuEvent = (newVal) {
      setState(() {
        var nguyenVatLieuSPs = _responseGetNguyenVatLieuSanPham != null &&
                _responseGetNguyenVatLieuSanPham!.nguyenVatLieuSanPhams != null
            ? _responseGetNguyenVatLieuSanPham!.nguyenVatLieuSanPhams
            : [];
        var elements = nguyenVatLieuSPs!
            .where((element) => element.name == newVal)
            .toList();

        if (elements != null && elements.length > 0) {
          products[index].material = elements[0].name;
          products[index].unit = elements[0].unit;

          if (elements[0].kg != null && int.parse(elements[0].kg) > 0) {
            products[index].kg = int.parse(elements[0].kg);
            var value = TextEditingValue(
              text: elements[0].kg,
              selection: TextSelection.fromPosition(
                TextPosition(offset: elements[0].kg.length),
              ),
            );
            controllers[index]["kgController"]!.value = value;
          } else {
            products[index].kg = 0.0;
            var value = TextEditingValue(
              text: '',
              selection: TextSelection.fromPosition(
                TextPosition(offset: 0),
              ),
            );
            controllers[index]["kgController"]!.value = value;
          }

          if (elements[0].unit == 'Kg') {
            products[index].hiddenKG = false;
          } else {
            products[index].hiddenKG = true;
          }
        }
      });
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.5))),
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
                              items: _responseGetNguyenVatLieuSanPham != null &&
                                      _responseGetNguyenVatLieuSanPham!
                                              .nguyenVatLieuSanPhams !=
                                          null
                                  ? _responseGetNguyenVatLieuSanPham!
                                      .nguyenVatLieuSanPhams!
                                      .map((e) {
                                      return DropdownMenuItem<dynamic>(
                                        child: Text(e.realName),
                                        value: e.name,
                                      );
                                    }).toList()
                                  : [],
                              value: products[index].product,
                              onChanged: selectProductEvent,

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
                      : products[index].product != null
                          ? Text(products[index].product!)
                          : Text("Không có dữ liệu."),
                ),
              ),
              Expanded(
                flex: 3,
                child: Visibility(
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
                                items: _responseGetVatTus != null &&
                                        _responseGetVatTus!
                                                .nguyenVatLieuSanPhams !=
                                            null
                                    ? _responseGetVatTus!.nguyenVatLieuSanPhams!
                                        .map((e) {
                                        return DropdownMenuItem<dynamic>(
                                          child: Text(e.realName),
                                          value: e.name,
                                        );
                                      }).toList()
                                    : [],
                                value: products[index].material,
                                onChanged: selectVatTuEvent,

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
                        : products[index].material != null
                            ? Text(products[index].material!)
                            : Text('Không có dữ liệu.'),
                  ),
                  visible: !products[index].hiddenVatTu,
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
                              height: 1,
                              color: Colors.black,
                            ),
                            onChanged: (text) {
                              if (["", null, false, 0].contains(
                                  controllers[index]['quantityController']!
                                      .text)) {
                                // do sth
                                products[index].quantity = 0;
                              } else {
                                products[index].quantity = int.parse(
                                    controllers[index]['quantityController']!
                                        .text);
                              }
                            },
                            textAlign: TextAlign.center,
                            controller: controllers[index]
                                ['quantityController'],
                          ),
                        )
                      : Text(
                          '${products[index].quantity}',
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Visibility(
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
                                height: 1,
                                color: Colors.black,
                              ),
                              onChanged: (text) {
                                if (["", null, false, 0].contains(
                                    controllers[index]['kgController']!.text)) {
                                  // do sth
                                  products[index].kg = 0;
                                } else {
                                  products[index].kg = int.parse(
                                      controllers[index]['kgController']!.text);
                                }
                              },
                              textAlign: TextAlign.center,
                              controller: controllers[index]['kgController'],
                            ),
                          )
                        : Text(
                            '${products[index].kg}',
                            textAlign: TextAlign.center,
                          ),
                  ),
                  visible: !products[index].hiddenKG,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('${products[index].unit}'),
              ),
              Expanded(
                flex: !isReadOnly ? 1 : 0,
                child: !isReadOnly
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            products.removeAt(index);
                            controllers.removeAt(index);
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
  }

  Widget _buildReceivingShellContext() {
    var sumNhapKho = nhapKhos.fold<int>(0, (sum, item) => sum + item.amount);

    var sumTraVe = traVes.fold<int>(0, (sum, item) => sum + item.amount);

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
                              '$sumNhapKho',
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
                              '$sumTraVe',
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
                            '${sumNhapKho - sumTraVe}',
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
                            !_isReadOnly ? 'Đã đặt hàng' : 'Đang giao hàng',
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
                          child: !_isReadOnly
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
                                      //TODO: Edit add product

                                      nhapKhos.add(
                                        DanhSachNhapKho(
                                          type: "Nhập kho",
                                          realName: null,
                                          amount: 0,
                                          title: '',
                                        ),
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
                  return !_isReadOnly
                      ? _buildRowRecivingShellWareHouse(ctx, index, 0)
                      : _buildRowRecivingShellWareHouseReadOnly(ctx, index);
                },
                itemCount: nhapKhos.length,
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
                          child: !_isReadOnly
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
                                      // TODO: Add them binh
                                      traVes.add(
                                        DanhSachNhapKho(
                                          type: "Trả về",
                                          realName: null,
                                          amount: 0,
                                          title: '',
                                        ),
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
                  return !_isReadOnly
                      ? _buildRowRecivingShellWareHouse(ctx, index, 1)
                      : _buildRowRecivingShellWareHouseReadOnly(ctx, index);
                },
                itemCount: traVes.length,
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

  _buildRowRecivingShellWareHouse(ctx, index, type) {
    Function(dynamic val)? recivingShellEvent;
    switch (type) {
      case 0:
        donNhapKhoEditControllers
            .add({"quantityController": TextEditingController()});
        recivingShellEvent = (val) {
          setState(() {
            nhapKhos[index].realName = val;
          });
        };
        break;
      case 1:
        donTraVeEditControllers
            .add({"quantityController": TextEditingController()});
        recivingShellEvent = (val) {
          setState(() {
            traVes[index].realName = val;
          });
        };
        break;
    }
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
                      items: _responseGetVatTus != null &&
                              _responseGetVatTus!.nguyenVatLieuSanPhams != null
                          ? _responseGetVatTus!.nguyenVatLieuSanPhams!.map((e) {
                              return DropdownMenuItem<dynamic>(
                                child: Text(e.realName),
                                value: e.name,
                              );
                            }).toList()
                          : [],
                      value: type == 0
                          ? nhapKhos[index].realName
                          : traVes[index].realName,
                      onChanged: recivingShellEvent,

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
                child: _buildTextFieldByType(type, index),
              ),
              flex: 1,
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (type == 0) {
                      nhapKhos.removeAt(index);
                      donNhapKhoEditControllers.removeAt(index);
                    } else {
                      traVes.removeAt(index);
                      donTraVeEditControllers.removeAt(index);
                    }
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

  Widget _buildTextFieldByType(type, index) {
    Function(String)? onchangedEvent;

    TextEditingController? controller;

    switch (type) {
      case 0:
        controller = donNhapKhoEditControllers[index]['quantityController'];
        onchangedEvent = (text) {
          setState(() {
            if (["", null, false, 0].contains(
                donNhapKhoEditControllers[index]['quantityController']!.text)) {
              // do sth
              nhapKhos[index].amount = 0;
            } else {
              nhapKhos[index].amount = int.parse(
                  donNhapKhoEditControllers[index]['quantityController']!.text);
            }
          });
        };
        break;
      case 1:
        controller = donTraVeEditControllers[index]['quantityController'];
        onchangedEvent = (text) {
          setState(() {
            if (["", null, false, 0].contains(
                donTraVeEditControllers[index]['quantityController']!.text)) {
              // do sth
              traVes[index].amount = 0;
            } else {
              traVes[index].amount = int.parse(
                  donTraVeEditControllers[index]['quantityController']!.text);
            }
          });
        };
        break;
    }
    return TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      // textAlign: TextAlign.center,
      decoration: InputDecoration(
        // suffixIcon: Icon(Icons.search),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0)),
          borderSide: const BorderSide(color: Colors.white, width: 0),
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
      onChanged: onchangedEvent,
      controller: controller,
      // selectionHeightStyle: BoxHeightStyle.strut,
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
  _buildHeaderContext() {
    var event = (item) {
      setState(() {
        _khSelection = item;
      });

      locator<Api>().getDeliveryAddress(customer: item).then((value) {
        setState(() {
          _responseGetDeliveryAddress = value;
        });
      });
    };
    return Container(
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
                    !_isReadOnly
                        ? Container(
                            height: 36,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                items: _responseGetCustomers != null &&
                                        _responseGetCustomers!.customers != null
                                    ? _responseGetCustomers!.customers!
                                        .map((e) {
                                        return DropdownMenuItem<dynamic>(
                                          child: Text(e.realName),
                                          value: e.name,
                                        );
                                      }).toList()
                                    : [],
                                value: _khSelection,
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
                        : Text(
                            getKhachHang()['TenKH']!,
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(getKhachHang()['MaKH']!),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Map<String, String> getKhachHang() {
    List<Customer>? customers = _responseGetCustomers != null &&
            _responseGetCustomers!.customers != null
        ? _responseGetCustomers!.customers
        : [];

    var elements =
        customers!.where((element) => element.name == _khSelection).toList();

    if (elements != null && elements.length > 0) {
      return {"TenKH": elements[0].realName, "MaKH": elements[0].name};
    } else {
      return {"TenKH": 'N/A', "MaKH": 'N/A'};
    }
  }

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
        _diaChiSelect = newVal;
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
              visible: !_isReadOnly && !isChecked,
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
              height: 550,
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
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
                                    fontSize: 14, fontWeight: FontWeight.bold),
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
                                !_isReadOnly
                                    ? Container(
                                        height: 32,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                148,
                                        child: addresses[index].isEditable
                                            ? DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  items: _responseGetDeliveryAddress !=
                                                              null &&
                                                          _responseGetDeliveryAddress!
                                                                  .addresses !=
                                                              null
                                                      ? _responseGetDeliveryAddress!
                                                          .addresses!
                                                          .map((e) {
                                                          return DropdownMenuItem<
                                                              dynamic>(
                                                            child:
                                                                Text(e.diaChi),
                                                            value: e.name,
                                                          );
                                                        }).toList()
                                                      : [],
                                                  value: _diaChiSelect,
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
                                                  fontSize: 15.0,
                                                  height: 1,
                                                  color: Colors.black,
                                                ),
                                                onSubmitted: (text) {
                                                  locator<Api>()
                                                      .createNewDeliveryAddress(
                                                          text,
                                                          _khSelection
                                                              as String,
                                                          null)
                                                      .then(
                                                    (value) {
                                                      setState(
                                                        () {
                                                          _responseCreateNewDeliveryAddress =
                                                              value;
                                                          setState(
                                                            () {
                                                              addresses[index]
                                                                  .name = _responseCreateNewDeliveryAddress !=
                                                                          null &&
                                                                      _responseCreateNewDeliveryAddress!
                                                                              .address !=
                                                                          null
                                                                  ? _responseCreateNewDeliveryAddress!
                                                                      .address
                                                                      .name
                                                                  : "";

                                                              addresses[index]
                                                                      .diaChi =
                                                                  text;

                                                              addresses[index]
                                                                      .isEnable =
                                                                  true;
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                      )
                                    : Text('${addresses[index].diaChi}'),
                                SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      addresses[index].isEditable = true;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Opacity(
                                        opacity: !_isReadOnly &&
                                                !addresses[index].isEditable
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
                          _buildProductContext(
                            _productForLocationEditControllers,
                            _productForLocations,
                            false,
                            address: addresses[index].name,
                            isEnable: addresses[index].isEnable,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: !_isReadOnly,
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
                        // _productForLocations.add(Product(
                        //   actualKg: 0,
                        //   actualQuantity: 0,
                        //   address: "",
                        //   kg: 0,
                        //   material: null,
                        //   product: null,
                        //   quantity: 0,
                        //   status: "",
                        //   type: "",
                        //   unit: "Bình",
                        //   unitPrice: 0,
                        //   hiddenVatTu: false,
                        //   hiddenKG: false,
                        // ));

                        addresses.add(
                          Address(
                            name: '',
                            diaChi: '',
                            customer: _khSelection as String,
                            isEnable: false,
                            isEditable: false,
                          ),
                        );
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
        child: !_isReadOnly
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeaderContext(),
                    Visibility(
                      child: _buildProductContext(
                          _productEditControllers, _products, false),
                      visible: !widget.coGiaoVanVien!,
                    ),
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

  // Widget _buildProductByLocationContext() {
  //   return Container(
  //       child: SingleChildScrollView(
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(0, 0, 28, 0),
  //           child: Container(
  //             width: MediaQuery.of(context).size.width - 30,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   flex: 3,
  //                   child: Text(
  //                     'Tên',
  //                     style: TextStyle(color: hexToColor('#14142B'))
  //                         .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 3,
  //                   child: Text(
  //                     'Vật tư',
  //                     style: TextStyle(color: hexToColor('#14142B'))
  //                         .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Text(
  //                     'Số lượng',
  //                     style: TextStyle(color: hexToColor('#14142B'))
  //                         .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Text(
  //                     'Kg',
  //                     style: TextStyle(color: hexToColor('#14142B'))
  //                         .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Text(
  //                     'Đơn vị',
  //                     style: TextStyle(color: hexToColor('#14142B'))
  //                         .copyWith(fontSize: 12, fontWeight: FontWeight.w700),
  //                     textAlign: TextAlign.start,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         Container(
  //           height: 120,
  //           child: ListView.builder(
  //             itemBuilder: (ctx, index) {
  //               var isLatestRow = index == 1;
  //               return Padding(
  //                 padding: const EdgeInsets.fromLTRB(10, 0, 0, 12),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       width: MediaQuery.of(context).size.width - 64,
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.grey,
  //                         ),
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
  //                         child: Container(
  //                           child: Row(
  //                             children: <Widget>[
  //                               Expanded(
  //                                 flex: 3,
  //                                 child: !_isReadOnly
  //                                     ? Padding(
  //                                         padding:
  //                                             const EdgeInsets.only(right: 12),
  //                                         child: Container(
  //                                           height: 28,
  //                                           child: DropdownButtonFormField(
  //                                             items: [
  //                                               DropdownMenuItem<dynamic>(
  //                                                 child: Text('40L'),
  //                                                 value: 1,
  //                                               )
  //                                             ],
  //                                             // keyboardType: this.keyboardType,
  //                                             decoration: InputDecoration(
  //                                               enabledBorder:
  //                                                   const OutlineInputBorder(
  //                                                 borderRadius:
  //                                                     BorderRadius.all(
  //                                                         Radius.circular(0.0)),
  //                                                 borderSide: const BorderSide(
  //                                                   color: Colors.grey,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                             style: TextStyle(
  //                                                 fontSize: 11.0,
  //                                                 height: 1,
  //                                                 color: Colors.black),
  //                                             // controller: controller,
  //                                             // height: 10,
  //                                           ),
  //                                         ),
  //                                       )
  //                                     : Text('Oxi lỏng'),
  //                               ),
  //                               Expanded(
  //                                 flex: 3,
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(right: 12),
  //                                   child: Text('Bình 175L'),
  //                                 ),
  //                               ),
  //                               Expanded(
  //                                 flex: 2,
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(right: 12),
  //                                   child: !_isReadOnly
  //                                       ? Container(
  //                                           // width: 64,
  //                                           height: 28,
  //                                           child: TextField(
  //                                             keyboardType:
  //                                                 TextInputType.number,
  //                                             decoration: InputDecoration(
  //                                               // suffixIcon: Icon(Icons.search),
  //                                               enabledBorder:
  //                                                   const OutlineInputBorder(
  //                                                 borderRadius:
  //                                                     BorderRadius.all(
  //                                                         Radius.circular(0.0)),
  //                                                 borderSide: const BorderSide(
  //                                                   color: Colors.grey,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                             style: TextStyle(
  //                                               fontSize: 14.0,
  //                                               height: 1,
  //                                               color: Colors.black,
  //                                             ),
  //                                           ),
  //                                         )
  //                                       : Text('30'),
  //                                 ),
  //                               ),
  //                               Expanded(
  //                                 flex: 2,
  //                                 child:
  //                                     Text('180', textAlign: TextAlign.center),
  //                               ),
  //                               Expanded(
  //                                 flex: 2,
  //                                 child:
  //                                     Text('Bình', textAlign: TextAlign.center),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: 2,
  //                     ),
  //                     isLatestRow
  //                         ? Visibility(
  //                             visible: !_isReadOnly ? true : false,
  //                             child: GestureDetector(
  //                               onTap: () {
  //                                 // setState(() {
  //                                 //   cylinders.removeAt(index);
  //                                 // });
  //                               },
  //                               child: Column(
  //                                 children: [
  //                                   FrappeIcon(
  //                                     FrappeIcons.adding,
  //                                     color: hexToColor('#FF0F00'),
  //                                     size: 18,
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                           )
  //                         : Text(''),
  //                   ],
  //                 ),
  //               );
  //             },
  //             itemCount: 2,
  //           ),
  //         )
  //       ],
  //     ),
  //   ));
  // }

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
              Navigator.of(context).pop();
            },
          ),
          actions: [],
          title: Text(
            ["", null, false, 0].contains(widget.name)
                ? 'Tạo đơn hàng'
                : widget.name!,
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
