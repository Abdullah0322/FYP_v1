import 'package:ClickandPick/BuyerDashboard/Category.dart';
import 'package:ClickandPick/BuyerDashboard/favourites.dart';
import 'package:ClickandPick/Cart/cart.dart';
import 'package:ClickandPick/Login/LoginPage.dart';
import 'package:ClickandPick/RiderDashboard/riderContactUs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class BuyerDrawer extends StatefulWidget {
  const BuyerDrawer({Key key}) : super(key: key);
  @override
  _BuyerDrawerState createState() => _BuyerDrawerState();
}

class _BuyerDrawerState extends State<BuyerDrawer> {
  getUser() async {
    try {
      DocumentSnapshot snap1 = await FirebaseFirestore.instance
          .collection("user")
          .doc(user.email)
          .get();
      setState(() {
        Buyer.userData.username = snap1['username'].toString();
        Buyer.userData.email = snap1['email'].toString();
        Buyer.userData.address = snap1['address'].toString();
        Buyer.userData.phone = snap1['phone'].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    getUser();

    super.initState();
  }

  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    getUser();

    return Buyer.userData == null
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
                        Buyer.userData.username ?? '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        Buyer.userData.email ?? "",
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
                  leading: Icon(Icons.person),
                  title: Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    //       Navigator.push(
                    ///       context,
                    //    MaterialPageRoute(builder: (context) => RiderProfile()),
                    //);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bike_scooter),
                  title: Text(
                    'Favourites',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Favorites()),
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
                  leading: Icon(Icons.shopping_bag_outlined),
                  title: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Category()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag_outlined),
                  title: Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cart()),
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
