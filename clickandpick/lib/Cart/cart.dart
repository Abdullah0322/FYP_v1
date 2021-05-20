import 'package:ClickandPick/BuyerDashboard/Category.dart';
import 'package:ClickandPick/BuyerDashboard/buyerdashboard.dart';
import 'package:ClickandPick/BuyerDashboard/light_color.dart';
import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/Cart/CheckoutPage.dart';
import 'package:ClickandPick/Cart/check.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:ClickandPick/settings.dart/setting_page.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:ClickandPick/widgets/DialogueBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Cart extends StatefulWidget {
  final Data data;
  final name;
  Cart({Key key, this.data, this.name}) : super(key: key);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _currentPage;
  int index;
  void initState() {
    _currentPage = 1;
    index = 2;
    getprice();
    super.initState();
  }

  double price = 0;

  int length;
  double gettol = 0;

  getprice() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.email)
          .collection('cart')
          .snapshots()
          .listen((event) {
        double abc = 0;
        setState(() {
          event.docs.forEach((x) {
            abc += int.parse(x['price']) * x['quantity'];
          });
          price = abc;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
    return price;
  }

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print(price);

    print(length);
    var screenWidth = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 68.0, left: 38),
                          child: Container(
                            child: TitleText(
                              text: 'Shopping',
                              fontSize: 27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0, left: 0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: TitleText(
                                text: 'Cart',
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 42.0, right: 20),
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                      title: 'Are you Sure ?',
                                      descriptions:
                                          'This will remove all the products from cart',
                                      text: 'Yes ',
                                      text1: 'NO');
                                });
                          },
                          child: Icon(
                            Icons.delete_outline,
                            color: LightColor.orange,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(user.email)
                        .collection('cart')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.hasData && snapshot.data.docs.isNotEmpty
                          ? ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];
                                return Column(children: <Widget>[
                                  Container(
                                    height: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(children: <Widget>[
                                        AspectRatio(
                                            aspectRatio: 1.2,
                                            child: Stack(children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18.0),
                                                child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    child: Stack(
                                                        children: <Widget>[
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: LightColor
                                                                      .lightGrey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                            ),
                                                          ),
                                                          CachedNetworkImage(
                                                              imageUrl:
                                                                  ds['image']),
                                                        ])),
                                              ),
                                            ])),
                                        Expanded(
                                            child: ListTile(
                                                title: TitleText(
                                                  text: ds['name'].toString(),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    TitleText(
                                                      text: '\RS ',
                                                      color: LightColor.red,
                                                      fontSize: 12,
                                                    ),
                                                    TitleText(
                                                      text: ds['total']
                                                          .toString(),
                                                      fontSize: 14,
                                                    ),
                                                  ],
                                                ),
                                                trailing: Container(
                                                  width: 35,
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: LightColor
                                                          .lightGrey
                                                          .withAlpha(150),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TitleText(
                                                    text: ds['quantity']
                                                        .toString(),
                                                    fontSize: 12,
                                                  ),
                                                ))),
                                      ]),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: 40,
                                  ),
                                ]);
                              })
                          : Container(
                              height: height * 0.2,
                              width: screenWidth,
                              child: Center(
                                child: TitleText(
                                  text: 'Your Cart is Empty',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ));
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      height: 50.0,
                      width: 300.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TitleText(
                              text: 'Total',
                              color: LightColor.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TitleText(
                              text: '${price}' ?? "",
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                height: 50.0,
                width: 300.0,
                child: RaisedButton(
                  color: Color(0xFFA579A3),
                  child: Text(
                    'CHECK OUT',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Checkout(
                                  data: Data(),
                                )));
                  },
                ),
              ),
            ),
          ),
        ],
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
          index: 2,
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
