import 'package:ClickandPick/RiderDashboard/Rider_drawer.dart';
import 'package:ClickandPick/RiderDashboard/openmap.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFBB03B2),
        title: Text('Contact Us'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  const emailid =
                      'mailto:clickandpick@gmail.com ?subject=Huston we in trouble, send Help';
                  if (await canLaunch(emailid)) {
                    await launch(emailid);
                  } else {
                    throw 'Could not email $emailid';
                  }
                },
                child: Text('Have complaints? Mail Us'),
              ),
              RaisedButton(
                onPressed: () async {
                  const tellNumber = 'tel:+9230008812584';
                  if (await canLaunch(tellNumber)) {
                    await launch(tellNumber);
                  } else {
                    throw 'Could not call $tellNumber';
                  }
                },
                child: Text('Have complaints? Call Us'),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OpenMap()));
                  // openMap(0, 0);
                },
                child: Text('Open Map'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
