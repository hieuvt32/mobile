// @dart=2.9

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/bang_thong_ke_kho.dart';
import 'package:frappe_app/model/bao_cao_cong_no_respone.dart';
import 'package:frappe_app/model/change_password_request.dart';
import 'package:frappe_app/model/change_password_response.dart';
import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/model/create_bao_nham_lan_request.dart';
import 'package:frappe_app/model/create_hoa_don_mua_ban_response.dart';
import 'package:frappe_app/model/create_new_delivery_address_response.dart';
import 'package:frappe_app/model/don_nhap_kho_response.dart';
import 'package:frappe_app/model/don_nhap_kho.dart';
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
import 'package:frappe_app/model/response_data.dart';
import 'package:frappe_app/model/update_bien_ban_kiem_kho.dart';
import 'package:frappe_app/model/update_lich_su_san_xuat_response.dart';
import 'package:frappe_app/model/update_trang_thai_quy_chuan_response.dart';

import '../../model/doctype_response.dart';
import '../../model/desktop_page_response.dart';
import '../../model/desk_sidebar_items_response.dart';
import '../../model/login_response.dart';

import '../../services/api/api.dart';

import '../../utils/helpers.dart';
import '../../utils/dio_helper.dart';
import '../../model/offline_storage.dart';

class DioApi implements Api {
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await DioHelper.dio.post(
        '/method/login',
        data: loginRequest.toJson(),
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.headers.map["set-cookie"] != null &&
            response.headers.map["set-cookie"][3] != null) {
          response.data["user_id"] =
              response.headers.map["set-cookie"][3].split(';')[0].split('=')[1];
        }

        return LoginResponse.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusMessage: error.message,
            statusCode: error,
          );
        }
      } else {
        throw e;
      }
    }
  }

  Future<DeskSidebarItemsResponse> getDeskSideBarItems() async {
    try {
      final response = await DioHelper.dio.post(
        '/method/frappe.desk.desktop.get_desk_sidebar_items',
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        if (await OfflineStorage.storeApiResponse()) {
          await OfflineStorage.putItem('deskSidebarItems', response.data);
        }

        try {
          return DeskSidebarItemsResponse.fromJson(response.data);
        } catch (e) {
          response.data["message"] = [
            ...response.data["message"]["Modules"],
            ...response.data["message"]["Administration"],
            ...response.data["message"]["Domains"],
          ];
          return DeskSidebarItemsResponse.fromJson(response.data);
        }
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
        // response;
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw e;
      }
    }
  }

  Future<DesktopPageResponse> getDesktopPage(String module) async {
    try {
      final response = await DioHelper.dio.post(
        '/method/frappe.desk.desktop.get_desktop_page',
        data: {
          'page': module,
        },
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        if (await OfflineStorage.storeApiResponse()) {
          await OfflineStorage.putItem('${module}Doctypes', response.data);
        }

        return DesktopPageResponse.fromJson(response.data);
      } else if (response.statusCode == 403) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw e;
      }
    }
  }

  Future<DoctypeResponse> getDoctype(String doctype) async {
    var queryParams = {
      'doctype': doctype,
    };

    try {
      final response = await DioHelper.dio.get(
        '/method/frappe.desk.form.load.getdoctype',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        List metaFields = response.data["docs"][0]["fields"];
        response.data["docs"][0]["field_map"] = {};

        metaFields.forEach((field) {
          response.data["docs"][0]["field_map"]["${field["fieldname"]}"] = true;
        });
        if (await OfflineStorage.storeApiResponse()) {
          await OfflineStorage.putItem('${doctype}Meta', response.data);
        }
        return DoctypeResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse(
          statusMessage: response.statusMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  Future<List> fetchList({
    @required List fieldnames,
    @required String doctype,
    @required DoctypeDoc meta,
    @required String orderBy,
    List filters,
    int pageLength,
    int offset,
  }) async {
    var queryParams = {
      'doctype': doctype,
      'fields': jsonEncode(fieldnames),
      'page_length': pageLength.toString(),
      'with_comment_count': true,
      'order_by': orderBy
    };

    queryParams['limit_start'] = offset.toString();

    if (filters != null && filters.length != 0) {
      queryParams['filters'] = jsonEncode(filters);
    }

    try {
      final response = await DioHelper.dio.get(
        '/method/frappe.desk.reportview.get',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        var l = response.data["message"];
        var newL = [];

        if (l.length == 0) {
          return newL;
        }

        for (int i = 0; i < l["values"].length; i++) {
          var o = {};
          for (int j = 0; j < l["keys"].length; j++) {
            var key = l["keys"][j];
            var value = l["values"][i][j];

            if (key == "docstatus") {
              key = "status";
              if (isSubmittable(meta)) {
                if (value == 0) {
                  value = "Draft";
                } else if (value == 1) {
                  value = "Submitted";
                } else if (value == 2) {
                  value = "Cancelled";
                }
              } else {
                value = value == 0 ? "Enabled" : "Disabled";
              }
            }
            o[key] = value;
          }
          newL.add(o);
        }

        if (await OfflineStorage.storeApiResponse()) {
          await OfflineStorage.putItem('${doctype}List', newL);
        }

        return newL;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  Future<GetDocResponse> getdoc(String doctype, String name) async {
    var queryParams = {
      'doctype': doctype,
      'name': name,
    };

    try {
      final response = await DioHelper.dio.get(
        '/method/frappe.desk.form.load.getdoc',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        if (await OfflineStorage.storeApiResponse()) {
          await OfflineStorage.putItem('$doctype$name', response.data);
        }
        return GetDocResponse.fromJson(response.data);
      } else if (response.statusCode == 403) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw e;
      }
    }
  }

  Future postComment(
      String refDocType, String refName, String content, String email) async {
    var queryParams = {
      'reference_doctype': refDocType,
      'reference_name': refName,
      'content': content,
      'comment_email': email,
      'comment_by': email
    };

    final response = await DioHelper.dio.post(
        '/method/frappe.desk.form.utils.add_comment',
        data: queryParams,
        options: Options(contentType: Headers.formUrlEncodedContentType));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future sendEmail(
      {@required recipients,
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
      printLetterhead}) async {
    var queryParams = {
      'recipients': recipients,
      'subject': subject,
      'content': content,
      'doctype': doctype,
      'name': doctypeName,
      'send_email': 1
    };

    final response = await DioHelper.dio.post(
        '/method/frappe.core.doctype.communication.email.make',
        data: queryParams,
        options: Options(contentType: Headers.formUrlEncodedContentType));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future addAssignees(String doctype, String name, List assignees) async {
    var data = {
      'assign_to': json.encode(assignees),
      'assign_to_me': 0,
      'doctype': doctype,
      'name': name,
      'bulk_assign': false,
      're_assign': false
    };

    try {
      var response = await DioHelper.dio.post(
        '/method/frappe.desk.form.assign_to.add',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Something went wrong');
      }
    } catch (e) {
      if (e is DioError) {
        var error;
        if (e.response != null) {
          error = e.response;
        } else {
          error = e.error;
        }

        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusCode: error.statusCode,
            statusMessage: error.statusMessage,
          );
        }
      } else {
        throw e;
      }
    }
  }

  Future removeAssignee(String doctype, String name, String assignTo) async {
    var data = {
      'doctype': doctype,
      'name': name,
      'assign_to': assignTo,
    };

    var response = await DioHelper.dio.post(
      '/method/frappe.desk.form.assign_to.remove',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future getDocinfo(String doctype, String name) async {
    var data = {
      "doctype": doctype,
      "name": name,
    };

    var response = await DioHelper.dio.post(
      '/method/frappe.desk.form.load.get_docinfo',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return Docinfo.fromJson(response.data["docinfo"]);
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future removeAttachment(
    String doctype,
    String name,
    String attachmentName,
  ) async {
    var data = {
      "fid": attachmentName,
      "dt": doctype,
      "dn": name,
    };

    var response = await DioHelper.dio.post(
      '/method/frappe.desk.form.utils.remove_attach',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future deleteComment(String name) async {
    var queryParams = {
      'doctype': 'Comment',
      'name': name,
    };

    final response = await DioHelper.dio.post('/method/frappe.client.delete',
        data: queryParams,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future uploadFiles({
    @required String doctype,
    @required String name,
    @required List<FrappeFile> files,
  }) async {
    for (FrappeFile frappeFile in files) {
      String fileName = frappeFile.file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          frappeFile.file.path,
          filename: fileName,
        ),
        "docname": name,
        "doctype": doctype,
        "is_private": frappeFile.isPrivate ? 1 : 0,
        "folder": "Home/Attachments"
      });

      var response = await DioHelper.dio.post(
        "/method/upload_file",
        data: formData,
      );
      if (response.statusCode != 200) {
        throw Exception('Something went wrong');
      }
    }
  }

  Future saveDocs(String doctype, Map formValue) async {
    var data = {
      "doctype": doctype,
      ...formValue,
    };

    try {
      final response = await DioHelper.dio.post(
        '/method/frappe.desk.form.save.savedocs',
        data: "doc=${Uri.encodeComponent(json.encode(data))}&action=Save",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error;
        if (e.response != null) {
          error = e.response;
        } else {
          error = e.error;
        }

        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusCode: error.statusCode,
            statusMessage: error.statusMessage,
          );
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  Future<Map> searchLink({
    String doctype,
    String refDoctype,
    String txt,
    int pageLength,
  }) async {
    var queryParams = {
      'txt': txt,
      'doctype': doctype,
      'reference_doctype': refDoctype,
      'ignore_user_permissions': 0,
    };

    if (pageLength != null) {
      queryParams['page_length'] = pageLength;
    }

    try {
      final response = await DioHelper.dio.post(
        '/method/frappe.desk.search.search_link',
        data: queryParams,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        if (await OfflineStorage.storeApiResponse()) {
          if (pageLength != null && pageLength == 9999) {
            await OfflineStorage.putItem('${doctype}LinkFull', response.data);
          } else {
            await OfflineStorage.putItem('$txt${doctype}Link', response.data);
          }
        }
        return response.data;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw e;
      }
    }
  }

  Future toggleLike(String doctype, String name, bool isFav) async {
    var data = {
      'doctype': doctype,
      'name': name,
      'add': isFav ? 'Yes' : 'No',
    };

    final response = await DioHelper.dio.post(
      '/method/frappe.desk.like.toggle_like',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future getTags(String doctype, String txt) async {
    var data = {
      'doctype': doctype,
      'txt': txt,
    };

    final response = await DioHelper.dio.post(
      '/method/frappe.desk.doctype.tag.tag.get_tags',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future removeTag(String doctype, String name, String tag) async {
    var data = {
      'dt': doctype,
      'dn': name,
      'tag': tag,
    };

    final response = await DioHelper.dio.post(
      '/method/frappe.desk.doctype.tag.tag.remove_tag',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future addTag(String doctype, String name, String tag) async {
    var data = {
      'dt': doctype,
      'dn': name,
      'tag': tag,
    };

    final response = await DioHelper.dio.post(
      '/method/frappe.desk.doctype.tag.tag.add_tag',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future addReview(String doctype, String name, Map reviewData) async {
    var doc = {
      "doctype": doctype,
      "name": name,
    };

    var data = '''doc=${Uri.encodeComponent(json.encode(doc))}
              &to_user=${Uri.encodeComponent(reviewData["to_user"])}
              &points=${int.parse(reviewData["points"])}
              &review_type=${reviewData["review_type"]}
              &reason=${reviewData["reason"]}'''
        .replaceAll(new RegExp(r"\s+"), "");
    // trim all whitespace

    try {
      final response = await DioHelper.dio.post(
        '/method/frappe.social.doctype.energy_point_log.energy_point_log.review',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data["_server_messages"] != null) {
          var errorMsgs = json.decode(response.data["_server_messages"]);
          var errorMsg = json.decode(errorMsgs[0])["message"];

          throw ErrorResponse(
            statusMessage: errorMsg,
          );
        }
        return response.data;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  Future setPermission({
    @required String doctype,
    @required String name,
    @required String user,
    @required Map shareInfo,
  }) async {
    var data = {
      'doctype': doctype,
      'name': name,
      'user': user,
      ...shareInfo,
    };

    final response = await DioHelper.dio.post(
      '/method/frappe.share.set_permission',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future shareAdd(String doctype, String name, Map shareInfo) async {
    var data = {
      'doctype': doctype,
      'name': name,
      ...shareInfo,
    };

    final response = await DioHelper.dio.post(
      '/method/frappe.share.add',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<Map> getContactList(String query) async {
    var data = {
      "txt": query,
    };

    final response = await DioHelper.dio.post(
        '/method/frappe.email.get_contact_list',
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType));
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future shareGetUsers({
    @required String doctype,
    @required String name,
  }) async {
    var data = {
      "doctype": doctype,
      "name": name,
    };

    final response = await DioHelper.dio.post(
      '/method/frappe.share.get_users',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Something went wrong');
    }
  }

  Future<GroupByCountResponse> getGroupByCount({
    @required String doctype,
    @required List currentFilters,
    @required String field,
  }) async {
    var reqData = {
      "doctype": doctype,
      "current_filters": currentFilters,
      "field": field
    };

    try {
      final response = await DioHelper.dio.post(
        '/method/frappe.desk.listview.get_group_by_count',
        data: reqData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        return GroupByCountResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    try {
      var usr = changePasswordRequest.usr;
      final response = await DioHelper.dio.put(
        "/resource/User/$usr",
        data: changePasswordRequest.toJson(),
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        return ChangePasswordResponse.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusMessage: error.message,
            statusCode: error,
          );
        }
      } else {
        throw e;
      }
    }
  }

  @override
  Future<GetQuyChuanThongTinResponse> getTraCuuSanXuat(String barcode) async {
    var queryParams = {
      'key': barcode,
    };
    try {
      final response = await DioHelper.dio.get(
        '/method/getTraCuuSanXuat',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
        // data: reqData,
        // options: Options(
        //   contentType: Headers.formUrlEncodedContentType,
        // ),
      );

      if (response.statusCode == 200) {
        return GetQuyChuanThongTinResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<UpdateLichSuSanXuatResponse> updateLichSuSanXuat(
      String barcode,
      String company,
      String product,
      String material,
      String serial,
      String status,
      int countByKg,
      double kg) async {
    var queryParams = {
      'barcode': barcode,
      'company': company,
      'product': product,
      'material': material,
      'count_by_kg': countByKg,
      'kg': kg,
      'status': status,
    };

    final response = await DioHelper.dio.post('/method/updateLichSuSanXuat',
        data: queryParams,
        options: Options(contentType: Headers.formUrlEncodedContentType));
    if (response.statusCode == 200) {
      return UpdateLichSuSanXuatResponse.fromJson(response.data);
    } else {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future<GetListQuyChuanThongTinResponse> getReportSanXuat({company}) async {
    var queryParams = {
      'company': company,
    };
    try {
      final response = await DioHelper.dio.get(
        '/method/getReportSanXuat',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
        // data: reqData,
        // options: Options(
        //   contentType: Headers.formUrlEncodedContentType,
        // ),
      );

      if (response.statusCode == 200) {
        return GetListQuyChuanThongTinResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<UpdateTrangThaiQuyChuanResponse> updateTrangThaiQuyChuan(
      String key, int status) async {
    var queryParams = {
      'key': key,
      'status': status,
    };
    try {
      final response = await DioHelper.dio.post(
          '/method/updateTrangThaiQuyChuan',
          data: queryParams,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        return UpdateTrangThaiQuyChuanResponse.fromJson(response.data);
      } else {
        return new UpdateTrangThaiQuyChuanResponse(
            responseData: ResponseData(
                code: response.statusCode, message: "", data: null));
      }
    } catch (e) {
      return new UpdateTrangThaiQuyChuanResponse(
          responseData:
              ResponseData(code: 404, message: "Item Not found", data: null));
    }
  }

  @override
  Future<GetKiemKhoResponse> getKiemKho(int type) async {
    var queryParams = {
      'type': type,
    };
    try {
      final response = await DioHelper.dio.get(
        '/method/getKiemKho',
        queryParameters: queryParams,
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return GetKiemKhoResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<UpdateBienBanKiemKhoResponse> updateBienBanKiemKho(
      int type, List<BangThongKeKho> bangThongKeKho) async {
    try {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['type'] = type;
      final List<Map<String, dynamic>> lstDataBangThongKeKhos =
          bangThongKeKho.map((e) => e.toJson()).toList();
      data['data'] = lstDataBangThongKeKhos;

      final response = await DioHelper.dio.post(
        '/method/updateBienBanKiemKho',
        data: data,
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        return UpdateBienBanKiemKhoResponse.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusMessage: error.message,
            statusCode: error,
          );
        }
      } else {
        throw e;
      }
    }
  }

  @override
  Future<GetRolesResponse> getRoles() async {
    try {
      final response = await DioHelper.dio.get(
        '/method/getRoles',
        queryParameters: {},
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return GetRolesResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<ListOrderResponse> getListOrder(int status) async {
    try {
      final response = await DioHelper.dio.get(
        '/method/getHoaDonMuaHang',
        queryParameters: {"status": status},
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return ListOrderResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<ListDonBaoBinhLoiRespone> getListDonBaoBinhLoi(
      String customerCode, String status) async {
    try {
      print(customerCode);
      print(status);

      final response = await DioHelper.dio.get(
        '/method/getDanhSachDonBaoBinhLoi',
        queryParameters: {"customer": customerCode, "status": status},
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = ListDonBaoBinhLoiRespone.fromJson(response.data);
        return data;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<GetCustomerByCompanyResponse> getCustomerByCompany(
      {String company}) async {
    try {
      final response = await DioHelper.dio.get(
        '/method/getCustomerByCompany',
        queryParameters: {},
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return GetCustomerByCompanyResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<GetNguyenVatLieuSanPhamResponse> getNguyenVatLieuSanPham(
      {int type}) async {
    try {
      final response = await DioHelper.dio.get(
        '/method/getNguyenVatLieuSanPham',
        queryParameters: {'type': type},
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return GetNguyenVatLieuSanPhamResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<GetDeliveryAddressResponse> getDeliveryAddress(
      {String customer}) async {
    try {
      final response = await DioHelper.dio.get(
        '/method/getDeliveryAddress',
        queryParameters: {'customer': customer},
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return GetDeliveryAddressResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<CreateNewDeliveryAddressResponse> updateDeliveryAddress(
      String diaChi, String customer, String name) async {
    try {
      final response = await DioHelper.dio.post(
        '/method/updateDeliveryAddress',
        data: Address(
                name: name,
                diaChi: diaChi,
                customer: customer,
                isEnable: false,
                isEditable: false)
            .toJson(),
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        return CreateNewDeliveryAddressResponse.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusMessage: error.message,
            statusCode: error,
          );
        }
      } else {
        throw e;
      }
    }
  }

  @override
  Future<CreateHoaDonMuaBanRespone> createHoaDonMuaBan(Order order) async {
    try {
      final response = await DioHelper.dio.post(
        '/method/createHoaDonBanHang',
        data: order.toJson(),
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        return CreateHoaDonMuaBanRespone.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusMessage: error.message,
            statusCode: error,
          );
        }
      } else {
        throw e;
      }
    }
  }

  @override
  Future<CreateDonNhapKhoResponse> createDonNhapKho(
      DonNhapKho donNhapKho) async {
    try {
      final response = await DioHelper.dio.post(
        '/method/createDonNhapKho',
        data: donNhapKho.toJson(),
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        return CreateDonNhapKhoResponse.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusMessage: error.message,
            statusCode: error,
          );
        }
      } else {
        throw e;
      }
    }
  }

  @override
  Future<GetSingleDonNhapKhoResponse> getSingleDonNhapKho(String maDon) async {
    try {
      final response = await DioHelper.dio.get(
        '/method/getSingleDonNhapKho',
        queryParameters: {'code_orders': maDon},
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return GetSingleDonNhapKhoResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<SingleOrderResponse> getSingleHoaDonBanHang(String name) async {
    try {
      final response = await DioHelper.dio.get(
        '/method/getSingleHoaDonBanHang',
        queryParameters: {'name': name},
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return SingleOrderResponse.fromJson(response.data);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        );
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<UpdateDonNhapKhoResponse> updateDonNhapKho(
      DonNhapKho donNhapKho) async {
    try {
      final response = await DioHelper.dio.post(
        '/method/updateDonNhapKho',
        data: donNhapKho.toJson(),
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        return UpdateDonNhapKhoResponse.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusMessage: error.message,
            statusCode: error,
          );
        }
      } else {
        throw e;
      }
    }
  }

  @override
  Future<UpdateHoaDonMuaBanRespone> updateHoaDonMuaBan(Order order) async {
    try {
      final response = await DioHelper.dio.post(
        '/method/updateHoaDonBanHang',
        data: order.toJson(),
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        return UpdateHoaDonMuaBanRespone.fromJson(response.data);
      } else {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusMessage: error.message,
            statusCode: error,
          );
        }
      } else {
        throw e;
      }
    }
  }

  @override
  Future<List<UploadFileResponse>> uploadFilesForBytes(
      {String doctype, String name, List<GasFile> files}) async {
    List<UploadFileResponse> responses = [];
    for (GasFile gasFile in files) {
      try {
        // String fileName = frappeFile.file.path.split('/').last;
        FormData formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(
            gasFile.file,
            filename: 'hieuvt.png',
          ),
          "docname": name,
          "doctype": doctype,
          "is_private": gasFile.isPrivate ? 1 : 0,
          "folder": "Home",
          "fieldname": "attach_signature_image"
        });

        var response = await DioHelper.dio.post(
          "/method/upload_file",
          data: formData,
        );

        if (response.statusCode != 200) {
          responses.add(UploadFileResponse(
              errorResponse: ErrorResponse(
            statusCode: response.statusCode,
            statusMessage: response.data["message"],
          )));
        }

        responses.add(UploadFileResponse.fromJson(response.data));
      } catch (e) {
        if (e is DioError) {
          var error = e.error;
          if (error is SocketException) {
            responses.add(
              UploadFileResponse(
                errorResponse: ErrorResponse(
                  statusCode: HttpStatus.serviceUnavailable,
                  statusMessage: error.message,
                ),
              ),
            );
          } else {
            responses.add(
              UploadFileResponse(
                errorResponse: ErrorResponse(
                  statusMessage: error.message,
                  statusCode: error,
                ),
              ),
            );
          }
        } else {
          throw e;
        }
      }
    }

    return responses;
  }

  @override
  Future<UploadFileResponse> uploadFileForBytes(
      {String doctype, String name, GasFile file}) async {
    try {
      // String fileName = frappeFile.file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          file.file,
          filename: file.fileName,
        ),
        "docname": name,
        "doctype": doctype,
        "is_private": file.isPrivate ? 1 : 0,
        "folder": "Home",
        "fieldname": file.fileName
      });

      var response = await DioHelper.dio.post(
        "/method/upload_file",
        data: formData,
      );

      if (response.statusCode != 200) {
        return UploadFileResponse(
            errorResponse: ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        ));
      }

      return UploadFileResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          return UploadFileResponse(
            errorResponse: ErrorResponse(
              statusCode: HttpStatus.serviceUnavailable,
              statusMessage: error.message,
            ),
          );
        } else {
          return UploadFileResponse(
            errorResponse: ErrorResponse(
              statusMessage: error.message,
              statusCode: error,
            ),
          );
        }
      } else {
        throw e;
      }
    }
  }

  @override
  Future<GetCustomerByCodeResponse> getCusomterByCode({String code}) async {
    try {
      final response = await DioHelper.dio.get('/method/getDetailKhachHang',
          queryParameters: {'customercode': code});

      if (response.statusCode == 200) {
        return GetCustomerByCodeResponse.fromJson(response.data);
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<SingleDonBaoBinhLoiRespone> getSingleDonBaoLoi(String id) async {
    try {
      final response = await DioHelper.dio.get('/method/getSingleDonBaoBinhLoi',
          queryParameters: {'feedback': id});

      if (response.statusCode == 200) {
        return SingleDonBaoBinhLoiRespone.fromJson(response.data);
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<ListBaoCaoCongNoKH> getBaoCaoCongNoChoKH(String key) async {
    try {
      final response = await DioHelper.dio
          .get('/method/getBaoCaoCongNoChoKH', queryParameters: {'key': key});

      if (response.statusCode == 200) {
        return ListBaoCaoCongNoKH.fromJson(response.data);
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<ListBaoCaoCongNoDetail> getBaoCaoCongNoDetail(
      {String key, String previouskey, String assetname}) async {
    try {
      final response = await DioHelper.dio
          .get('/method/getBaoCaoCongNoKHChiTiet', queryParameters: {
        'key': key,
        'previouskey': previouskey,
        'assetname': assetname
      });

      if (response.statusCode == 200) {
        return ListBaoCaoCongNoDetail.fromJson(response.data);
      } else {
        throw ErrorResponse();
      }
    } catch (e) {
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(statusMessage: error.message);
        }
      } else {
        throw ErrorResponse();
      }
    }
  }

  @override
  Future<dynamic> createBaoNhamLan(CreateBaoNhamLanRequest request) async {
    try {
      dynamic json = request.toJson();
      final response = await DioHelper.dio.post(
        '/method/createBaoCaoNhamLan',
        data: request.toJson(),
        options: Options(
          validateStatus: (status) {
            return status < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw ErrorResponse(
          statusCode: response.statusCode,
          statusMessage: response.data["message"],
        );
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        var error = e.error;
        if (error is SocketException) {
          throw ErrorResponse(
            statusCode: HttpStatus.serviceUnavailable,
            statusMessage: error.message,
          );
        } else {
          throw ErrorResponse(
            statusMessage: error.message,
            statusCode: error,
          );
        }
      } else {
        throw e;
      }
    }
  }
}
