import 'dart:io';

import 'package:ClickandPick/BuyerDashboard/buyerdashboard.dart';
import 'package:ClickandPick/Manager/ManageOrders.dart';
import 'package:ClickandPick/Register/registerbuyer.dart';
import 'package:ClickandPick/Register/registertype.dart';
import 'package:ClickandPick/RiderDashboard/RiderDashboard.dart';
import 'package:ClickandPick/RiderDashboard/riderPendingOrders.dart';
import 'package:ClickandPick/RiderDashboard/riderProfile.dart';
import 'package:ClickandPick/SellerDashboard/ManageOrders.dart';
import 'package:ClickandPick/SellerDashboard/ManageProducts.dart';
import 'package:ClickandPick/SellerDashboard/seller.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'bezierContainer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        //  Navigator.push(
        //    context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterInterface(),
                    ));
              },
              child: Text(
                'Register',
                style: TextStyle(
                    color: Color(0xFFBB03B2),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'C',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFFBB03B2),
          ),
          children: [
            TextSpan(
              text: 'li',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ck',
              style: TextStyle(color: Color(0xFFBB03B2), fontSize: 30),
            ),
            TextSpan(
              text: '&',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Pi',
              style: TextStyle(color: Color(0xFFBB03B2), fontSize: 30),
            ),
            TextSpan(
              text: 'ck',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final email = TextEditingController();
  bool showPass = true;
  bool login;
  String type;

  void toggle() {
    setState(() {
      showPass = !showPass;
    });
  }

  List user = [];
  List seller = [];
  List rider = [];

  void getUser() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('user').get();

    snap.docs.forEach((element) {
      user.add(element.id);
    });
  }

  void getSeller() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('seller').get();

    snap.docs.forEach((element) {
      seller.add(element.id);
    });
  }

  void getRiders() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('rider').get();

    snap.docs.forEach((element) {
      rider.add(element.id);
    });
  }

  void getmanager() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('manager').get();

    snap.docs.forEach((element) {
      seller.add(element.id);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSeller();
    getUser();
    getRiders();
    getmanager();
  }

  void logIn(String type) async {
    if (type == 'Buyer') {
      setState(() {
        _isInAsyncCall = true;
      });
      try {
        await FirebaseFirestore.instance
            .doc("user/${email.text}")
            .get()
            .then((doc) async {
          if (doc.exists) {
            try {
              // ignore: unused_local_variable
              UserCredential user = await mauth.signInWithEmailAndPassword(
                  email: email.text, password: password.text);
              setState(() {
                login = true;
                _isInAsyncCall = false;
              });
              if (user != null) {}
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => BuyerDashboard()),
                  (route) => false);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                setState(() {
                  login = true;
                  _isInAsyncCall = false;
                });
                Fluttertoast.showToast(
                  msg: "User not found for this email",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red[400],
                  textColor: Colors.white,
                  fontSize: 15,
                );
              } else if (e.code == 'wrong-password') {
                setState(() {
                  login = true;
                  _isInAsyncCall = false;
                });
                Fluttertoast.showToast(
                  msg: "Wrong password",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red[400],
                  textColor: Colors.white,
                  fontSize: 15,
                );
              }
            } catch (e) {
              print("Error: " + e);
            }
          } else {
            setState(() {
              login = true;
              _isInAsyncCall = false;
            });

            Fluttertoast.showToast(
              msg: "User not found for this email",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red[400],
              textColor: Colors.white,
              fontSize: 15,
            );
          }
        });
      } catch (e) {
        setState(() {
          login = true;
          _isInAsyncCall = false;
        });
        print(e);
      }
    } else if (type == 'Seller') {
      setState(() {
        _isInAsyncCall = true;
      });
      try {
        await FirebaseFirestore.instance
            .doc("seller/${email.text}")
            .get()
            .then((doc) async {
          if (doc.exists) {
            try {
              // ignore: unused_local_variable
              UserCredential user = await mauth.signInWithEmailAndPassword(
                  email: email.text, password: password.text);
              setState(() {
                login = true;
                _isInAsyncCall = false;
              });
              if (user != null) {
                try {} catch (e) {
                  print(e);
                }
              }
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ManageProducts()),
                  (route) => false);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                setState(() {
                  login = true;
                  _isInAsyncCall = false;
                });
                Fluttertoast.showToast(
                  msg: "User not found for this email",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red[400],
                  textColor: Colors.white,
                  fontSize: 15,
                );
              } else if (e.code == 'wrong-password') {
                setState(() {
                  login = true;
                  _isInAsyncCall = false;
                });
                Fluttertoast.showToast(
                  msg: "Wrong password",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red[400],
                  textColor: Colors.white,
                  fontSize: 15,
                );
              }
            } catch (e) {
              print("Error: " + e);
            }
          } else {
            setState(() {
              login = true;
              _isInAsyncCall = false;
            });

            Fluttertoast.showToast(
              msg: "User not found for this email",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red[400],
              textColor: Colors.white,
              fontSize: 15,
            );
          }
        });
      } catch (e) {
        setState(() {
          login = true;
        });
        print(e);
      }
    } else if (type == 'Rider') {
      setState(() {
        _isInAsyncCall = true;
      });
      try {
        await FirebaseFirestore.instance
            .doc("rider/${email.text}")
            .get()
            .then((doc) async {
          if (doc.exists) {
            try {
              // ignore: unused_local_variable
              UserCredential user = await mauth.signInWithEmailAndPassword(
                  email: email.text, password: password.text);
              setState(() {
                login = true;
                _isInAsyncCall = false;
              });
              if (user != null) {
                try {} catch (e) {
                  print(e);
                }
              }
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => RiderDashboard()),
                  (route) => false);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                setState(() {
                  login = true;
                  _isInAsyncCall = false;
                });
                Fluttertoast.showToast(
                  msg: "User not found for this email",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red[400],
                  textColor: Colors.white,
                  fontSize: 15,
                );
              } else if (e.code == 'wrong-password') {
                setState(() {
                  login = true;
                  _isInAsyncCall = false;
                });
                Fluttertoast.showToast(
                  msg: "Wrong password",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red[400],
                  textColor: Colors.white,
                  fontSize: 15,
                );
              }
            } catch (e) {
              print("Error: " + e);
            }
          } else {
            setState(() {
              login = true;
              _isInAsyncCall = false;
            });

            Fluttertoast.showToast(
              msg: "User not found for this email",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red[400],
              textColor: Colors.white,
              fontSize: 15,
            );
          }
        });
      } catch (e) {
        setState(() {
          login = true;
        });
        print(e);
      }
    } else if (type == 'Manager') {
      setState(() {
        _isInAsyncCall = true;
      });
      try {
        await FirebaseFirestore.instance
            .doc("manager/${email.text}")
            .get()
            .then((doc) async {
          if (doc.exists) {
            try {
              // ignore: unused_local_variable
              UserCredential user = await mauth.signInWithEmailAndPassword(
                  email: email.text, password: password.text);
              setState(() {
                login = true;
                _isInAsyncCall = false;
              });
              if (user != null) {
                try {} catch (e) {
                  print(e);
                }
              }
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ManageOrders()),
                  (route) => false);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                setState(() {
                  login = true;
                  _isInAsyncCall = false;
                });
                Fluttertoast.showToast(
                  msg: "User not found for this email",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red[400],
                  textColor: Colors.white,
                  fontSize: 15,
                );
              } else if (e.code == 'wrong-password') {
                setState(() {
                  login = true;
                  _isInAsyncCall = false;
                });
                Fluttertoast.showToast(
                  msg: "Wrong password",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red[400],
                  textColor: Colors.white,
                  fontSize: 15,
                );
              }
            } catch (e) {
              print("Error: " + e);
            }
          } else {
            setState(() {
              login = true;
              _isInAsyncCall = false;
            });

            Fluttertoast.showToast(
              msg: "User not found for this email",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red[400],
              textColor: Colors.white,
              fontSize: 15,
            );
          }
        });
      } catch (e) {
        setState(() {
          login = true;
        });
        print(e);
      }
      _isInAsyncCall = false;
    }
  }

  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: _isInAsyncCall,
      child: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Email Id',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: email,
                                  validator: validateEmail,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xFFF4F3F4),
                                      filled: true)),
                              Text(
                                'Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: password,
                                  validator: (input) {
                                    return input.length < 8
                                        ? "Password must be greater than 7 charaters"
                                        : null;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true)),
                              Container(
                                child: RadioButtonGroup(
                                    labels: <String>[
                                      "Buyer",
                                      "Seller",
                                      "Rider",
                                      "Manager",
                                    ],
                                    onChange: (String a, int b) {
                                      setState(() {
                                        type = a;
                                      });
                                    },
                                    onSelected: (String selected) =>
                                        print(selected)),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  FormState fs = _formKey.currentState;
                                  fs.validate();
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      print('connected');
                                      setState(() {
                                        login = false;
                                      });
                                      logIn(type);
                                    }
                                  } on SocketException catch (_) {
                                    print('not connected');
                                    setState(() {
                                      login = false;
                                    });
                                    Fluttertoast.showToast(
                                      msg:
                                          "You're not connected to the internet",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Colors.red[400],
                                      textColor: Colors.white,
                                      fontSize: 15,
                                    );
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            offset: Offset(2, 4),
                                            blurRadius: 5,
                                            spreadRadius: 2)
                                      ],
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFFAC42A6),
                                            Color(0xFF82168B)
                                          ])),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    _divider(),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class Rider {
  static final Rider _singleton = Rider._internal();
  factory Rider() => _singleton;
  Rider._internal();
  static Rider get userData => _singleton;

  String username;
  String phone;
  String vehicle;
  String vehiclereg;
  String email;
}

class Sell {
  static final Sell _singleton = Sell._internal();
  factory Sell() => _singleton;
  Sell._internal();
  static Sell get userData => _singleton;

  String username;
  String phone;
  String city;
  String gender;
  String address;
  String email;

  List<String> favProdcts;
}

class Buyer {
  static final Buyer _singleton = Buyer._internal();
  factory Buyer() => _singleton;
  Buyer._internal();
  static Buyer get userData => _singleton;
  String username;
  String phone;
  String city;
  String gender;
  String address;
  String email;
  List<String> favProdcts;
}

class Manager {
  static final Manager _singleton = Manager._internal();
  factory Manager() => _singleton;
  Manager._internal();
  static Manager get userData => _singleton;
  String username;
  String phone;
  String city;
  String gender;
  String address;
  String email;
  List<String> favProdcts;
}

String validateEmail(String value) {
  print("validateEmail : $value ");

  if (value.isEmpty) return "enter email";

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regex = new RegExp(pattern);

  if (!regex.hasMatch(value.trim())) {
    return "the email address is not valid";
  }

  return null;
}
