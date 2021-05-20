import 'dart:ui';

import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/Manager/Riders.dart';
import 'package:ClickandPick/SellerDashboard/Seller_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ClickandPick/Login/LoginPage.dart';

class SellerOrders extends StatefulWidget {
  @override
  _SellerOrdersState createState() => _SellerOrdersState();
}

class _SellerOrdersState extends State<SellerOrders> {
  var gg;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  QuerySnapshot riderSnap;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  getOrders() {
    User user = FirebaseAuth.instance.currentUser;
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('selleremail', isEqualTo: user.email)
          .where('picked from vendor', isEqualTo: false)
          .snapshots();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: e,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
        fontSize: 15,
      );
    }
  }

  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var screenWidth = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFBB03B2),
        title: Text("Pending Orders"),
      ),
      drawer: SellerDrawer(),
      body: StreamBuilder(
        stream: getOrders(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData && snapshot.data.docs.isNotEmpty
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Center(
                      child: Card(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            print('Card tapped.');
                          },
                          child: SizedBox(
                              width: width * 0.93,
                              height: 120,
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 10),
                                    child: Container(
                                      child: Text(
                                        ds['id'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 38.0, left: 25),
                                        child: Container(
                                          child: Text(
                                            ds['name'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 280),
                                    child: Container(
                                      child: CachedNetworkImage(
                                          imageUrl: ds['image']),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 68.0, left: 25),
                                    child: Container(
                                      child: Text(
                                        ds['buyeremail'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 17),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 88.0, left: 100),
                                    child: Container(
                                      height: 30,
                                      width: 150,
                                      child: RaisedButton(
                                        color: Color(0xFFBB03B2),
                                        onPressed: () {
                                          return showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Are you sure the item is picked by Rider?',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Segoe'),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Segoe'),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Segoe'),
                                                      ),
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'orders')
                                                            .doc(ds.id)
                                                            .update({
                                                          'picked from vendor':
                                                              true
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text(
                                          'Picked by Rider',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  })
              : Container(
                  height: height * 0.2,
                  width: screenWidth,
                  child: Center(
                    child: TitleText(
                      text: 'You Dont have any Orders',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ));
        },
      ),
    );
  }
}
