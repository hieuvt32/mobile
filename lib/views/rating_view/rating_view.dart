import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/rating_order_request.dart';
import 'package:frappe_app/services/api/api.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/frappe_alert.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/widgets/frappe_button.dart';

class ChipChoiceOption {
  String label;
  bool selected;

  ChipChoiceOption({required this.label, required this.selected});
}

class RatingView extends StatefulWidget {
  RatingView({required this.orderName});

  final String orderName;

  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  List<ChipChoiceOption> options = [
    ChipChoiceOption(label: "Chất lượng sản phẩm tốt", selected: false),
    ChipChoiceOption(label: "Giao hàng nhanh", selected: false),
    ChipChoiceOption(label: "Cửa hàng phục vụ rất tốt", selected: false),
    ChipChoiceOption(label: "Nhân viên nhiệt tình", selected: false)
  ];
  TextEditingController commentControllner = TextEditingController();
  bool isButtonLoading = false;
  double rating = 0;

  Future ratingOrder() async {
    try {
      String comment =
          options.where(((e) => e.selected)).map((e) => e.label).join(', ');
      if (comment.length == 0) {
        comment = commentControllner.value.text;
      }

      if (rating == 0 && comment.length == 0) {
        FrappeAlert.warnAlert(
            title: "Opps",
            subtitle: "Hãy đánh giá chất lượng dịch vụ của chúng tôi",
            context: context);
        return;
      }

      setState(() {
        isButtonLoading = true;
      });

      await locator<Api>().createRatingDonHang(CreateRatingRequest(
          rating: rating, comments: comment, orderName: widget.orderName));

      setState(() {
        isButtonLoading = false;
      });

      FrappeAlert.successAlert(
          title: "Success",
          subtitle: "Cảm ơn bạn đã đánh giá chất lượng dịch vụ của chúng tôi.",
          context: context);
    } catch (e) {
      setState(() {
        isButtonLoading = false;
      });

      FrappeAlert.errorAlert(
          title: "Error",
          subtitle: "Có lỗi xảy ra, vui lòng thử lại sau",
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthContext = MediaQuery.of(context).size.width;
    bool isEnable = !options.any((element) => element.selected);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mã đơn hàng"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Đánh giá dịch vụ",
                  style: TextStyle(
                      color: hexToColor("#00478B"),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Đơn hàng được giao thành công",
                  style: TextStyle(
                      color: hexToColor("#0072BC"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 32,
                ),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  unratedColor: Colors.amber.withOpacity(0.3),
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    size: 20,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    this.rating = rating;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                Wrap(
                  children: options.asMap().entries.map(
                    (entry) {
                      ChipChoiceOption option = entry.value;
                      int index = entry.key;

                      return Container(
                          constraints:
                              BoxConstraints(maxWidth: widthContext / 2 - 10),
                          margin: const EdgeInsets.all(6),
                          child: ChoiceChip(
                            label: Text(option.label),
                            selected: option.selected,
                            selectedColor: Colors.pink,
                            onSelected: (bool selected) {
                              List<ChipChoiceOption> listOption = [...options];
                              listOption[index].selected = selected;
                              setState(() {
                                options = listOption;
                              });
                            },
                          ));
                    },
                  ).toList(),
                ),
                SizedBox(
                  height: 32,
                ),
                isEnable
                    ? Container(
                        height: 120,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          controller: commentControllner,
                          maxLines: 4,
                          textInputAction: TextInputAction.done,
                          decoration: new InputDecoration(
                            hintText:
                                "Hãy chia sẻ với chúng tôi cảm nghĩ của bạn về dịch vụ lần này nhé!!!",
                            hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 14),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 0.0),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 120),
                SizedBox(
                  height: 32,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: hexToColor("#FF0F00")),
                  height: 48,
                  width: double.infinity,
                  child: TextButton(
                      onPressed: isButtonLoading ? null : ratingOrder,
                      child: isButtonLoading
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                              height: 20.0,
                              width: 20.0,
                            )
                          : Text(
                              "Lưu",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                )
              ],
            ),
          )),
    );
  }
}
