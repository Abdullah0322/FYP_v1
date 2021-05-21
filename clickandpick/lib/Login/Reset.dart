import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/Login/bezierContainer.dart';
import 'package:ClickandPick/Login/loginPage.dart';
import 'package:ClickandPick/Register/registerbuyer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Reset extends StatefulWidget {
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  @override
  final email = TextEditingController();
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width * 0.8,
                  child: TextFormField(
                      controller: email,
                      validator: validateEmail,
                      decoration: InputDecoration(
                          hintText: 'Enter your Email Id',
                          hintStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                          fillColor: Color(0xFFF4F3F4),
                          filled: true)),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        mauth.sendPasswordResetEmail(email: email.text);
                        Fluttertoast.showToast(
                          msg: "Link has been Sent Please Check your email",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red[400],
                          textColor: Colors.white,
                          fontSize: 15,
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                        child: TitleText(
                          text: 'Send Request',
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
