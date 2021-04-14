import 'dart:io';

import 'package:ClickandPick/Login/LoginPage.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../utils/colors.dart';

final FirebaseAuth mauth = FirebaseAuth.instance;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final email = TextEditingController();
  final confirm = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  bool signUp;
  bool showPass = true;
  bool showconfirmPass = true;
  void toggle() {
    setState(() {
      showPass = !showPass;
    });
  }

  void toggleconfirm() {
    setState(() {
      showconfirmPass = !showconfirmPass;
    });
  }

  final requiredValidator =
      RequiredValidator(errorText: 'this field is required');
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  ]);
  void signup() async {
    try {
      // ignore: unused_local_variable
      UserCredential user = await mauth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      User users = FirebaseAuth.instance.currentUser;

      setState(() {
        signUp = true;
      });
      if (user != null) {
        try {
          FirebaseFirestore.instance
              .collection("user")
              .doc("${email.text}")
              .set({
            'created_at': Timestamp.now(),
            'username': name.text,
            'email': email.text,
            'phone': phone.text,
            'address': ''
          });
        } catch (e) {
          print('Error is: ' + e);
        }
      }
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Registered successfully!',
                style: TextStyle(color: Colors.black, fontFamily: 'Segoe'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.black, fontFamily: 'Segoe'),
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  },
                ),
              ],
            );
          }).then((value) async {
        try {
          await FirebaseAuth.instance.signOut();
        } catch (e) {
          print(e);
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "Email already in use",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15,
        );
      }
    } catch (e) {
      print("Error: " + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    //width of the screen
    var width = MediaQuery.of(context).size.width;
    int emailValidate;
    bool emailValidatorvar;
    return Scaffold(
      backgroundColor: containercolor,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(25, 70, 0, 0),
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
                    padding: EdgeInsets.fromLTRB(25, 110, 0, 0),
                    child: Text(
                      'Signup to  ',
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
                      'get started',
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
                          controller: name,
                          validator: requiredValidator,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: 'Name',
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
                          controller: password,
                          validator: passwordValidator,
                          obscureText: showPass,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: toggle,
                                child: Icon(
                                  Icons.remove_red_eye,
                                  size: 20,
                                  color: Colors.grey,
                                )),
                            contentPadding: EdgeInsets.only(left: 10, top: 15),
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
                          controller: confirm,
                          validator: (val) {
                            if (val.isEmpty) return 'Empty';
                            if (val != password.text) return 'Not Match';
                            return null;
                          },
                          obscureText: showconfirmPass,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: toggleconfirm,
                                child: Icon(
                                  Icons.remove_red_eye,
                                  size: 20,
                                  color: Colors.grey,
                                )),
                            contentPadding: EdgeInsets.only(left: 10, top: 15),
                            hintText: 'Confirm Password',
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
                          controller: phone,
                          validator: validateMobile,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: headingcolor),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: width - width * 0.08,
                      child: GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              if (result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                print('connected');
                                setState(() {
                                  signUp = false;
                                });
                                signup();
                              }
                            } on SocketException catch (_) {
                              print('not connected');
                              setState(() {
                                signUp = false;
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
                          }
                        },
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: buttoncolor,
                            ),
                            height: 55,
                            width: width * 0.8,
                            child: Center(
                              child: Text(
                                'Sign Up',
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
                              'Already have an account?',
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
                                  builder: (context) => LoginPage(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 120.0),
                            child: Text(
                              'Signin',
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
            ]),
      ),
    );
  }
}

String validateEmail(String value) {
  print("validateEmail : $value ");

  if (value.isEmpty) return "This field is required";

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regex = new RegExp(pattern);

  if (!regex.hasMatch(value.trim())) {
    return "The Email Address is not valid";
  }

  return null;
}

String validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}
