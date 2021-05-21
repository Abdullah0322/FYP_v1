import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Check extends StatefulWidget {
  final Data data;
  Check({Key key, this.data}) : super(key: key);
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  List picked = [false, false];

  int totalAmount = 0;

  pickToggle(index) {
    setState(() {
      picked[index] = !picked[index];
      getTotalAmount();
    });
  }

  getTotalAmount() {
    var count = 0;
    for (int i = 0; i < picked.length; i++) {
      if (picked[i]) {
        count = count + 1;
      }
      if (i == picked.length - 1) {
        setState(() {
          totalAmount = 248 * count;
        });
      }
    }
  }

  getUsers() {
    User user = FirebaseAuth.instance.currentUser;
    try {
      return FirebaseFirestore.instance
          .collection('user')
          .doc(user.email)
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  setquant() async {
    QuerySnapshot snap2 = await FirebaseFirestore.instance
        .collection('seller')
        .doc(user.email)
        .collection('products')
        .doc('category')
        .collection('kids')
        .get();
  }

  void initState() {
    getprice();
    super.initState();
  }

  double price = 0;

  int length;
  double gettol = 0;
  getphone() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.email)
        .get();
    setState(() {
      g = snap['phone'];
    });
  }

  var g;

  getprice() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.email)
          .collection('cart')
          .snapshots()
          .listen((event) {
        double abc = 0;
        setState(() {
          event.docs.forEach((x) {
            abc += int.parse(x['price']) * x['quantity'];
          });
          price = abc;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
    return price;
  }

  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(children: [
                Stack(children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                  ),
                  Container(
                    height: 250.0,
                    width: double.infinity,
                    color: Color(0xFFFDD148),
                  ),
                  Positioned(
                    bottom: 450.0,
                    right: 100.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200.0),
                        color: Color(0xFFFEE16D),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 500.0,
                    left: 150.0,
                    child: Container(
                        height: 300.0,
                        width: 300.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Color(0xFFFEE16D).withOpacity(0.5))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: IconButton(
                        alignment: Alignment.topLeft,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {}),
                  ),
                  Positioned(
                      top: 75.0,
                      left: 15.0,
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      )),
                  Positioned(
                    top: 150.0,
                    child: Column(
                      children: <Widget>[
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('user')
                                .doc(user.email)
                                .collection('cart')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              return snapshot.hasData
                                  ? ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DocumentSnapshot ds =
                                            snapshot.data.docs[index];
                                        return Container(
                                          child: Text(ds['name']),
                                        );
                                      },
                                    )
                                  : Container(
                                      height: 30,
                                      width: 30,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                            }),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 600.0, bottom: 15.0),
                      child: Container(
                          height: 50.0,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('Total: \$' + totalAmount.toString()),
                              SizedBox(width: 10.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  onPressed: () {},
                                  elevation: 0.5,
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      'Pay Now',
                                    ),
                                  ),
                                  textColor: Colors.white,
                                ),
                              )
                            ],
                          )))
                ])
              ])
            ]),
      ),
    );
  }
}
