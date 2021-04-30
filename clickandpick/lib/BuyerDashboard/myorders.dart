import 'package:ClickandPick/BuyerDashboard/Buyer_Drawer.dart';
import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/Manager/Riders.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'light_color.dart';

class Myorders extends StatefulWidget {
  @override
  _MyordersState createState() => _MyordersState();
}

class _MyordersState extends State<Myorders> {
  User user = FirebaseAuth.instance.currentUser;
  getOrders() {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('buyeremail', isEqualTo: user.email)
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
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA579A3),
        title: Text("Orders"),
      ),
      drawer: BuyerDrawer(),
      body: StreamBuilder(
        stream: getOrders(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Column(children: <Widget>[
                      Container(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(children: <Widget>[
                            AspectRatio(
                                aspectRatio: 1.2,
                                child: Stack(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Container(
                                        height: 100,
                                        width: 100,
                                        child: Stack(children: <Widget>[
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: LightColor.lightGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          ),
                                          CachedNetworkImage(
                                              imageUrl: ds['image']),
                                        ])),
                                  ),
                                ])),
                            Expanded(
                                child: ListTile(
                                    title: TitleText(
                                      text: ds['name'].toString(),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    subtitle: Row(
                                      children: <Widget>[
                                        TitleText(
                                          text: '\RS ',
                                          color: LightColor.red,
                                          fontSize: 12,
                                        ),
                                        TitleText(
                                          text: ds['total'].toString(),
                                          fontSize: 14,
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      width: 35,
                                      height: 35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: LightColor.lightGrey
                                              .withAlpha(150),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TitleText(
                                        text: ds['quantity'].toString(),
                                        fontSize: 12,
                                      ),
                                    ))),
                          ]),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 40,
                      ),
                    ]);
                  })
              : Container();
        },
      ),
    );
  }
}
