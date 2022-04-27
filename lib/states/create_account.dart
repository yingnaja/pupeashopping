
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pupeashopping/utility/my_constant.dart';
import 'package:pupeashopping/utility/my_dialog.dart';
import 'package:pupeashopping/witgets/show_image.dart';
import 'package:pupeashopping/witgets/show_title.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? typeUser;
  File? file;
  double? lat, lng;

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

  Future<Null> findLatLng()async{
    Position? position = await findPosittion();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('### lat = $lat, lng = $lng');
    });
  }

  Future<Position?> findPosittion()async{
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
        title: Text('Create New Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
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
          ],
        ),
      ),
    );
  }

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
