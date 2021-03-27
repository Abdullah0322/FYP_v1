import 'package:ClickandPick/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool liked = false;
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFB33771),
        title: Text("Favorites"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(user.email)
                .collection('favourites')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return snapshot == null
                            ? Container(
                                height: 30,
                                width: 30,
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : Container(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 16, right: 16, top: 16),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 8,
                                                left: 8,
                                                top: 8,
                                                bottom: 8),
                                            width: 80,
                                            height: 80,
                                            child: CachedNetworkImage(
                                                imageUrl: ds['image']),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 8, top: 4),
                                                    child: Text(
                                                      ds['name'].toString(),
                                                      maxLines: 2,
                                                      softWrap: true,
                                                      style: CustomTextStyle
                                                          .textFormFieldSemiBold
                                                          .copyWith(
                                                              fontSize: 14),
                                                    ),
                                                  ),
                                                  Utils.getSizedBox(height: 6),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          ds['price']
                                                              .toString(),
                                                          style: CustomTextStyle
                                                              .textFormFieldBlack
                                                              .copyWith(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {},
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  size: 24,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons.add,
                                                                size: 24,
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            flex: 100,
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        alignment: Alignment.center,
                                        margin:
                                            EdgeInsets.only(right: 10, top: 8),
                                        child: GestureDetector(
                                          onTap: () async {
                                            FirebaseFirestore.instance
                                                .collection("user")
                                                .doc(user.email)
                                                .collection('favourites')
                                                .doc(snapshot
                                                    .data.docs[index].id)
                                                .delete();

                                            Fluttertoast.showToast(
                                                msg: "Item Removed",
                                                toastLength: Toast.LENGTH_LONG);
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            color: Colors.green),
                                      ),
                                    )
                                  ],
                                ),
                              );
                      },
                    )
                  : Container(
                      height: 30,
                      width: 30,
                      child: Center(child: CircularProgressIndicator()));
            }),
      ),
    );
  }
}
