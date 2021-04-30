import 'package:ClickandPick/BuyerDashboard/Category.dart';
import 'package:ClickandPick/BuyerDashboard/buyerdashboard.dart';
import 'package:ClickandPick/Cart/cart.dart';
import 'package:ClickandPick/Login/LoginPage.dart';
import 'package:ClickandPick/RiderDashboard/riderContactUs.dart';
import 'package:ClickandPick/app_properties.dart';
import 'package:ClickandPick/custom_background.dart';
import 'package:ClickandPick/settings.dart/change_country.dart';
import 'package:ClickandPick/settings.dart/change_password_page.dart';
import 'package:ClickandPick/settings.dart/legal_about_page.dart';
import 'package:ClickandPick/settings.dart/notifications_settings_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'change_language_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          title: Text(
            'Settings',
            style: TextStyle(color: darkGrey),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          bottom: true,
          child: LayoutBuilder(
              builder: (builder, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 24.0, right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'General',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            ListTile(
                              title: Text('Notifications'),
                              leading:
                                  Image.asset('assets/icons/notifications.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          NotificationSettingsPage())),
                            ),
                            ListTile(
                              title: Text('Contact Us'),
                              leading: Image.asset('assets/icons/about_us.png'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ContactUs()));
                              },
                            ),
                            ListTile(
                              title: Text('ABout Us'),
                              leading: Image.asset('assets/icons/about_us.png'),
                              onTap: () {},
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                'Account',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            ListTile(
                              title: Text('Change Name'),
                              leading:
                                  Image.asset('assets/icons/change_pass.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangePasswordPage())),
                            ),
                            ListTile(
                              title: Text('Change Password'),
                              leading:
                                  Image.asset('assets/icons/change_pass.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangePasswordPage())),
                            ),
                            ListTile(
                              leading: Icon(Icons.exit_to_app),
                              title: Text(
                                'Log Out',
                                style: TextStyle(),
                              ),
                              onTap: () async {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                } catch (e) {
                                  print(e);
                                }
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          color: Colors.black54,
          backgroundColor: Color(0xFFA579A3),
          buttonBackgroundColor: Colors.black54,
          items: <Widget>[
            Icon(Icons.home, size: 20, color: Color(0xFFFFFFFF)),
            Icon(Icons.category, size: 20, color: Color(0xFFFFFFFF)),
            Icon(Icons.shopping_bag, size: 20, color: Color(0xFFFFFFFF)),
            Icon(Icons.people, size: 20, color: Color(0xFFFFFFFF)),
          ],
          animationDuration: Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
          index: 3,
          onTap: (index) {
            print(index);
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BuyerDashboard()));
            }
            if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Category(),
                  ));
            }
            if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cart(),
                  ));
            }
            if (index == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ));
            }
          },

          //other params
        ),
      ),
    );
  }
}
