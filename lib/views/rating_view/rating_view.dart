import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:frappe_app/widgets/frappe_button.dart';

class ChipChoiceOption {
  String label;
  bool selected;

  ChipChoiceOption({required this.label, required this.selected});
}

class RatingView extends StatefulWidget {
  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  List<int> tag = [0];
  List<ChipChoiceOption> options = [
    ChipChoiceOption(label: "Chất lượng sản phẩm tốt", selected: false),
    ChipChoiceOption(label: "Giao hàng nhanh", selected: false),
    ChipChoiceOption(label: "Cửa hàng phục vụ rất tốt", selected: false),
    ChipChoiceOption(label: "Nhân viên nhiệt tình", selected: false)
  ];

  @override
  Widget build(BuildContext context) {
    double widthContext = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Mã đơn hàng"),
        ),
        body: SingleChildScrollView(
            reverse: true,
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
                    minRating: 0.5,
                    unratedColor: Colors.amber.withOpacity(0.3),
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      size: 20,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
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
                                List<ChipChoiceOption> listOption = [
                                  ...options
                                ];
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
                  TextField(
                    maxLines: 6,
                    decoration: new InputDecoration(
                      hintText:
                          "Hãy chia sẻ với chúng tôi cảm nghĩ của bạn về dịch vụ lần này nhé!!!",
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  FrappeFlatButton(
                      fullWidth: true,
                      height: 48,
                      onPressed: () {},
                      buttonType: ButtonType.primary,
                      title: "Lưu"),
                ],
              ),
            )));
  }
}
