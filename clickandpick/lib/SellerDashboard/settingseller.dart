import 'package:ClickandPick/Login/loginPage.dart';
import 'package:ClickandPick/RiderDashboard/riderContactUs.dart';
import 'package:ClickandPick/SellerDashboard/aboutUS.dart';
import 'package:ClickandPick/SellerDashboard/changesellername.dart';
import 'package:ClickandPick/SellerDashboard/chnageShop.dart';
import 'package:ClickandPick/app_properties.dart';
import 'package:ClickandPick/custom_background.dart';
import 'package:ClickandPick/settings.dart/change_password_page.dart';
import 'package:ClickandPick/settings.dart/notifications_settings_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingSeller extends StatefulWidget {
  @override
  _SettingSellerState createState() => _SettingSellerState();
}

class _SettingSellerState extends State<SettingSeller> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          brightness: Brightness.light,
          backgroundColor: Color(0xFFBB03B2),
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.white),
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
                              title: Text('About Us'),
                              leading: Image.asset('assets/icons/about_us.png'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => AboutUs()));
                              },
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
                                      builder: (_) => ChnageSellername())),
                            ),
                            ListTile(
                              title: Text('Change Shop Name'),
                              leading:
                                  Image.asset('assets/icons/change_pass.png'),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChangeShop())),
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
      ),
    );
  }
}
