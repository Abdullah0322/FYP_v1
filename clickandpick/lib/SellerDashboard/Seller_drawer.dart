import 'package:ClickandPick/RiderDashboard/riderContactUs.dart';
import 'package:ClickandPick/SellerDashboard/ManageOrders.dart';
import 'package:ClickandPick/SellerDashboard/dileveredorders.dart';
import 'package:ClickandPick/SellerDashboard/seller.dart';
import 'package:ClickandPick/SellerDashboard/settingseller.dart';
import 'package:ClickandPick/settings.dart/setting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ClickandPick/Login/LoginPage.dart';

class SellerDrawer extends StatefulWidget {
  const SellerDrawer({Key key}) : super(key: key);
  @override
  _SellerDrawerState createState() => _SellerDrawerState();
}

class _SellerDrawerState extends State<SellerDrawer> {
  getSeller() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("seller")
          .doc(user.email)
          .get();
      setState(() {
        Sell.userData.email = snap['email'].toString();
        Sell.userData.username = snap['username'].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    getSeller();

    return Sell.userData == null
        ? Container(
            height: 30,
            width: 30,
            child: Center(child: CircularProgressIndicator()))
        : Drawer(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(40),
                  color: Color(0xFFA579A3),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //image: DecorationImage(), fit:BoxFit.fill,
                        ),
                      ),
                      Text(
                        Sell.userData.username ?? '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        Sell.userData.email ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag_sharp),
                  title: Text(
                    'Manage Profile',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingSeller()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag_sharp),
                  title: Text(
                    'Dilevered Orders',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DileveredOrders()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag_outlined),
                  title: Text(
                    'Pending Orders',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SellerOrders()),
                    );
                  },
                ),
                Divider(
                  height: 64,
                  thickness: 0.5,
                  color: Colors.blueGrey.withOpacity(0.3),
                  indent: 32,
                  endIndent: 32,
                ),
                ListTile(
                  leading: Icon(Icons.shop),
                  title: Text(
                    'Manage Products',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerDashboard()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUs()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ],
            ),
          );
  }
}
