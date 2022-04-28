import 'package:flutter/material.dart';

class BuyerSerivce extends StatefulWidget {
  const BuyerSerivce({Key? key}) : super(key: key);

  @override
  State<BuyerSerivce> createState() => _BuyerSerivceState();
}

class _BuyerSerivceState extends State<BuyerSerivce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buyer')),
    );
  }
}
