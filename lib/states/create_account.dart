import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pupeashopping/utility/my_constant.dart';
import 'package:pupeashopping/utility/my_dialog.dart';
import 'package:pupeashopping/witgets/show_image.dart';
import 'package:pupeashopping/witgets/show_porgress.dart';
import 'package:pupeashopping/witgets/show_title.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? avatar;
  String? typeUser;
  File? file;
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');

      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาตแชร์ Location', 'โปรดแชร์ Location');
        } else {
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาตแชร์ Location', 'โปรดแชร์ Location');
        } else {
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      MyDialog().alertLocationService(
          context, 'Location ของคุณปิดอยู่', 'กรุณาเปิด Location Service');
    }
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosittion();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('### lat = $lat, lng = $lng');
    });
  }

  Future<Position?> findPosittion() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [buildCreatNewAccount()],
        title: Text('Create New Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildTitle('สมัครสมาชิก'),
                  buildName(size),
                  buildTitle('ชนิดของ User'),
                  buildRadiobuyer(size),
                  buildRadioSeller(size),
                  buildRadioRider(size),
                  buildUser(size),
                  buildPhone(size),
                  buildPassword(size),
                  buildAddress(size),
                  buildTitle('รูปภาพ'),
                  buildAvatar(size),
                  buildTitle('แสดงที่อยู่ของคุณ'),
                  buildMap(),
                  buildCreateButtontest(size, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildCreateButtontest(double size, BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 16),
      width: size * 0.8,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
          if (typeUser == null) {
            print('Non Choose Type User');
            MyDialog().normalDialog(
              context,
              'ยังไม่ได้เลือกชนิดของ User',
              'กรุณาเลือกชนิดของ User',
            );
          } else {
            print('Process Insert to Database');
            uploadPictureAndInsertData();
          }
        }
        },
        child: Text('Create New Account'),
      ),
    );
  }

  IconButton buildCreatNewAccount() {
    return IconButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          if (typeUser == null) {
            print('Non Choose Type User');
            MyDialog().normalDialog(
              context,
              'ยังไม่ได้เลือกชนิดของ User',
              'กรุณาเลือกชนิดของ User',
            );
          } else {
            print('Process Insert to Database');
            uploadPictureAndInsertData();
          }
        }
      },
      icon: Icon(Icons.cloud_upload),
    );
  }

  IconButton buildCreatNewAccountButton() {
    return IconButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          if (typeUser == null) {
            print('Non Choose Type User');
            MyDialog().normalDialog(
              context,
              'ยังไม่ได้เลือกชนิดของ User',
              'กรุณาเลือกชนิดของ User',
            );
          } else {
            print('Process Insert to Database');
            uploadPictureAndInsertData();
          }
        }
      },
      icon: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> uploadPictureAndInsertData() async {
    String name = nameController.text;
    String user = userController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String address = addressController.text;
    print(
        '### name = $name, user = $user, phone = $phone, password = $password, address = $address');
    String path =
        '${MyConstant.domain}/pupeashopping/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(path).then((value) async {
      print('### value ===> $value');
      if (value.toString() == 'null') {
        print('### User OK');

        if (file == null) {
          processInsertMySQL(
              name: name,
              user: user,
              phone: phone,
              password: password,
              address: address);
          //No Avatar
        } else {
          // Have avatar
          print('### process Upload Avatar');

          String apiSaveAvatar =
              '${MyConstant.domain}/pupeashopping/saveAvatar.php';
          int i = Random().nextInt(100000);
          String nameAvatar = 'avatar$i.jpg';
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameAvatar);
          FormData data = FormData.fromMap(map);
          await Dio().post(apiSaveAvatar, data: data).then((value) {
            avatar = '/pupeashopping/avatar/$nameAvatar';
            processInsertMySQL(
                name: name,
                user: user,
                phone: phone,
                password: password,
                address: address);
          });
        }
      } else {
        MyDialog().normalDialog(context, 'User Fasle', 'Please Change User');
      }
    });
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? user,
      String? phone,
      String? password,
      String? address}) async {
    print('### ProcessInsertMySQL Work and avatar ===>> $avatar');
    String apiInserUser =
        '${MyConstant.domain}/pupeashopping/insertUser.php?isAdd=true&name=$name&typeUser=$typeUser&address=$address&phone=$phone&user=$user&password=$password&avatar=$avatar&lat=$lat&lng=$lng';
    await Dio().get(apiInserUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'Create New User False !!!', 'Please Try Again');
      }
      ;
    });
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี่', snippet: 'Lat = $lat, Lng = $lng'),
        ),
      ].toSet();

  Widget buildMap() => Container(
        width: double.infinity,
        height: 300,
        child: lat == null
            ? ShowProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lng!),
                  zoom: 16,
                ),
                onMapCreated: (controller) {},
                markers: setMarker(),
              ),
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .getImage(source: source, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 30,
            color: MyConstant.dark,
          ),
        ),
        Container(
          width: size * 0.6,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: file == null
              ? ShowImage(path: MyConstant.avatar)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          margin: EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก User ด้วย';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3_Style(),
              labelText: 'User :',
              prefixIcon: Icon(Icons.people, color: MyConstant.dark),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          // margin: EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: phoneController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Phone ด้วย';
              } else {}
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3_Style(),
              labelText: 'Phone :',
              prefixIcon: Icon(Icons.phone, color: MyConstant.dark),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          margin: EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Password ด้วย';
              } else {}
            },
            obscureText: true,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3_Style(),
              labelText: 'Password :',
              prefixIcon: Icon(Icons.lock, color: MyConstant.dark),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          margin: EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Address ด้วย';
              } else {}
            },
            maxLines: 4,
            decoration: InputDecoration(
              hintStyle: MyConstant().h3_Style(),
              hintText: 'Address :',
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Icon(Icons.home, color: MyConstant.dark),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadiobuyer(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
              activeColor: MyConstant.dark,
              title: ShowTitle(
                title: 'Buyer',
                textStyle: MyConstant().h2_Style(),
              ),
              value: 'buyer',
              groupValue: typeUser,
              onChanged: (value) {
                setState(() {
                  typeUser = value as String?;
                });
              }),
        ),
      ],
    );
  }

  Row buildRadioSeller(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
              activeColor: MyConstant.dark,
              title: ShowTitle(
                title: 'Seller',
                textStyle: MyConstant().h2_Style(),
              ),
              value: 'seller',
              groupValue: typeUser,
              onChanged: (value) {
                setState(() {
                  typeUser = value as String?;
                });
              }),
        ),
      ],
    );
  }

  Row buildRadioRider(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
              activeColor: MyConstant.dark,
              title: ShowTitle(
                title: 'Rider',
                textStyle: MyConstant().h2_Style(),
              ),
              value: 'rider',
              groupValue: typeUser,
              onChanged: (value) {
                setState(() {
                  typeUser = value as String?;
                });
              }),
        ),
      ],
    );
  }

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          // margin: EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Name ด้วย';
              } else {}
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3_Style(),
              labelText: 'Name :',
              prefixIcon: Icon(Icons.fingerprint, color: MyConstant.dark),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2_Style(),
      ),
    );
  }
}
