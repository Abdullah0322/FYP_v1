import 'package:ClickandPick/RiderDashboard/riderContactUs.dart';
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
import 'package:geolocator/geolocator.dart';

class Checkout extends StatefulWidget {
  final Data data;
  Checkout({Key key, this.data}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var g;
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

  getphone() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.email)
        .get();
    setState(() {
      g = snap['phone'];
    });
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
    getphone();
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
    return Scaffold(
        backgroundColor: containercolor,
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
            ),
            Container(
              height: 250.0,
              width: double.infinity,
              color: Color(0xFFBB03B2),
            ),
            Positioned(
              bottom: 450.0,
              right: 100.0,
              child: Container(
                height: 400.0,
                width: 400.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200.0),
                  color: Color(0xFFBB03B2),
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
                      color: Color(0xFFBB03B2).withOpacity(0.5))),
            ),
            Positioned(
                top: 35.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                )),
            Positioned(
              top: 95.0,
              left: 15.0,
              child: TitleText(
                text: 'Checkout',
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 150,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.77,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .doc(user.email)
                          .collection('cart')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];

                                  return Center(
                                      child: Column(
                                    children: <Widget>[
                                      Material(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        elevation: 3.0,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 15.0, right: 10.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              20.0,
                                          height: 250.0,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                child: Container(
                                                  height: 80,
                                                  child: CachedNetworkImage(
                                                      imageUrl: ds['image']),
                                                ),
                                              ),
                                              Positioned(
                                                top: 90,
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        ' ID: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ds['id'],
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 110,
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        ' Name: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ds['name'],
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 130,
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        ' Price: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ds['total'].toString() +
                                                            ' RS ',
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 150,
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        ' Seller Email: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ds['selleremail']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 170,
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        ' Shop Address: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        ds['selleraddress']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: 300,
                                                top: 20,
                                                child: Container(
                                                  width: 35,
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: LightColor
                                                          .lightGrey
                                                          .withAlpha(150),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TitleText(
                                                    text: ds['quantity']
                                                        .toString(),
                                                    fontSize: 12,
                                                  ),
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
                                                                    child: Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'Segoe'),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text(
                                                                      "Yes",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'Segoe'),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      User user = FirebaseAuth
                                                                          .instance
                                                                          .currentUser;
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(user
                                                                              .email)
                                                                          .collection(
                                                                              'orders')
                                                                          .doc()
                                                                          .set({
                                                                        'name':
                                                                            ds['name'],
                                                                        'selleremail':
                                                                            ds['selleremail'].toString(),
                                                                        'id': ds['id']
                                                                            .toString(),
                                                                        'quantity':
                                                                            ds['quantity'].toString()
                                                                      });

                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'orders')
                                                                          .doc()
                                                                          .set({
                                                                        'name':
                                                                            ds['name'],
                                                                        'selleremail':
                                                                            ds['selleremail'].toString(),
                                                                        'id': ds['id']
                                                                            .toString(),
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
                                                                        'phone':
                                                                            g.toString(),
                                                                        'picked from vendor':
                                                                            false,
                                                                        'Order Dilevered to Collection Point':
                                                                            false,
                                                                        'Order Recieved to Collection Point':
                                                                            false,
                                                                        'Rider':
                                                                            "",
                                                                        'shopaddress':
                                                                            ds['selleraddress']
                                                                      });
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(user
                                                                              .email)
                                                                          .collection(
                                                                              'cart')
                                                                          .doc(ds
                                                                              .id)
                                                                          .delete();
                                                                      Navigator.of(
                                                                              context)
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
                                                      color: Color(0xFFBB03B2),
                                                      textColor: Colors.white,
                                                    ),
                                                  ))),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ));
                                },
                              )
                            : Container(
                                height: 30,
                                width: 30,
                                child:
                                    Center(child: CircularProgressIndicator()));
                      }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
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
                  )),
            )
          ],
        ));
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
