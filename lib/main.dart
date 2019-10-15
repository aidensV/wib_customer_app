import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'login.dart';
import 'splash_screen.dart';
import 'tracking/tracking.dart';
import 'wishlist/wishlist.dart';


var routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginPage(),
  "/dashboard": (BuildContext context) => DashboardPage(),
  "/tracking" : (BuildContext context) => Tracking(),
  "/wishlist" : (BuildContext context) => Wishlist(),
};

void main() {
  runApp(new MaterialApp(
    title: "Warung Islami Bogor",
    home: new SplashScreen(),
    theme: new ThemeData(fontFamily: 'TitilliumWeb'),
    debugShowCheckedModeBanner: false,
    routes: routes,
  ));
}

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
      labelStyle: TextStyle(
          color: Color(0xff25282b),
          fontSize: 24.0
      ),
    ),
  );
}

