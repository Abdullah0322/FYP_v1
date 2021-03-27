import 'package:ClickandPick/Cart/cart.dart';
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
            child: Text("Category",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 20)),
          ),
          leading: GestureDetector(
            onTap: () {/* Write listener code here */},
            child: Icon(Icons.arrow_back,
                color: Colors.black // add custom icons also
                ),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                    color: Colors.black,
                  ),
                )),
          ]),
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
                          builder: (context) => CategorySelected(type: 'women'),
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
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: AssetImage('assets/women.jpg'),
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            child: Text(
                              'Women',
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
                          builder: (context) => CategorySelected(type: 'men'),
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
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: AssetImage('assets/Men.jpg'),
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            child: Text(
                              'Men',
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
                          builder: (context) => CategorySelected(type: 'kids'),
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
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: AssetImage('assets/Shoes.jpg'),
                              ),
                            ),
                          ),
                          Center(
                              child: Container(
                            child: Text(
                              'Kids',
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
          backgroundColor: containercolor,
          buttonBackgroundColor: Colors.black54,
          items: <Widget>[
            Icon(Icons.home, size: 20, color: Colors.orange[300]),
            Icon(Icons.category, size: 20, color: Colors.orange[300]),
            Icon(Icons.shopping_bag, size: 20, color: Colors.orange[300]),
            Icon(Icons.people, size: 20, color: Colors.orange[300]),
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
          }

          //other params
          ),
    );
  }
}
