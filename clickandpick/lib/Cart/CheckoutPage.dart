import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/BuyerDashboard/light_color.dart';

class Checkout extends StatefulWidget {
  final Data data;
  Checkout({Key key, this.data}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

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

  void initState() {
    getprice();
    super.initState();
  }

  double price = 0;

  int length;
  double gettol = 0;

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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: containercolor,
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            "ADDRESS",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        body: Builder(builder: (context) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      StreamBuilder(
                          stream: getUsers(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            return snapshot.hasData
                                ? Container(
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                    ),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            border: Border.all(
                                                color: Colors.grey.shade200)),
                                        padding: EdgeInsets.only(
                                            left: 12, top: 8, right: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data['username'],
                                                  style: CustomTextStyle
                                                      .textFormFieldSemiBold
                                                      .copyWith(fontSize: 14),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 8,
                                                      right: 8,
                                                      top: 4,
                                                      bottom: 4),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      color:
                                                          Colors.grey.shade300,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  16))),
                                                  child: Text(
                                                    "HOME",
                                                    style: CustomTextStyle
                                                        .textFormFieldBlack
                                                        .copyWith(
                                                            color: Colors
                                                                .indigoAccent
                                                                .shade200,
                                                            fontSize: 8),
                                                  ),
                                                )
                                              ],
                                            ),
                                            createAddressText(
                                                snapshot.data['email'], 6),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: "Mobile : ",
                                                    style: CustomTextStyle
                                                        .textFormFieldMedium
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color: Colors.grey
                                                                .shade800)),
                                                TextSpan(
                                                    text:
                                                        snapshot.data['phone'],
                                                    style: CustomTextStyle
                                                        .textFormFieldBold
                                                        .copyWith(
                                                            color: Colors.black,
                                                            fontSize: 12)),
                                              ]),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Container(
                                              color: Colors.grey.shade300,
                                              height: 1,
                                              width: double.infinity,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                        child: CircularProgressIndicator()));
                          }),
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
                                      return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  height: 250,
                                                  margin: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      top: 16),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  16))),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 8,
                                                            left: 8,
                                                            top: 8,
                                                            bottom: 8),
                                                        width: 80,
                                                        height: 80,
                                                        child:
                                                            CachedNetworkImage(
                                                                imageUrl: ds[
                                                                    'image']),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            8,
                                                                        top: 4),
                                                                child: Text(
                                                                  ds['name']
                                                                      .toString(),
                                                                  maxLines: 2,
                                                                  softWrap:
                                                                      true,
                                                                  style: CustomTextStyle
                                                                      .textFormFieldSemiBold
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14),
                                                                ),
                                                              ),
                                                              Utils.getSizedBox(
                                                                  height: 6),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      ds['total']
                                                                              .toString() +
                                                                          " RS ",
                                                                      style: CustomTextStyle
                                                                          .textFormFieldBlack
                                                                          .copyWith(
                                                                              color: Colors.black),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              FittedBox(
                                                                child:
                                                                    Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        ds['selleremail']
                                                                            .toString(),
                                                                        style: CustomTextStyle
                                                                            .textFormFieldBlack
                                                                            .copyWith(color: Colors.black),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      " Quantity " +
                                                                          ds['quantity']
                                                                              .toString(),
                                                                      style: CustomTextStyle
                                                                          .textFormFieldBlack
                                                                          .copyWith(
                                                                              color: Colors.black),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        flex: 100,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 200.0),
                                                  child: Center(
                                                    child: Container(
                                                      width: 300,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 12),
                                                      child: RaisedButton(
                                                        onPressed: () {
                                                          return showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Are you sure you want to buy this product',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'Segoe'),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                      child:
                                                                          Text(
                                                                        "Cancel",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily: 'Segoe'),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child:
                                                                          Text(
                                                                        "Yes",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily: 'Segoe'),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        User user = FirebaseAuth
                                                                            .instance
                                                                            .currentUser;
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('user')
                                                                            .doc(user.email)
                                                                            .collection('orders')
                                                                            .doc()
                                                                            .set({
                                                                          'name':
                                                                              ds['name'],
                                                                          'selleremail':
                                                                              ds['selleremail'].toString(),
                                                                          'id':
                                                                              ds['id'].toString(),
                                                                          'quantity':
                                                                              ds['quantity'].toString()
                                                                        });

                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('orders')
                                                                            .doc()
                                                                            .set({
                                                                          'name':
                                                                              ds['name'],
                                                                          'selleremail':
                                                                              ds['selleremail'].toString(),
                                                                          'id':
                                                                              ds['id'].toString(),
                                                                          'quantity':
                                                                              ds['quantity'].toString(),
                                                                          'price':
                                                                              ds['price'],
                                                                          'total':
                                                                              ds['total'],
                                                                          'image':
                                                                              ds['image'],
                                                                          'buyeremail':
                                                                              user.email,
                                                                          'picked from vendor':
                                                                              false,
                                                                          'Order Dilevered to Collection Point':
                                                                              false,
                                                                          'Order Recieved to Collection Point':
                                                                              false,
                                                                          'Rider':
                                                                              ""
                                                                        });
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('user')
                                                                            .doc(user.email)
                                                                            .collection('cart')
                                                                            .doc(ds.id)
                                                                            .delete();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        showThankYouBottomSheet(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Text(
                                                          "Place Order",
                                                          style: CustomTextStyle
                                                              .textFormFieldMedium
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        color: Colors.pink,
                                                        textColor: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]);
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    height: 50.0,
                    width: 300.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TitleText(
                            text: 'Total',
                            color: LightColor.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TitleText(
                            text: '${price}' + " RS " ?? "",
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  showThankYouBottomSheet(BuildContext context) {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage("images/ic_thank_you.png"),
                    width: 300,
                  ),
                ),
              ),
              flex: 5,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                "\n\nThank you for your purchase. Our company values each and every customer. We strive to provide state-of-the-art devices that respond to our clients’ individual needs. If you have any questions or feedback, please don’t hesitate to reach out.",
                            style: CustomTextStyle.textFormFieldMedium.copyWith(
                                fontSize: 14, color: Colors.grey.shade800),
                          )
                        ])),
                    SizedBox(
                      height: 24,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Place another order",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(color: Colors.white),
                      ),
                      color: Colors.pink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2);
  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: CustomTextStyle.textFormFieldMedium
            .copyWith(fontSize: 12, color: Colors.grey.shade800),
      ),
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
