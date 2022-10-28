// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:firstapp/Comm/ComHelp.dart';
import 'package:firstapp/Database/PrefectureModel.dart';
import 'package:firstapp/Database/Prefecture_dao.dart';
import 'package:firstapp/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Prefecture_home_Screen.dart';

class PrefectureInfoDataScreen extends StatefulWidget {
  const PrefectureInfoDataScreen({Key? key}) : super(key: key);

  @override
  _PrefectureInfoDataScreenState createState() =>
      _PrefectureInfoDataScreenState();
}

class _PrefectureInfoDataScreenState extends State<PrefectureInfoDataScreen> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final _formKey = new GlobalKey<FormState>();
  final PrefecDao _dao = PrefecDao();

  final _prefectureName = TextEditingController();
  final _prefectureEmail = TextEditingController();
  final _prefectureCity = TextEditingController();
  final _prefectureState = TextEditingController();
  final _prefecturePassword = TextEditingController();
  final _prefectureCode = TextEditingController();
  int? _prefectureId;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _prefectureId = sp.getInt('prefecID');
      _prefectureName.text = sp.getString("prefecName")!;
      _prefectureEmail.text = sp.getString("prefecEmail")!;
      _prefecturePassword.text = sp.getString("prefecPassword")!;
      _prefectureCity.text = sp.getString("prefecCity")!;
      _prefectureState.text = sp.getString("prefecState")!;
      _prefectureCode.text = sp.getString('prefecCode')!;
    });
  }

  Widget _PrefectureData({
    required String Title,
    required IconData icon,
    required TextEditingController prefectureText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Title,
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: prefectureText,
            obscureText: false,
            style: kOpenSansWhite,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icon,
                color: Colors.white,
              ),
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _PrefecturePassword(
      {required String title, required TextEditingController prefectureText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: prefectureText,
            obscureText: _showCoverPassword,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _showCoverPassword = true;
  Widget _ShowCoverPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _showCoverPassword,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _showCoverPassword = value!;
                });
              },
            ),
          ),
          const Text(
            'Ocultar/Mostrar senha',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _UpdateBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: update,
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: const Text(
          'Alterar Dados',
          style: kOpenSans,
        ),
      ),
    );
  }

  Widget _DeleteBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: delete,
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.red,
        child: const Text(
          'Deletar Conta',
          style: kOpenSans_white,
        ),
      ),
    );
  }

  delete() async {
    int pid = _prefectureId!;
    String pname = _prefectureName.text;
    String pemail = _prefectureEmail.text;
    String ppasswd = _prefecturePassword.text;
    String pcity = _prefectureCity.text;
    String pstate = _prefectureState.text;
    String pcode = _prefectureCode.text;

    PrefecModel prefecture =
          PrefecModel(pid, pname, pemail, pcity, pstate, ppasswd, pcode);
    await _dao.deletePrefecture(pid).then((value) {
      if (value == 1) {
        //alertDialog("Successfully Deleted");

        updateSP(prefecture, false).whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (Route<dynamic> route) => false);
        });
      }
    });
  }

  update() async {
    int pid = _prefectureId!;
    String pname = _prefectureName.text;
    String pemail = _prefectureEmail.text;
    String ppasswd = _prefecturePassword.text;
    String pcity = _prefectureCity.text;
    String pstate = _prefectureState.text;
    String pcode = _prefectureCode.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      PrefecModel prefecture =
          PrefecModel(pid, pname, pemail, pcity, pstate, ppasswd, pcode);
      await _dao.updatePrefecture(prefecture).then((value) {
        if (value == 1) {
          alertDialog("Successfully Updated");

          updateSP(prefecture, true).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const PrefectureHomeScreen()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog("Error Update");
        }
      }).catchError((error) {
        print(error);
        alertDialog("Error");
      });
    }
  }

  Future updateSP(PrefecModel prefecture, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setInt('prefecID', prefecture.prefecID);
      sp.setString("prefecName", prefecture.prefecName);
      sp.setString("prefecEmail", prefecture.prefecEmail);
      sp.setString("prefecPassword", prefecture.prefecPassword);
      sp.setString("prefecCity", prefecture.prefecCity);
      sp.setString("prefecState", prefecture.prefecState);
      sp.setString("prefecCode", prefecture.prefecCode);
    } else {
      sp.remove('prefecID');
      sp.remove('prefecName');
      sp.remove('prefecEmail');
      sp.remove('prefecPassword');
      sp.remove('prefecCity');
      sp.remove('prefecState');
      sp.remove('prefecCode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          width: 250,
          child: Center(
            child: Text(
              'Dados da Conta',
              style: kfontSize_28,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
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
                    vertical: 80.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _PrefectureData(
                          Title: 'prefeitura',
                          icon: Icons.person_outline,
                          prefectureText: _prefectureName),
                      const SizedBox(height: 10.0),
                      _PrefectureData(
                          Title: 'Código da prefeitura',
                          icon: Icons.numbers_rounded,
                          prefectureText: _prefectureCode),
                      const SizedBox(height: 10.0),
                      _PrefectureData(
                          Title: 'Estado',
                          icon: Icons.location_on,
                          prefectureText: _prefectureState),
                      const SizedBox(height: 10.0),
                      _PrefectureData(
                          Title: 'Cidade',
                          icon: Icons.location_on,
                          prefectureText: _prefectureCity),
                      const SizedBox(height: 10.0),
                      _PrefectureData(
                          Title: 'E-mail',
                          icon: Icons.email,
                          prefectureText: _prefectureEmail),
                      const SizedBox(height: 10.0),
                      _PrefecturePassword(
                        title: 'Senha',
                        prefectureText: _prefecturePassword,
                      ),
                      _ShowCoverPassword(),
                      _UpdateBtn(),
                      const SizedBox(
                        height: 20,
                      ),
                      _DeleteBtn(),
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