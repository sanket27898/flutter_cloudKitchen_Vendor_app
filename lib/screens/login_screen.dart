import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vender_app_flutter/screens/home_screen.dart';
import 'package:vender_app_flutter/screens/register_screen.dart';
import 'package:vender_app_flutter/widgets/reset_password_screen.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Icon icon;
  bool _visible = false;
  var _emailTextController = TextEditingController();
  String email;
  String password;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'images/logo.png',
                          height: 60,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailTextController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Email';
                        }
                        final bool _isVaild =
                            EmailValidator.validate(_emailTextController.text);
                        if (!_isVaild) {
                          return 'Invalid Email Formate';
                        }
                        setState(() {
                          email = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                          ),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Password';
                        }
                        if (value.length < 6) {
                          return 'Minimum 6 characters';
                        }
                        setState(() {
                          password = value;
                        });
                        return null;
                      },
                      obscureText: _visible == false ? true : false,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _visible
                                ? Icon(Icons.remove_red_eye_outlined)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                          ),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ResetPassword.routeName);
                          },
                          child: Text(
                            'Forgot Password ? ',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _loading = true;
                                });
                                _authData
                                    .loginVendor(email, password)
                                    .then((credential) {
                                  if (credential != null) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    Navigator.pushReplacementNamed(
                                        context, HomeScreen.routeName);
                                  } else {
                                    setState(() {
                                      _loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(_authData.error),
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                            child: _loading
                                ? LinearProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FlatButton(
                          padding: EdgeInsets.zero,
                          child: RichText(
                            text: TextSpan(text: '', children: [
                              TextSpan(
                                  text: 'Don\'t have an account ? ',
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  )),
                            ]),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegisterScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
