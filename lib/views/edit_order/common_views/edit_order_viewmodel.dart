import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/create_new_delivery_address_response.dart';
import 'package:frappe_app/model/customer.dart';
import 'package:frappe_app/model/danh_sach_nhap_kho.dart';
import 'package:frappe_app/model/don_nhap_kho.dart';
import 'package:frappe_app/model/file_upload_response.dart';
import 'package:frappe_app/model/get_customer_by_company_response.dart';
import 'package:frappe_app/model/get_delivery_address_response.dart';
import 'package:frappe_app/model/get_guyen_vat_lieu_san_pham_response.dart';
import 'package:frappe_app/model/giao_viec_signature.dart';
import 'package:frappe_app/model/nguyen_vat_lieu_san_pham.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/views/base_viewmodel.dart';
import 'package:frappe_app/views/customer_list_order/customer_list_order_view.dart';
import 'package:injectable/injectable.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class EditOrderViewModel extends BaseViewModel {
  late SignatureController _signatureCustomerController;
  late SignatureController _signatureSupplierController;

  Order? _order;

  List<UserRole> _userRoles = [];

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

  late List<Map<String, TextEditingController>> _donHoanTraEditControllers;

  late List<Product> _products;

  late List<Product> _productForLocations;

  late List<DanhSachNhapKho> _nhapKhos;

  late List<DanhSachNhapKho> _hoanTras;

  late List<DanhSachNhapKho> _traVes;

  DonNhapKho? _donNhapKho;

  late List<Address> _addresses;

  late List<Address> _editAddresses;

  late List<Customer> _customers;
  late List<NguyenVatLieuSanPham> _nguyenVatLieuVatTus;

  late List<NguyenVatLieuSanPham> _nguyenVatLieuSanPhams;

  GiaoViecSignatureResponse? _giaoViecSignatureResponse;

  late List<GiaoViecSignature> _giaoViecSignatures;

  late double _totalOrderPrice = 0;

  double get totalOrderPrice => _totalOrderPrice;

  List<GiaoViecSignature> get giaoViecSignatures => _giaoViecSignatures;

  // Object? _diaChiSelect;

  String? _customerValue;

  bool _sellInWarehouse = false;
  // bool _readOnlyView = false;
  bool _haveDelivery = false;

  int _isRated = 0;

  bool _saveTemplate = false;

  bool _isLoading = false;

  String? _name;

  String? _title;

  bool get isLoading => _isLoading;

  String get title => _title ?? '';

  bool get sellInWarehouse => _sellInWarehouse;

  bool get readOnlyView {
    if (_order != null) {
      if (['Chờ xác nhận', 'Đang giao hàng', 'Đã giao hàng', 'Đã hủy']
          .contains(_order!.status)) return true;

      if (_order!.status == "Đã đặt hàng" &&
          isAvailableRoles([UserRole.KhachHang])) return true;

      // if (_order!.status == 'Đã giao hàng') {
      //   return true;
      // }else if (_order!.status == 'Đang giao hàng') {
      //   return true;

    }

    return false;
  }

  bool get haveDelivery => _haveDelivery;

  int get isRated => _isRated;

  bool get saveTemplate => _saveTemplate;

  OrderState get orderState {
    return calculateState();
  }

  List<Map<String, TextEditingController>> get productEditControllers =>
      _productEditControllers;

  List<Map<String, TextEditingController>>
      get productForLocationEditControllers =>
          _productForLocationEditControllers;
  List<Map<String, TextEditingController>> get donNhapKhoEditControllers =>
      _donNhapKhoEditControllers;

  List<Map<String, TextEditingController>> get donTraVeEditControllers =>
      _donTraVeEditControllers;

  List<Map<String, TextEditingController>> get donHoanTraEditControllers =>
      _donHoanTraEditControllers;

  List<DanhSachNhapKho> get nhapKhos => _nhapKhos;

  List<DanhSachNhapKho> get traVes => _traVes;

  List<DanhSachNhapKho> get hoanTras => _hoanTras;

  List<UserRole> get userRoles {
    if (_userRoles.length == 0) {
      return Config().roles;
    }

    return _userRoles;
  }

  String? get customerValue => _customerValue;

  Order? get order => _order;

  late Config _config;

  Config? get config => _config;

  List<Customer> get customers => _customers;

  List<Address> get addresses => _addresses;

  List<Address> get editAddresses => _editAddresses;

  List<Product> get products => _products;
  List<Product> get productForLocations => _productForLocations;

  List<NguyenVatLieuSanPham> get nguyenVatLieuVatTus => _nguyenVatLieuVatTus;

  List<NguyenVatLieuSanPham> get nguyenVatLieuSanPhams =>
      _nguyenVatLieuSanPhams;

  SignatureController get signatureCustomerController =>
      _signatureCustomerController;

  SignatureController get signatureSupplierController =>
      _signatureSupplierController;

  OrderState calculateState() {
    if (_order != null) {
      switch (_order!.status) {
        case "Chờ xác nhận":
          return OrderState.WaitForComfirm;
        case "Đã đặt hàng":
          if (_haveDelivery)
            return OrderState.WaitingForShipment;
          else
            return OrderState.NewOrder;
        case "Đang giao hàng":
          return OrderState.Delivering;
        case "Đã giao hàng":
          return OrderState.Delivered;
        case "Đã hủy":
          return OrderState.Cancelled;
        default:
      }
    }

    return OrderState.PreNewOrder;
  }

  String get orderStatus {
    if (_order != null) {
      switch (_order!.status) {
        case "Đã đặt hàng":
          return 'Đã đặt';
        default:
      }
    }

    return '';
  }

  bool isAvailableRoles(List<UserRole> roles) {
    return _userRoles.any((element) => roles.contains(element));
  }

  initState() {
    // Save current role to  _userRoles variable;
    _userRoles = Config().roles;

    if (isAvailableRoles([UserRole.KhachHang])) {
      String customerCode = Config().customerCode;

      getCustomerByCode(customerCode);
      customerSelect(customerCode);
    }

    _giaoViecSignatures = [];

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

    _donHoanTraEditControllers = [];

    _config = Config();

    _products = [];
    // _readOnlyView = false;

    _productForLocations = [];

    _nhapKhos = [];
    _traVes = [];
    _hoanTras = [];
    _addresses = [];
    _editAddresses = [];

    _customers = [];
    _haveDelivery = false;

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
        attachSignatureCustomerImage: '',
        attachSignatureSupplierImage: "",
        cancelPerson: '',
        cancelReason: '',
        type: "B");

    _donNhapKho = DonNhapKho(
      codeOrders: _name != null ? _name! : '',
      name: '',
      company: '',
      title: '',
      status: '',
      listShell: [],
    );
  }

  setIsRated(int isRated) {
    _isRated = isRated;
  }

  setHaveDelivery(bool haveDelivery) {
    _haveDelivery = haveDelivery;
  }

  initPreData() async {
    if (!_userRoles.contains(UserRole.KhachHang)) {
      await getCustomerByCompany();
    }

    await getNguyenVatLieuSanPham();
    await getVatTuSanPham();
    await getChiTietDonHang();
    await getChiTietDonNhapKho();

    await getGiaoViecSignature();

    _isLoading = false;
    notifyListeners();
  }

  setName(String? name) {
    _name = name;
    _title = ["", null, false, 0].contains(name) ? 'Tạo đơn hàng' : name;
    notifyListeners();
  }

  init() {
    // if (_name != null && _name!.length > 0) {

    // }
    // if (["", null, false, 0].contains(_name) &&
    //     orderState == OrderState.PreNewOrder) return;
    _isLoading = true;
    initState();
  }

  saveTemplateOrder(bool enableToSave) {
    final String key = "order_template";

    if (enableToSave) {
      List<Map<String, dynamic>> listProduct = _products.map((value) {
        return {
          "actualKg": value.actualKg,
          "address": value.address,
          "kg": value.kg,
          "material": value.material,
          "product": value.product,
          "quantity": value.quantity,
          "status": value.status,
          "type": value.type,
          "unit": value.unit,
          "unitPrice": value.unitPrice,
        };
      }).toList();

      Config.set(key, jsonEncode(listProduct));
    } else
      Config.remove(key);

    _saveTemplate = enableToSave;
    notifyListeners();
  }

// customer logic code;
  Future getCustomerByCode(String customerCode) async {
    locator<Api>().getCusomterByCode(code: customerCode).then((response) {
      Customer? customer = response.customer;
      if (customer != null) {
        _customers = [customer];
        _customerValue = customerCode;
        notifyListeners();
      }
    });
  }

  GiaoViecSignature? getGiaoViecSignatureByAddress(String address) {
    var giaoViecSignatureByAddress = _giaoViecSignatures
        .where((element) => element.address == address)
        .toList();

    if (giaoViecSignatureByAddress != null &&
        giaoViecSignatureByAddress.length > 0) {
      return giaoViecSignatureByAddress[0];
    }

    return null;
  }

  Future getCustomerByCompany() async {
    _responseGetCustomers = await locator<Api>().getCustomerByCompany();

    _customers = _responseGetCustomers != null &&
            _responseGetCustomers!.customers != null
        ? _responseGetCustomers!.customers!
        : [];

    notifyListeners();
  }

  Future getGiaoViecSignature() async {
    if (!["", null, false, 0].contains(_name)) {
      _giaoViecSignatureResponse =
          await locator<Api>().getGiaoViecSignature(_name!);

      _giaoViecSignatures = _giaoViecSignatureResponse != null &&
              _giaoViecSignatureResponse!.message != null
          ? _giaoViecSignatureResponse!.message
          : [];
    }
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

        if (_order!.products != null && _order!.products.length > 0) {
          // get total price of an order
          _totalOrderPrice = _order!.products.fold(0, (pv, cu) {
            return pv + cu.unitPrice;
          });

          _customerValue = _order!.vendor;
          _sellInWarehouse = _order!.sellInWarehouse == 1;

          _responseGetDeliveryAddress = await locator<Api>()
              .getDeliveryAddress(customer: _customerValue as String);
          _addresses = _responseGetDeliveryAddress != null &&
                  _responseGetDeliveryAddress!.addresses != null
              ? _responseGetDeliveryAddress!.addresses!
              : [];
          if (_order!.sellInWarehouse != 0) {
            for (var product in _order!.products) {
              _products.add(product);
              _productEditControllers.add({
                "kgController": TextEditingController(text: "${product.kg}"),
                "quantityController":
                    TextEditingController(text: "${product.quantity}")
              });
            }
            // TODO: Nếu lỗi xem lại tại đây
            // _readOnlyView = true;
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
                  _editAddresses.add(elements[0]);
                  // _readOnlyView = true;
                }
              }
            }
          }
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

  customerSelect(dynamic value) async {
    _customerValue = value;
    var response = await locator<Api>().getDeliveryAddress(customer: value);
    _responseGetDeliveryAddress = response;
    _addresses = _responseGetDeliveryAddress != null &&
            _responseGetDeliveryAddress!.addresses != null
        ? _responseGetDeliveryAddress!.addresses!
        : [];
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

    for (var donHoanTraEditController in _donHoanTraEditControllers) {
      donHoanTraEditController["quantityController"]!.dispose();
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
      enabledVatTu: false,
      enabledKG: false,
      diaChi: "",
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
      enabledVatTu: false,
      enabledKG: false,
      diaChi: "",
    ));
    _productForLocationEditControllers.add({
      "kgController": TextEditingController(),
      "quantityController": TextEditingController()
    });
    notifyListeners();
  }

  addNhapKho({String address = ''}) {
    _nhapKhos.add(
      DanhSachNhapKho(
        type: "Nhập kho",
        realName: null,
        amount: 0,
        title: '',
        address: address,
      ),
    );

    _donNhapKhoEditControllers
        .add({"quantityController": TextEditingController()});

    notifyListeners();
  }

  addTraVe({String address = ''}) {
    _traVes.add(
      DanhSachNhapKho(
        type: "Trả về",
        realName: null,
        amount: 0,
        title: '',
        address: address,
      ),
    );

    _donTraVeEditControllers
        .add({"quantityController": TextEditingController()});

    notifyListeners();
  }

  addAddress() {
    _editAddresses.add(
      Address(
        name: null,
        diaChi: '',
        customer: _customerValue as String,
        isEnable: false,
        isEditable: false,
      ),
    );
  }

  changeState() {
    notifyListeners();
  }

  clearSignatureCustomer() {
    _signatureCustomerController = new SignatureController();
    notifyListeners();
  }

  clearSignatureSupplier() {
    _signatureSupplierController = new SignatureController();
    notifyListeners();
  }

  Future customerCreateOrder(BuildContext context) async {
    try {
      Customer customer = _customers[0];

      _order!.email = customer.email;
      _order!.paymentStatus = 'Chưa thanh toán';
      _order!.phone = customer.phone;
      _order!.products = _productForLocations;
      _order!.sellInWarehouse = 0;
      _order!.status = "Chờ xác nhận";
      _order!.taxId = customer.taxId;
      _order!.totalCost = 0;
      _order!.vendor = customer.code;
      _order!.vendorName = customer.realName;
      _order!.type = 'B';
      _order!.vendorAddress = '';
      _order!.vendorName = customer.realName;

      var createOrderResponse =
          await locator<Api>().createHoaDonMuaBan(_order!);

      FrappeAlert.successAlert(
          title: 'Tạo đơn thành công',
          context: context,
          subtitle: 'Tạo đơn hàng thành công.');
    } catch (err) {
      FrappeAlert.errorAlert(
          title: 'Error',
          context: context,
          subtitle: 'Có lỗi xảy ra, vui lòng thử lại sau.');
    }
  }

  Future createOrder(context, {String type = 'B'}) async {
    if (_userRoles.contains(UserRole.KhachHang)) {
      await customerCreateOrder(context);
      return;
    }

    Attachments? customerAttachmemts;
    Attachments? supplierAttachments;
    if (order!.sellInWarehouse == 1) {
      var imgId = Uuid().v1().toString();
      var customerBytes = await _signatureCustomerController.toPngBytes();
      if (customerBytes != null) {
        var responseUploadCustomer = await locator<Api>().uploadFileForBytes(
          doctype: 'HLGas_HoaDonMuaBan',
          name: _name!, //
          file: GasFile(
            file: customerBytes,
            fileName: 'hlgas_hoadonmuaban-$imgId.png',
            fieldName: 'attach_signature_customer_image',
          ),
        );

        if (responseUploadCustomer != null &&
            responseUploadCustomer.attachments != null) {
          customerAttachmemts = responseUploadCustomer.attachments;
        } else {
          customerAttachmemts = null;
        }
      } else {
        FrappeAlert.errorAlert(
            title: 'Tạo mới không thành công',
            context: context,
            subtitle: 'Bạn cần có chữ ký khách hàng trước khi hoàn thành đơn.');
        return;
      }

      imgId = Uuid().v1().toString();
      var supplierBytes = await _signatureSupplierController.toPngBytes();
      if (supplierBytes != null) {
        var responseUploadSupplier = await locator<Api>().uploadFileForBytes(
          doctype: 'HLGas_HoaDonMuaBan',
          name: _name!, //
          file: GasFile(
            file: supplierBytes,
            fileName: 'hlgas_hoadonmuaban-$imgId.png',
            fieldName: 'attach_signature_supplier_image',
          ),
        );

        if (responseUploadSupplier != null &&
            responseUploadSupplier.attachments != null) {
          supplierAttachments = responseUploadSupplier.attachments;
        } else {
          supplierAttachments = null;
        }
      } else {
        FrappeAlert.errorAlert(
            title: 'Tạo mới không thành công',
            context: context,
            subtitle:
                'Bạn cần có chữ ký nhà cung cấp trước khi hoàn thành đơn.');
        return;
      }
    }

    // if (!_sellInWarehouse) {
    //   for
    // }

    List<Customer>? customers = _responseGetCustomers != null &&
            _responseGetCustomers!.customers != null
        ? _responseGetCustomers!.customers
        : [];

    var elements =
        customers!.where((element) => element.code == _customerValue).toList();

    if (elements != null && elements.length > 0) {
      _order!.email = elements[0].email;
      _order!.paymentStatus = 'Chưa thanh toán';
      _order!.phone = elements[0].phone;
      _order!.products = _sellInWarehouse ? _products : _productForLocations;
      _order!.sellInWarehouse = _sellInWarehouse ? 1 : 0;
      _order!.status = !_sellInWarehouse ? "Đã đặt hàng" : "Đã giao hàng";
      _order!.taxId = elements[0].taxId;
      _order!.totalCost = 0;
      _order!.vendor = elements[0].code;

      _order!.vendorAddress = '';

      _order!.type = type;

      _order!.vendorName = elements[0].realName;
      _order!.attachSignatureCustomerImage =
          customerAttachmemts != null ? customerAttachmemts.fileUrl : '';

      _order!.attachSignatureSupplierImage =
          supplierAttachments != null ? supplierAttachments.fileUrl : '';

      var createOrderResponse =
          await locator<Api>().createHoaDonMuaBan(_order!);

      if (createOrderResponse != null &&
          createOrderResponse.responseData != null) {
        _donNhapKho!.codeOrders = createOrderResponse.responseData.data;
        _donNhapKho!.status = _order!.status;
        _donNhapKho!.listShell = [...nhapKhos, ...traVes];
        _name = createOrderResponse.responseData.data;
        _title = createOrderResponse.responseData.data;

        var createDonNhapKhoResponse =
            await locator<Api>().createDonNhapKho(_donNhapKho!);

        if (createDonNhapKhoResponse != null &&
            createDonNhapKhoResponse.responseData != null) {
          FrappeAlert.successAlert(
              title: 'Tạo đơn thành công',
              context: context,
              subtitle: 'Tạo đơn hàng thành công.');
        }

        _haveDelivery = false;

        var donBanHangResponse =
            await locator<Api>().getSingleHoaDonBanHang(_name!);

        if (donBanHangResponse != null && donBanHangResponse.order != null) {
          _order = donBanHangResponse.order;
        }

        var donNhapKhoResponse =
            await locator<Api>().getSingleDonNhapKho(_name!);
        if (donNhapKhoResponse != null &&
            donNhapKhoResponse.donNhapKho != null) {
          _donNhapKho = donNhapKhoResponse.donNhapKho;
        }

        notifyListeners();
      } else {
        FrappeAlert.errorAlert(
            title: 'Lỗi xảy ra',
            context: context,
            subtitle:
                'Tạo đơn hàng không thành công, có lỗi khi tạo đơn hàng!');
      }
    } else {
      FrappeAlert.errorAlert(
          title: 'Lỗi xảy ra',
          context: context,
          subtitle: 'Không có khách hàng, xin hãy chọn khách hàng!');
    }
  }

  Future updateOrder(context, {String status = '', String type = 'B'}) async {
    Attachments? customerAttachmemts;
    Attachments? supplierAttachments;
    if (order!.sellInWarehouse == 1) {
      var imgId = Uuid().v1().toString();
      var customerBytes = await _signatureCustomerController.toPngBytes();
      if (customerBytes != null) {
        var responseUploadCustomer = await locator<Api>().uploadFileForBytes(
          doctype: 'HLGas_HoaDonMuaBan',
          name: _name!, //
          file: GasFile(
            file: customerBytes,
            fileName: 'hlgas_hoadonmuaban-$imgId.png',
            fieldName: 'attach_signature_customer_image',
          ),
        );

        if (responseUploadCustomer != null &&
            responseUploadCustomer.attachments != null) {
          customerAttachmemts = responseUploadCustomer.attachments;
        } else {
          customerAttachmemts = null;
        }
      }

      imgId = Uuid().v1().toString();
      var supplierBytes = await _signatureSupplierController.toPngBytes();
      if (supplierBytes != null) {
        var responseUploadSupplier = await locator<Api>().uploadFileForBytes(
          doctype: 'HLGas_HoaDonMuaBan',
          name: _name!, //
          file: GasFile(
            file: supplierBytes,
            fileName: 'hlgas_hoadonmuaban-$imgId.png',
            fieldName: 'attach_signature_supplier_image',
          ),
        );

        if (responseUploadSupplier != null &&
            responseUploadSupplier.attachments != null) {
          supplierAttachments = responseUploadSupplier.attachments;
        } else {
          supplierAttachments = null;
        }
      }
    }

    List<Customer>? customers = _responseGetCustomers != null &&
            _responseGetCustomers!.customers != null
        ? _responseGetCustomers!.customers
        : [];

    var elements =
        customers!.where((element) => element.code == _order!.vendor).toList();

    if (elements != null && elements.length > 0) {
      _order!.email = elements[0].email;
      _order!.paymentStatus = 'Chưa thanh toán';
      _order!.phone = elements[0].phone;
      _order!.products = _sellInWarehouse ? _products : _productForLocations;
      _order!.sellInWarehouse = _sellInWarehouse ? 1 : 0;
      _order!.status = ["", null, false, 0].contains(status)
          ? !_sellInWarehouse
              ? "Đã đặt hàng"
              : "Đã giao hàng"
          : status;
      _order!.taxId = elements[0].taxId;
      _order!.totalCost = 0;
      _order!.vendor = elements[0].code;

      _order!.vendorAddress = '';

      _order!.type = type;

      _order!.vendorName = elements[0].realName;
      _order!.attachSignatureCustomerImage =
          customerAttachmemts != null ? customerAttachmemts.fileUrl : '';

      _order!.attachSignatureSupplierImage =
          supplierAttachments != null ? supplierAttachments.fileUrl : '';

      var uploadHoaDonMuaBan = await locator<Api>().updateHoaDonMuaBan(_order!);

      if (uploadHoaDonMuaBan != null &&
          uploadHoaDonMuaBan.responseData != null) {
        _donNhapKho!.codeOrders = _name!;
        _donNhapKho!.status = _order!.status;
        _donNhapKho!.listShell = [...nhapKhos, ...traVes];
        var updateDonNhapKhoResponse =
            await locator<Api>().updateDonNhapKho(_donNhapKho!);
        if (updateDonNhapKhoResponse != null &&
            updateDonNhapKhoResponse.responseData != null) {
          notifyListeners();
          FrappeAlert.successAlert(
              title: 'Cập nhật thành công',
              context: context,
              subtitle: 'Cập nhật đơn hàng thành công.');
        }
      } else {
        FrappeAlert.errorAlert(
            title: 'Lỗi xảy ra',
            context: context,
            subtitle: 'Không cập nhật được đơn hàng!');
      }
    } else {
      FrappeAlert.errorAlert(
        title: 'Lỗi xảy ra',
        context: context,
        subtitle: 'Không có khách hàng, xin hãy chọn khách hàng!',
      );
    }
    notifyListeners();
  }

  Future<void> cancelOrder(context) async {
    try {
      _order!.status = "Đã hủy";
      _order!.cancelPerson = Config().customerCode;
      _order!.cancelDate = DateTime.now();

      await locator<Api>().updateHoaDonMuaBan(_order!);

      FrappeAlert.successAlert(
          title: 'Success',
          context: context,
          subtitle: 'Hủy đơn hàng thành công.');

      Navigator.pop(context, true);
    } catch (err) {
      Navigator.pop(context, true);
      FrappeAlert.errorAlert(
        title: 'Error',
        context: context,
        subtitle: 'Có lỗi xảy ra, vui lòng thử lại sau!',
      );
    }
  }

  Future deleteOrder(BuildContext context, String orderName) async {
    try {
      await locator<Api>().deleteDonMuaBan(orderName);

      FrappeAlert.successAlert(
          title: "Success",
          subtitle: "Xóa đơn hàng thành công.",
          context: context);

      Navigator.pop(context, true);
    } catch (e) {
      FrappeAlert.successAlert(
          title: "Error",
          subtitle: "Có lỗi xảy ra, vui lòng thử lại sau!",
          context: context);
    }
  }

  Future updateGiaoViecSignature(context,
      {String status = '', String address = ''}) async {
    Attachments? customerAttachmemts;
    Attachments? supplierAttachments;
    var imgId = Uuid().v1().toString();
    var customerBytes = await _signatureCustomerController.toPngBytes();
    if (customerBytes != null) {
      var responseUploadCustomer = await locator<Api>().uploadFileForBytes(
        doctype: 'HLGas_GiaoViec_Signature',
        name: _name!, //
        file: GasFile(
          file: customerBytes,
          fileName: 'hlgas_giaoviec_signature-$imgId.png',
          fieldName: 'attach_signature_customer_image',
        ),
      );

      if (responseUploadCustomer != null &&
          responseUploadCustomer.attachments != null) {
        customerAttachmemts = responseUploadCustomer.attachments;
      } else {
        customerAttachmemts = null;
      }
    }

    imgId = Uuid().v1().toString();
    var supplierBytes = await _signatureSupplierController.toPngBytes();
    if (supplierBytes != null) {
      var responseUploadSupplier = await locator<Api>().uploadFileForBytes(
        doctype: 'HLGas_GiaoViec_Signature',
        name: _name!, //
        file: GasFile(
          file: supplierBytes,
          fileName: 'hlgas_giaoviec_signature-$imgId.png',
          fieldName: 'attach_signature_deliver_image',
        ),
      );

      if (responseUploadSupplier != null &&
          responseUploadSupplier.attachments != null) {
        supplierAttachments = responseUploadSupplier.attachments;
      } else {
        supplierAttachments = null;
      }
    }

    await locator<Api>().updateGiaoViecSignature(
        _order!.name,
        status != null && status != '' ? status : _order!.status,
        address,
        customerAttachmemts != null ? customerAttachmemts.fileUrl : '',
        supplierAttachments != null ? supplierAttachments.fileUrl : '');

    // if(updateGiaoViecSignatureResponse != null) {

    // }

    notifyListeners();
  }
}

enum OrderState {
  WaitForComfirm,
  PreNewOrder,
  NewOrder,
  WaitingForShipment,
  Delivering,
  Delivered,
  Cancelled
}
