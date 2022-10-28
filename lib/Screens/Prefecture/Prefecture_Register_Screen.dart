// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:firstapp/utilities/colors.dart';
import 'Prefecture_Login_Screen.dart';
import 'package:firstapp/Comm/ComHelp.dart';
import 'package:firstapp/Database/PrefectureModel.dart';
import 'package:firstapp/Database/Prefecture_dao.dart';

class PrefectureRegisterScreen extends StatefulWidget {
  const PrefectureRegisterScreen({Key? key}) : super(key: key);

  @override
  _PrefectureRegisterScreenState createState() =>
      _PrefectureRegisterScreenState();
}

class _PrefectureRegisterScreenState extends State<PrefectureRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showCoverPassword = true;

  final _prefectureName = TextEditingController();
  final _prefectureEmail = TextEditingController();
  final _prefectureCity = TextEditingController();
  final _prefectureState = TextEditingController();
  final _prefecturePassword = TextEditingController();
  final _prefectureCPassword = TextEditingController();
  final _prefectureCode = TextEditingController();

  final PrefecDao _dao = PrefecDao();

  

  signUp() async {
    String pname = _prefectureName.text;
    String pemail = _prefectureEmail.text;
    String ppasswd = _prefecturePassword.text;
    String pcpasswd = _prefectureCPassword.text;
    String pcity = _prefectureCity.text;
    String pstate = _prefectureState.text;
    String pcode = _prefectureCode.text;

    if (_formKey.currentState!.validate()) {
      if (ppasswd != pcpasswd) {
        alertDialog('Password diferentes');
      } else {
        _formKey.currentState!.save();

        PrefecModel uModel =
            PrefecModel(0, pname, pemail, pcity, pstate, ppasswd, pcode);
        await _dao.save(uModel).then((userData) {
          alertDialog("salvo com sucesso");
          print(uModel);
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

  Widget _PrefectureData({
    required String Title,
    required String hintTitle,
    required IconData icon,
    required TextEditingController PrefectureText,
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
            controller: PrefectureText,
            obscureText: false,
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

  Widget _PrefectureRegisterPassoword(
      {required String Title,
      required String hintTitle,
      required TextEditingController prefectureText}) {
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
          height: 60.0,
          child: TextField(
            controller: prefectureText,
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

  Widget _CreateAccountBtn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: signUp,
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: const Text(
          'Criar conta',
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
              'Criar Conta',
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
                          Title: 'Escreva o nome completo da prefeitura',
                          hintTitle: 'Ex: João da Silva',
                          icon: Icons.person_outline,
                          PrefectureText: _prefectureName),
                      const SizedBox(height: 10.0),
                      _PrefectureData(
                          Title: 'Escreva o código da prefeitura',
                          hintTitle: 'Ex: 123456789',
                          icon: Icons.numbers,
                          PrefectureText: _prefectureCode),
                      const SizedBox(height: 10.0),
                      _PrefectureData(
                          Title: 'Escreva o Estado',
                          hintTitle: 'Ex: Paraná',
                          icon: Icons.location_on,
                          PrefectureText: _prefectureState),
                      const SizedBox(height: 10.0),
                      _PrefectureData(
                          Title: 'Escreva a cidade',
                          hintTitle: 'Ex: curitiba',
                          icon: Icons.location_on,
                          PrefectureText: _prefectureCity),
                      const SizedBox(height: 10.0),
                      _PrefectureData(
                          Title: 'Criar e-mail',
                          hintTitle: 'Ex: exemplo@gmail.com',
                          icon: Icons.email,
                          PrefectureText: _prefectureEmail),
                      const SizedBox(height: 10.0),
                      _PrefectureRegisterPassoword(
                          Title: 'Digite a senha que deseja criar',
                          hintTitle: 'senha entre 8 a 16 caracteres',
                          prefectureText: _prefecturePassword),
                      const SizedBox(height: 10.0),
                      _PrefectureRegisterPassoword(
                          Title: 'Confirmar senha',
                          hintTitle: 'senha entre 8 a 16 caracteres',
                          prefectureText: _prefectureCPassword),
                      _ShowCoverPassword(),
                      const SizedBox(height: 10.0),
                      _CreateAccountBtn(context),
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