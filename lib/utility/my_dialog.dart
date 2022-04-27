// import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pupeashopping/utility/my_constant.dart';
import 'package:pupeashopping/witgets/show_image.dart';
import 'package:pupeashopping/witgets/show_title.dart';

class MyDialog {
  Future<Null> alertLocationService(
      BuildContext context, String title, String message) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: ShowImage(
                  path: MyConstant.image1,
                ),
                title: ShowTitle(
                  title: title,
                  textStyle: MyConstant().h2_Style(),
                ),
                subtitle: ShowTitle(
                  title: message,
                  textStyle: MyConstant().h3_Style(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                  },
                  child: Text('OK'),
                )
              ],
            ));
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: ListTile(
                leading: ShowImage(path: MyConstant.image1),
                title:
                    ShowTitle(title: title, textStyle: MyConstant().h2_Style()),
                subtitle: ShowTitle(
                    title: message, textStyle: MyConstant().h3_Style()),
              ),
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text('OK')),
              ],
            ));
  }
}
