// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:firstapp/Screens/User/Location_Screen.dart';


final ImagePicker _picker = ImagePicker();

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({
    Key? key,
  }) : super(key: key);


  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  File? image;
  String? image64En;
  // final String databasesPath = image?.path;
  // final String path = join(databasesPath, 'tcc_app.db');

  Widget __PhotoGalleryBtn({
    required String title,
    required IconData icon,
    required VoidCallback onClick,
  }) {
    return SizedBox(
      child: RaisedButton(
        elevation: 0,
        color: Colors.transparent,
        onPressed: onClick,
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            Text(
              title,
              style: kfontSize_20,
            )
          ],
        ),
      ),
    );
  }

  Future pickImageGallery(ImageSource source) async {
    try {
      final XFile? image =
          await _picker.pickImage(source: source, imageQuality: 50);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('failed. Error; $e');
    }
  }

  Widget _RowPhotoGallery() {
    return SizedBox(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 30.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            __PhotoGalleryBtn(
                title: "Camera",
                icon: Icons.camera_alt,
                onClick: () => pickImageGallery(
                      ImageSource.camera,
                    )),
            const SizedBox(height: 10.0),
            __PhotoGalleryBtn(
                title: "Galeria",
                icon: Icons.image,
                onClick: () => pickImageGallery(ImageSource.gallery)),
          ],
        ),
      ),
    );
  }

  Widget _PhotoBox(image) {
    return Container(
      width: 300.0,
      height: 300.0,
      child: image,
      decoration: PhotoDecorationBox,
    );
  }

  Confirm() async {
    print('Next Button Pressed');
    final bytes = image?.readAsBytesSync();
    image64En = base64Encode(bytes!);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationScreen(
          image: image64En.toString(),
        ),
      ),
    );
  }

  Widget _NextBtn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: Confirm,
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: const Text(
          'Proximo',
          style: kOpenSans,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          width: 250,
          child: Center(
            child: Text(
              'Tirar Foto',
              style: kfontSize_28,
            ),
          ),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 30.0),
                      _PhotoBox(image != null
                          ? Image.file(image!, fit: BoxFit.cover)
                          : null),
                      const SizedBox(
                        height: 10.0,
                      ),
                      _RowPhotoGallery(),
                      _NextBtn(context),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}