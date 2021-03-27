import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                                      return Column(children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            Container(
                                              height: 250,
                                              margin: EdgeInsets.only(
                                                  left: 16, right: 16, top: 16),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(16))),
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
                                                    child: CachedNetworkImage(
                                                        imageUrl: ds['image']),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 8,
                                                                    top: 4),
                                                            child: Text(
                                                              ds['name']
                                                                  .toString(),
                                                              maxLines: 2,
                                                              softWrap: true,
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
                                                                  ds['price']
                                                                      .toString(),
                                                                  style: CustomTextStyle
                                                                      .textFormFieldBlack
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                )
                                                              ],
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
                                                                  ds['selleremail']
                                                                      .toString(),
                                                                  style: CustomTextStyle
                                                                      .textFormFieldBlack
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                )
                                                              ],
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
                                                                  ds['quantity']
                                                                      .toString(),
                                                                  style: CustomTextStyle
                                                                      .textFormFieldBlack
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
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
                                              padding: const EdgeInsets.only(
                                                  top: 200.0),
                                              child: Center(
                                                child: Container(
                                                  width: 300,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                                  child: RaisedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Dialog(
                                                              child: Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      height:
                                                                          300,
                                                                      padding: EdgeInsets.only(
                                                                          left: Constants
                                                                              .padding,
                                                                          top: Constants.avatarRadius +
                                                                              Constants
                                                                                  .padding,
                                                                          right: Constants
                                                                              .padding,
                                                                          bottom:
                                                                              Constants.padding),
                                                                      margin: EdgeInsets.only(
                                                                          top: Constants
                                                                              .avatarRadius),
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .rectangle,
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(Constants.padding),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                color: Colors.black,
                                                                                offset: Offset(0, 10),
                                                                                blurRadius: 10),
                                                                          ]),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            ' Are you sure to buy this product?',
                                                                            style:
                                                                                TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                            'You can Pick this Product from Nearest Collection Centre',
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                22,
                                                                          ),
                                                                          Row(children: <
                                                                              Widget>[
                                                                            Align(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: FlatButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Text(
                                                                                    'NO',
                                                                                    style: TextStyle(fontSize: 18),
                                                                                  )),
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: FlatButton(
                                                                                  onPressed: () {
                                                                                    User user = FirebaseAuth.instance.currentUser;
                                                                                    FirebaseFirestore.instance.collection('user').doc(user.email).collection('orders').doc(ds['id'].toString()).set({
                                                                                      'name': ds['name'],
                                                                                      'selleremail': ds['selleremail'].toString(),
                                                                                      'id': ds['id'].toString(),
                                                                                      'quantity': ds['quantity'].toString()
                                                                                    });

                                                                                    FirebaseFirestore.instance.collection('orders').doc().set({
                                                                                      'name': ds['name'],
                                                                                      'selleremail': ds['selleremail'].toString(),
                                                                                      'id': ds['id'].toString(),
                                                                                      'quantity': ds['quantity'].toString(),
                                                                                      'buyeremail': user.email,
                                                                                      'picked from vendor': false,
                                                                                      'Order Dilevered to Collection Point': false,
                                                                                      'Order Recieved to Collection Point': false,
                                                                                    });
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Text(
                                                                                    'Yes',
                                                                                    style: TextStyle(fontSize: 18),
                                                                                  )),
                                                                            ),
                                                                          ]),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: Constants
                                                                          .padding,
                                                                      right: Constants
                                                                          .padding,
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        radius:
                                                                            Constants.avatarRadius,
                                                                        child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                                                                            child: Image.asset("assets/model.jpeg")),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            );
                                                          });
                                                      User user = FirebaseAuth
                                                          .instance.currentUser;
                                                    },
                                                    child: Text(
                                                      "Place Order",
                                                      style: CustomTextStyle
                                                          .textFormFieldMedium
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
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
                      priceSection()
                    ],
                  ),
                ),
                flex: 90,
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
                      onPressed: () {},
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Track Order",
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

  priceSection() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 4,
              ),
              Text(
                "PRICE DETAILS",
                style: CustomTextStyle.textFormFieldMedium.copyWith(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total",
                    style: CustomTextStyle.textFormFieldSemiBold
                        .copyWith(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                    'HI',
                    style: CustomTextStyle.textFormFieldMedium
                        .copyWith(color: Colors.black, fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  createPriceItem(String key, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: Colors.grey.shade700, fontSize: 12),
          ),
          Text(
            value,
            style: CustomTextStyle.textFormFieldMedium
                .copyWith(color: color, fontSize: 12),
          )
        ],
      ),
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
