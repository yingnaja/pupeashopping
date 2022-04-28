import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyConstant {
  // Gernaral
  static String appName = 'Pupea Shopping';
  static String domain = 'https://cd1f-27-145-169-11.ap.ngrok.io';
  // Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSellerService = '/sellerServcie';
  static String routeRiderService = '/riderService';
  static String routAddProduct = '/addProduct';
  // Image
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/image5.png';
  static String avatar = 'images/avatar.png';
  static String zoomProduct = 'images/zoomproduct.png';
  // Colors
  static Color primary = Color(0xfff9b9d0);
  static Color dark = Color(0xffc5899f);
  static Color light = Color(0xffffecff);
  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(255, 197, 137, 0.1),
    100: Color.fromRGBO(255, 197, 137, 0.2),
    200: Color.fromRGBO(255, 197, 137, 0.3),
    300: Color.fromRGBO(255, 197, 137, 0.4),
    400: Color.fromRGBO(255, 197, 137, 0.5),
    500: Color.fromRGBO(255, 197, 137, 0.6),
    600: Color.fromRGBO(255, 197, 137, 0.7),
    700: Color.fromRGBO(255, 197, 137, 0.8),
    800: Color.fromRGBO(255, 197, 137, 0.9),
    900: Color.fromRGBO(255, 197, 137, 1.0),
  };

  // TextStyle
  TextStyle h1_Style() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2_Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );
  TextStyle h2_WhiteStyle() => TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      );
  TextStyle h3_Style() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle h3_whiteStyle() => TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );
  // Button Style
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
