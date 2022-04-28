import 'package:flutter/material.dart';
import 'package:pupeashopping/utility/my_constant.dart';
import 'package:pupeashopping/witgets/show_signout.dart';
import 'package:pupeashopping/witgets/show_title.dart';

class BuyerSerivce extends StatefulWidget {
  const BuyerSerivce({Key? key}) : super(key: key);

  @override
  State<BuyerSerivce> createState() => _BuyerSerivceState();
}

class _BuyerSerivceState extends State<BuyerSerivce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer'),
      ),
      drawer: Drawer(
        child: ShowSignOut(),
      ),
    );
  }
}
