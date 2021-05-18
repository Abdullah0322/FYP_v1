import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Watches extends StatefulWidget {
  @override
  _WatchesState createState() => _WatchesState();
}

class _WatchesState extends State<Watches> {
  final sellername = TextEditingController();
  final nameCon = TextEditingController();
  final shopaddress = TextEditingController();
  File _image;
  String imagePath;
  FullMetadata metaData;
  var currentItems = null;
  var sizeItems = null;
  var sizeEItems = null;
  var edititems = null;
  Future uploadFile(String id, String folder) async {
    if (_image == null) {
    } else {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('$folder/${id + Timestamp.now().toString()}');
        UploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask.whenComplete(() async {
          await storageReference.getDownloadURL().then((value) {
            setState(() {
              imagePath = value;
            });
          });
          await storageReference.getMetadata().then((value) {
            setState(() {
              metaData = value;
            });
          });
        });
        print('File Uploaded');
      } catch (e) {
        print('not uploaded');
        Fluttertoast.showToast(
          msg: e,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 15,
        );
      }
    }
  }

  bool stap = false;
  bool mtap = false;
  bool ltap = false;
  final nameECon = TextEditingController();
  final quanECon = TextEditingController();
  final catECon = TextEditingController();
  final priECon = TextEditingController();
  final idECon = TextEditingController();
  final desECon = TextEditingController();
  bool delete;
  bool edit;
  Future deleteFile(String bucket, String fullPath) async {
    try {
      FirebaseStorage storage =
          FirebaseStorage.instanceFor(bucket: 'gs://' + bucket);
      await storage
          .ref()
          .child(fullPath)
          .delete()
          .then((value) => print('Deleted '));
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: e,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
        fontSize: 15,
      );
    }
  }

  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  getOrders() {
    try {
      User user = FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance
          .collection('seller')
          .doc(user.email)
          .collection('products')
          .doc('category')
          .collection('watches')
          .snapshots();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: e,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
        fontSize: 15,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var h = AppBar().preferredSize.height;
    var padding = MediaQuery.of(context).padding;
    var height = MediaQuery.of(context).size.height - h - padding.top;

    return Scaffold(
      body: StreamBuilder(
        stream: getOrders(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Center(
                      child: Card(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(ds['id'],
                                        style: TextStyle(
                                            fontFamily: 'Segoe',
                                            fontWeight: FontWeight.bold)),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Description:',
                                            style: TextStyle(
                                                fontFamily: 'Segoe',
                                                fontWeight: FontWeight.w700)),
                                        SizedBox(height: 10),
                                        Text(
                                          ds['description'],
                                          style: TextStyle(
                                            fontFamily: 'Segoe',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          onLongPress: () {
                            setState(() {
                              nameECon.text = ds['name'];
                              priECon.text = ds['price'];
                              ds['quantity'];
                              desECon.text = ds['description'];
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Product ID: ' + ds['id'],
                                      style: TextStyle(
                                          fontFamily: 'Segoe',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      "Select an option",
                                      style: TextStyle(
                                        fontFamily: 'Segoe',
                                      ),
                                    ),
                                    actions: [
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Stack(children: [
                                                      Dialog(
                                                          insetPadding:
                                                              EdgeInsets.all(0),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                            },
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                width:
                                                                    width * 0.9,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      'Edit product',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Segoe',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Theme(
                                                                        data:
                                                                            new ThemeData(
                                                                          primaryColor:
                                                                              Colors.grey[700],
                                                                        ),
                                                                        child:
                                                                            TextField(
                                                                          style:
                                                                              TextStyle(fontFamily: 'Segoe'),
                                                                          controller:
                                                                              nameECon,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          cursorColor:
                                                                              Colors.grey[700],
                                                                          decoration: InputDecoration(
                                                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                              hintText: ds['name'],
                                                                              hintStyle: TextStyle(fontFamily: 'Segoe', fontSize: 12)),
                                                                        )),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Theme(
                                                                        data:
                                                                            new ThemeData(
                                                                          primaryColor:
                                                                              Colors.grey[700],
                                                                        ),
                                                                        child:
                                                                            TextField(
                                                                          style:
                                                                              TextStyle(fontFamily: 'Segoe'),
                                                                          controller:
                                                                              desECon,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          cursorColor:
                                                                              Colors.grey[700],
                                                                          decoration: InputDecoration(
                                                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                              hintText: ds['description'],
                                                                              hintStyle: TextStyle(fontFamily: 'Segoe', fontSize: 12)),
                                                                        )),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Theme(
                                                                        data:
                                                                            new ThemeData(
                                                                          primaryColor:
                                                                              Colors.grey[700],
                                                                        ),
                                                                        child:
                                                                            TextField(
                                                                          style:
                                                                              TextStyle(fontFamily: 'Segoe'),
                                                                          controller:
                                                                              priECon,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          cursorColor:
                                                                              Colors.grey[700],
                                                                          decoration: InputDecoration(
                                                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                              hintText: ds['price'],
                                                                              hintStyle: TextStyle(fontFamily: 'Segoe', fontSize: 12)),
                                                                        )),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Theme(
                                                                        data:
                                                                            new ThemeData(
                                                                          primaryColor:
                                                                              Colors.grey[700],
                                                                        ),
                                                                        child:
                                                                            TextField(
                                                                          style:
                                                                              TextStyle(fontFamily: 'Segoe'),
                                                                          controller:
                                                                              quanECon,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          cursorColor:
                                                                              Colors.grey[700],
                                                                          decoration: InputDecoration(
                                                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                              hintText: ds['quantity'],
                                                                              hintStyle: TextStyle(fontFamily: 'Segoe', fontSize: 12)),
                                                                        )),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    SizedBox(
                                                                        height:
                                                                            20),
                                                                    Container(
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          try {
                                                                            User
                                                                                user =
                                                                                FirebaseAuth.instance.currentUser;

                                                                            FirebaseFirestore.instance.collection('seller').doc(user.email).collection('products').doc('category').collection('watches').doc(ds['id'].toString()).update({
                                                                              'name': nameECon.text,
                                                                              'quantity': quanECon.text,
                                                                              'price': priECon.text,
                                                                              'description': desECon.text,
                                                                              'sellername': sellername.text,
                                                                              'shopaddress': shopaddress.text,
                                                                              'size': stap == true && mtap == false && ltap == false
                                                                                  ? 'S'
                                                                                  : stap == false && mtap == true && ltap == false
                                                                                      ? 'M'
                                                                                      : stap == false && mtap == false && ltap == true
                                                                                          ? 'L'
                                                                                          : stap == true && mtap == true && ltap == false
                                                                                              ? 'SM'
                                                                                              : stap == true && mtap == false && ltap == true
                                                                                                  ? 'SL'
                                                                                                  : stap == false && mtap == true && ltap == true
                                                                                                      ? 'ML'
                                                                                                      : stap == true && mtap == true && ltap == true
                                                                                                          ? 'SML'
                                                                                                          : 'nothing',
                                                                              'image_path': _image == null ? ds['image_path'] : imagePath,
                                                                              'bucket': _image == null ? ds['bucket'] : metaData.bucket,
                                                                              'full_path': _image == null ? ds['full_path'] : metaData.fullPath
                                                                            });
                                                                            print('Updated');
                                                                            setState(() {
                                                                              _image = null;
                                                                            });
                                                                            Fluttertoast.showToast(
                                                                              msg: "Product Updated",
                                                                              toastLength: Toast.LENGTH_LONG,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 3,
                                                                              backgroundColor: Colors.green,
                                                                              textColor: Colors.white,
                                                                              fontSize: 15,
                                                                            );

                                                                            Navigator.pop(context);
                                                                          } catch (e) {}
                                                                        },
                                                                        child: Text(
                                                                            'Edit',
                                                                            style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontFamily: "Segoe",
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromRGBO(102, 126, 234, 1))),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ))
                                                    ]);
                                                  });
                                                });
                                          },
                                          child: Text('Edit',
                                              style: TextStyle(
                                                  fontFamily: "Segoe",
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      102, 126, 234, 1)))),
                                      GestureDetector(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Are you sure?',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Segoe',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        content: delete == true
                                                            ? Container(
                                                                height: 40,
                                                                width: 40,
                                                                child: Center(
                                                                  child: SizedBox(
                                                                      height: 35,
                                                                      width: 35,
                                                                      child: CircularProgressIndicator(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(
                                                                          Color.fromRGBO(
                                                                              102,
                                                                              126,
                                                                              234,
                                                                              1),
                                                                        ),
                                                                        strokeWidth:
                                                                            3,
                                                                      )),
                                                                ),
                                                              )
                                                            : null,
                                                        actions: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'No',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Segoe',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 20),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              try {
                                                                final result =
                                                                    await InternetAddress
                                                                        .lookup(
                                                                            'google.com');
                                                                if (result
                                                                        .isNotEmpty &&
                                                                    result[0]
                                                                        .rawAddress
                                                                        .isNotEmpty) {
                                                                  print(
                                                                      'connected');
                                                                  setState(() {
                                                                    delete =
                                                                        true;
                                                                  });

                                                                  try {
                                                                    User user = FirebaseAuth
                                                                        .instance
                                                                        .currentUser;
                                                                    deleteFile(
                                                                            ds['bucket'],
                                                                            ds['full_path'])
                                                                        .then((value) async {
                                                                      try {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('products')
                                                                            .doc('category')
                                                                            .collection('watches')
                                                                            .doc(ds['id'])
                                                                            .delete();
                                                                      } catch (e) {}
                                                                      try {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('seller')
                                                                            .doc(user.email)
                                                                            .collection('products')
                                                                            .doc('category')
                                                                            .collection('watches')
                                                                            .doc(ds['id'])
                                                                            .delete();

                                                                        print(
                                                                            'deleted');
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg:
                                                                              "Product Deleted",
                                                                          toastLength:
                                                                              Toast.LENGTH_LONG,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              3,
                                                                          backgroundColor:
                                                                              Colors.red[400],
                                                                          textColor:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              15,
                                                                        );

                                                                        setState(
                                                                            () {
                                                                          delete =
                                                                              false;
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      } catch (e) {
                                                                        print(
                                                                            e);
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg:
                                                                              e,
                                                                          toastLength:
                                                                              Toast.LENGTH_LONG,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              3,
                                                                          backgroundColor:
                                                                              Colors.red[400],
                                                                          textColor:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              15,
                                                                        );
                                                                        setState(
                                                                            () {
                                                                          delete =
                                                                              false;
                                                                        });
                                                                      }
                                                                    });
                                                                  } catch (e) {
                                                                    print(e);
                                                                    Fluttertoast
                                                                        .showToast(
                                                                      msg: e,
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity:
                                                                          ToastGravity
                                                                              .BOTTOM,
                                                                      timeInSecForIosWeb:
                                                                          3,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red[400],
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          15,
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      delete =
                                                                          false;
                                                                    });
                                                                  }
                                                                }
                                                              } on SocketException catch (_) {
                                                                Navigator.pop(
                                                                    context);
                                                                print(
                                                                    'not connected');
                                                                setState(() {
                                                                  delete =
                                                                      false;
                                                                });
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg:
                                                                      "You're not connected to the internet",
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  timeInSecForIosWeb:
                                                                      3,
                                                                  backgroundColor:
                                                                      Colors.red[
                                                                          400],
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 15,
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Segoe',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          )
                                                        ],
                                                        actionsPadding:
                                                            EdgeInsets.only(
                                                                bottom: 10,
                                                                right: 10),
                                                      );
                                                    },
                                                  );
                                                });
                                          },
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  fontFamily: "Segoe",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red))),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[800],
                                      spreadRadius: -2.5,
                                      blurRadius: 1,
                                      offset: Offset(2, 3))
                                ]),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.13,
                                    width: MediaQuery.of(context).size.height *
                                        0.13,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: ds['image_path'].toString(),
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color.fromRGBO(
                                                      102, 126, 234, 1),
                                                ),
                                                strokeWidth: 3,
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 27,
                                      child: Text(
                                          ds['name'] == null ? '' : ds['name'],
                                          style: TextStyle(
                                              fontFamily: 'Segoe',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        ds['price'] == null
                                            ? ''
                                            : 'Rs. ' + ds['price'] + "/-",
                                        style: TextStyle(
                                            fontFamily: 'Segoe', fontSize: 15)),
                                  ],
                                ),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: 165,
                                            padding: EdgeInsets.only(left: 13),
                                            decoration: BoxDecoration(
                                                // color: Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ds['size']
                                                        .split('')
                                                        .length ==
                                                    3
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                Color.fromRGBO(
                                                                    102,
                                                                    126,
                                                                    234,
                                                                    0.7)),
                                                        child: Center(
                                                          child: Text(
                                                              ds['size']
                                                                  .split('')[0],
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Segoe',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                Color.fromRGBO(
                                                                    102,
                                                                    126,
                                                                    234,
                                                                    0.7)),
                                                        child: Center(
                                                          child: Text(
                                                              ds['size']
                                                                  .split('')[1],
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Segoe',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color:
                                                                Color.fromRGBO(
                                                                    102,
                                                                    126,
                                                                    234,
                                                                    0.7)),
                                                        child: Center(
                                                          child: Text(
                                                              ds['size']
                                                                  .split('')[2],
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Segoe',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : ds['size'].split('').length ==
                                                        2
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        102,
                                                                        126,
                                                                        234,
                                                                        0.7)),
                                                            child: Center(
                                                              child: Text(
                                                                  ds['size'].split(
                                                                      '')[0],
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Segoe',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromRGBO(
                                                                        102,
                                                                        126,
                                                                        234,
                                                                        0.7)),
                                                            child: Center(
                                                              child: Text(
                                                                  ds['size'].split(
                                                                      '')[1],
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Segoe',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : ds['size']
                                                                .split('')
                                                                .length ==
                                                            1
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Container(
                                                                height: 25,
                                                                width: 25,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            102,
                                                                            126,
                                                                            234,
                                                                            0.7)),
                                                                child: Center(
                                                                  child: Text(
                                                                      ds['size']
                                                                              .split('')[
                                                                          0],
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Segoe',
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container()),
                                      ),
                                      Column(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Colors.grey[300],
                                                ),
                                                // height: 35,
                                                width: 110,
                                                child: Center(
                                                  child: Text(
                                                      ds['id'] == null
                                                          ? ''
                                                          : 'ID: ' + ds['id'],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Segoe',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Colors.grey[300],
                                                ),
                                                width: 110,
                                                child: Center(
                                                  child: Text(
                                                      ds['quantity'] == null
                                                          ? ''
                                                          : ds['quantity'],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Segoe',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        },
      ),
    );
  }
}
