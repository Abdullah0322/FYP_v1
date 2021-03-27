import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RiderProfile extends StatefulWidget {
  RiderProfile({Key key}) : super(key: key);
  @override
  _RiderProfileState createState() => _RiderProfileState();
}

class _RiderProfileState extends State<RiderProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
        ),
      ),
      //  drawer: Riderdrawer(),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('We are building this screen.. Haza Sabar Habibi'),
            ]),
      ),
    );
  }
}
