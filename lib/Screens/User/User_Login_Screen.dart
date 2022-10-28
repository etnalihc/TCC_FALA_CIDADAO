// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, avoid_print, non_constant_identifier_names

import 'package:firstapp/Screens/User/User_Register_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:firstapp/Screens/User/User_Home_Screen.dart';
import '../../Comm/ComHelp.dart';
import 'User_Forgot_Password_Screen.dart';
import 'package:firstapp/Database/User_dao.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/Database/UserModel.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({Key? key}) : super(key: key);

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  bool _rememberMe = false;
  bool _showCoverPassword = true;
  final _formKey = GlobalKey<FormState>();
  final UserDao _dao = UserDao();

  final _userEmail = TextEditingController();
  final _userPassword = TextEditingController();

  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("userName", user.userName);
    sp.setInt('userID', user.userID);
    sp.setString("userEmail", user.userEmail);
    sp.setString("userPassword", user.userPassword);
    sp.setString("userCity", user.userCity);
    sp.setString("userState", user.userState);
    print(sp.getString("userName"));
  }

  Widget _UserLoginData({
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

  Widget _UserPassoword({
    required TextEditingController userText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Senha',
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
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Digite sua senha',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _ForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          print('Forgot Password Button Pressed');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserForgotPasswordScreen()));
        },
        padding: const EdgeInsets.only(right: 0.0),
        child: const Text(
          'esqueceu a senha?',
          style: kLabelStyle,
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

  Widget _RememberMeCheckbox() {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          const Text(
            'lembrar conta',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  login() async {
    String uemail = _userEmail.text;
    String passwd = _userPassword.text;

    if (uemail.isEmpty) {
      alertDialog("Por favor escreva seu email");
    } else if (passwd.isEmpty) {
      alertDialog("Por favor escreva sua senha");
    } else {
      await _dao.getLoginUser(uemail, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            print(userData);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const UserHomeScreen()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog("E-mail ou senha invalidos");
        }
      }).catchError((error) {
        print(error);
        alertDialog("Erro ao entrar");
      });
    }
  }

  Widget _LoginBtn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: login,
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: const Text(
          'LOGIN',
          style: kOpenSans,
        ),
      ),
    );
  }

  Widget _SignupBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('sign up Button Pressed');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UserRegisterScreen()),
        );
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'não tem uma conta? ',
              style: kfontSize_16,
            ),
            TextSpan(
              text: 'cadastre-se',
              style: kfontSize_16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    print(_dao.findAll());
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          width: 250,
          child: Center(
            child: Text(
              'Login Usuario',
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
                      _UserLoginData(
                          Title: 'E-mail',
                          hintTitle: 'Digite seu e-mail',
                          icon: Icons.email,
                          userText: _userEmail),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _UserPassoword(userText: _userPassword),
                      _ShowCoverPassword(),
                      _ForgotPasswordBtn(),
                      //_RememberMeCheckbox(),
                      _LoginBtn(context),
                      _SignupBtn(context),
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