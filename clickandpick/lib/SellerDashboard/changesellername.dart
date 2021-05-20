import 'package:ClickandPick/Login/LoginPage.dart';
import 'package:ClickandPick/app_properties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChnageSellername extends StatefulWidget {
  @override
  _ChnageSellernameState createState() => _ChnageSellernameState();
}

class _ChnageSellernameState extends State<ChnageSellername> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final newname = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var message;
  getUser() async {
    try {
      DocumentSnapshot snap1 = await FirebaseFirestore.instance
          .collection("seller")
          .doc(user.email)
          .get();
      setState(() {
        Sell.userData.username = snap1['username'].toString();
        Sell.userData.email = snap1['email'].toString();
        Sell.userData.address = snap1['address'].toString();
        Sell.userData.phone = snap1['phone'].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    getUser();

    super.initState();
  }

  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget changePasswordButton = InkWell(
      onTap: () {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Are you sure you want to change your name?',
                  style: TextStyle(color: Colors.black, fontFamily: 'Segoe'),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Cancel",
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Segoe'),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Yes",
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Segoe'),
                    ),
                    onPressed: () {
                      User user = FirebaseAuth.instance.currentUser;
                      FirebaseFirestore.instance
                          .collection('seller')
                          .doc(user.email)
                          .update({
                        'username': newname.text,
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      },
      child: Container(
        height: 60,
        width: 180,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: Text("Confirm Change",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        brightness: Brightness.light,
        backgroundColor: Color(0xFFBB03B2),
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SafeArea(
          bottom: true,
          child: LayoutBuilder(
            builder: (b, constraints) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 48.0, top: 16.0),
                            child: Text(
                              'Change Name',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              'Existing Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: Sell.userData.username,
                                      hintStyle: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)))),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 24, bottom: 12.0),
                            child: Text(
                              'Enter new Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: TextField(
                                controller: newname,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'New Name',
                                    hintStyle: TextStyle(fontSize: 12.0)),
                              )),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: bottomPadding != 20 ? 20 : bottomPadding),
                          width: width,
                          child: Center(child: changePasswordButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
