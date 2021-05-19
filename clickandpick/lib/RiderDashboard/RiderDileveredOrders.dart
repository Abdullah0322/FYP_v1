import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/Login/loginPage.dart';
import 'package:ClickandPick/RiderDashboard/Rider_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RiderDilevered extends StatefulWidget {
  @override
  _RiderDileveredState createState() => _RiderDileveredState();
}

class _RiderDileveredState extends State<RiderDilevered> {
  var gg;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  QuerySnapshot riderSnap;
  getOrders() {
    User user = FirebaseAuth.instance.currentUser;
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('Rider', isEqualTo: Rider.userData.email)
          .where('Order Dilevered to Collection Point', isEqualTo: true)
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
    var screenWidth = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delivered Orders",
        ),
      ),
      drawer: Riderdrawer(),
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
                                    padding: const EdgeInsets.only(left: 280),
                                    child: Container(
                                      child: CachedNetworkImage(
                                          imageUrl: ds['image']),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18.0),
                                    child: Container(
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 38.0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            ' Name: ',
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 58.0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            ' Seller email: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ds['selleremail'],
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
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
                      text: 'You have Dilevered No Order',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ));
        },
      ),
    );
  }
}
