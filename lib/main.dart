import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vender_app_flutter/providers/product_provider.dart';
import 'package:vender_app_flutter/screens/add_newproduct_screen.dart';
import 'package:vender_app_flutter/widgets/reset_password_screen.dart';

import './providers/auth_provider.dart';

import './screens/splash_screen.dart';
import './screens/register_screen.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => AuthProvider()),
      Provider(create: (_) => ProductProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
        fontFamily: 'Lato',
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        ResetPassword.routeName: (ctx) => ResetPassword(),
        AddNewProduct.routeName: (ctx) => AddNewProduct(),
      },
    );
  }
}
