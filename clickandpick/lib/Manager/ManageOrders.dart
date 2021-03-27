import 'package:ClickandPick/Manager/Manager_drawer.dart';
import 'package:ClickandPick/Manager/Riders.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ManageOrders extends StatefulWidget {
  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  int riderCount;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  QuerySnapshot riderSnap;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  getOrders() {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('Order Recieved to Collection Point', isEqualTo: false)
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: ManagerDrawer(),
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
                                        top: 68.0, left: 25),
                                    child: Container(
                                      child: Text(
                                        ds.id,
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
                                          ds.id;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ManageRiders(
                                                        data: Data(
                                                          id: ds.id,
                                                          name: snapshot.data
                                                                  .docs[index]
                                                              ['name'],
                                                          selleremail: snapshot
                                                                  .data
                                                                  .docs[index]
                                                              ['selleremail'],
                                                          quantity: snapshot
                                                                  .data
                                                                  .docs[index]
                                                              ['quantity'],
                                                          buyeremail: snapshot
                                                                  .data
                                                                  .docs[index]
                                                              ['buyeremail'],
                                                        ),
                                                      )));
                                        },
                                        child: Text('Assign Rider'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 88.0, left: 200),
                                    child: Container(
                                      height: 30,
                                      width: 150,
                                      child: RaisedButton(
                                        color: Colors.green[300],
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(ds.id)
                                              .update({
                                            'Order Recieved to Collection Point':
                                                true
                                          });
                                        },
                                        child: Text('Order Recieved'),
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
