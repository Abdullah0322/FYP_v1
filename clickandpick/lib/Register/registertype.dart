import 'package:ClickandPick/Intro.dart';
import 'package:ClickandPick/Login/login.dart';
import 'package:ClickandPick/Register/registerbuyer.dart';
import 'package:ClickandPick/Register/registermanager.dart';
import 'package:ClickandPick/Register/registerrider.dart';
import 'package:ClickandPick/Register/registerseller.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:flutter/material.dart';

class RegisterInterface extends StatefulWidget {
  @override
  _RegisterInterfaceState createState() => _RegisterInterfaceState();
}

class _RegisterInterfaceState extends State<RegisterInterface> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    //width of the screen
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: containercolor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: Container(
                  child: Text(
                    'Register As A?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: headingcolor,
                      fontSize: 35,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: buttoncolor,
              width: width * 0.9,
              child: Card(
                color: buttoncolor,
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Buyer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IntroPage(),
                        ));
                  },
                  dense: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: buttoncolor,
              width: width * 0.9,
              child: Card(
                color: buttoncolor,
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Seller',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterSeller(),
                        ));
                  },
                  dense: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: buttoncolor,
              width: width * 0.9,
              child: Card(
                color: buttoncolor,
                child: ListTile(
                  title: Center(
                    child: Text(
                      'Rider',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterRider(),
                        ));
                  },
                  dense: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Container(
                    child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: headingcolor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )),
                Container(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 150.0),
                    child: Text(
                      'Signin',
                      style: TextStyle(
                        color: headingcolor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
