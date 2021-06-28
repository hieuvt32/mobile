import 'package:flutter/material.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'notification.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final notifications = [
    NotificationModel(
        title: 'Khách hàng Phạm Văn A vừa tạo 1 đơn hàng tại chi nhánh Hạ Long',
        time: '30 phút trước',
        isReaded: true),
    NotificationModel(
        title: 'Khách hàng Phạm Văn A vừa tạo 1 đơn hàng tại chi nhánh Hạ Long',
        time: '30 phút trước',
        isReaded: true),
    NotificationModel(
        title: 'Khách hàng Phạm Văn A vừa tạo 1 đơn hàng tại chi nhánh Hạ Long',
        time: '30 phút trước',
        isReaded: false),
    NotificationModel(
        title: 'Khách hàng Phạm Văn A vừa tạo 1 đơn hàng tại chi nhánh Hạ Long',
        time: '30 phút trước',
        isReaded: false),
    NotificationModel(
        title: 'Khách hàng Phạm Văn A vừa tạo 1 đơn hàng tại chi nhánh Hạ Long',
        time: '30 phút trước',
        isReaded: false),
    NotificationModel(
        title: 'Khách hàng Phạm Văn A vừa tạo 1 đơn hàng tại chi nhánh Hạ Long',
        time: '30 phút trước',
        isReaded: false),
    NotificationModel(
        title: 'Khách hàng Phạm Văn A vừa tạo 1 đơn hàng tại chi nhánh Hạ Long',
        time: '30 phút trước',
        isReaded: false),
    NotificationModel(
        title: 'Khách hàng Phạm Văn A vừa tạo 1 đơn hàng tại chi nhánh Hạ Long',
        time: '30 phút trước',
        isReaded: false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            // Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_to_drive),
            onPressed: () {
              // Get.back();
            },
          )
        ],
        title: Text(
          'Thông báo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // body: AnswerButton(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: hexToColor('#007BFF'),
                                width: notifications[index].isReaded ? 0 : 1),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: notifications[index].isReaded
                                ? hexToColor('#DFECF4')
                                : null),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 26, 8),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    '${notifications[index].title}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '${notifications[index].time}',
                                    style: TextStyle(
                                        fontSize: 6,
                                        fontWeight: FontWeight.w400,
                                        color: hexToColor('#00478B')),
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: notifications.length,
                ),
              ),
            ],
          ),
        ), /* add child content here */
      ),
      backgroundColor: Colors.white,
    );
  }
}
