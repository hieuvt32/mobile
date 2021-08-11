import 'package:flutter/foundation.dart';
import 'package:frappe_app/model/bang_thong_ke_kho.dart';
import 'package:frappe_app/model/bao_cao_cong_no_respone.dart';
import 'package:frappe_app/model/change_password_request.dart';
import 'package:frappe_app/model/change_password_response.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/create_bao_nham_lan_request.dart';
import 'package:frappe_app/model/create_hoa_don_mua_ban_response.dart';
import 'package:frappe_app/model/create_new_delivery_address_response.dart';
import 'package:frappe_app/model/don_nhap_kho.dart';
import 'package:frappe_app/model/don_nhap_kho_response.dart';
import 'package:frappe_app/model/get_customer_by_code_response.dart';
import 'package:frappe_app/model/file_upload_response.dart';
import 'package:frappe_app/model/get_customer_by_company_response.dart';
import 'package:frappe_app/model/get_delivery_address_response.dart';
import 'package:frappe_app/model/get_doc_response.dart';
import 'package:frappe_app/model/get_guyen_vat_lieu_san_pham_response.dart';
import 'package:frappe_app/model/get_kiem_kho_response.dart';
import 'package:frappe_app/model/get_list_quy_chuan_thong_tin_response.dart';
import 'package:frappe_app/model/get_quy_chuan_thong_tin_response.dart';
import 'package:frappe_app/model/get_roles_response.dart';
import 'package:frappe_app/model/group_by_count_response.dart';
import 'package:frappe_app/model/list_don_bao_binh_loi_response.dart';
import 'package:frappe_app/model/list_order_response.dart';
import 'package:frappe_app/model/login_request.dart';
import 'package:frappe_app/model/order.dart';
import 'package:frappe_app/model/product.dart';
import 'package:frappe_app/model/update_bien_ban_kiem_kho.dart';
import 'package:frappe_app/model/update_lich_su_san_xuat_response.dart';
import 'package:frappe_app/model/update_trang_thai_quy_chuan_response.dart';

import '../../model/doctype_response.dart';
import '../../model/desktop_page_response.dart';
import '../../model/desk_sidebar_items_response.dart';
import '../../model/login_response.dart';

abstract class Api {
  Future<LoginResponse> login(
    LoginRequest loginRequest,
  );

  Future<GetQuyChuanThongTinResponse> getTraCuuSanXuat(
    String barcode,
  );

  Future<GetKiemKhoResponse> getKiemKho(
    int type,
  );

  Future<GetCustomerByCompanyResponse> getCustomerByCompany({
    String company,
  });

  Future<GetDeliveryAddressResponse> getDeliveryAddress({
    String customer,
  });

  Future<GetNguyenVatLieuSanPhamResponse> getNguyenVatLieuSanPham({
    int? type,
  });

  Future<GetListQuyChuanThongTinResponse> getReportSanXuat({String? company});

  Future<UpdateLichSuSanXuatResponse> updateLichSuSanXuat(
    String barcode,
    String company,
    String product,
    String material,
    String serial,
    String status,
    int countByKg,
    double kg,
  );

  Future<CreateNewDeliveryAddressResponse> updateDeliveryAddress(
    String? diaChi,
    String? customer,
    String? name,
  );

  Future<GetRolesResponse> getRoles();

  Future<ChangePasswordResponse> changePassword(
    ChangePasswordRequest changePasswordRequest,
  );

  Future<ListOrderResponse> getListOrder(int status, {int? sellInWareHouse});

  Future<ListDonBaoBinhLoiRespone> getListDonBaoBinhLoi(
      String customerCode, String status);

  Future<UpdateTrangThaiQuyChuanResponse> updateTrangThaiQuyChuan(
    String key,
    int status,
  );

  Future<CreateHoaDonMuaBanRespone> createHoaDonMuaBan(Order order);

  Future<UpdateHoaDonMuaBanRespone> updateHoaDonMuaBan(Order order);

  Future<SingleOrderResponse> getSingleHoaDonBanHang(
    String name,
  );

  Future<CreateDonNhapKhoResponse> createDonNhapKho(DonNhapKho donNhapKho);

  Future<UpdateDonNhapKhoResponse> updateDonNhapKho(DonNhapKho donNhapKho);

  Future<dynamic> updateGiaoViecSignature(
    String order,
    String status,
    String address,
    String attachSignatureCustomerImage,
    String attachSignatureDeliverImage,
  );

  Future<GetSingleDonNhapKhoResponse> getSingleDonNhapKho(String maDon);

  Future<UpdateBienBanKiemKhoResponse> updateBienBanKiemKho(
    int type,
    List<BangThongKeKho> bangThongKeKho,
  );

  Future<DeskSidebarItemsResponse> getDeskSideBarItems();

  Future<DesktopPageResponse> getDesktopPage(
    String module,
  );

  Future<DoctypeResponse> getDoctype(
    String doctype,
  );

  Future<List> fetchList({
    @required List fieldnames,
    @required String doctype,
    @required DoctypeDoc meta,
    @required String orderBy,
    List filters,
    int pageLength,
    int offset,
  });

  Future<GetDocResponse> getdoc(String doctype, String name);

  Future postComment(
    String refDocType,
    String refName,
    String content,
    String email,
  );

  Future sendEmail({
    @required recipients,
    cc,
    bcc,
    @required subject,
    @required content,
    @required doctype,
    @required doctypeName,
    sendEmail,
    printHtml,
    sendMeACopy,
    printFormat,
    emailTemplate,
    attachments,
    readReceipt,
    printLetterhead,
  });

  Future addAssignees(String doctype, String name, List assignees);

  Future removeAssignee(String doctype, String name, String assignTo);

  Future getDocinfo(String doctype, String name);

  Future removeAttachment(
    String doctype,
    String name,
    String attachmentName,
  );

  Future deleteComment(String name);

  Future uploadFiles({
    @required String doctype,
    @required String name,
    @required List<FrappeFile> files,
  });

  Future<List<UploadFileResponse>> uploadFilesForBytes({
    @required String doctype,
    @required String name,
    @required List<GasFile> files,
  });

  Future<UploadFileResponse> uploadFileForBytes({
    @required String doctype,
    @required String name,
    @required GasFile file,
  });

  Future saveDocs(String doctype, Map formValue);

  Future<Map> searchLink({
    String doctype,
    String refDoctype,
    String txt,
    int pageLength,
  });

  Future toggleLike(String doctype, String name, bool isFav);

  Future getTags(String doctype, String txt);

  Future removeTag(String doctype, String name, String tag);

  Future addTag(String doctype, String name, String tag);

  Future addReview(String doctype, String name, Map reviewData);

  Future setPermission({
    @required String doctype,
    @required String name,
    @required Map shareInfo,
    @required String user,
  });

  Future shareAdd(String doctype, String name, Map shareInfo);

  Future shareGetUsers({
    @required String doctype,
    @required String name,
  });

  Future<Map> getContactList(String query);

  Future<GroupByCountResponse> getGroupByCount({
    required String doctype,
    required List currentFilters,
    required String field,
  });

  Future<GetCustomerByCodeResponse> getCusomterByCode({String code});

  Future<SingleDonBaoBinhLoiRespone> getSingleDonBaoLoi(String id);

  Future<ListBaoCaoCongNoKH> getBaoCaoCongNoChoKH(String key);

  Future<ListBaoCaoCongNoDetail> getBaoCaoCongNoDetail(
      {required String key,
      required String previouskey,
      required String assetname});

  Future<dynamic> createBaoNhamLan(CreateBaoNhamLanRequest request);
}
