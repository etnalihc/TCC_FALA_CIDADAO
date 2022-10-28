// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utilities/colors.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class UserHistoryInfo extends StatefulWidget {
  const UserHistoryInfo(
      {Key? key,
      required this.location,
      required this.image,
      required this.locInfo})
      : super(
          key: key,
        );

  final String location;
  final String image;
  final String locInfo;

  @override
  _UserHistoryInfoState createState() => _UserHistoryInfoState();
}

class _UserHistoryInfoState extends State<UserHistoryInfo> {
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    print(widget.location);
    String imageT = widget.image;
    String regex64 = imageT.replaceAll("data:image/png;imageT,", '');
    image = const Base64Decoder().convert(regex64);
  }

  Widget _PhotoBox(image) {
    return FullScreenWidget(
      child: Container(
        width: 350.0,
        height: 300.0,
        decoration: PhotoDecorationBox,
        child: Image.memory(image, fit: BoxFit.contain),
      ),
    );
  }

  Widget _infofield(Location) {
    String locationString = Location;
    locationString.replaceAll(RegExp(r','), ' ');
    return Container(
      width: 400.0,
      height: 100.0,
      decoration: kBoxDecorationStyle,
      child: Text(
        locationString,
        style: kfontSize_18,
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
              'Informações',
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
                    horizontal: 60.0,
                    vertical: 80.0,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _PhotoBox(image),
                        const SizedBox(
                          height: 30.0,
                        ),
                        _infofield(widget.location),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _infofield(widget.locInfo),
                      ],
                    ),
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