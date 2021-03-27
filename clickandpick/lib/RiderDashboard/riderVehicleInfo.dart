import 'package:flutter/material.dart';

class VehicleInformation extends StatefulWidget {
  VehicleInformation({Key key}) : super(key: key);

  @override
  _VehicleInformationState createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vehicle Information",
        ),
      ),
      //    drawer: Riderdrawer(),
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
