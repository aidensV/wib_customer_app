import 'package:flutter/material.dart';

class MyNavigator {
  static void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }
  static void goToDashboard(BuildContext context) {
    Navigator.pushNamed(context, "/dashboard");
  }
  static void goToTracking(BuildContext context) {
    Navigator.pushNamed(context, "/tracking");
  }
  static void goToRepeatOrder(BuildContext context) {
    Navigator.pushNamed(context, "/repeat_order");
  }
  static void goToListTracking(BuildContext context) {
    Navigator.pushNamed(context, "/list_tracking");
  }
  static void goWishlist(BuildContext context){
    Navigator.pushNamed(context, "/wishlist");
  }
  static void goKeranjang(BuildContext context){
    Navigator.pushNamed(context, "/keranjangbelanja");
  }
}