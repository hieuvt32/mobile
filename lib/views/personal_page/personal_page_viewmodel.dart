import 'package:frappe_app/views/base_viewmodel.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PersonalPageViewModel extends BaseViewModel {
  late bool enableEdit;

  late String name;
  late String taxId;
  late String phone;
  late String email;
  late List<String> address = [];

  void initValue() {
    enableEdit = false;
    address = [];
  }

  void togggleEdit() {
    enableEdit = !enableEdit;
    print(enableEdit);
    notifyListeners();
  }

  void saveAddress(int index, String value) {
    address[index] = value;
  }

  void addAddress() {
    address.add('');
    notifyListeners();
  }

  void removeAddress(int index) {
    address.removeAt(index);
    notifyListeners();
  }

  void saveInfo() {}
}
