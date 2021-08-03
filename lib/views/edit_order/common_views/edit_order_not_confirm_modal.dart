import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';

class EditOrderNotConfirmModal extends StatefulWidget {
  const EditOrderNotConfirmModal({Key? key}) : super(key: key);

  @override
  _EditOrderNotConfirmModalState createState() =>
      _EditOrderNotConfirmModalState();
}

class _EditOrderNotConfirmModalState extends State<EditOrderNotConfirmModal> {
  void submitData() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 5),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Wrap(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'Lý do không xác nhận',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 34,
              ),
              TextField(
                maxLines: 8,
                decoration: InputDecoration(
                  // labelText: 'Lý do',
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                controller: titleController,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: hexToColor('#FF0F00'),
                      // side: BorderSide(
                      //   width: 1.0,
                      // ),
                      minimumSize: Size(120, 32),
                      // padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        // side: BorderSide(
                        //   color: hexToColor('#0072BC'),
                        // ),
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return GestureDetector(
                            onTap: () {},
                            child: EditOrderNotConfirmModal(),
                            behavior: HitTestBehavior.opaque,
                          );
                        },
                      );
                    },
                    child: Text(
                      'Không xác nhận',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: hexToColor('#0072BC'),
                      // side: BorderSide(
                      //   width: 1.0,
                      // ),

                      minimumSize: Size(120, 32),
                      // padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        // side: BorderSide(
                        //   color: hexToColor('#FF0F00'),
                        // ),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Lưu',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
