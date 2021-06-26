import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:frappe_app/config/frappe_icons.dart';
import 'package:frappe_app/utils/frappe_icon.dart';
import 'package:frappe_app/utils/helpers.dart';

class HomeChildView extends StatefulWidget {
  const HomeChildView({Key? key}) : super(key: key);

  @override
  _HomeChildViewState createState() => _HomeChildViewState();
}

class _HomeChildViewState extends State<HomeChildView> {
  final menuList = [
    FrappeIcons.card_collection,
    FrappeIcons.add_user,
    FrappeIcons.arrow_right,
    FrappeIcons.assign,
    FrappeIcons.attachment,
    FrappeIcons.browse
  ];
  @override
  Widget build(BuildContext context) {
    var maxIndex = menuList.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image(
                  image: AssetImage("assets/home_footer.png"),
                  fit: BoxFit.fill,
                );
              },
              itemCount: 3,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
              itemHeight: 50,
              containerHeight: 50,
              // indicatorLayout: PageIndicatorLayout.COLOR,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Wrap(
            children: [
              ...menuList
                  .asMap()
                  .map((i, e) {
                    return MapEntry(
                        i,
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: new Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                child: new Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: FrappeIcon(
                                      e,
                                      color: hexToColor('#FF0F00'),
                                      size: 48,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: hexToColor('#FF0F00'), width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  // margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                ),
                                height: 112,
                                width: 112,
                              ),
                              new Padding(
                                padding: new EdgeInsets.only(top: 6.0),
                                child: new Text("Giao vận"),
                              ),
                              i > (maxIndex - 3)
                                  ? SizedBox(
                                      height: 60,
                                    )
                                  : SizedBox.shrink()
                            ],
                          ),
                        ));
                  })
                  .values
                  .toList(),
            ],
          )
        ]),
      ),
      backgroundColor: Colors.white,
    );
  }
}
