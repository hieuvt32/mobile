import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/create_new_delivery_address_response.dart';
import 'package:frappe_app/model/customer.dart';
import 'package:frappe_app/model/danh_sach_nhap_kho.dart';
import 'package:frappe_app/model/don_nhap_kho.dart';
import 'package:frappe_app/model/get_customer_by_company_response.dart';
import 'package:frappe_app/model/get_delivery_address_response.dart';
import 'package:frappe_app/model/get_guyen_vat_lieu_san_pham_response.dart';
import 'package:frappe_app/model/nguyen_vat_lieu_san_pham.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/views/base_viewmodel.dart';
import 'package:injectable/injectable.dart';
import 'package:signature/signature.dart';

@lazySingleton
class EditOrderViewModel extends BaseViewModel {
  late SignatureController _signatureCustomerController;
  late SignatureController _signatureSupplierController;

  Order? _order;

  GetCustomerByCompanyResponse? _responseGetCustomers;

  GetNguyenVatLieuSanPhamResponse? _responseGetSanPhams;

  GetNguyenVatLieuSanPhamResponse? _responseGetVatTus;

  CreateNewDeliveryAddressResponse? _responseCreateNewDeliveryAddress;

  GetDeliveryAddressResponse? _responseGetDeliveryAddress;

  late List<Map<String, TextEditingController>> _productEditControllers;
  late List<Map<String, TextEditingController>>
      _productForLocationEditControllers;
  late List<Map<String, TextEditingController>> _donNhapKhoEditControllers;
  late List<Map<String, TextEditingController>> _donTraVeEditControllers;

  late List<Product> _products;

  late List<Product> _productForLocations;

  late List<DanhSachNhapKho> _nhapKhos;

  late List<DanhSachNhapKho> _traVes;

  DonNhapKho? _donNhapKho;

  late List<Address> _addresses;

  late List<Customer> _customers;
  late List<NguyenVatLieuSanPham> _nguyenVatLieuVatTus;

  late List<NguyenVatLieuSanPham> _nguyenVatLieuSanPhams;

  // Object? _diaChiSelect;

  String? _customerValue;

  bool _sellInWarehouse = false;
  bool _readOnlyView = false;

  String? _name;

  String? _title;

  String get title => _title ?? '';

  bool get sellInWarehouse => _sellInWarehouse;

  bool get readOnlyView => _readOnlyView;

  List<Map<String, TextEditingController>> get productEditControllers =>
      _productEditControllers;

  List<Map<String, TextEditingController>>
      get productForLocationEditControllers =>
          _productForLocationEditControllers;
  List<Map<String, TextEditingController>> get donNhapKhoEditControllers =>
      _donNhapKhoEditControllers;

  List<Map<String, TextEditingController>> get donTraVeEditControllers =>
      _donTraVeEditControllers;

  List<DanhSachNhapKho> get nhapKhos => _nhapKhos;

  List<DanhSachNhapKho> get traVes => _traVes;

  String? get customerValue => _customerValue;

  Order? get order => _order;

  late Config _config;

  Config? get config => _config;

  List<Customer> get customers => _customers;

  List<Product> get products => _products;

  List<NguyenVatLieuSanPham> get nguyenVatLieuVatTus => _nguyenVatLieuVatTus;

  List<NguyenVatLieuSanPham> get nguyenVatLieuSanPhams =>
      _nguyenVatLieuSanPhams;

  SignatureController get signatureCustomerController =>
      _signatureCustomerController;

  SignatureController get signatureSupplierController =>
      _signatureSupplierController;

  initState() {
    _signatureSupplierController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    _signatureCustomerController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    _productEditControllers = [];
    _productForLocationEditControllers = [];

    _donNhapKhoEditControllers = [];
    _donTraVeEditControllers = [];

    _config = Config();

    _products = [];

    _productForLocations = [];

    _nhapKhos = [];
    _traVes = [];
    _addresses = [];

    _customers = [];

    _responseGetCustomers = null;
    _customerValue = null;
    _nguyenVatLieuVatTus = [];
    _nguyenVatLieuSanPhams = [];
    // _diaChiSelect = null;

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
        vendorName: '',
        attachSignatureImage: '');

    _donNhapKho = DonNhapKho(
      codeOrders: _name != null ? _name! : '',
      name: '',
      company: '',
      title: '',
      status: '',
      listShell: [],
    );
  }

  initPreData() async {
    await getCustomerByCompany();
    await getNguyenVatLieuSanPham();
    await getVatTuSanPham();
    await getChiTietDonHang();
    await getChiTietDonNhapKho();
  }

  setName(String? name) {
    _name = name;
    _title = ["", null, false, 0].contains(name) ? 'Tạo đơn hàng' : name;
    notifyListeners();
  }

  init() {
    initState();
  }

  Future getCustomerByCompany() async {
    _responseGetCustomers = await locator<Api>().getCustomerByCompany();

    _customers = _responseGetCustomers != null &&
            _responseGetCustomers!.customers != null
        ? _responseGetCustomers!.customers!
        : [];
    notifyListeners();
  }

  Future getNguyenVatLieuSanPham() async {
    _responseGetSanPhams =
        await locator<Api>().getNguyenVatLieuSanPham(type: 0);

    _nguyenVatLieuSanPhams = _responseGetSanPhams != null &&
            _responseGetSanPhams!.nguyenVatLieuSanPhams != null
        ? _responseGetSanPhams!.nguyenVatLieuSanPhams!
        : [];
    notifyListeners();
  }

  Future getVatTuSanPham() async {
    _responseGetVatTus = await locator<Api>().getNguyenVatLieuSanPham(type: 1);
    _nguyenVatLieuVatTus = _responseGetVatTus != null &&
            _responseGetVatTus!.nguyenVatLieuSanPhams != null
        ? _responseGetVatTus!.nguyenVatLieuSanPhams!
        : [];
    notifyListeners();
  }

  Future getChiTietDonHang() async {
    if (!["", null, false, 0].contains(_name)) {
      var response = await locator<Api>().getSingleHoaDonBanHang(_name!);

      if (response != null && response.order != null) {
        _order = response.order;
        if (_order!.status == 'Đã giao hàng') {
          _readOnlyView = true;
        }
        if (_order!.products != null && _order!.products.length > 0) {
          if (_order!.sellInWarehouse != 0) {
            for (var product in _order!.products) {
              _products.add(product);
              _productEditControllers.add({
                "kgController": TextEditingController(text: "${product.kg}"),
                "quantityController":
                    TextEditingController(text: "${product.quantity}")
              });
            }
            _readOnlyView = true;
          } else {
            var locations = [];
            for (var product in _order!.products) {
              _productForLocations.add(product);
              _productForLocationEditControllers.add({
                "kgController": TextEditingController(text: "${product.kg}"),
                "quantityController":
                    TextEditingController(text: "${product.quantity}")
              });
              if (!locations.contains(product.address)) {
                locations.add(product.address);

                List<Address>? listAdrress =
                    _responseGetDeliveryAddress != null &&
                            _responseGetDeliveryAddress!.addresses != null
                        ? _responseGetDeliveryAddress!.addresses
                        : [];

                var elements = listAdrress!
                    .where((element) => element.name == product.address)
                    .toList();

                if (elements != null && elements.length > 0) {
                  _addresses.add(elements[0]);
                  _readOnlyView = true;
                }
              }
            }
          }
          _customerValue = _order!.vendor;
          _sellInWarehouse = _order!.sellInWarehouse == 1;
          _responseGetDeliveryAddress = await locator<Api>()
              .getDeliveryAddress(customer: _customerValue as String);
        }
        notifyListeners();
      }
    }
  }

  Future getChiTietDonNhapKho() async {
    if (!["", null, false, 0].contains(_name)) {
      var response = await locator<Api>().getSingleDonNhapKho(_name!);
      if (response != null && response.donNhapKho != null) {
        _donNhapKho = response.donNhapKho;

        if (response != null && response.donNhapKho != null) {
          _donNhapKho = response.donNhapKho;
          if (_donNhapKho!.listShell != null &&
              _donNhapKho!.listShell.length > 0) {
            for (var shell in _donNhapKho!.listShell) {
              if (shell.type == "Nhập kho") {
                _nhapKhos.add(shell);
                _donNhapKhoEditControllers.add({
                  "quantityController":
                      TextEditingController(text: "${shell.amount}")
                });
              } else {
                _traVes.add(shell);
                _donTraVeEditControllers.add({
                  "quantityController":
                      TextEditingController(text: "${shell.amount}")
                });
              }
            }
          }
        }
      }
      notifyListeners();
    }
  }

  customerSelect(dynamic value) {
    _customerValue = value;
    notifyListeners();
  }

  sellInWarehouseSelection(bool? value) {
    _sellInWarehouse = value!;
    notifyListeners();
  }

  void disposed() {
    _signatureSupplierController.dispose();
    _signatureCustomerController.dispose();
    for (var productEditController in _productEditControllers) {
      productEditController["kgController"]!.dispose();
      productEditController["quantityController"]!.dispose();
    }

    for (var productForLocationEditController
        in _productForLocationEditControllers) {
      productForLocationEditController["kgController"]!.dispose();
      productForLocationEditController["quantityController"]!.dispose();
    }

    for (var donNhapKhoEditController in _donNhapKhoEditControllers) {
      donNhapKhoEditController["quantityController"]!.dispose();
    }

    for (var donTraVeEditController in _donTraVeEditControllers) {
      donTraVeEditController["quantityController"]!.dispose();
    }
  }

  void addSanPham() {
    _products.add(Product(
      actualKg: 0,
      actualQuantity: 0,
      address: "",
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
    _productEditControllers.add({
      "kgController": TextEditingController(),
      "quantityController": TextEditingController()
    });
    notifyListeners();
  }

  void addSanPhamByLocation(String address) {
    _productForLocations.add(Product(
      actualKg: 0,
      actualQuantity: 0,
      address: address,
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
    _productForLocationEditControllers.add({
      "kgController": TextEditingController(),
      "quantityController": TextEditingController()
    });
    notifyListeners();
  }

  addNhapKho() {
    _nhapKhos.add(
      DanhSachNhapKho(
        type: "Nhập kho",
        realName: null,
        amount: 0,
        title: '',
      ),
    );

    _donNhapKhoEditControllers
        .add({"quantityController": TextEditingController()});

    notifyListeners();
  }

  addTraVe() {
    _traVes.add(
      DanhSachNhapKho(
        type: "Trả về",
        realName: null,
        amount: 0,
        title: '',
      ),
    );

    _donTraVeEditControllers
        .add({"quantityController": TextEditingController()});

    notifyListeners();
  }

  changeState() {
    notifyListeners();
  }
}
