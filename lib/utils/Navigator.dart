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

}