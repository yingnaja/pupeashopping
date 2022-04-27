import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyConstant {
  // Gernaral
  static String appName = 'Pupea Shopping';
  // Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  // Image
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/image5.png';
  static String avatar = 'images/avatar.png';
  // Colors
  static Color primary = Color(0xfff9b9d0);
  static Color dark = Color(0xffc5899f);
  static Color light = Color(0xffffecff);
  // TextStyle
  TextStyle h1_Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);
  TextStyle h2_Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w700);
  TextStyle h3_Style() =>
      TextStyle(fontSize: 14, color: dark, fontWeight: FontWeight.normal);
  // Button Style
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
