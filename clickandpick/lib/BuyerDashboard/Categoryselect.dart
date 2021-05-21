import 'package:ClickandPick/BuyerDashboard/details.dart';
import 'package:ClickandPick/BuyerDashboard/search.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CategorySelected extends StatefulWidget {
  String type;
  CategorySelected({this.type});
  @override
  _CategorySelectedState createState() => _CategorySelectedState();
}

class _CategorySelectedState extends State<CategorySelected> {
  getProducts() {
    try {
      return FirebaseFirestore.instance
          .collection('products')
          .doc('category')
          .collection(widget.type.toLowerCase())
          .snapshots();
    } catch (e) {
      print(e);
    }
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
              child: Text("Products",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 20)),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,
                  color: Colors.black // add custom icons also
                  ),
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Search(
                            type: widget.type,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                      color: Colors.black,
                    ),
                  )),
            ]),
        body: StreamBuilder(
            stream: getProducts(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.hasData
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height * 1),
                          crossAxisCount: 2),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];

                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Details(
                                          data: Data(
                                            id: snapshot.data.docs[index]['id'],
                                            name: snapshot.data.docs[index]
                                                ['name'],
                                            price: snapshot.data.docs[index]
                                                ['price'],
                                            image: snapshot.data.docs[index]
                                                ['image_path'],
                                            description: snapshot.data
                                                .docs[index]['description'],
                                            sellername: snapshot
                                                .data.docs[index]['sellername'],
                                            shopaddress: snapshot.data
                                                .docs[index]['shopaddress'],
                                            selleremail: snapshot.data
                                                .docs[index]['selleremail'],
                                            rating: snapshot.data.docs[index]
                                                ['rating'],
                                            quantity: snapshot.data.docs[index]
                                                ['quantity'],
                                            collectionpoint:
                                                snapshot.data.docs[index]
                                                    ['collection point'],
                                          ),
                                        ),
                                      ));
                                },
                                child: Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: ds['image_path'].toString(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10),
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  ds['name'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10),
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  ds['price'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10),
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'In stock',
                                  style: TextStyle(
                                      color: Color(0xFF84A2AF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                  : CircularProgressIndicator();
            }));
  }
}
