import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Details extends StatefulWidget {
  final Data data;
  String type;

  Details({Key key, this.data, this.type}) : super(key: key);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  double width;
  double height;
  double safePadding;
  //opacity of the normal text
  double opac;
  //opacity of the image;
  double opac2;
  int index;
  int index2;
  void checkiteminfavourites(String descriptionAsID, BuildContext) {}
  var page = PageController();
  var page2 = PageController();
  String email;
  @override
  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser;
    setState(() {
      email = user.email;
    });
    getfav(widget.data.id);
    opac = 0;
    opac2 = 0;
    index = 0;
    index2 = 0;

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        opac = 1.0;
      });
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        opac2 = 1.0;
      });
    });
  }

  //
  //
  // These two functions make the page scroll up even when the page has a singlechildscrollview
  _scrollUp() async {
    await page.previousPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  _scrollDown() async {
    await page.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  changequnat() async {}
  DocumentSnapshot favsnap;

  bool _isFavorited;

  getfav(String id) async {
    User user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot snapShot = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.email)
        .collection('favourites')
        .doc(id)
        .get();
    setState(() {
      favsnap = snapShot;
    });
    if (favsnap.exists) {
      setState(() {
        _isFavorited = false;
      });
    } else {
      setState(() {
        _isFavorited = true;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  var dec;
  var cd;
  setquant() {
    cd = int.parse(widget.data.quantity) - quantity;

    setState(() {
      dec = cd;
    });
    return dec;
  }

  getpri() {
    double abc = 0;

    abc += int.parse(widget.data.price) * quantity;

    setState(() {
      price = abc;
    });
    return price;
  }

  double price = 0;
  String id;
  int quantity = 1;
  static const List<double> initialRating = [
    0.5,
    1,
    1.5,
    2,
    2.5,
    3,
    3.5,
    4,
    4.5,
    5
  ];

  @override
  Widget build(BuildContext context) {
    getpri();
    setquant();
    print(_isFavorited);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    page = PageController(initialPage: 0);
    page2 = PageController(initialPage: 0);

    return favsnap == null
        ? Container(
            height: 30,
            width: 30,
            child: Center(child: CircularProgressIndicator()))
        : Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: (favsnap.exists
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border)),
                      color: Colors.red[500],
                      onPressed: () async {
                        User user = FirebaseAuth.instance.currentUser;
                        if (_isFavorited == true) {
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(user.email)
                              .collection('favourites')
                              .doc(widget.data.id)
                              .set({
                            'id': widget.data.id,
                            'name': widget.data.name,
                            'image': widget.data.image,
                            'price': widget.data.price,
                            'description': widget.data.description,
                          });
                          _toggleFavorite();
                          getfav(widget.data.id);
                          Fluttertoast.showToast(
                              msg: "Item Added to Favorites",
                              toastLength: Toast.LENGTH_LONG);
                        } else {
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(user.email)
                              .collection('favourites')
                              .doc(widget.data.id)
                              .delete();
                          _toggleFavorite();
                          getfav(widget.data.id);
                          Fluttertoast.showToast(
                              msg: "Item removed from Favorites",
                              toastLength: Toast.LENGTH_LONG);
                        }
                      }),
                  //IconButton(
                  // color: (LocalUser.userData.favProdcts.contains('cureentProductId'))
                  // ? Color(0xFFB33771)
                  //   : Colors.grey,
                  // icon: liked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                  //onPressed: () async {
                  //User user = FirebaseAuth.instance.currentUser;
                  //DocumentReference ref = await FirebaseFirestore.instance
                  //.collection('user')
                  //.doc(user.email)
                  //.collection('favourites')
                  //.add({
                  //'name': widget.data.name,
                  //'image': widget.data.image,
                  //'price': widget.data.price,
                  //'description': widget.data.description,
                  //});
                  //setState(() {
                  //  liked = liked;
                  //    id = ref.id;
                  //    });
                  //      print(ref.id);
                  //        Fluttertoast.showToast(
                  //              msg: "Item Added to Favorites",
                  //                toastLength: Toast.LENGTH_LONG);
//}),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    child: Icon(index2 == 0
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up_outlined),
                    onPressed: () {
                      if (index2 == 1) {
                        page.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      } else {
                        page.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                  ),
                ]),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            body: PageView(
              scrollDirection: Axis.vertical,
              controller: page,
              onPageChanged: (i) {
                setState(() {
                  index2 = i;
                });
              },
              children: [
                Stack(
                  children: [
                    //
                    //
                    // The image behind the info
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: opac,
                      child: PageView(
                        controller: page2,
                        onPageChanged: (i) {
                          setState(() {
                            index = i;
                          });
                        },
                        children: [
                          Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.dstATop),
                                fit: BoxFit.fitWidth,
                                image: CachedNetworkImageProvider(
                                  '${widget.data.image}',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.dstATop),
                                fit: BoxFit.fitWidth,
                                image: CachedNetworkImageProvider(
                                  '${widget.data.image}',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //
                    //
                    // The top page info
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: opac2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${widget.data.name}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width / 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            //
                            //
                            // indicator of the number of pictures
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 10,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(0),
                                  itemCount: (2),
                                  itemBuilder: (BuildContext context, int ind) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Container(
                                        margin: EdgeInsets.all(0),
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: index == ind
                                              ? Colors.blue[200]
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${widget.data.price}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: SmoothStarRating(
                                allowHalfRating: false,
                                size: 30.0,
                                color: Colors.yellow,
                                rating: widget.data.rating,
                                onRated: (double value) async {
                                  debugPrint(
                                      'Image no. $index was rated $value stars!!!');

                                  User user = FirebaseAuth.instance.currentUser;

                                  await FirebaseFirestore.instance
                                      .collection('products')
                                      .doc('category')
                                      .collection(widget.type)
                                      .doc(widget.data.id.toString())
                                      .update({
                                    'rating': value,
                                  });
                                },
                                borderColor: Colors.grey,
                                //allowHalfRating: true,
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Seller name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${widget.data.sellername}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: width / 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //
                //
                // function to allow for scroll in the single child scroll view
                NotificationListener(
                  onNotification: (notification) {
                    if (notification is OverscrollNotification) {
                      if (notification.overscroll > 0) {
                        _scrollDown();
                      } else {
                        _scrollUp();
                      }
                    }
                  },
                  //
                  //
                  // The bottom page info
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 50, 50, 50),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product Description',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${widget.data.description}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width / 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 50, 50, 50),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Seller Shop Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${widget.data.shopaddress}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width / 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 50, 50, 50),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(children: <Widget>[
                                  Container(
                                    child: Text('Select Quantity',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Container(
                                      child: IconButton(
                                        color: Colors.white,
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          if (quantity > 1) {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 60,
                                      height: 30,
                                      color: Colors.white,
                                      child: Center(
                                          child: Text(
                                        quantity.toString(),
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                        color: Colors.white,
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          if (quantity <
                                              int.parse(widget.data.quantity))
                                            setState(() {
                                              quantity++;
                                            });
                                        }),
                                  ),
                                ]),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: width - width * 0.08,
                              child: GestureDetector(
                                onTap: () async {
                                  User user = FirebaseAuth.instance.currentUser;

                                  await FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(user.email)
                                      .collection('cart')
                                      .doc(widget.data.id)
                                      .set({
                                    'selleremail': widget.data.selleremail,
                                    'id': widget.data.id,
                                    'name': widget.data.name,
                                    'image': widget.data.image,
                                    'price': widget.data.price,
                                    'description': widget.data.description,
                                    'quantity': quantity,
                                    'total': price,
                                    'selleraddress': widget.data.shopaddress
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Item Added to Cart",
                                      toastLength: Toast.LENGTH_LONG);
                                  await FirebaseFirestore.instance
                                      .collection('products')
                                      .doc('category')
                                      .collection(widget.type)
                                      .doc(widget.data.id)
                                      .update({'quantity': dec.toString()});

                                  await FirebaseFirestore.instance
                                      .collection('seller')
                                      .doc(widget.data.selleremail)
                                      .collection('products')
                                      .doc('category')
                                      .collection(widget.type)
                                      .doc(widget.data.id)
                                      .update({'quantity': dec.toString()});
                                },
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF667EEA),
                                            offset: Offset(0, 6),
                                            blurRadius: 3,
                                            spreadRadius: -4)
                                      ],
                                      borderRadius: BorderRadius.circular(6),
                                      color: buttoncolor,
                                    ),
                                    height: 55,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Center(
                                      child: Text(
                                        'Add to Cart ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
