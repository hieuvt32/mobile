import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/create_new_delivery_address_response.dart';
import 'package:frappe_app/model/create_tracking_request.dart';
import 'package:frappe_app/model/customer.dart';
import 'package:frappe_app/model/danh_sach_nhap_kho.dart';
import 'package:frappe_app/model/don_gia_mua_ban.dart';
import 'package:frappe_app/model/don_nhap_kho.dart';
import 'package:frappe_app/model/file_upload_response.dart';
import 'package:frappe_app/model/get_customer_by_company_response.dart';
import 'package:frappe_app/model/get_delivery_address_response.dart';
import 'package:frappe_app/model/get_guyen_vat_lieu_san_pham_response.dart';
import 'package:frappe_app/model/giao_viec_signature.dart';
import 'package:frappe_app/model/nguyen_vat_lieu_san_pham.dart';
import 'package:frappe_app/model/offline_storage.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/model/response_data.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/views/base_viewmodel.dart';
import 'package:frappe_app/views/customer_list_order/customer_list_order_view.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class EditOrderViewModel extends BaseViewModel {
  // Start: controller editing data
  late SignatureController _signatureCustomerController;
  late SignatureController _signatureSupplierController;
  late List<Map<String, TextEditingController>> _productEditControllers;
  late Map<String, List<Map<String, TextEditingController>>>
      _productForLocationEditControllerMap;
  late List<Map<String, TextEditingController>> _donNhapKhoEditControllers;
  late List<Map<String, TextEditingController>> _donTraVeEditControllers;
  late List<Map<String, TextEditingController>> _donHoanTraEditControllers;
  late List<TextEditingController> _addressControllers;
  // End: controller editing data

  // Start: data store
  Order? _order;
  List<UserRole> _userRoles = [];
  late List<Product> _products;
  late List<Product> _productForLocations;
  late List<DanhSachNhapKho> _nhapKhos;
  late List<DanhSachNhapKho> _hoanTras;
  late List<DanhSachNhapKho> _traVes;
  DonNhapKho? _donNhapKho;
  late List<Address> _addresses;
  late List<Address> _editAddresses;
  late List<Customer> _customers;
  late List<Customer> _manufactures;
  late List<DonGiaMuaBan> _donGiaMuaBans;
  late List<NguyenVatLieuSanPham> _nguyenVatLieuVatTus;
  late List<NguyenVatLieuSanPham> _nguyenVatLieuSanPhams;
  late List<GiaoViecSignature> _giaoViecSignatures;
  late List<BienSoXe> _bienSoXes;
  late List<Employee> _employees;
  late double _totalOrderPrice = 0;
  late bool _isNhaCungCap = false;
  late GiaoViec giaoViec;
  String? _customerValue;
  bool _sellInWarehouse = false;
  bool _haveDelivery = false;
  int _isRated = 0;
  bool _saveTemplate = false;
  bool _isLoading = false;
  String? _name;
  String? _title;
  late Config _config;
  bool isCreateScreen = false;
  late bool _isSaved = false;
  // End: data store

  final String key = "order_template";

  storeData() {
    try {
      var editOrderViewModel = {
        "order": _order,
        // "user_roles": _userRoles,
        "products": products,
        "product_for_locations": _productForLocations,
        "nhap_khos": _nhapKhos,
        "hoan_tras": _hoanTras,
        "tra_ves": _traVes,
        "don_nhap_kho": _donNhapKho,
        "addresses": _addresses,
        "edit_addresses": _editAddresses,
        "customers": _customers,
        "manufactures": _manufactures,
        "don_gia_mua_bans": _donGiaMuaBans,
        "nguyen_vat_lieu_vat_tus": _nguyenVatLieuVatTus,
        "nguyen_vat_lieu_san_phams": _nguyenVatLieuSanPhams,
        "giao_viec_signatures": _giaoViecSignatures,
        "bien_so_xes": _bienSoXes,
        "employees": _employees,
        "total_order_price": _totalOrderPrice,
        "is_nha_cung_cap": _isNhaCungCap,
        "giao_viec": giaoViec,
        "customer_value": _customerValue,
        "sell_in_warehouse": _sellInWarehouse,
        "have_delivery": _haveDelivery,
        "is_rated": _isRated,
        "save_template": _saveTemplate,
        "name": _name,
        "title": _title,
        "is_saved": _isSaved,
      };

      var jsonData = jsonEncode(editOrderViewModel);

      Config.set(
        key,
        jsonData,
      );
    } catch (e) {
      print(e);
    }
  }

  loadStoreData() async {
    try {
      Config.remove(key);
      if (Config.containsKey(key)) {
        var jsonData = Config.get(key);

        var data = jsonDecode(jsonData);

        if (!data["is_saved"] || data['save_template']) {
          _order = Order.fromJson(data["order"]);

          _products = (data["products"] as List<dynamic>)
              .map((e) => Product.fromJson(e))
              .toList();

          _productForLocations =
              (data["product_for_locations"] as List<dynamic>)
                  .map((e) => Product.fromJson(e))
                  .toList();

          _sellInWarehouse = data["sell_in_warehouse"];

          _isNhaCungCap = data["is_nha_cung_cap"];

          // get total price of an order
          _totalOrderPrice = data["total_order_price"];

          _customerValue = data["customer_value"];

          _addresses = (data["addresses"] as List<dynamic>)
              .map((e) => Address.fromJson(e))
              .toList();

          _editAddresses = (data["edit_addresses"] as List<dynamic>)
              .map((e) => Address.fromJson(e))
              .toList();

          if (_sellInWarehouse || _isNhaCungCap) {
            for (var product in _products) {
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

            var mapData = groupBy<Product, String>(
                _productForLocations, (obj) => obj.address);
            for (var product in _productForLocations) {
              // _productForLocations.add(product);

              if (!locations.contains(product.address)) {
                locations.add(product.address);

                _addressControllers.add(TextEditingController());

                // List<Address>? listAdrress = _addresses;

                // var elements = listAdrress
                //     .where((element) => element.name == product.address)
                //     .toList();

                // if (elements != null && elements.length > 0) {
                //   _editAddresses.add(elements[0]);
                // }
                if (mapData.containsKey(product.address)) {
                  var products = mapData[product.address]!.toList();
                  List<Map<String, TextEditingController>> mapChildData = [];
                  for (int i = 0; i < products.length; i++) {
                    mapChildData.add({
                      "kgController":
                          TextEditingController(text: "${products[i].kg}"),
                      "quantityController":
                          TextEditingController(text: "${products[i].quantity}")
                    });
                  }
                  if (!_productForLocationEditControllerMap
                      .containsKey(product.address))
                    _productForLocationEditControllerMap[product.address] =
                        mapChildData;
                }
              }
            }
          }
          changeState(isSaving: false);
        } else
          Config.remove(key);
      }
    } catch (e) {
      print(e);
    }
  }

  // Start: public get value
  double get totalOrderPrice => _totalOrderPrice;
  List<GiaoViecSignature> get giaoViecSignatures => _giaoViecSignatures;
  List<BienSoXe> get bienSoXes => _bienSoXes;
  List<Employee> get employees => _employees;
  List<DonGiaMuaBan> get donGiaMuaBans => _donGiaMuaBans;
  DonNhapKho? get donNhapKho => _donNhapKho;
  bool get isLoading => _isLoading;
  String get title => _title ?? '';
  bool get sellInWarehouse {
    _order!.sellInWarehouse = _sellInWarehouse ? 1 : 0;
    return _sellInWarehouse;
  }

  bool get readOnlyView {
    if (_order != null) {
      if (['Chờ xác nhận', 'Đang giao hàng', 'Đã giao hàng', 'Đã hủy']
          .contains(_order!.status)) return true;

      if (_order!.status == "Đã đặt hàng" &&
          isAvailableRoles([UserRole.KhachHang, UserRole.DieuPhoi]))
        return true;

      if (_order!.status == "Đã đặt hàng" && _isNhaCungCap) return true;

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
  Map<String, List<Map<String, TextEditingController>>>
      get productForLocationEditControllerMap =>
          _productForLocationEditControllerMap;
  List<Map<String, TextEditingController>> get donNhapKhoEditControllers =>
      _donNhapKhoEditControllers;
  List<Map<String, TextEditingController>> get donTraVeEditControllers =>
      _donTraVeEditControllers;
  List<Map<String, TextEditingController>> get donHoanTraEditControllers =>
      _donHoanTraEditControllers;
  List<TextEditingController> get addressControllers => _addressControllers;

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
  Config? get config => _config;
  List<Customer> get customers => _customers;
  List<Customer> get manufactures => _manufactures;
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
      return _order!.status;
    }

    return '';
  }
  // End: public get value

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

    giaoViec = GiaoViec(
        deliverDate: DateTime.now().toString(),
        plate: null,
        supportEmployee: null,
        order: _name,
        employee: null);

    _giaoViecSignatures = [];

    _donGiaMuaBans = [];

    _addressControllers = [];

    _signatureSupplierController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    _signatureCustomerController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    _productEditControllers = [];
    _productForLocationEditControllerMap = Map();

    _donNhapKhoEditControllers = [];
    _donTraVeEditControllers = [];

    _donHoanTraEditControllers = [];

    _isSaved = false;

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
      reasonEdit: '',
    );
  }

  setIsRated(int isRated) {
    _isRated = isRated;
  }

  setHaveDelivery(bool haveDelivery) {
    _haveDelivery = haveDelivery;
  }

  setIsNhaCungCap(bool isNhaCungCap) {
    _isNhaCungCap = isNhaCungCap;
  }

  initPreData() async {
    if (!_userRoles.contains(UserRole.KhachHang)) {
      await getCustomerByCompany();
    }

    await getManufactureByCompany();

    await getNguyenVatLieuSanPham();
    await getVatTuSanPham();
    await getChiTietDonHang();
    await getChiTietDonNhapKho();
    await getGiaoViecSignature();
    await getGiaoViec();

    await getDSBienSoXe();
    await getDSEmployeeByCompany();

    await getDonGiaMuaBans();

    _isLoading = false;
    changeState();
  }

  setName(String? name) {
    _name = name;
    _title = ["", null, false, 0].contains(name) ? 'Tạo đơn hàng' : name;
    changeState();
  }

  init() {
    // if (_name != null && _name!.length > 0) {

    // }
    // if (["", null, false, 0].contains(_name) &&
    //     orderState == OrderState.PreNewOrder) return;
    _isLoading = true;
    initState();
  }

  Future confirmEditingRequest(BuildContext context) async {
    try {
      _donNhapKho!.status = "Đã xác nhận";
      _donNhapKho!.reasonEdit = "";
      await locator<Api>().updateDonNhapKho(_donNhapKho!);

      FrappeAlert.successAlert(
          title: "Thông báo",
          subtitle: "Có lỗi xảy ra, vui lòng thử lại sau!",
          context: context);

      changeState();
    } catch (err) {
      FrappeAlert.errorAlert(
          title: "Thông báo",
          subtitle: "Có lỗi xảy ra, vui lòng thử lại sau!",
          context: context);
    }
  }

  Future confirmKhongXacNhan(BuildContext context,
      {String status = "", String reasonEdit = ""}) async {
    try {
      _donNhapKho!.status = status;
      _donNhapKho!.reasonEdit = reasonEdit;
      await locator<Api>().updateDonNhapKho(_donNhapKho!);

      FrappeAlert.successAlert(
          title: "Thông báo",
          subtitle: "Có lỗi xảy ra, vui lòng thử lại sau!",
          context: context);

      changeState();
    } catch (err) {
      FrappeAlert.errorAlert(
          title: "Thông báo",
          subtitle: "Có lỗi xảy ra, vui lòng thử lại sau!",
          context: context);
    }
  }

  Future confirmOrder(BuildContext context) async {
    try {
      if (_order!.status == "Chờ xác nhận") {
        _order!.status = "Đã đặt hàng";
        await locator<Api>().updateHoaDonMuaBan(order!);

        FrappeAlert.successAlert(
            title: "Thông báo",
            subtitle: "Xác nhận đơn hàng thành công",
            context: context);

        changeState();
      } else {
        throw Error();
      }
    } catch (err) {
      FrappeAlert.errorAlert(
          title: "Thông báo",
          subtitle: "Có lỗi xảy ra, vui lòng thử lại sau",
          context: context);
    }
  }

  saveTemplateOrder(bool enableToSave) {
    final String key = "order_template";

    if (enableToSave) {
      // List<Map<String, dynamic>> listProduct = _products.map((value) {
      //   return {
      //     "actualKg": value.actualKg,
      //     "address": value.address,
      //     "kg": value.kg,
      //     "material": value.material,
      //     "product": value.product,
      //     "quantity": value.quantity,
      //     "status": value.status,
      //     "type": value.type,
      //     "unit": value.unit,
      //     "unitPrice": value.unitPrice,
      //   };
      // }).toList();

      // Config.set(key, jsonEncode(listProduct));
      storeData();
    }
    // else
    //   Config.remove(key);

    _saveTemplate = enableToSave;
    changeState();
  }

  // customer logic code;
  Future getCustomerByCode(String customerCode) async {
    locator<Api>().getCusomterByCode(code: customerCode).then((response) {
      Customer? customer = response.customer;
      if (customer != null) {
        _customers = [customer];
        _customerValue = customerCode;
        changeState();
      }
    });
  }

  Future refuseOrder(String reason) async {}

  void addGiaoViecSignature(GiaoViecSignature giaoViecSignature) {
    _giaoViecSignatures.add(giaoViecSignature);
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

  Future getDonGiaMuaBans() async {
    var response = await locator<Api>().getDonGiaMuaBans();

    _donGiaMuaBans = response != null && response.donGiaMuaBans != null
        ? response.donGiaMuaBans!
        : [];

    changeState();
  }

  DonGiaMuaBan? getSingleDonGiaMuaBan(String realName) {
    var donGiaMuaBan = _donGiaMuaBans
        .where((element) => element.realName == realName)
        .toList();

    if (donGiaMuaBan != null && donGiaMuaBan.length > 0) {
      return donGiaMuaBan[0];
    }

    return null;
  }

  Future getCustomerByCompany() async {
    var response = await locator<Api>().getCustomerByCompany();

    _customers = response != null && response.customers != null
        ? response.customers!
        : [];

    changeState();
  }

  Future getManufactureByCompany() async {
    var response = await locator<Api>().getManufactureByCompany();

    _manufactures = response != null && response.customers != null
        ? response.customers!
        : [];

    changeState();
  }

  Future getGiaoViecSignature() async {
    if (!["", null, false, 0].contains(_name)) {
      var response = await locator<Api>().getGiaoViecSignature(_name!);

      _giaoViecSignatures =
          response != null && response.message != null ? response.message : [];
    }
    changeState();
  }

  Future getNguyenVatLieuSanPham() async {
    var response = await locator<Api>().getNguyenVatLieuSanPham(type: 0);

    _nguyenVatLieuSanPhams =
        response != null && response.nguyenVatLieuSanPhams != null
            ? response.nguyenVatLieuSanPhams!
            : [];
    changeState();
  }

  Future getVatTuSanPham() async {
    var response = await locator<Api>().getNguyenVatLieuSanPham(type: 1);
    _nguyenVatLieuVatTus =
        response != null && response.nguyenVatLieuSanPhams != null
            ? response.nguyenVatLieuSanPhams!
            : [];
    changeState();
  }

  Future getDSBienSoXe() async {
    var response = await locator<Api>().getDSBienSoXe();
    _bienSoXes = response != null && response.data != null
        ? (response.data as List<dynamic>)
            .map((e) => BienSoXe.fromJson(e))
            .toList()
        : [];
    changeState();
  }

  Future getGiaoViec() async {
    if (!["", null, false, 0].contains(_order!.name)) {
      var response = await locator<Api>().getGiaoViec(_order!.name);
      giaoViec = response != null && response.message != null
          ? response.message!
          : giaoViec;
    }
    changeState();
  }

  Future getDSEmployeeByCompany() async {
    var response = await locator<Api>().getDSEmployeeByCompany();
    _employees = response != null && response.data != null
        ? (response.data as List<dynamic>)
            .map((e) => Employee.fromJson(e))
            .toList()
        : [];
    changeState();
  }

  Future getChiTietDonHang() async {
    if (!["", null, false, 0].contains(_name)) {
      var response = await locator<Api>().getSingleHoaDonBanHang(_name!);

      if (response != null && response.order != null) {
        _order = response.order;

        if (_order!.products != null && _order!.products.length > 0) {
          // get total price of an order
          _totalOrderPrice = _order!.totalCost;

          _customerValue = _order!.vendor;
          _sellInWarehouse = _order!.sellInWarehouse == 1;

          var responseGetDeliveryAddress = await locator<Api>()
              .getDeliveryAddress(customer: _customerValue as String);
          _addresses = responseGetDeliveryAddress != null &&
                  responseGetDeliveryAddress.addresses != null
              ? responseGetDeliveryAddress.addresses!
              : [];
          if (_order!.sellInWarehouse != 0 || _isNhaCungCap) {
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

            var mapData = groupBy<Product, String>(
                _order!.products, (obj) => obj.address);
            for (var product in _order!.products) {
              _productForLocations.add(product);

              if (!locations.contains(product.address)) {
                locations.add(product.address);

                _addressControllers.add(TextEditingController());

                List<Address>? listAdrress =
                    responseGetDeliveryAddress != null &&
                            responseGetDeliveryAddress.addresses != null
                        ? responseGetDeliveryAddress.addresses
                        : [];

                var elements = listAdrress!
                    .where((element) => element.name == product.address)
                    .toList();

                if (elements != null && elements.length > 0) {
                  _editAddresses.add(elements[0]);
                }
                if (mapData.containsKey(product.address)) {
                  var products = mapData[product.address]!.toList();
                  List<Map<String, TextEditingController>> mapChildData = [];
                  for (int i = 0; i < products.length; i++) {
                    mapChildData.add({
                      "kgController":
                          TextEditingController(text: "${products[i].kg}"),
                      "quantityController":
                          TextEditingController(text: "${products[i].quantity}")
                    });
                  }
                  if (!_productForLocationEditControllerMap
                      .containsKey(product.address))
                    _productForLocationEditControllerMap[product.address] =
                        mapChildData;
                }
              }
            }
          }
        }
        changeState();
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
      changeState();
    }
  }

  customerSelect(dynamic value) async {
    _customerValue = value;
    var response = await locator<Api>().getDeliveryAddress(customer: value);
    _addresses = response != null && response.addresses != null
        ? response.addresses!
        : [];
    changeState();
  }

  sellInWarehouseSelection(bool? value) {
    _sellInWarehouse = value!;
    changeState();
  }

  void disposed() {
    _signatureSupplierController.dispose();
    _signatureCustomerController.dispose();
    for (var productEditController in _productEditControllers) {
      productEditController["kgController"]!.dispose();
      productEditController["quantityController"]!.dispose();
    }

    for (var editAddress in _editAddresses) {
      if (_productForLocationEditControllerMap.containsKey(editAddress.name)) {
        for (var controller
            in _productForLocationEditControllerMap[editAddress.name]!) {
          controller["kgController"]!.dispose();
          controller["quantityController"]!.dispose();
        }
      }
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

    for (var addressController in _addressControllers) {
      addressController.dispose();
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
      addressText: "",
    ));
    _productEditControllers.add({
      "kgController": TextEditingController(),
      "quantityController": TextEditingController()
    });
    changeState();
  }

  void addSanPhamByLocation(String address, String addressText) {
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
      addressText: addressText,
    ));

    if (_productForLocationEditControllerMap.containsKey(address)) {
      var controllers = _productForLocationEditControllerMap[address];
      controllers!.add({
        "kgController": TextEditingController(),
        "quantityController": TextEditingController()
      });
    } else {
      _productForLocationEditControllerMap[address] = [
        {
          "kgController": TextEditingController(),
          "quantityController": TextEditingController()
        }
      ];
    }

    changeState();
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

    changeState();
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

    changeState();
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
    _addressControllers.add(TextEditingController());
  }

  changeState({bool isSaving = true}) {
    if (isSaving && isCreateScreen) {
      storeData();
    }
    notifyListeners();
  }

  clearSignatureCustomer() {
    _signatureCustomerController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    changeState();
  }

  clearSignatureSupplier() {
    _signatureSupplierController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    changeState();
  }

  clearAllSignatures() {
    _signatureSupplierController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    _signatureCustomerController = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    changeState();
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

      // calculateTotalPrice();

      // _order!.totalCost = _totalOrderPrice;
      _order!.vendor = customer.code;
      _order!.vendorName = customer.realName;
      _order!.type = 'B';
      _order!.vendorAddress = '';
      _order!.vendorName = customer.realName;

      var createOrderResponse =
          await locator<Api>().createHoaDonMuaBan(_order!);

      if (createOrderResponse != null &&
          createOrderResponse.responseData != null) {
        _name = createOrderResponse.responseData.data["name"];
        _title = createOrderResponse.responseData.data["name"];
        _order!.name = createOrderResponse.responseData.data["name"];
        _totalOrderPrice =
            createOrderResponse.responseData.data["total_amount"];
        _order!.totalCost =
            createOrderResponse.responseData.data["total_amount"];
      }

      changeState();
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

  Future createOrder(
    context, {
    String type = 'B',
    bool isNhaCungCap = false,
  }) async {
    try {
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
              subtitle:
                  'Bạn cần có chữ ký khách hàng trước khi hoàn thành đơn.');
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

      List<Customer>? customers = [];

      if (isNhaCungCap) {
        customers = _manufactures;
      } else {
        customers = _customers;
      }

      var elements =
          customers.where((element) => element.code == _customerValue).toList();

      if (elements != null && elements.length > 0) {
        _order!.email = elements[0].email;
        _order!.paymentStatus = 'Chưa thanh toán';
        _order!.phone = elements[0].phone;
        if (_isNhaCungCap) {
          _order!.products = products;
        } else {
          _order!.products =
              _sellInWarehouse ? _products : _productForLocations;
        }

        var quantity = _order!.products.fold<int>(
            0, (previousValue, element) => previousValue + element.quantity);
        if (_order!.products.length <= 0 || quantity <= 0) {
          FrappeAlert.errorAlert(
              title: 'Lỗi xảy ra',
              context: context,
              subtitle: 'bạn chưa có sản phẩm nào!');
          return;
        }

        // calculateTotalPrice();

        // _order!.totalCost = _totalOrderPrice;
        _order!.sellInWarehouse = _sellInWarehouse ? 1 : 0;
        _order!.status = !_sellInWarehouse ? "Đã đặt hàng" : "Đã giao hàng";
        _order!.taxId = elements[0].taxId;
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
          _donNhapKho!.codeOrders =
              createOrderResponse.responseData.data["name"];
          _donNhapKho!.status = "Chờ nhập hàng";
          _donNhapKho!.listShell = [...nhapKhos, ...traVes];
          _name = createOrderResponse.responseData.data["name"];
          _title = createOrderResponse.responseData.data["name"];
          _order!.name = createOrderResponse.responseData.data["name"];
          _totalOrderPrice =
              createOrderResponse.responseData.data["total_amount"];
          _order!.totalCost =
              createOrderResponse.responseData.data["total_amount"];
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
          var code =
              "CNT-$_customerValue-${DateFormat('MMyy').format(DateTime.now())}";
          await locator<Api>().createCongNoTienHoaDon(code, _name!);
          if (!saveTemplate) _isSaved = true;
          changeState();
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
    } catch (e) {
      FrappeAlert.errorAlert(
          title: 'Lỗi xảy ra',
          context: context,
          subtitle:
              'Khi thực thi tác vụ, xin hãy liên hệ với bên phát triển để xử lý!');
    }
  }

  Future updatePhanCong() async {
    var response = await locator<Api>().updateGiaoViec(_name, giaoViec.employee,
        giaoViec.supportEmployee, giaoViec.plate, giaoViec.deliverDate);
    giaoViec.name = response['message']["name"];
    changeState();
  }

  calculateTotalPrice() {
    _totalOrderPrice = _order!.products.fold(0, (pv, cu) {
      var realName = cu.product;

      cu.type = "Vật tư";

      if (!["", null, false, 0].contains(cu.material)) {
        realName = "$realName-${cu.material}";

        cu.type = "Sản phẩm";
      }

      var total = pv;

      var getDonGiaMuaBan = getSingleDonGiaMuaBan(realName!);

      if (getDonGiaMuaBan != null) {
        total += (cu.actualQuantity * getDonGiaMuaBan.unitPrice) * 0.1 +
            (cu.actualQuantity * getDonGiaMuaBan.unitPrice);
      } else {
        total += 0.0;
      }

      return total;
    });
  }

  Future updateOrder(
    context, {
    String status = '',
    String type = 'B',
    bool isNhaCungCap = false,
    String statusDonNhapKho = 'Chờ nhập hàng',
  }) async {
    try {
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
        // else {
        //   FrappeAlert.errorAlert(
        //     title: 'Lỗi xảy ra',
        //     context: context,
        //     subtitle: 'Bạn chưa có chữ ký khách hàng!',
        //   );
        //   return;
        // }

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
        // else {
        //   FrappeAlert.errorAlert(
        //     title: 'Lỗi xảy ra',
        //     context: context,
        //     subtitle: 'Bạn chưa có chữ ký nhà cung cấp!',
        //   );
        //   return;
        // }
      }

      List<Customer>? customers = [];

      if (isNhaCungCap) {
        customers = _manufactures;
      } else {
        customers = _customers;
      }

      var elements =
          customers.where((element) => element.code == _order!.vendor).toList();

      if (elements != null && elements.length > 0) {
        _order!.email = elements[0].email;
        _order!.paymentStatus = 'Chưa thanh toán';
        _order!.phone = elements[0].phone;
        if (_isNhaCungCap) {
          _order!.products = products;
        } else {
          _order!.products =
              _sellInWarehouse ? _products : _productForLocations;
        }
        var quantity = _order!.products.fold<int>(
            0, (previousValue, element) => previousValue + element.quantity);
        if (_order!.products.length <= 0 || quantity <= 0) {
          FrappeAlert.errorAlert(
              title: 'Lỗi xảy ra',
              context: context,
              subtitle: 'bạn chưa có sản phẩm nào!');
          return;
        }

        // calculateTotalPrice();

        // _order!.totalCost = _totalOrderPrice;
        _order!.sellInWarehouse = _sellInWarehouse ? 1 : 0;
        _order!.status = ["", null, false, 0].contains(status)
            ? !_sellInWarehouse
                ? "Đã đặt hàng"
                : "Đã giao hàng"
            : status;
        _order!.taxId = elements[0].taxId;
        _order!.vendor = elements[0].code;

        _order!.vendorAddress = '';

        _order!.type = type;

        _order!.vendorName = elements[0].realName;
        _order!.attachSignatureCustomerImage =
            customerAttachmemts != null ? customerAttachmemts.fileUrl : '';

        _order!.attachSignatureSupplierImage =
            supplierAttachments != null ? supplierAttachments.fileUrl : '';

        var uploadHoaDonMuaBan =
            await locator<Api>().updateHoaDonMuaBan(_order!);

        if (uploadHoaDonMuaBan != null &&
            uploadHoaDonMuaBan.responseData != null) {
          _totalOrderPrice =
              uploadHoaDonMuaBan.responseData.data["total_amount"];
          _order!.totalCost =
              uploadHoaDonMuaBan.responseData.data["total_amount"];
          if (status == "Đang giao hàng") {
            List<CreateTrackingLocationRequest> locations = _order!.products
                .map((e) => CreateTrackingLocationRequest(
                    address: e.diaChi, order: order!.name))
                .toList();

            LocationData currentLocation = await Location().getLocation();
            locations.add(CreateTrackingLocationRequest(
                address: "Xe",
                order: _order!.name,
                latitude: currentLocation.latitude,
                longitude: currentLocation.longitude));

            await locator<Api>().createTrackingLocation(locations);
          }

          _donNhapKho!.codeOrders = _name!;
          _donNhapKho!.status = statusDonNhapKho;
          _donNhapKho!.listShell = [...nhapKhos, ...traVes];

          var updateDonNhapKhoResponse =
              await locator<Api>().updateDonNhapKho(_donNhapKho!);
          if (updateDonNhapKhoResponse != null &&
              updateDonNhapKhoResponse.responseData != null) {
            changeState();
            FrappeAlert.successAlert(
                title: 'Cập nhật thành công',
                context: context,
                subtitle: 'Cập nhật đơn hàng thành công.');
          }

          var code =
              "CNT-$_customerValue-${DateFormat('MMyy').format(DateTime.now())}";
          await locator<Api>().createCongNoTienHoaDon(code, _name!);

          for (var product in _order!.products) {
            if (!["", null, false, 0].contains(product.material)) {
              await createCongNoTaiSan(
                  product.material!,
                  product.quantity - product.actualQuantity,
                  0,
                  product.kg - product.actualKg);
            }
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
      changeState();
    } catch (e) {
      FrappeAlert.errorAlert(
          title: 'Lỗi xảy ra',
          context: context,
          subtitle:
              'Khi thực thi tác vụ, xin hãy liên hệ với bên phát triển để xử lý!');
    }
  }

  Future<void> createCongNoTaiSan(
      String assetName, int received, int returned, double totalKg) async {
    await locator<Api>().createCongNoTaiSan(
        _customerValue!, _name!, assetName, received, returned, totalKg);
  }

  Future<void> cancelOrder(
      {required BuildContext context, String? reason}) async {
    try {
      _order!.status = "Đã hủy";
      _order!.cancelPerson = Config().customerCode;
      _order!.cancelDate = DateTime.now();
      _order!.cancelReason = reason ?? "";

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

  Future<GiaoViecSignature?> updateGiaoViecSignature(context,
      {String status = '', String address = ''}) async {
    try {
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
      } else {
        FrappeAlert.errorAlert(
            title: 'Tạo mới không thành công',
            context: context,
            subtitle: 'Bạn cần có chữ ký khách hàng trước khi hoàn thành đơn.');
        return null;
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
      } else {
        FrappeAlert.errorAlert(
            title: 'Tạo mới không thành công',
            context: context,
            subtitle:
                'Bạn cần có chữ ký nhà cung cấp trước khi hoàn thành đơn.');

        return null;
      }

      await locator<Api>().updateGiaoViecSignature(
          _order!.name,
          status != null && status != '' ? status : _order!.status,
          address,
          customerAttachmemts != null ? customerAttachmemts.fileUrl : '',
          supplierAttachments != null ? supplierAttachments.fileUrl : '');

      // if(updateGiaoViecSignatureResponse != null) {

      // }

      return GiaoViecSignature(
        address: address,
        attachSignatureCustomerImage:
            customerAttachmemts != null ? customerAttachmemts.fileUrl : '',
        attachSignatureDeliverImage:
            supplierAttachments != null ? supplierAttachments.fileUrl : '',
        order: _order!.name,
        status: status != null && status != '' ? status : _order!.status,
      );

      // changeState();
    } catch (e) {
      return null;
    }
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
