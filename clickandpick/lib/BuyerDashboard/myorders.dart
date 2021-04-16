import 'package:ClickandPick/BuyerDashboard/Buyer_Drawer.dart';
import 'package:ClickandPick/Manager/Riders.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                    return Center(
                      child: Card(
                        child: InkWell(
                          splashColor: Colors.red.withAlpha(30),
                          onTap: () {
                            print('Card tapped.');
                          },
                          child: Container(
                              width: width * 0.93,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          'ID:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          ds['id'],
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      ds['name'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      ds['buyeremail'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      ds.id,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    );
                  })
              : Container();
        },
      ),
    );
  }
}
