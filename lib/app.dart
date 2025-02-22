// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:frappe_app/views/home_view.dart';
import 'package:provider/provider.dart';

import 'lifecycle_manager.dart';

import 'model/config.dart';
import 'utils/enums.dart';

import 'services/connectivity_service.dart';

import 'views/login/login_view.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class FrappeApp extends StatefulWidget {
  @override
  _FrappeAppState createState() => _FrappeAppState();
}

class _FrappeAppState extends State<FrappeApp> {
  bool _isLoggedIn = false;
  bool _isLoaded = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() {
    setState(() {
      _isLoggedIn = Config().isLoggedIn;
    });

    _isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: LifeCycleManager(
        child: StreamProvider<ConnectivityStatus>(
          initialData: ConnectivityStatus.offline,
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          child: MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale(
                'en',
              ),
              Locale(
                'vi',
              ),
            ],
            navigatorKey: navigatorKey,
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            title: 'Hạ Long Gas',
            theme: new ThemeData(
              // textTheme: GoogleFonts.interTextTheme(
              //   Theme.of(context).textTheme.apply(
              //       // fontSizeFactor: 0.7,
              //       ),
              // ),
              disabledColor: Colors.black,
              primaryColor: Colors.white,
              accentColor: Colors.black54,
            ),
            home: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                body: _isLoaded
                    ? _isLoggedIn
                        ? HomeView()
                        : Login()
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
