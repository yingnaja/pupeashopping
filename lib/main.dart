import 'package:flutter/material.dart';
import 'package:pupeashopping/states/authen.dart';
import 'package:pupeashopping/states/create_account.dart';
import 'package:pupeashopping/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
};

String? initailRout;

void main() {
  initailRout = MyConstant.appName;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      title: MyConstant.appName,
      initialRoute: initailRout,
    );
  }
}
