// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:toast/toast.dart';
import 'User_Login_Screen.dart';
import 'package:firstapp/Comm/ComHelp.dart';
import 'package:firstapp/Database/UserModel.dart';
import 'package:firstapp/Database/User_dao.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({Key? key}) : super(key: key);

  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _userName = TextEditingController();
  final _userEmail = TextEditingController();
  final _userCity = TextEditingController();
  final _userState = TextEditingController();
  final _userPassword = TextEditingController();
  final _userCPassword = TextEditingController();

  bool _showCoverPassword = true;

  final UserDao _dao = UserDao();

  Widget _UserData({
    required String Title,
    required String hintTitle,
    required IconData icon,
    required TextEditingController userText,
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
            controller: userText,
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

  Widget _UserRegisterPassoword({
    required String Title,
    required String hintTitle,
    required TextEditingController userText,
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
          height: 60.0,
          child: TextField(
            controller: userText,
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

  signUp() async {
    String uname = _userName.text;
    String uemail = _userEmail.text;
    String upasswd = _userPassword.text;
    String ucpasswd = _userCPassword.text;
    String ucity = _userCity.text;
    String ustate = _userState.text;

    if (_formKey.currentState!.validate()) {
      if (upasswd != ucpasswd) {
        alertDialog('Password diferentes');
      } else {
        _formKey.currentState!.save();

        UserModel uModel = UserModel(0, uname, uemail, ucity, ustate, upasswd);
        await _dao.save(uModel).then((userData) {
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
    ToastContext().init(context);
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
        //value: SystemUiOverlayStyle.light,
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
                        Title: 'Digite seu nome completo',
                        hintTitle: 'Ex: João da Silva',
                        icon: Icons.person_outline,
                        userText: _userName,
                      ),
                      const SizedBox(height: 10.0),
                      _UserData(
                        Title: 'Digite o Estado que você mora',
                        hintTitle: 'Ex: Paraná',
                        icon: Icons.location_on,
                        userText: _userState,
                      ),
                      const SizedBox(height: 10.0),
                      _UserData(
                        Title: 'Digite a cidade que você mora',
                        hintTitle: 'Ex: curitiba',
                        icon: Icons.location_on,
                        userText: _userCity,
                      ),
                      const SizedBox(height: 10.0),
                      _UserData(
                        Title: 'Criar e-mail',
                        hintTitle: 'Ex: exemplo@gmail.com',
                        icon: Icons.email,
                        userText: _userEmail,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      _UserRegisterPassoword(
                        Title: 'Digite a senha que deseja criar',
                        hintTitle: 'senha entre 8 a 16 caracteres',
                        userText: _userPassword,
                      ),
                      const SizedBox(height: 10.0),
                      _UserRegisterPassoword(
                        Title: 'Digite a senha que deseja criar',
                        hintTitle: 'senha entre 8 a 16 caracteres',
                        userText: _userCPassword,
                      ),
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