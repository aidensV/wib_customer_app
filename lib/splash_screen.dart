// import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:wib_customer_app/dashboard.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';

// import 'package:wib_customer_app/notification_service/notification_service.dart';
// import 'package:wib_customer_app/pusher/pusher_service.dart';
// import 'utils/Navigator.dart';
// import 'dashboard_view.dart';
// import 'storage/storage.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _username;

  Future<Null> getSharedPrefs() async {
    // DataStore dataStore = new DataStore();
    // _username = await dataStore.getDataString("username");

    // if (_username == 'Tidak ditemukan') {
    //   Timer(Duration(seconds: 2),
    //       () => Navigator.pushReplacementNamed(context, "/login"));
    // } else {
    //   Timer(Duration(seconds: 2),
    //       () => Navigator.pushReplacementNamed(context, "/dashboard"));
    // }
    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          settings: RouteSettings(name: '/dashboard'),
          builder: (BuildContext context) => DashboardPage(),
        ),
      ),
    );
  }

  // Future<void> initPlatformState() async {

  //   // Configure BackgroundFetch.
  //   BackgroundFetch.configure(
  //           BackgroundFetchConfig(
  //               minimumFetchInterval: 1,
  //               stopOnTerminate: false,
  //               startOnBoot: true,
  //               enableHeadless: true,
  //               requiresBatteryNotLow: false,
  //               requiresCharging: false,
  //               requiresStorageNotLow: false,
  //               requiresDeviceIdle: false,
  //               requiredNetworkType: BackgroundFetchConfig.NETWORK_TYPE_NONE),
  //           _onBackgroundFetch)
  //       .then((int status) {
  //     print('[BackgroundFetch] configure success: $status');

  //   }).catchError((e) {
  //     print('[BackgroundFetch] configure ERROR: $e');

  //   });

  //   // Optionally query the current BackgroundFetch status.
  //   int status = await BackgroundFetch.status;

  //   print(status);

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }

  // void _onBackgroundFetch() {

  //   // This is the fetch-event callback.
  //   print('[BackgroundFetch] Event received');
  //   print('AR background fetch is success');

  //   notificationService = new NotificationService(context: context);

  //   notificationService.initStateNotificationCustomerSudahBayarService();
  //   PusherService pusherService =
  //       PusherService(notificationService: notificationService);

  //   pusherService = PusherService(notificationService: notificationService);
  //   pusherService.firePusher();

  //   // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
  //   // for taking too long in the background.
  //   BackgroundFetch.finish();
  // }

  @override
  void initState() {
    // initPlatformState();

    getSharedPrefs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Center(
                    child: Text(
                      "Warung Islami Bogor",
                      style: TextStyle(
                          color: Color(0xff31B057),
                          fontFamily: 'TitilliumWeb',
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
