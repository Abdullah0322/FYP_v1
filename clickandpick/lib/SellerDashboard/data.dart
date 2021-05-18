import 'dart:io';

class Data {
  String id;
  String name;
  String quantity;
  String category;
  final image;
  String price;
  String description;
  String sellername;
  String shopaddress;
  String selleremail;
  String buyeremail;
  double total;
  double rating;

  Data({
    this.name,
    this.quantity,
    this.category,
    this.image,
    this.price,
    this.id,
    this.description,
    this.sellername,
    this.shopaddress,
    this.selleremail,
    this.buyeremail,
    this.total,
    this.rating,
  });
}

class Seller {
  String name;
  String email;
  String shopname;
  String address;
  Seller({
    this.name,
    this.address,
    this.email,
    this.shopname,
  });
}
