// import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wib_customer_app/notification_service/notification_service.dart';
import 'package:wib_customer_app/pages/account/account.dart';
import 'package:wib_customer_app/pages/account/setting.dart';

// Remember import flutter/material package first
import 'dashboard.dart';
import 'login.dart';
import 'splash_screen.dart';
import 'package:provider/provider.dart';

import 'pages/tracking/list.dart';
import 'pages/tracking/tracking.dart';
import 'pages/tracking_list/tracking.dart';
import 'pages/repeat_order/repeat_order.dart';
import 'pages/wishlist/wishlist.dart';
import 'pages/shopping_cart/shoppingcart.dart';
import 'pages/checkout/checkout.dart';
import 'pages/shops/bloc.dart';
import 'pages/shops/detail.dart';
import 'pages/profile/profile.dart';
import 'pages/test/test.dart';

// This route for identifi when you use navigator
Map<String, WidgetBuilder> routesX = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginPage(),
  "/dashboard": (BuildContext context) => DashboardPage(),
  "/list_tracking" : (BuildContext context) => ListNotaTracking(),
  "/tracking" : (BuildContext context) => Tracking(),
  "/wishlist" : (BuildContext context) => Wishlist(),
  "/keranjangbelanja" : (BuildContext context) => Keranjang(),
  "/tracking_list" : (BuildContext context) => TrackingList(),
  "/repeat_order" : (BuildContext context) => RepeatOrder(),
  "/repeat_order" : (BuildContext context) => RepeatOrder(),
  "/checkout" : (BuildContext context) => Checkout(),
  "/details" : (BuildContext context) => DetailShop(),
  '/profile' : (BuildContext context) => ProfilePage(),
  '/account' : (BuildContext context) => Account(),
  '/settingprofile' : (BuildContext context) => SettingProfile(),
  "/test" : (BuildContext context) => TestCode()

};

// void backgroundFetchHeadlessTask() async {
//   print('[BackgroundFetch] Headless event received.');
//   print('AR background fetch headless is success');
//   BackgroundFetch.finish();
// }

void main() {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  runApp(MyApp());

  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopBloc>(
        builder: (context) => ShopBloc(),
        child: MaterialApp(
          title: "Warung Islami Bogor Shop",
          home: new SplashScreen(),
          // this below syntax how you set default font for apps
          // Remember to add font first in pubspec.yaml
          // Remeber only use free fonts if you cant buy font dont force it mate :))
          theme: new ThemeData(fontFamily: 'Roboto'),
          debugShowCheckedModeBanner: false,
          // debungShowCheckedModeBanner: false, this syntax for remove dubugbanner on left top phone screem
          routes: routesX,
        ));
  }
}

// This ThemeData for default color in this application, you can use it or this will add automaticly as defaul color, i dont know to :))
// #Best Regards Previous Programmer :))) GLHF
ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
    primaryColor: Color(0xff25282b),
    accentColor: Color(0xff31B057),
    scaffoldBackgroundColor: Colors.white,
    buttonColor: Color(0xff31B057),
    hintColor: Color(0xff31B057),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(color: Color(0xff25282b), fontSize: 24.0),
    ),
  );
}
