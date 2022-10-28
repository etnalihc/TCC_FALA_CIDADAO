// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, deprecated_member_use, avoid_print, use_build_context_synchronously

import 'package:firstapp/Database/LocModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'User_Home_Screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/Database/Localization_dao.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    Key? key,
    required this.image,
  }) : super(key: key);
  final String image;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final txt = TextEditingController();
  final LocationDao _dao = LocationDao();
  final _locInfo = TextEditingController();
  String dropdownvalue = 'Árvore caída';

  List<String>  items = [
    'Árvore caída',
    'Buraco na rua',
    'Poste caído',
    'buraco na calçada',
    'Inundação',
    'Vazamento',
    'Sem energia',
    'Fios soltos',
    'Outro'
  ];

  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    preferences = await SharedPreferences.getInstance();
    String? location = preferences.getString('location1');
    print(location);
    //print(widget.image);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    txt.dispose();
    super.dispose();
  }

  List<dynamic> adress = [];
  Future<void> _getLocation() async {
    Position position = await _determinePosition();
    print(position);
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    setState(() {
      adress.add(
          '${placemarks[0].street}, ${placemarks[0].name}, ${placemarks[0].postalCode}, ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}');
    });
  }

  String RemobeB = '';
  Widget _LocationIcon() {
    String loc = adress.join('-');
    return RaisedButton(
      elevation: 0,
      color: Colors.transparent,
      onPressed: () {
        _getLocation();
        RemobeB = loc.replaceAll(RegExp(r'[]'), ' ');
        print(RemobeB);
        txt.text = RemobeB;
        adress.clear();
        setState(() {});
      },
      child: Column(
        children: const <Widget>[
          Icon(
            Icons.location_on,
            size: 50,
            color: Colors.white,
          ),
          Text(
            "pegar a localização atual",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _LocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Digite a localização',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            style: kOpenSansWhite,
            controller: txt,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: 'Exemplo: bairro, rua',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _OptionalInfo({
    required TextEditingController LocText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Informações opcionais',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            //keyboardType: TextInputType.emailAddress,
            controller: LocText,
            style: kOpenSansWhite,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: 'Exemplo: perto do hospital, em frente ao posto',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Send() async {
    String locInfo = _locInfo.text;
    print('Confirm Button Pressed');
    if (locInfo.isEmpty) {
      locInfo = 'Sem informações adicionais';
    }
    LocationModel uModel = LocationModel(
        0, RemobeB, widget.image, locInfo, dropdownvalue, 'Em espera');
    await _dao.save(uModel);
    print(uModel);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const UserHomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _ConfirmBtn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: Send,
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: const Text(
          'confirmar',
          style: kOpenSans,
        ),
      ),
    );
  }

  Widget _ChoseType() {
    return DropdownButton(
      // Initial Value
      value: dropdownvalue,
      style: kOpenSans_blue,
      // Down Arrow Icon
      
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items.map<DropdownMenuItem<String>>((String items) {
        return DropdownMenuItem<String>(
          value: items,
          child: Text(items, style: kLabelStyle_black,),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
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
              'Pegar Localização',
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _LocationIcon(),
                      const SizedBox(
                        height: 40.0,
                      ),
                      _LocationInfo(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _OptionalInfo(LocText: _locInfo),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _ChoseType(),
                      _ConfirmBtn(context),
                      const SizedBox(
                        height: 20.0,
                      ),
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