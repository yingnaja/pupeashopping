import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pupeashopping/utility/my_constant.dart';
import 'package:pupeashopping/utility/my_dialog.dart';
import 'package:pupeashopping/witgets/show_image.dart';
import 'package:pupeashopping/witgets/show_title.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => processAddProduct(),
            icon: Icon(Icons.cloud_upload),
          ),
        ],
        title: Text('Add Product'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(
            FocusNode(),
          ),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildProductName(constraints),
                    buildProductPrice(constraints),
                    buildProductDetail(constraints),
                    buildImage(constraints),
                    addProductButton(constraints),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container addProductButton(BoxConstraints constraints) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 16),
      width: constraints.maxWidth * 0.75,
      child: ElevatedButton(
        onPressed: () {
          processAddProduct();
        },
        child: Text('Add Product'),
        style: MyConstant().myButtonStyle(),
      ),
    );
  }

  Future<Null> processAddProduct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        // print('### choose 4 image Success');

        MyDialog().showProgressDialog(context);

        String apiSaveProduct =
            '${MyConstant.domain}/pupeashopping/saveProduct.php';

        int loop = 0;
        for (var item in files) {
          int i = Random().nextInt(1000000);
          String nameFile = 'product$i.jpg';
          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveProduct, data: data).then((value) {
            print('Upload Success');
            loop++;
            if (loop >= files.length) {
              Navigator.pop(context);
            }
          });
        }
      } else {
        MyDialog().normalDialog(context, 'More Image', 'Please More Image');
      }
    }
  }

  Future<Null> processImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      // files[index] == File(result!.path);
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Future<Null> ChooseSourceImageDialog(int index) async {
    print('Click From index ===> $index');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image2),
          title: ShowTitle(
            title: 'Source Image ${index + 1} ?',
            textStyle: MyConstant().h2_Style(),
          ),
          subtitle: ShowTitle(
            title: 'Please Tab on Camera or Gallery',
            textStyle: MyConstant().h3_Style(),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera, index);
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery, index);
                },
                child: Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 0.75,
          margin: EdgeInsets.only(top: 10),
          child: file == null
              ? Image.asset(MyConstant.zoomProduct)
              : Image.file(file!),
        ),
        Container(
          width: constraints.maxWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                margin: EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () => ChooseSourceImageDialog(0),
                  child: files[0] == null
                      ? Image.asset(MyConstant.zoomProduct)
                      : Image.file(files[0]!, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                margin: EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () => ChooseSourceImageDialog(1),
                  child: files[1] == null
                      ? Image.asset(MyConstant.zoomProduct)
                      : Image.file(files[1]!, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                margin: EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () => ChooseSourceImageDialog(2),
                  child: files[2] == null
                      ? Image.asset(MyConstant.zoomProduct)
                      : Image.file(files[2]!, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                margin: EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () => ChooseSourceImageDialog(3),
                  child: files[3] == null
                      ? Image.asset(MyConstant.zoomProduct)
                      : Image.file(files[3]!, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProductName(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            labelStyle: MyConstant().h3_Style(),
            labelText: 'Name Product :',
            prefixIcon: Icon(
              Icons.production_quantity_limits,
              color: MyConstant.dark,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(30),
            )),
      ),
    );
  }

  Widget buildProductPrice(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Price in Blank';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelStyle: MyConstant().h3_Style(),
            labelText: 'Price Product :',
            prefixIcon: Icon(
              Icons.money_sharp,
              color: MyConstant.dark,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(30),
            )),
      ),
    );
  }

  Widget buildProductDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Detail in Blank';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
            hintStyle: MyConstant().h3_Style(),
            hintText: 'Detail Product :',
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Icon(
                Icons.details,
                color: MyConstant.dark,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(30),
            )),
      ),
    );
  }
}
