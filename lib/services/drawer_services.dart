import 'package:flutter/material.dart';
import '../screens/banner_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/product_screen.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == 'Dashboard') {
      return MainScreen();
    }
    if (title == 'Product') {
      return ProductScreen();
    }
    if (title == 'Banner') {
      return BannerScreen();
    }
    return MainScreen();
  }
}
