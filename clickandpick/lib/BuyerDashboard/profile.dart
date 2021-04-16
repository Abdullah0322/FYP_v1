import 'package:ClickandPick/BuyerDashboard/Category.dart';
import 'package:ClickandPick/BuyerDashboard/buyerdashboard.dart';
import 'package:ClickandPick/Cart/cart.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final passwordcontroller = TextEditingController();
  final newpassword = TextEditingController();
  final repeatpass = TextEditingController();
  final displayname = TextEditingController();
  bool checkCurrentPasswordValid = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                      controller: passwordcontroller,
                      validator: (input) {
                        return input.length < 8
                            ? "Password must be greater than 7 charaters"
                            : null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Password',
                          border: InputBorder.none,
                          fillColor: Color(0xFFF4F3F4),
                          filled: true)),
                  TextFormField(
                      controller: newpassword,
                      validator: (input) {
                        return input.length < 8
                            ? "Password must be greater than 7 charaters"
                            : null;
                      },
                      decoration: InputDecoration(
                          hintText: 'New Password',
                          border: InputBorder.none,
                          fillColor: Color(0xFFF4F3F4),
                          filled: true)),
                  TextFormField(
                      controller: repeatpass,
                      validator: (value) {
                        newpassword.text == value
                            ? null
                            : 'Password is not valid';
                      },
                      decoration: InputDecoration(
                          hintText: 'Repeat Password',
                          border: InputBorder.none,
                          fillColor: Color(0xFFF4F3F4),
                          filled: true)),
                  RaisedButton(child: Text('Save'), onPressed: () {})
                ],
              )),
        ),
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
                    builder: (context) => Profile(),
                  ));
            }
          }

          //other params
          ),
    );
  }
}
