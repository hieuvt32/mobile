import 'package:frappe_app/model/common.dart';
import 'package:frappe_app/utils/enums.dart';

class Constants {
  static var offlinePageSize = 50;
  static var pageSize = 10;

  static var imageExtensions = ['jpg', 'jpeg'];

  static List<FilterOperator> filterOperators = [
    FilterOperator(label: "Like", value: "like"),
    FilterOperator(label: "Equals", value: "="),
    FilterOperator(label: "Not Equals", value: "!="),
    FilterOperator(label: "Not Like", value: "not like"),
    // FilterOperator(label: "In", value: "in"),

    // FilterOperator(label: "Not In", value: "not in"),
    FilterOperator(label: "Is", value: "is"),
  ];

  static Map<String, UserRole> mappingRole = {
    "Khách Hàng": UserRole.KhachHang,
    "Thủ Kho": UserRole.ThuKho,
    "Giám Đốc": UserRole.GiamDoc,
    "Giao Vận": UserRole.GiaoVan,
    "Điều Phối": UserRole.DieuPhoi,
  };
}
