import 'package:ClickandPick/Login/LoginPage.dart';
import 'package:ClickandPick/Manager/Collectionpointinfo.dart';
import 'package:ClickandPick/Manager/Riders.dart';
import 'package:ClickandPick/Manager/Shops.dart';
import 'package:ClickandPick/RiderDashboard/riderContactUs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ClickandPick/Manager/ManageOrders.dart';

class ManagerDrawer extends StatelessWidget {
  ManagerDrawer({Key key}) : super(key: key);

  getManager() async {
    try {
      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("manager")
          .doc(user.email)
          .get();

      Manager.userData.email = snap2['email'].toString();
      Manager.userData.phone = snap2['collection point'].toString();
    } catch (e) {
      print(e);
    }
  }

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    getManager();
    return Drawer(
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
                  Manager.userData.email ?? '',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Text(
                  Manager.userData.phone ?? '',
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
          Divider(
            height: 64,
            thickness: 0.5,
            color: Colors.blueGrey.withOpacity(0.3),
            indent: 32,
            endIndent: 32,
          ),
          ListTile(
            leading: Icon(Icons.shop_two),
            title: Text(
              'Manage Shops',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManageShops(
                          type: Manager.userData.email,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shop_two),
            title: Text(
              'Manage Orders',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageOrders(
                      //type: Manager.userData.email,
                      ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bike_scooter),
            title: Text(
              'Manage Riders',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageRiders()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text(
              'Collection Point ',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CollectionPointInformation()),
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
