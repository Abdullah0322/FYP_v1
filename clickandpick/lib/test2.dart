import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  var response;
  var response2;

  void initState() {
    getRequest();

    postRequest();
    postLog();
    super.initState();
  }

  void postRequest() async {
    var response = await http.post(
        Uri.parse("https://ingzz.net/public/api/driver/update_address"),
        body: jsonEncode({
          "mode": "formdata",
          "formdata": [
            {"key": "user_id", "value": "5", "type": "text"},
            {"key": "latitude", "value": "31.00343", "type": "text"},
            {"key": "longitude", "value": "72.43333", "type": "text"},
            {
              "key": "address",
              "value": "lahore, punjab, pakistan",
              "type": "text"
            }
          ]
        }));

    print(json.decode(response.body));
  }

  void postLog() async {
    var response =
        await http.post(Uri.parse("https://ingzz.net/public/api/login"),
            body: jsonEncode(
              {
                "mode": "formdata",
                "formdata": [
                  {"key": "email", "value": "cus@gmail.com", "type": "text"},
                  {"key": "password", "value": "123456", "type": "text"}
                ]
              },
            ));
    print(json.decode(response.body));
  }

  void getRequest() async {
    var res = await http.get(Uri.parse(
        "http://ingzz.net/public/api/markets?api_token=mgjgYShH6DzOYcho8x2svkeUKawJ0nnMHDXSM8FnlKOpfPSgiPoVJrbFwKrc"));

    setState(() {
      response = json.decode(res.body);
    });
  }

  void getRequest2() async {
    var res1 = await http.get(
        Uri.parse(" http://ingzz.net/public/api/driver/get_driver_location/5"));

    setState(() {
      response2 = json.decode(res1.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    postLog();
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Column(
        children: [
          Text(
            "Name",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(response['data'][0]['name']),
          Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(response['data'][0]['description']),
          Text(
            "Address",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(response['data'][0]['address']),
          Text(
            "Phone",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(response['data'][0]['phone']),
          Text(
            "Mpobile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(response['data'][0]['mobile']),
          Text(
            "Information",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(response['data'][0]['information']),
        ],
      ),
    );
  }
}
