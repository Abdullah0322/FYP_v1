import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/Login/bezierContainer.dart';
import 'package:ClickandPick/Login/loginPage.dart';
import 'package:ClickandPick/RiderDashboard/Rider_drawer.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RiderDashboard extends StatefulWidget {
  @override
  _RiderDashboardState createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int menCount;
  int womenCount;
  QuerySnapshot menSnap;
  QuerySnapshot womenSnap;
  void getProducts() async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('orders')
          .where('Rider', isEqualTo: user.email)
          .where('Order Dilevered to Collection Point', isEqualTo: false)
          .get();

      setState(() {
        menCount = snap.docs.length;

        menSnap = snap;
      });
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

  void getProduct() async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      QuerySnapshot snap1 = await FirebaseFirestore.instance
          .collection('orders')
          .where('Rider', isEqualTo: user.email)
          .where('Order Dilevered to Collection Point', isEqualTo: true)
          .get();

      setState(() {
        womenCount = snap1.docs.length;
      });
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

  getUsers() {
    User user = FirebaseAuth.instance.currentUser;
    try {
      return FirebaseFirestore.instance
          .collection('rider')
          .doc(user.email)
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  getearning() {
    User user = FirebaseAuth.instance.currentUser;
    try {
      return FirebaseFirestore.instance
          .collection('rider')
          .doc(user.email)
          .collection('earning')
          .doc('earning')
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    getUsers();
    getProducts();
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFBB03B2),
        elevation: 0.0,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: Text("Click and Pick",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
        ),
        // leading: GestureDetector(
        //   onTap: () {
        //     scaffoldKey.currentState.openDrawer();
        //     /* Write listener code here */
        //   },
        //   child: Icon(Icons.menu, color: Colors.black // add custom icons also
        //       ),
        // ),
      ),
      drawer: Riderdrawer(),
      body: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Padding(
            padding: const EdgeInsets.only(top: 48.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: getUsers(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
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
                                              MainAxisAlignment.spaceBetween,
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
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(16))),
                                              child: Text(
                                                "Active profile",
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
                                                        color: Colors
                                                            .grey.shade800)),
                                            TextSpan(
                                                text: snapshot.data['phone'],
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
                                child:
                                    Center(child: CircularProgressIndicator()));
                      }),
                  Container(
                    child: TitleText(
                        text: 'My Earning',
                        fontSize: 27,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700),
                  ),
                  StreamBuilder(
                      stream: getearning(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
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
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[],
                                        ),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "You have Earned  ",
                                                style: CustomTextStyle
                                                    .textFormFieldMedium
                                                    .copyWith(
                                                        fontSize: 22,
                                                        color: Colors
                                                            .grey.shade800)),
                                            TextSpan(
                                                text: snapshot.data['earn']
                                                        .toString() +
                                                    " RS ",
                                                style: CustomTextStyle
                                                    .textFormFieldBold
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontSize: 22)),
                                          ]),
                                        ),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "Note:  ",
                                                style: CustomTextStyle
                                                    .textFormFieldMedium
                                                    .copyWith(
                                                        fontSize: 15,
                                                        color: Colors
                                                            .grey.shade800)),
                                            TextSpan(
                                                text:
                                                    "You will earn 50 Rs Per Order " +
                                                        " RS ",
                                                style: CustomTextStyle
                                                    .textFormFieldBold
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontSize: 15)),
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
                                child:
                                    Center(child: CircularProgressIndicator()));
                      }),
                  Container(
                    child: TitleText(
                        text: 'My Pending Orders',
                        fontSize: 27,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
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
                        padding: EdgeInsets.only(left: 12, top: 8, right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 6,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Your Pending Orders: ",
                                    style: CustomTextStyle.textFormFieldMedium
                                        .copyWith(
                                            fontSize: 22,
                                            color: Colors.grey.shade800)),
                                TextSpan(
                                    text: menCount.toString(),
                                    style: CustomTextStyle.textFormFieldBold
                                        .copyWith(
                                            color: Colors.black, fontSize: 22)),
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
                  ),
                  Container(
                    child: TitleText(
                        text: 'My Delivered Orders',
                        fontSize: 27,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
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
                        padding: EdgeInsets.only(left: 12, top: 8, right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 6,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Your Deliered Orders: ",
                                    style: CustomTextStyle.textFormFieldMedium
                                        .copyWith(
                                            fontSize: 22,
                                            color: Colors.grey.shade800)),
                                TextSpan(
                                    text: womenCount.toString() == null
                                        ? "0"
                                        : womenCount.toString(),
                                    style: CustomTextStyle.textFormFieldBold
                                        .copyWith(
                                            color: Colors.black, fontSize: 22)),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
