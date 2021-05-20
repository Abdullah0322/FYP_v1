import 'package:ClickandPick/SellerDashboard/Categories/Shoes.dart';
import 'package:ClickandPick/SellerDashboard/Categories/clothing.dart';
import 'package:ClickandPick/SellerDashboard/Categories/electronics.dart';
import 'package:ClickandPick/SellerDashboard/Categories/food.dart';
import 'package:ClickandPick/SellerDashboard/Categories/fragrances.dart';
import 'package:ClickandPick/SellerDashboard/Categories/watches.dart';
import 'package:flutter/material.dart';
import 'package:ClickandPick/Cart/cart.dart';
import 'package:ClickandPick/SellerDashboard/Seller_drawer.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'dart:io';
import 'data.dart';

import 'package:ClickandPick/Login/LoginPage.dart';

class ManageProducts extends StatefulWidget {
  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<bool> isLoggedIn() async {
    User user = FirebaseAuth.instance.currentUser;
    print(user.emailVerified);
  }

  final itemsList = List<String>.generate(20, (n) => "List item $n");
  List<Data> allData = List<Data>();
  File _image;
  final picker = ImagePicker();
  final sellername = TextEditingController();
  final nameCon = TextEditingController();
  final shopaddress = TextEditingController();
  final quanCon = TextEditingController();
  final catCon = TextEditingController();
  final priCon = TextEditingController();
  final idCon = TextEditingController();
  final desCon = TextEditingController();

  final nameECon = TextEditingController();
  final quanECon = TextEditingController();
  final catECon = TextEditingController();
  final priECon = TextEditingController();
  final idECon = TextEditingController();
  final desECon = TextEditingController();
  bool stap = false;
  bool mtap = false;
  bool ltap = false;

  int menCount;
  int womenCount;
  int kidCount;
  TabController tabController;
  QuerySnapshot menSnap;
  QuerySnapshot womenSnap;
  QuerySnapshot kidsSnap;
  FullMetadata metaData;
  bool delete;
  bool edit;
  int tabindex;
  var category = [
    "Food",
    "Electronics",
    "Clothing",
    "Watches",
    "Fragrances",
    "Shoes"
  ];
  List<String> size = ["Small", "Medium", "Large"];
  var currentItems = null;
  var sizeItems = null;
  var sizeEItems = null;
  var edititems = null;
  bool saved;
  bool reload = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String imagePath;
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

  void initState() {
    super.initState();

    tabController = TabController(length: 6, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {
          tabindex = tabController.index;
        });
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var h = AppBar().preferredSize.height;
    var padding = MediaQuery.of(context).padding;
    var height = MediaQuery.of(context).size.height - h - padding.top;
    isLoggedIn();
    return SafeArea(
        child: WillPopScope(
            onWillPop: () {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Are you sure you want to exit?',
                        style:
                            TextStyle(color: Colors.black, fontFamily: 'Segoe'),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Segoe'),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Exit",
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Segoe'),
                          ),
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              SystemNavigator.pop();
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: e,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red[400],
                                textColor: Colors.white,
                                fontSize: 15,
                              );
                              print(e);
                            }
                          },
                        ),
                      ],
                    );
                  });
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Color(0xFFFFFFFF),
              appBar: AppBar(
                backgroundColor: Color(0xFFBB03B2),
                title: Text(
                  'Products',
                  style: TextStyle(
                      fontFamily: 'Segoe',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                leading: GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState.openDrawer();
                    /* Write listener code here */
                  },
                  child: Icon(Icons.menu,
                      color: Colors.white // add custom icons also
                      ),
                ),
                centerTitle: true,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Color.fromRGBO(102, 126, 234, 1),
                  controller: tabController,
                  tabs: [
                    Tab(
                      child: Text(
                        'Food',
                        style: TextStyle(
                            fontFamily: 'Segoe', fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Electronics',
                        style: TextStyle(
                            fontFamily: 'Segoe', fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Clothing',
                        style: TextStyle(
                            fontFamily: 'Segoe', fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Watches',
                        style: TextStyle(
                            fontFamily: 'Segoe', fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Fragrances',
                        style: TextStyle(
                            fontFamily: 'Segoe', fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Shoes',
                        style: TextStyle(
                            fontFamily: 'Segoe', fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                elevation: 0,
              ),
              drawer: SellerDrawer(),
              body: TabBarView(controller: tabController, children: <Widget>[
                Food(),
                Electronics(),
                Clothing(),
                Watches(),
                Fragances(),
                Shoes(),
              ]),
              floatingActionButton: new FloatingActionButton(
                onPressed: () {
                  setState(() {
                    stap = false;
                    ltap = false;
                    mtap = false;
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return Stack(
                          children: [
                            Dialog(
                              insetPadding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                },
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    // height: height * 0.8,
                                    width: width * 0.9,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Add product',
                                          style: TextStyle(
                                              fontFamily: 'Segoe',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        Theme(
                                          data: new ThemeData(
                                            primaryColor: Colors.grey[700],
                                          ),
                                          child: TextField(
                                            style:
                                                TextStyle(fontFamily: 'Segoe'),
                                            controller: idCon,
                                            textInputAction:
                                                TextInputAction.next,
                                            cursorColor: Colors.grey[700],
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText:
                                                    'Enter Unique Barcode',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 12)),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Theme(
                                          data: new ThemeData(
                                            primaryColor: Colors.grey[700],
                                          ),
                                          child: TextField(
                                            style:
                                                TextStyle(fontFamily: 'Segoe'),
                                            controller: nameCon,
                                            textInputAction:
                                                TextInputAction.next,
                                            cursorColor: Colors.grey[700],
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText: 'Enter Name',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 12)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0,
                                        ),
                                        Theme(
                                          data: new ThemeData(
                                            primaryColor: Colors.grey[700],
                                          ),
                                          child: TextField(
                                            style:
                                                TextStyle(fontFamily: 'Segoe'),
                                            controller: quanCon,
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            cursorColor: Colors.grey[700],
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText: 'Enter quantity',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 12)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0,
                                        ),
                                        Theme(
                                          data: new ThemeData(
                                            primaryColor: Colors.grey[700],
                                          ),
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            style:
                                                TextStyle(fontFamily: 'Segoe'),
                                            controller: priCon,
                                            cursorColor: Colors.grey[700],
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText: 'Enter price',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 12)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0,
                                        ),
                                        Theme(
                                          data: new ThemeData(
                                            primaryColor: Colors.grey[700],
                                          ),
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.next,
                                            style:
                                                TextStyle(fontFamily: 'Segoe'),
                                            controller: desCon,
                                            cursorColor: Colors.grey[700],
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText: 'Enter description',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 12)),
                                          ),
                                        ),
                                        Theme(
                                          data: new ThemeData(
                                            primaryColor: Colors.grey[700],
                                          ),
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.next,
                                            style:
                                                TextStyle(fontFamily: 'Segoe'),
                                            controller: sellername,
                                            cursorColor: Colors.grey[700],
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText: 'Enter Seller name',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 12)),
                                          ),
                                        ),
                                        Theme(
                                          data: new ThemeData(
                                            primaryColor: Colors.grey[700],
                                          ),
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.next,
                                            style:
                                                TextStyle(fontFamily: 'Segoe'),
                                            controller: shopaddress,
                                            cursorColor: Colors.grey[700],
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText: 'Enter shop address',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 12)),
                                          ),
                                        ),
                                        Theme(
                                          data: new ThemeData(
                                            primaryColor: Colors.grey[700],
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              hint: Text('Select category',
                                                  style: TextStyle(
                                                    fontFamily: 'Segoe',
                                                    fontSize: 13,
                                                  )),
                                              style: TextStyle(
                                                  fontFamily: 'Segoe',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontSize: 15),
                                              items: category.map(
                                                  (String dropDownStringItem) {
                                                return DropdownMenuItem<String>(
                                                  value: dropDownStringItem,
                                                  child:
                                                      Text(dropDownStringItem),
                                                );
                                              }).toList(),
                                              onChanged:
                                                  (String newValueSelected) {
                                                setState(() {
                                                  this.currentItems =
                                                      newValueSelected;
                                                });
                                              },
                                              value: currentItems,
                                              isExpanded: true,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                          thickness: 1,
                                          color: Colors.black,
                                        ),
                                        Divider(
                                          height: 0,
                                          thickness: 1,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Container(
                                          height: 40,
                                          width: width * 0.9,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Select size',
                                                style: TextStyle(
                                                  fontFamily: 'Segoe',
                                                  fontSize: 13,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            stap == false
                                                                ? setState(() {
                                                                    stap = true;
                                                                  })
                                                                : setState(() {
                                                                    stap =
                                                                        false;
                                                                  });
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: stap ==
                                                                            true
                                                                        ? Color.fromRGBO(
                                                                            102,
                                                                            126,
                                                                            234,
                                                                            1)
                                                                        : Colors
                                                                            .transparent,
                                                                    offset: stap ==
                                                                            true
                                                                        ? Offset(
                                                                            0, 6)
                                                                        : Offset(
                                                                            0,
                                                                            0),
                                                                    blurRadius:
                                                                        stap == true
                                                                            ? 3
                                                                            : 0,
                                                                    spreadRadius:
                                                                        stap == true
                                                                            ? -4
                                                                            : 0)
                                                              ],
                                                              color: stap ==
                                                                      true
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          102,
                                                                          126,
                                                                          234,
                                                                          1)
                                                                  : Colors.grey[
                                                                      300],
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'S',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Segoe',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 9,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            mtap == false
                                                                ? setState(() {
                                                                    mtap = true;
                                                                  })
                                                                : setState(() {
                                                                    mtap =
                                                                        false;
                                                                  });
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: mtap ==
                                                                            true
                                                                        ? Color.fromRGBO(
                                                                            102,
                                                                            126,
                                                                            234,
                                                                            1)
                                                                        : Colors
                                                                            .transparent,
                                                                    offset: mtap ==
                                                                            true
                                                                        ? Offset(
                                                                            0, 6)
                                                                        : Offset(
                                                                            0,
                                                                            0),
                                                                    blurRadius:
                                                                        mtap == true
                                                                            ? 3
                                                                            : 0,
                                                                    spreadRadius:
                                                                        mtap == true
                                                                            ? -4
                                                                            : 0)
                                                              ],
                                                              color: mtap ==
                                                                      true
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          102,
                                                                          126,
                                                                          234,
                                                                          1)
                                                                  : Colors.grey[
                                                                      300],
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'M',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Segoe',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 9,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            ltap == false
                                                                ? setState(() {
                                                                    ltap = true;
                                                                  })
                                                                : setState(() {
                                                                    ltap =
                                                                        false;
                                                                  });
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            width: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: ltap ==
                                                                            true
                                                                        ? Color.fromRGBO(
                                                                            102,
                                                                            126,
                                                                            234,
                                                                            1)
                                                                        : Colors
                                                                            .transparent,
                                                                    offset: ltap ==
                                                                            true
                                                                        ? Offset(
                                                                            0, 6)
                                                                        : Offset(
                                                                            0,
                                                                            0),
                                                                    blurRadius:
                                                                        ltap == true
                                                                            ? 3
                                                                            : 0,
                                                                    spreadRadius:
                                                                        ltap == true
                                                                            ? -4
                                                                            : 0)
                                                              ],
                                                              color: ltap ==
                                                                      true
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          102,
                                                                          126,
                                                                          234,
                                                                          1)
                                                                  : Colors.grey[
                                                                      300],
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'L',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Segoe',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
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
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Divider(
                                          height: 0,
                                          thickness: 1,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            getImage();
                                          },
                                          child: Container(
                                            height: 40,
                                            width: width * 0.9,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Colors.white70,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                  ),
                                                ]),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            'Select primary image',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Segoe',
                                                                fontSize: 13),
                                                          ))),
                                                ),
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Icon(Icons.image)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 10),
                                          height: 40,
                                          width: width * 0.9,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  nameCon.clear();
                                                  quanCon.clear();
                                                  priCon.clear();
                                                  catCon.clear();
                                                  idCon.clear();
                                                  desCon.clear();
                                                  setState(() {
                                                    currentItems = null;
                                                    sizeItems = null;
                                                    stap = false;
                                                    mtap = false;
                                                    ltap = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontFamily: 'Segoe',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    saved = false;
                                                  });
                                                  if (nameCon.text == '') {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Name cannot be empty",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else if (quanCon.text ==
                                                      '') {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Quantity cannot be empty",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else if (priCon.text ==
                                                      '') {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Price cannot be empty",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else if (sellername.text ==
                                                      '') {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Seller name cannot be empty",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else if (shopaddress.text ==
                                                      '') {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Shop address cannot be empty",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else if (desCon.text ==
                                                      '') {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Description cannot be empty",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else if (sellername.text ==
                                                      '') {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Seller name cannot be empty",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else if (shopaddress.text ==
                                                      '') {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Shop address cannot be empty",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else if (currentItems ==
                                                      null) {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Please select a category",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else if (_image == null) {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Please select an image",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textColor: Colors.white,
                                                      fontSize: 15,
                                                    );
                                                    setState(() {
                                                      saved = true;
                                                    });
                                                  } else {
                                                    print(
                                                        "Text:" + nameCon.text);
                                                    bool exit;

                                                    try {
                                                      final result =
                                                          await InternetAddress
                                                              .lookup(
                                                                  'google.com');
                                                      if (result.isNotEmpty &&
                                                          result[0]
                                                              .rawAddress
                                                              .isNotEmpty) {
                                                        print('connected');
                                                        User user = FirebaseAuth
                                                            .instance
                                                            .currentUser;
                                                        if (user != null) {
                                                          try {
                                                            QuerySnapshot snap = await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'product')
                                                                .doc(user.email)
                                                                .collection(
                                                                    'products')
                                                                .doc('category')
                                                                .collection(
                                                                    currentItems
                                                                        .toString()
                                                                        .toLowerCase())
                                                                .get();
                                                            QuerySnapshot snap1 = await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products')
                                                                .doc('category')
                                                                .collection(
                                                                    currentItems
                                                                        .toString()
                                                                        .toLowerCase())
                                                                .get();
                                                            print(snap
                                                                .docs.length);
                                                            int checkAlreadyExist =
                                                                0;
                                                            snap.docs
                                                                .forEach((doc) {
                                                              if (doc.id ==
                                                                  idCon.text) {
                                                                checkAlreadyExist++;
                                                              } else {}
                                                            });
                                                            snap1.docs
                                                                .forEach((doc) {
                                                              if (doc.id ==
                                                                  idCon.text) {
                                                                checkAlreadyExist++;
                                                              } else {}
                                                            });
                                                            if (checkAlreadyExist ==
                                                                0) {
                                                              try {
                                                                await uploadFile(
                                                                        idCon
                                                                            .text,
                                                                        currentItems)
                                                                    .then(
                                                                        (value) {
                                                                  try {
                                                                    User user = FirebaseAuth
                                                                        .instance
                                                                        .currentUser;
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'products')
                                                                        .doc(
                                                                            'category')
                                                                        .collection(currentItems
                                                                            .toString()
                                                                            .toLowerCase())
                                                                        .doc(idCon
                                                                            .text)
                                                                        .set({
                                                                      'id': idCon
                                                                          .text,
                                                                      'selleremail':
                                                                          user.email,
                                                                      'name': nameCon
                                                                          .text,
                                                                      'quantity':
                                                                          quanCon
                                                                              .text,
                                                                      'price':
                                                                          priCon
                                                                              .text,
                                                                      'description':
                                                                          desCon
                                                                              .text,
                                                                      'sellername':
                                                                          sellername
                                                                              .text,
                                                                      'rating':
                                                                          0.0,
                                                                      'shopaddress':
                                                                          shopaddress
                                                                              .text,
                                                                      'size': stap == true &&
                                                                              mtap == false &&
                                                                              ltap == false
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
                                                                      'image_path':
                                                                          imagePath,
                                                                      'bucket':
                                                                          metaData
                                                                              .bucket,
                                                                      'full_path':
                                                                          metaData
                                                                              .fullPath
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      saved =
                                                                          true;
                                                                    });
                                                                  } catch (e) {}
                                                                  try {
                                                                    User user = FirebaseAuth
                                                                        .instance
                                                                        .currentUser;
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'seller')
                                                                        .doc(user
                                                                            .email)
                                                                        .collection(
                                                                            'products')
                                                                        .doc(
                                                                            'category')
                                                                        .collection(currentItems
                                                                            .toString()
                                                                            .toLowerCase())
                                                                        .doc(idCon
                                                                            .text)
                                                                        .set({
                                                                      'id': idCon
                                                                          .text,
                                                                      'selleremail':
                                                                          user.email,
                                                                      'name': nameCon
                                                                          .text,
                                                                      'quantity':
                                                                          quanCon
                                                                              .text,
                                                                      'price':
                                                                          priCon
                                                                              .text,
                                                                      'description':
                                                                          desCon
                                                                              .text,
                                                                      'sellername':
                                                                          sellername
                                                                              .text,
                                                                      'rating':
                                                                          0.0,
                                                                      'shopaddress':
                                                                          shopaddress
                                                                              .text,
                                                                      'size': stap == true &&
                                                                              mtap == false &&
                                                                              ltap == false
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
                                                                      'image_path':
                                                                          imagePath,
                                                                      'bucket':
                                                                          metaData
                                                                              .bucket,
                                                                      'full_path':
                                                                          metaData
                                                                              .fullPath
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      saved =
                                                                          true;
                                                                    });
                                                                    // getProducts();
                                                                    Fluttertoast
                                                                        .showToast(
                                                                      msg:
                                                                          "Product added successfully",
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
                                                                              .green,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          15,
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      _image =
                                                                          null;
                                                                    });

                                                                    exit = true;
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
                                                                  }
                                                                });
                                                              } catch (e) {
                                                                print(
                                                                    "Ex: " + e);
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg: e,
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
                                                                exit = false;
                                                              }
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg:
                                                                    "Product with this Barcode already exist",
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
                                                              setState(() {
                                                                saved = true;
                                                              });
                                                              exit = false;
                                                            }
                                                          } catch (e) {
                                                            print(
                                                                "Exception: " +
                                                                    e);
                                                            Fluttertoast
                                                                .showToast(
                                                              msg: e,
                                                              toastLength: Toast
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
                                                                  Colors.white,
                                                              fontSize: 15,
                                                            );
                                                            exit = false;
                                                            setState(() {
                                                              saved = true;
                                                            });
                                                          }
                                                        }
                                                        if (exit == false) {
                                                          return null;
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                        nameCon.clear();
                                                        quanCon.clear();
                                                        priCon.clear();
                                                        catCon.clear();
                                                        idCon.clear();
                                                        desCon.clear();
                                                        setState(() {
                                                          stap = false;
                                                          mtap = false;
                                                          ltap = false;
                                                        });
                                                      }
                                                    } on SocketException catch (_) {
                                                      Navigator.pop(context);

                                                      print('not connected');
                                                      setState(() {
                                                        saved = true;
                                                      });
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "You're not connected to the internet",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 3,
                                                        backgroundColor:
                                                            Colors.red[400],
                                                        textColor: Colors.white,
                                                        fontSize: 15,
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  'Add',
                                                  style: TextStyle(
                                                      fontFamily: 'Segoe',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            saved == null
                                ? Container()
                                : saved == false
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.transparent,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color.fromRGBO(102, 126, 234, 1),
                                          ),
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Container()
                          ],
                        );
                      });
                    },
                  ).then((value) {
                    nameCon.clear();
                    quanCon.clear();
                    priCon.clear();
                    catCon.clear();
                    idCon.clear();
                    desCon.clear();
                    setState(() {
                      currentItems = null;
                      sizeItems = null;
                      stap = false;
                      mtap = false;
                      ltap = false;
                    });
                  });
                },
                backgroundColor: Color(0xFFBB03B2),
                child: Icon(Icons.add),
                heroTag: Text('Add Product'),
              ),
            )));
  }
}
