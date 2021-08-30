import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/model/address.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/list_don_bao_binh_loi_response.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/views/base_view.dart';

import 'package:frappe_app/views/edit_gas_broken/list_broken_gas_adress_model.dart';
import 'package:frappe_app/views/expansion_custom_panel.dart';
import 'package:frappe_app/widgets/frappe_button.dart';

class ListBrokenGasAddress extends StatefulWidget {
  ListBrokenGasAddress({this.id, this.customer});

  final String? id;
  final String? customer;

  @override
  _ListBrokenGasAddressState createState() => _ListBrokenGasAddressState();
}

class _ListBrokenGasAddressState extends State<ListBrokenGasAddress> {
  ExpansionItem buildBrokenGasListItem(
      {required bool enableEdit,
      required BinhLoi item,
      required int childIndex,
      required int parentIndex,
      required EditGasBrokenViewModel model}) {
    return ExpansionItem(
        true,
        (isExpanded) => Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mã chế tạo: " + item.serial,
                      style: TextStyle(fontSize: 16)),
                  enableEdit
                      ? isExpanded
                          ? GestureDetector(
                              onTap: () {
                                model.deleteBinhLoiItem(
                                    parentIndex, childIndex);
                              },
                              child: FrappeIcon(
                                FrappeIcons.delete,
                                size: 18,
                              ),
                            )
                          : SizedBox()
                      : SizedBox()
                ],
              ),
            ),
        [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Mã chế tạo: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: enableEdit
                      ? Container(
                          height: 32,
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: item.serialController,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 10),
                            ),
                          ),
                        )
                      : Text(
                          item.serial,
                          style: TextStyle(fontSize: 16),
                        ),
                  flex: 2,
                )
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Lý do báo lỗi: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: enableEdit
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: item.descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                        )
                      : Text(
                          item.description,
                          style: TextStyle(fontSize: 16),
                        ),
                  flex: 2,
                )
              ],
            ),
          ),
        ]);
  }

  ExpansionItem buildExpansionItem({
    required bool enableEdit,
    required DonBaoLoiAddress item,
    required int itemIndex,
    required EditGasBrokenViewModel model,
  }) {
    return ExpansionItem(
        true,
        (isExpanded) => Row(
              children: [
                Text("Địa chỉ:", style: TextStyle(fontSize: 16)),
                enableEdit
                    ? isExpanded
                        ? Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8, right: 8),
                              child: DropdownButtonFormField<String>(
                                value: item.address,
                                hint: Text("Chọn địa chỉ"),
                                isExpanded: true,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(0),
                                    enabledBorder: InputBorder.none),
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                onChanged: (String? newValue) {
                                  model.changeAddress(
                                      itemIndex, newValue ?? "");
                                },
                                items: model.deliveryAddresses.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.diaChi,
                                    child: Text(value.diaChi),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        : Text(
                            item.address ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                    : Text(
                        item.address ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
              ],
            ),
        [
          ExpansionCustomPanel(
              backgroundBodyColor: Colors.white,
              backgroundTitleColor: hexToColor('#F2F8FC'),
              items: item.listBinhloi.asMap().entries.map((entry) {
                return buildBrokenGasListItem(
                    enableEdit: enableEdit,
                    item: entry.value,
                    parentIndex: itemIndex,
                    childIndex: entry.key,
                    model: model);
              }).toList()),
          SizedBox(
            height: 8,
          ),
          enableEdit
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                            color: hexToColor("#0072BC"),
                            borderRadius: BorderRadius.circular(4)),
                        child: TextButton(
                          onPressed: () {
                            model.addBinhLoi(itemIndex);
                          },
                          child: Text(
                            "Thêm bình",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                            color: hexToColor("#FF0F00"),
                            borderRadius: BorderRadius.circular(4)),
                        child: TextButton(
                          onPressed: () {
                            model.deleteAddress(itemIndex);
                          },
                          child: Text(
                            "Xóa địa chỉ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox()
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditGasBrokenViewModel>(
        onModelReady: (model) {
          model.initState(id: widget.id, customer: widget.customer);
        },
        builder: (context, model, child) => Builder(builder: (context) {
              SingleDonBaoBinhLoiRespone? donBaoBinhLoi = model.donBaoBinhLoi;

              List<DonBaoLoiAddress> listDonBaoLoiAddress =
                  donBaoBinhLoi.listDonBaoLoiAddress ?? [];

              bool enableEdit = model.enableEdit;
              String feedback = "";

              if (!enableEdit) {
                feedback = donBaoBinhLoi.feedback ?? "";
              }

              return Scaffold(
                  appBar: AppBar(
                    title: Text("Dánh sách bình lỗi"),
                  ),
                  body: !model.isLoading
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpansionCustomPanel(
                                  backgroundBodyColor:
                                      hexToColor("#0072BC").withOpacity(0.3),
                                  backgroundTitleColor: Colors.white,
                                  backgroundIconColor:
                                      hexToColor("#000000").withOpacity(0.18),
                                  items: listDonBaoLoiAddress
                                      .asMap()
                                      .entries
                                      .map((entry) => buildExpansionItem(
                                          enableEdit: enableEdit,
                                          itemIndex: entry.key,
                                          item: entry.value,
                                          model: model))
                                      .toList()),
                              enableEdit
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: hexToColor("#0072BC"),
                                          radius: Radius.circular(4),
                                          dashPattern: [4, 4],
                                          strokeWidth: 1,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            height: 40,
                                            child: TextButton(
                                                onPressed: () {
                                                  model.addNewAddress();
                                                },
                                                child: Text("Thêm địa chỉ")),
                                          )),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Ghi chú",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              enableEdit
                                  ? TextField(
                                      controller: model.noteFieldController,
                                      maxLines: 4,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.teal)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 10),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        donBaoBinhLoi.description ?? "",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                              SizedBox(
                                height: 16,
                              ),
                              enableEdit
                                  ? Container(
                                      height: 48,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: hexToColor("#FF0F00"),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: TextButton(
                                        onPressed: () {
                                          model
                                              .createDonBaoBinhLoi()
                                              .then((value) {
                                            FrappeAlert.successAlert(
                                                title:
                                                    "Báo bình lỗi thành công.",
                                                context: context);
                                            model.initData();
                                            model.notifyListeners();
                                          }).catchError((err) {
                                            FrappeAlert.errorAlert(
                                                title:
                                                    "Có lỗi xảy ra, vui lòng thử lại sau.",
                                                context: context);
                                          });
                                        },
                                        child: Text(
                                          "Báo bình lỗi",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    )
                                  : feedback.length > 0
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Phản hồi",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                feedback,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            )
                                          ],
                                        )
                                      : Config()
                                              .roles
                                              .contains(UserRole.DieuPhoi)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Phản hồi",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: TextField(
                                                    controller: model
                                                        .feedbackController,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: 3,
                                                    decoration: InputDecoration(
                                                      border: new OutlineInputBorder(
                                                          borderSide:
                                                              new BorderSide(
                                                                  color: Colors
                                                                      .teal)),
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 24),
                                                Container(
                                                  height: 48,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          hexToColor("#0072BC"),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      model.updateDonBaoBinhLoi(
                                                          context);
                                                    },
                                                    child: Text(
                                                      "Gửi phản hồi",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              height: 48,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: hexToColor("#FF0F00"),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: TextButton(
                                                onPressed: () {
                                                  model.deleteDonBinhBaoLoi(
                                                      context);
                                                },
                                                child: Text(
                                                  "Xóa",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                            ],
                          ))
                      : Center(
                          child: CircularProgressIndicator(),
                        ));
            }));
  }
}
