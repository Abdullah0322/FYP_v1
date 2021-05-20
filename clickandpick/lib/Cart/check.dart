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
                                                          margin:
                                                              EdgeInsets.only(
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
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              8,
                                                                          top:
                                                                              4),
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
                                                                Utils
                                                                    .getSizedBox(
                                                                        height:
                                                                            6),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        ds['total'].toString() +
                                                                            " RS ",
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
                                                                            ds['quantity'].toString(),
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
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 12),
                                                        child: RaisedButton(
                                                          onPressed: () {
                                                            return showDialog(
                                                                context:
                                                                    context,
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
                                                                              color: Colors.black,
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
                                                                              color: Colors.black,
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
                                                                              .collection('user')
                                                                              .doc(user.email)
                                                                              .collection('cart')
                                                                              .doc(ds.id)
                                                                              .delete();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          // showThankYouBottomSheet(
                                                                          //   context);
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
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                          color: Colors.pink,
                                                          textColor:
                                                              Colors.white,
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
      bottomNavigationBar: Material(
          elevation: 7.0,
          color: Colors.white,
          child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.white,
                          child: Icon(
                            Icons.shopping_basket,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.white,
                          child: Icon(
                            Icons.account_box,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.white,
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.white,
                          child: Icon(
                            Icons.account_box,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ]),
              ))),
    );
  }

  Widget itemCard(itemName, color, price, imgPath, available, i) {}
}
