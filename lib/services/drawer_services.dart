import 'package:flutter/material.dart';
import 'package:vender_app_flutter/screens/dashboard_screen.dart';
import 'package:vender_app_flutter/screens/product_screen.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == 'Dashboard') {
      return MainScreen();
    }
    if (title == 'Product') {
      return ProductScreen();
    }
    return MainScreen();
  }
}
