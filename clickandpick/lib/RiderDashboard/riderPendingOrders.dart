import 'package:ClickandPick/Login/login.dart';
import 'package:ClickandPick/RiderDashboard/Rider_Drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PendingOrders extends StatefulWidget {
  PendingOrders({Key key}) : super(key: key);
  @override
  _PendingOrdersState createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  var gg;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  QuerySnapshot riderSnap;
  getOrders() {
    User user = FirebaseAuth.instance.currentUser;
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('Rider', isEqualTo: Rider.userData.email)
          .where('Order Dilevered to Collection Point', isEqualTo: false)
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
        title: Text(
          "Pending Orders",
        ),
      ),
      drawer: Riderdrawer(),
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
                                        ds['selleremail'],
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
                                          FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(ds.id)
                                              .update({
                                            'Order Dilevered to Collection Point':
                                                true
                                          });
                                        },
                                        child: Text('Order Delivered'),
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
