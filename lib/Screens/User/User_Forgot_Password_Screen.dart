// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, non_constant_identifier_names

import 'package:firstapp/Comm/ComHelp.dart';
import 'package:firstapp/Database/UserModel.dart';
import 'package:firstapp/Database/User_dao.dart';
import 'package:firstapp/Screens/User/User_Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/utilities/colors.dart';
import 'User_Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserForgotPasswordScreen extends StatefulWidget {
  const UserForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _UserForgotPasswordScreenState createState() =>
      _UserForgotPasswordScreenState();
}

class _UserForgotPasswordScreenState extends State<UserForgotPasswordScreen> {
  final _formKey = new GlobalKey<FormState>();
  final _userPassword = TextEditingController();
  final _userCPassword = TextEditingController();
  final _userEmail = TextEditingController();
  String _userCEmail = '';
  String _userName = '';
  String _userCity = '';
  String _userState = '';
  int? _userId;
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final UserDao _dao = UserDao();

  bool _showCoverPassword = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _userId = sp.getInt('userID');
      _userName = sp.getString("userName")!;
      _userCEmail = sp.getString("userEmail")!;
      //_userPassword.text = sp.getString("userPassword")!;
      _userCity = sp.getString("userCity")!;
      _userState = sp.getString("userState")!;
    });
  }

  Widget _UserData(
      {required String title,
      required String hintTitle,
      required IconData icon,
      required TextEditingController textUser}) {
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
            controller: textUser,
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

  Widget _UserForgotPassoword(
      {required String title,
      required String hintTitle,
      required TextEditingController textUser}) {
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
            controller: textUser,
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
    int uid = _userId!;
    String uname = _userName;
    String uemail = _userEmail.text;
    String upasswd = _userPassword.text;
    String ucpasswd = _userCPassword.text;
    String ucity = _userCity;
    String ustate = _userState;

    if (_formKey.currentState!.validate()) {
      if(uemail != _userCEmail){
        alertDialog("Email Errado");
      }else if (uemail.isEmpty) {
        alertDialog("Por favor escreva seu email");
      }else if (upasswd != ucpasswd) {
        alertDialog('Password diferentes');
      }else {
        _formKey.currentState!.save();

        UserModel uModel =
            UserModel(uid, uname, uemail, ucity, ustate, upasswd);
        await _dao.updateUser(uModel).then((userData) {
          alertDialog("salvo com sucesso");
          print(uModel);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const UserLoginScreen()),
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
                      _UserData(
                          title: 'Digite o seu e-mail',
                          hintTitle: 'Ex: exemple@gmail.com',
                          icon: Icons.email,
                          textUser: _userEmail),
                      const SizedBox(height: 10.0),
                      _UserForgotPassoword(
                          title: 'Digite a nova senha',
                          hintTitle: 'senha entre 8 à 16 caracteres',
                          textUser: _userPassword),
                      const SizedBox(height: 10.0),
                      _UserForgotPassoword(
                          title: 'Confirme a senha',
                          hintTitle: 'senha entre 8 à 16 caracteres',
                          textUser: _userCPassword),
                      _ShowCoverPassword(),
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