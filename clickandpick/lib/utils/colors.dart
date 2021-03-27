import 'dart:ui';
import 'package:flutter/material.dart';

Color containercolor = Color(0xeef5f5f5);
Color headingcolor = Color(0xff443f5d);
Color subheading = Color(0xffb0adc0);
Color buttoncolor = Color(0xdd0e4a86);

class AppColor {
  static var black = Color(0xFF2F2F3E);
  static var bodyColor = Color(0xFF6F8398);
}

class CustomTextStyle {
  static var textFormFieldRegular = TextStyle(
      fontSize: 16,
      fontFamily: "Helvetica",
      color: Colors.black,
      fontWeight: FontWeight.w400);

  static var textFormFieldLight =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w200);

  static var textFormFieldMedium =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w500);

  static var textFormFieldSemiBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w600);

  static var textFormFieldBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w700);

  static var textFormFieldBlack =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w900);
}

class Utils {
  static getSizedBox({double width, double height}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}

class ListProfileSection {
  String title;
  String icon;
  Color color;
  Widget widget;

  ListProfileSection(this.title, this.icon, this.color, this.widget);
}
