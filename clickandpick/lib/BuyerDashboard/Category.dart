import 'package:ClickandPick/Cart/cart.dart';
import 'package:ClickandPick/settings.dart/setting_page.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ClickandPick/BuyerDashboard/buyerdashboard.dart';

import 'Categoryselect.dart';
import 'buyerdashboard.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int _currentPage;
  int index;
  void initState() {
    super.initState();
    index = 1;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    //width of the screen
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text("Category",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 20)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategorySelected(type: 'clothing'),
                        ));
                  },
                  child: Container(
                      width: width * 0.93,
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.35),
                                    BlendMode.dstATop),
                                image: AssetImage('assets/clothing.png'),
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            child: Text(
                              'Clothes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40),
                            ),
                          )),
                        ],
                      )),
                ),
              ),
            ),
            Center(
              child: Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategorySelected(type: 'shoes'),
                        ));
                  },
                  child: Container(
                      width: width * 0.93,
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.dstATop),
                                image: AssetImage('assets/shoes.png'),
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            child: Text(
                              'Shoes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40),
                            ),
                          )),
                        ],
                      )),
                ),
              ),
            ),
            Center(
              child: Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategorySelected(type: 'watches'),
                        ));
                  },
                  child: Container(
                      width: width * 0.93,
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.3),
                                    BlendMode.dstATop),
                                image: AssetImage('assets/watches.png'),
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            child: Text(
                              'Watches',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40),
                            ),
                          )),
                        ],
                      )),
                ),
              ),
            ),
            Center(
              child: Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategorySelected(type: 'electronics'),
                        ));
                  },
                  child: Container(
                      width: width * 0.93,
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.dstATop),
                                image: AssetImage('assets/electronics.png'),
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            child: Text(
                              'Electronics & Tech',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40),
                            ),
                          )),
                        ],
                      )),
                ),
              ),
            ),
            Center(
              child: Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategorySelected(type: 'food'),
                        ));
                  },
                  child: Container(
                      width: width * 0.93,
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.35),
                                    BlendMode.dstATop),
                                image: AssetImage('assets/food.png'),
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            child: Text(
                              'Food Products',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40),
                            ),
                          )),
                        ],
                      )),
                ),
              ),
            ),
            Center(
              child: Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategorySelected(type: 'fragances'),
                        ));
                  },
                  child: Container(
                      width: width * 0.93,
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.3),
                                    BlendMode.dstATop),
                                image: AssetImage('assets/fragrances.png'),
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            child: Text(
                              'Fragrances',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40),
                            ),
                          )),
                        ],
                      )),
                ),
              ),
            ),
          ],
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
          index: 1,
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
          }

          //other params
          ),
    );
  }
}
