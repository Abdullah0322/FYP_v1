import 'dart:io';

import 'package:ClickandPick/BuyerDashboard/buyerdashboard.dart';
import 'package:ClickandPick/Intro.dart';
import 'package:ClickandPick/Manager/ManageOrders.dart';
import 'package:ClickandPick/Register/registerbuyer.dart';
import 'package:ClickandPick/Register/registertype.dart';
import 'package:ClickandPick/RiderDashboard/riderPendingOrders.dart';
import 'package:ClickandPick/SellerDashboard/seller.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../BuyerDashboard/buyerdashboard.dart';
import '../utils/colors.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  MaterialPageRoute(builder: (context) => SellerDashboard()),
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
                  MaterialPageRoute(builder: (context) => PendingOrders()),
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
    print(type);
    //height of the screen
    var height = MediaQuery.of(context).size.height;
    //width of the screen
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: containercolor,
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 110, 0, 0),
                    child: Text(
                      'Hello!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: headingcolor,
                        fontSize: 35,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 150, 0, 0),
                    child: Text(
                      'Please',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: headingcolor,
                        fontSize: 35,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 190, 0, 0),
                    child: Text(
                      'Signin',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: headingcolor,
                        fontSize: 35,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: width * 0.8,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        child: TextFormField(
                          controller: email,
                          validator: validateEmail,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: 'Email Address',
                            hintStyle: TextStyle(color: headingcolor),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        width: width * 0.8,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        child: TextFormField(
                          obscureText: true,
                          controller: password,
                          validator: (input) {
                            return input.length < 8
                                ? "Password must be greater than 7 charaters"
                                : null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: headingcolor),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
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
                            onSelected: (String selected) => print(selected)),
                      ),
                    ),
                    Container(
                      width: width - width * 0.08,
                      child: GestureDetector(
                        onTap: () async {
                          FormState fs = _formKey.currentState;
                          fs.validate();

                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
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
                              msg: "You're not connected to the internet",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red[400],
                              textColor: Colors.white,
                              fontSize: 15,
                            );
                          }
                        },
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF667EEA),
                                    offset: Offset(0, 6),
                                    blurRadius: 3,
                                    spreadRadius: -4)
                              ],
                              borderRadius: BorderRadius.circular(6),
                              color: buttoncolor,
                            ),
                            height: 55,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Center(
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Container(
                            child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              'Forgot your Password?',
                              style: TextStyle(
                                color: headingcolor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )),
                        Container(
                            child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterInterface(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 120.0),
                            child: Text(
                              'Signup',
                              style: TextStyle(
                                color: headingcolor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Rider {
  static final Rider _singleton = Rider._internal();
  factory Rider() => _singleton;
  Rider._internal();
  static Rider get userData => _singleton;

  String username;
  String phone;

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
