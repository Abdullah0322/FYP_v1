import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/Manager/Manager_drawer.dart';
import 'package:ClickandPick/Manager/Riders.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  var currentCollectionPoint;
  var snap1;
  getOrders() async {
    User user = FirebaseAuth.instance.currentUser;
    var snap2 = await FirebaseFirestore.instance
        .collection("manager")
        .doc(user.email)
        .get()
        .then((value) {
      setState(() {
        currentCollectionPoint = value.data()['collection point'];
        snap1 = FirebaseFirestore.instance
            .collection('orders')
            .where('Order Recieved to Collection Point', isEqualTo: false)
            .where('collection point', isEqualTo: currentCollectionPoint)
            .snapshots();
      });
    });

    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
    return snap1;
  }

  // getOrders() {
  //   User user = FirebaseAuth.instance.currentUser;

  //   try {
  //     return FirebaseFirestore.instance
  //         .collection('orders')
  //         .where('Order Recieved to Collection Point', isEqualTo: false)
  //         .where(field)
  //         .snapshots();

  //     _refreshController.refreshCompleted();
  //     _refreshController.loadComplete();
  //   } catch (e) {
  //     print(e);
  //     Fluttertoast.showToast(
  //       msg: e,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 3,
  //       backgroundColor: Colors.red[400],
  //       textColor: Colors.white,
  //       fontSize: 15,
  //     );
  //   }
  // }

  void initState() {
    super.initState();
    getOrders();
    User user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFBB03B2),
        title: Text("Orders"),
      ),
      drawer: ManagerDrawer(),
      body: StreamBuilder(
        stream: snap1,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData && snapshot.data.docs.isNotEmpty
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 280),
                                    child: Container(
                                      child: CachedNetworkImage(
                                          imageUrl: ds['image']),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          ' ID: ',
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
                                    child: Row(
                                      children: [
                                        Text(
                                          ' Name :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          ds['name'],
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          ' Buyer Email :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          ds['buyeremail'],
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          ' Phone Number :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          ds['phone'],
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          ' Seller Shop Address :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          ds['shopaddress'],
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          height: 30,
                                          width: 150,
                                          child: ds['Rider'].toString() == ""
                                              ? RaisedButton(
                                                  color: Color(0xFFAC42A6),
                                                  onPressed: () {
                                                    ds.id;

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ManageRiders(
                                                                      data:
                                                                          Data(
                                                                        id: ds
                                                                            .id,
                                                                        name: snapshot
                                                                            .data
                                                                            .docs[index]['name'],
                                                                        selleremail: snapshot
                                                                            .data
                                                                            .docs[index]['selleremail'],
                                                                        quantity: snapshot
                                                                            .data
                                                                            .docs[index]['quantity'],
                                                                        buyeremail: snapshot
                                                                            .data
                                                                            .docs[index]['buyeremail'],
                                                                      ),
                                                                    )));
                                                  },
                                                  child: Text('Assign Rider',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFFFFFFFF))),
                                                )
                                              : RaisedButton(
                                                  onPressed: () {},
                                                  color: Color(0xFFAC42A6),
                                                  child: Center(
                                                    child: Text(
                                                        'Rider has been Assigned'),
                                                  ),
                                                )),
                                      Container(
                                        height: 30,
                                        width: 150,
                                        child: RaisedButton(
                                          color: Color(0xFFAC42A6),
                                          onPressed: () {
                                            return showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
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
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Segoe'),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                            'Order Recieved to Collection Point':
                                                                true
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text('Order Recieved',
                                              style: TextStyle(
                                                  color: Color(0xFFFFFFFF))),
                                        ),
                                      )
                                    ],
                                  ),
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
