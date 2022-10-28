// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, non_constant_identifier_names, unused_field

import 'package:firstapp/Comm/ComHelp.dart';
import 'package:firstapp/Database/PrefectureModel.dart';
import 'package:firstapp/Database/Prefecture_dao.dart';
import 'package:firstapp/Screens/User/User_Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Prefecture_Login_Screen.dart';

class PrefectureForgotPasswordScreen extends StatefulWidget {
  const PrefectureForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _PrefectureForgotPasswordScreen createState() =>
      _PrefectureForgotPasswordScreen();
}

class _PrefectureForgotPasswordScreen
    extends State<PrefectureForgotPasswordScreen> {
  bool _showCoverPassword = true;
  final _formKey = GlobalKey<FormState>();
  final PrefecDao _dao = PrefecDao();

  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String _prefectureName = '';
  final _prefectureEmail = TextEditingController();
  String _prefectureCity = '';
  String _prefectureState = '';
  int? _prefectureID;
  String _prefectureCEmail = '';
  String _prefectureCCode = '';
  final _prefecturePassword = TextEditingController();
  final _prefectureCPassword = TextEditingController();
  final _prefectureCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _prefectureID = sp.getInt('prefecID');
      _prefectureName = sp.getString("prefecName")!;
      _prefectureCEmail = sp.getString("prefecEmail")!;
      _prefectureCCode = sp.getString('prefecCode')!;
      _prefectureCity = sp.getString("prefecCity")!;
      _prefectureState = sp.getString("prefecState")!;
    });
  }

  Widget _PrefectureData(
      {required String title,
      required String hintTitle,
      required IconData icon,
      required TextEditingController textPrefec}) {
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
          height: 50.0,
          child: TextField(
            controller: textPrefec,
            keyboardType: TextInputType.emailAddress,
            style: kOpenSansWhite,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icon,
                color: Colors.white,
              ),
              hintText: hintTitle,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _PrefectureForogotPassoword({
    required String title,
    required String hintTitle,
    required TextEditingController textPrefec,
  }) {
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
            controller: textPrefec,
            obscureText: _showCoverPassword,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: hintTitle,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  ConfirmP() async {
    int pid = _prefectureID!;
    String pname = _prefectureName;
    String pemail = _prefectureEmail.text;
    String ppasswd = _prefecturePassword.text;
    String pcpasswd = _prefectureCPassword.text;
    String pcity = _prefectureCity;
    String pstate = _prefectureState;
    String pcode = _prefectureCode.text;

    if (_formKey.currentState!.validate()) {
      if (pemail != _prefectureCEmail) {
        alertDialog("Email Errado");
      } else if (pcode != _prefectureCCode) {
        alertDialog("Codigo errado");
      } else if (pemail.isEmpty) {
        alertDialog("Por favor escreva seu email");
      } else if (ppasswd != pcpasswd) {
        alertDialog('Password diferentes');
      } else {
        _formKey.currentState!.save();

        PrefecModel pModel =
            PrefecModel(pid, pname, pemail, pcity, pstate, ppasswd, pcode);
        await _dao.updatePrefecture(pModel).then((userData) {
          alertDialog("salvo com sucesso");
          print(pModel);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const PrefectureLoginScreen()),
            (Route<dynamic> route) => false,
          );
        }).catchError((error) {
          print(error);
          alertDialog("Erro ao salvar");
        });
      }
    }
  }

  Widget _ConfirmBtn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: ConfirmP,
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: const Text(
          'Confirmar',
          style: kOpenSans,
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          width: 250,
          child: Center(
            child: Text(
              'Esqueceu a Senha',
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
                          title: 'Digite o e-mail da prefeitura',
                          hintTitle: 'Ex: exemple@gmail.com',
                          icon: Icons.email,
                          textPrefec: _prefectureEmail),
                      const SizedBox(height: 10.0),
                      _PrefectureData(
                          title: 'Digite o código da prefeitura',
                          hintTitle: 'Ex: 123456789',
                          icon: Icons.numbers,
                          textPrefec: _prefectureCode),
                      const SizedBox(height: 10.0),
                      _PrefectureForogotPassoword(
                          title: 'Digite a nova senha',
                          hintTitle: 'senha entre 8 à 16 caracteres',
                          textPrefec: _prefecturePassword),
                      const SizedBox(height: 10.0),
                      _PrefectureForogotPassoword(
                          title: 'Confirme a senha',
                          hintTitle: 'senha entre 8 à 16 caracteres',
                          textPrefec: _prefectureCPassword),
                      _ShowCoverPassword(),
                      const SizedBox(height: 10.0),
                      _ConfirmBtn(context),
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