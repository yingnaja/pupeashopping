

import 'package:flutter/material.dart';
import 'package:pupeashopping/states/add_product.dart';
import 'package:pupeashopping/states/authen.dart';
import 'package:pupeashopping/states/buyer_service.dart';
import 'package:pupeashopping/states/create_account.dart';
import 'package:pupeashopping/states/rider_service.dart';
import 'package:pupeashopping/states/seller_service.dart';
import 'package:pupeashopping/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyerService': (BuildContext context) => BuyerSerivce(),
  '/sellerServcie': (BuildContext context) => SellerService(),
  '/riderService': (BuildContext context) => RiderService(),
  '/addProduct': (BuildContext context) => AddProduct(),
};

String? initailRout;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type_user = preferences.getString('type_user');
  print('#### type = $type_user');
  if (type_user?.isEmpty ?? true) {
    initailRout = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (type_user) {
      case 'buyer':
        initailRout = MyConstant.routeBuyerService;
        runApp(MyApp());
        break;
      case 'seller':
        initailRout = MyConstant.routeSellerService;
        runApp(MyApp());
        break;
      case 'rider':
        initailRout = MyConstant.routeRiderService;
        runApp(MyApp());
        break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xfff9b9d0, MyConstant.mapMaterialColor);
    return MaterialApp(
      routes: map,
      title: MyConstant.appName,
      initialRoute: initailRout,
      // theme: ThemeData(primaryColor: Colors.amber),
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
