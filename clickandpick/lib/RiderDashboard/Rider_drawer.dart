import 'package:ClickandPick/BuyerDashboard/Category.dart';
import 'package:ClickandPick/BuyerDashboard/favourites.dart';
import 'package:ClickandPick/Cart/cart.dart';
import 'package:ClickandPick/RiderDashboard/RiderDileveredOrders.dart';
import 'package:ClickandPick/RiderDashboard/riderContactUs.dart';
import 'package:ClickandPick/RiderDashboard/riderPendingOrders.dart';
import 'package:ClickandPick/RiderDashboard/settingRider.dart';
import 'package:ClickandPick/SellerDashboard/dileveredorders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ClickandPick/Login/LoginPage.dart';

class Riderdrawer extends StatefulWidget {
  @override
  _RiderdrawerState createState() => _RiderdrawerState();
  Riderdrawer({Key key}) : super(key: key);
}

class _RiderdrawerState extends State<Riderdrawer> {
  getRider() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("rider")
          .doc(user.email)
          .get();
      setState(() {
        Rider.userData.email = snap['email'].toString();
        Rider.userData.username = snap['username'].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    getRider();
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(40),
            color: Colors.blueGrey,
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
                  Rider.userData.username ?? '',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Text(
                  Rider.userData.email ?? "",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Column(children: <Widget>[
            Text(
              'Inactive/Active',
              style: TextStyle(color: Color(0xff868686), fontSize: 12.0),
            ),
          ]),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('rider')
                .doc(user.email)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              return Switch(
                  value: snapshot.data == null
                      ? false
                      : snapshot.data["available"],
                  onChanged: (value) {
                    FirebaseFirestore.instance
                        .collection('rider')
                        .doc(Rider.userData.email)
                        .update({'available': value}).whenComplete(() {
                      print('Field Deleted');
                    });
                  });
            },
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingRider()),
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
              'Dilevered Orders',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RiderDilevered()),
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
                MaterialPageRoute(builder: (context) => PendingOrders()),
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
