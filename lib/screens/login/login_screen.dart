import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/resources/auth_repositories.dart';
import 'package:instagram_clone/screens/home/home_screen.dart';
import 'package:instagram_clone/screens/register/register_screen.dart';
import 'package:instagram_clone/widgets/bordered_input_field.dart';
import 'package:instagram_clone/widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {

  static final String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffold = GlobalKey<ScaffoldState>();
  
  String _email = "", _password = "";

  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 140,),
                    Text("Instagram Clone",
                      style: TextStyle(
                          fontFamily: 'Billabong',
                          fontSize:46
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 36, left: 24, right: 24),
                      child: Form(
                        autovalidate: false,
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            BorderedInputField(
                              placeholder: "Email address",
                              onChanged: (email) {
                                _email = email;
                              },
                              validator: (email) {
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp email_regex = RegExp(pattern);
                                if(email.isEmpty) {
                                  return "E-mail can not be empty.";
                                } else if(!email_regex.hasMatch(email)) {
                                  return "Invalid email.";
                                } else {
                                  return null;
                                }
                              },
                              textInputType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            BorderedInputField(
                              placeholder: "Password",
                              onChanged: (password) {
                                setState(() {
                                  _password = password;
                                });
                              },
                              validator:  (password) {
                                if(password.isEmpty) {
                                  return "Can not enter empty password.";
                                } else if(password.length < 8) {
                                  return "Password must be atleast 8 characters long.";
                                } else {
                                  return null;
                                }
                              },
                              isPassword: true,
                            ),
                            SizedBox(
                              height: 14,),
                            Container(
                              width: double.infinity,
                              child: FlatButton(
                                onPressed: () {
                                  if(_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    login();
                                  }
                                },
                                padding: EdgeInsets.all(16),
                                color: Colors.blue[600],
                                child: Text("Login",
                                style: TextStyle(
                                  fontSize: 15
                                ),),
                                textColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 11
                        ),
                        children: [
                          TextSpan(text: "Forgotten your login details? "),
                          TextSpan(text: "Get help with signing in",
                            recognizer: TapGestureRecognizer()..onTap = () => print("Forget password."),
                              style: TextStyle(
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.w600
                            )),
                          TextSpan(text: '.')
                        ]
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 0.8,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4, right: 4),
                            child: Text("OR",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 0.8,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 11
                        ),
                        children: [
                          TextSpan(text: "Don't have an account? "),
                          TextSpan(text: "Sign up",
                              recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, RegisterScreen.id),
                              style: TextStyle(
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.w600
                            )
                          ),
                          TextSpan(text: ".")
                        ]
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Divider(color: Colors.black12,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: Text("Instagram clone from Ashim",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black38
                        ),
                      ),
                    )
                  ],
                )
              ],
          )
        ),
      ),
    );
  }
  
  void login() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(title: "Logging in...",));
    final res = await _authRepository.login(_email, _password);
    Navigator.pop(context);
    if(res is FirebaseUser) {
      print(res);
    } else {
      if(res is PlatformException) {
        _scaffold.currentState.showSnackBar(
            SnackBar(
              content: Text(res.message),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            )
        );
      }
    }
  }
}
