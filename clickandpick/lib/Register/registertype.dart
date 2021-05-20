import 'package:ClickandPick/Intro.dart';
import 'package:ClickandPick/Login/LoginPage.dart';
import 'package:ClickandPick/Login/bezierContainer.dart';
import 'package:ClickandPick/Register/registerbuyer.dart';
import 'package:ClickandPick/Register/registermanager.dart';
import 'package:ClickandPick/Register/registerrider.dart';
import 'package:ClickandPick/Register/registerseller.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Container(
        height: height,
        child: Stack(children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Padding(
            padding: const EdgeInsets.only(top: 58.0),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Container(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'C',
                                style: GoogleFonts.portLligatSans(
                                  textStyle:
                                      Theme.of(context).textTheme.display1,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFBB03B2),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'li',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30),
                                  ),
                                  TextSpan(
                                    text: 'ck',
                                    style: TextStyle(
                                        color: Color(0xFFBB03B2), fontSize: 30),
                                  ),
                                  TextSpan(
                                    text: '&',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30),
                                  ),
                                  TextSpan(
                                    text: 'Pi',
                                    style: TextStyle(
                                        color: Color(0xFFBB03B2), fontSize: 30),
                                  ),
                                  TextSpan(
                                    text: 'ck',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      color: Color(0xFFBB03B2),
                      width: width * 0.9,
                      child: Card(
                        color: Color(0xFFBB03B2),
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
                      color: Color(0xFFBB03B2),
                      width: width * 0.9,
                      child: Card(
                        color: Color(0xFFBB03B2),
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
                      color: Color(0xFFBB03B2),
                      width: width * 0.9,
                      child: Card(
                        color: Color(0xFFBB03B2),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Already Have an Account ?',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ));
                                },
                                child: Text(
                                  'Signin',
                                  style: TextStyle(
                                      color: Color(0xFFBB03B2),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
