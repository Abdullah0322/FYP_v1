import 'dart:convert';

import 'package:ClickandPick/test2.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart' as http;

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
  void postRequest() async {
    var response = await http.post(
        Uri.parse("http://trailer.solutionsoul.com/api/register"),
        body: jsonEncode(
          {
            "mode": "formdata",
            "formdata": [
              {"key": "name", "value": "demo test", "type": "text"},
              {"key": "email", "value": "cus@gmail.com", "type": "text"},
              {"key": "password", "value": "123456", "type": "text"},
              {"key": "user_type", "value": "0", "type": "text"}
            ]
          },
        ));

    print(json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    //width of the screen
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                height: 250,
                color: Colors.orange,
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 35,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Center(
                    child: Container(
                      width: width * 0.8,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueGrey[900],
                        border: new Border.all(
                          color: Colors.orange,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        controller: email,
                        validator: validateEmail,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          hintText: 'Email Address',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Container(
                      width: width * 0.8,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueGrey[900],
                        border: new Border.all(
                          color: Colors.orange,
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
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: width * 0.8,
                    child: GestureDetector(
                      onTap: () async {
                        postRequest();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Test2()));
                      },
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
                          color: Colors.orange,
                        ),
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Center(
                          child: Text(
                            'Log in',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                            child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              'Forgot your Password?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 15),
                            ),
                          ),
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            child: InkWell(
                          onTap: () {
                            //     Navigator.push(
                            //       context,
                            //     MaterialPageRoute(
                            //     builder: (context) => Registeruser(),
                            // ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 120.0),
                            child: Text(
                              'Signup',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
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
