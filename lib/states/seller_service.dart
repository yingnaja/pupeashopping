import 'package:flutter/material.dart';
import 'package:pupeashopping/bodys/shop_manage_seller.dart';
import 'package:pupeashopping/bodys/show_order_seller.dart';
import 'package:pupeashopping/bodys/show_product_seller.dart';
import 'package:pupeashopping/utility/my_constant.dart';
import 'package:pupeashopping/witgets/show_signout.dart';
import 'package:pupeashopping/witgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  State<SellerService> createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  List<Widget> widgets = [
    ShowOrderSeller(),
    ShopManageSeller(),
    ShowProductSeller(),
  ];
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: null,
                  accountEmail: null,
                ),
                menuShowOrder(),
                menuShopManage(),
                menuShowProduct(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTitle(title: 'Show Order', textStyle: MyConstant().h2_Style()),
      subtitle: ShowTitle(
          title: 'รายละเอียดของ Order ที่ลูกค้าสั่ง',
          textStyle: MyConstant().h3_Style()),
    );
  }

  ListTile menuShopManage() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2_outlined),
      title:
          ShowTitle(title: 'Shop Manage', textStyle: MyConstant().h2_Style()),
      subtitle: ShowTitle(
          title: 'แก้ไขแสดงรายละเอียดให้ลูกค้าเห็น',
          textStyle: MyConstant().h3_Style()),
    );
  }

  ListTile menuShowProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_3_outlined),
      title: ShowTitle(
        title: 'Show Product',
        textStyle: MyConstant().h2_Style(),
      ),
      subtitle: ShowTitle(
          title: 'แสดงรายละเอียดสินค้าที่เราขาย',
          textStyle: MyConstant().h3_Style()),
    );
  }
}
