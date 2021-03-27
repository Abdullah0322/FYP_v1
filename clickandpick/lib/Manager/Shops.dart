import 'dart:io';

import 'package:ClickandPick/Login/login.dart';
import 'package:ClickandPick/Manager/Manager_drawer.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ManageShops extends StatefulWidget {
  String type;
  ManageShops({this.type});
  @override
  _ManageShopsState createState() => _ManageShopsState();
}

class _ManageShopsState extends State<ManageShops> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var sellerCount;
  var gg;
  QuerySnapshot sellerSnap;
  void getUser() async {
    User user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot snap2 = await FirebaseFirestore.instance
        .collection("manager")
        .doc(user.email)
        .get();

    Manager.userData.email = snap2['email'].toString();
    gg = snap2['collection point'].toString();

    QuerySnapshot snap1 = await FirebaseFirestore.instance
        .collection('seller')
        .where('collection point', isEqualTo: gg)
        .get();
    setState(() {
      sellerCount = snap1.docs.length;
      sellerSnap = snap1;
    });
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    var width = MediaQuery.of(context).size.width;

    return sellerSnap == null
        ? Container(
            height: 30,
            width: 30,
            child: Center(child: CircularProgressIndicator()))
        : Scaffold(
            key: scaffoldKey,
            backgroundColor: containercolor,
            appBar: AppBar(
              title: Text(
                'Click and Pick',
                style: TextStyle(
                    fontFamily: 'Segoe',
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              leading: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState.openDrawer();
                  /* Write listener code here */
                },
                child: Icon(Icons.menu,
                    color: Colors.black // add custom icons also
                    ),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.green[400],
            ),
            drawer: ManagerDrawer(),
            body: Container(
                child: ListView.builder(
              itemCount: sellerCount,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                child: Center(
                  child: Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                          width: width * 0.93,
                          height: 120,
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25.0, top: 10),
                                child: Container(
                                  child: Text(
                                    sellerSnap.docs[index]['username'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 38.0, left: 25),
                                child: Container(
                                  child: Text(
                                    sellerSnap.docs[index]['email'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 58.0, left: 25),
                                child: Container(
                                  child: Text(
                                    sellerSnap.docs[index]['shopname'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 78.0, left: 25),
                                child: Container(
                                  child: Text(
                                    sellerSnap.docs[index]['address'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            )));
  }
}
