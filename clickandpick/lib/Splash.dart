import 'package:ClickandPick/BuyerDashboard/buyerdashboard.dart';
import 'package:ClickandPick/Intro.dart';
import 'package:ClickandPick/Login/LoginPage.dart';
import 'package:ClickandPick/Manager/ManageOrders.dart';
import 'package:ClickandPick/RiderDashboard/riderPendingOrders.dart';
import 'package:ClickandPick/SellerDashboard/seller.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    });

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            height: 270.0,
            width: 270.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Logo.png'),
              ),
            ),
          ),
        ));
  }
}
