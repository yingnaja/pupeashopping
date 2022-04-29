import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pupeashopping/models/product_model.dart';
import 'package:pupeashopping/utility/my_constant.dart';
import 'package:pupeashopping/witgets/show_image.dart';
import 'package:pupeashopping/witgets/show_porgress.dart';
import 'package:pupeashopping/witgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({Key? key}) : super(key: key);

  @override
  State<ShowProductSeller> createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool? haveData;
  List<ProductModel> productModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    if (productModels.length != 0) {
      productModels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetProductWhereIdSeller =
        '${MyConstant.domain}/pupeashopping/getProductWhereIdSeller.php?isAdd=true&idSeller=$id';
    await Dio().get(apiGetProductWhereIdSeller).then((value) {
      // print('### value ===> $value');

      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        // Have Data
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);
          print('###  name Product ===> ${model.name}');

          setState(() {
            load = false;
            haveData = true;
            productModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowImage(path: MyConstant.zoomProduct),
                      ShowTitle(
                          title: 'No Product',
                          textStyle: MyConstant().h1_Style()),
                      ShowTitle(
                          title: 'Please Add Product',
                          textStyle: MyConstant().h2_Style()),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routAddProduct).then(
          (value) => loadValueFromAPI(),
        ),
        child: Text('Add'),
      ),
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/pupeashopping/${strings[0]}';
    return url;
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShowTitle(
                      title: productModels[index].name,
                      textStyle: MyConstant().h2_Style()),
                  Container(
                    width: constraints.maxWidth * 0.5,
                    height: constraints.maxWidth * 0.4,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: createUrl(productModels[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          ShowImage(path: MyConstant.zoomProduct),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(
                      title: 'Price ${productModels[index].price} THB',
                      textStyle: MyConstant().h2_Style()),
                  ShowTitle(
                      title: productModels[index].detail,
                      textStyle: MyConstant().h3_Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            print('### You Click Edit');
                          },
                          icon: Icon(Icons.edit_outlined,
                              size: 36, color: MyConstant.dark)),
                      IconButton(
                          onPressed: () {
                            print('## YOu Click Delete from index = $index');
                            confirmDialogDelete(productModels[index]);
                          },
                          icon: Icon(Icons.delete_outlined,
                              size: 36, color: MyConstant.dark))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> confirmDialogDelete(ProductModel productModel) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: createUrl(productModel.images),
                  placeholder: (context, url) => ShowProgress(),
                ),
                title: ShowTitle(
                    title: 'Delete ${productModel.name} ?',
                    textStyle: MyConstant().h2_Style()),
                subtitle: ShowTitle(
                  title: productModel.detail,
                  textStyle: MyConstant().h3_Style(),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      print('### Confirm Delete at Id ==> ${productModel.id}');
                      String apiDeleteProductWhereId =
                          '${MyConstant.domain}/pupeashopping/deleteProductWhereId.php?isAdd=true&id=${productModel.id}';
                      await Dio().get(apiDeleteProductWhereId).then((value) {
                        Navigator.pop(context);
                        loadValueFromAPI();
                      });
                    },
                    child: Text('Delete')),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancle'))
              ],
            ));
  }
}
