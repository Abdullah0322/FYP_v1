import 'dart:io';

import 'package:ClickandPick/Manager/Manager_drawer.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ManageRiders extends StatefulWidget {
  final Data data;
  ManageRiders({Key key, this.data}) : super(key: key);
  @override
  _ManageRidersState createState() => _ManageRidersState();
}

class _ManageRidersState extends State<ManageRiders>
    with TickerProviderStateMixin {
  int riderCount;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  QuerySnapshot riderSnap;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  getRider() {
    try {
      return FirebaseFirestore.instance
          .collection('rider')
          .where('available', isEqualTo: true)
          .snapshots();

      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
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

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: containercolor,
      appBar: AppBar(
        title: Text(
          'Click and Pick',
          style: TextStyle(
              fontFamily: 'Segoe', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState.openDrawer();
            /* Write listener code here */
          },
          child: Icon(Icons.menu, color: Colors.black // add custom icons also
              ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green[400],
      ),
      drawer: ManagerDrawer(),
      body: StreamBuilder(
        stream: getRider(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
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
                                        ds['username'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 38.0, left: 25),
                                    child: Container(
                                      child: Text(
                                        ds['email'],
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
                                        color: Colors.green[300],
                                        onPressed: () {
                                           return showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Are you sure you want to assign this rider?',
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
                                                          FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(widget.data.id)
                                              .update({'Rider': ds['email']});
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        
                                        },
                                        child: Text('Assign Order'),
                                      ),
                                    ),
                                  )
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
