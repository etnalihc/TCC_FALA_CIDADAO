// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, avoid_print, non_constant_identifier_names

import 'package:firstapp/Database/PrefectureModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:toast/toast.dart';
import '../../Comm/ComHelp.dart';
import 'Prefecture_Register_Screen.dart';
import 'Prefecture_Forgot_Password_Screen.dart';
import 'Prefecture_home_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/Database/Prefecture_dao.dart';
import 'package:firstapp/Database/PrefectureModel.dart';

class PrefectureLoginScreen extends StatefulWidget {
  const PrefectureLoginScreen({Key? key}) : super(key: key);

  @override
  _PrefectureLoginScreenState createState() => _PrefectureLoginScreenState();
}

class _PrefectureLoginScreenState extends State<PrefectureLoginScreen> {
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final PrefecDao _dao = PrefecDao();
  bool _showCoverPassword = true;

  final _prefectureEmail = TextEditingController();
  final _prefecturePassword = TextEditingController();
  final _prefectureCode = TextEditingController();

  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  Future setSP(PrefecModel prefecture) async {
    final SharedPreferences sp = await _pref;
    print(_dao.findAll());

    sp.setInt('prefecID', prefecture.prefecID);
    sp.setString("prefecName", prefecture.prefecName);
    sp.setString("prefecEmail", prefecture.prefecEmail);
    sp.setString("prefecPassword", prefecture.prefecPassword);
    sp.setString("prefecCity", prefecture.prefecCity);
    sp.setString("prefecState", prefecture.prefecState);
    sp.setString("prefecCode", prefecture.prefecCode);
    print(sp.getString("prefecName"));
  }

  Widget _PrefectureLoginData({
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

  Widget _PrefecturePassoword({
    required TextEditingController PrefectureText,
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
            controller: PrefectureText,
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

  Widget _ForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          print('Forgot Password Button Pressed');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const PrefectureForgotPasswordScreen()));
        },
        padding: const EdgeInsets.only(right: 0.0),
        child: const Text(
          'esqueceu a senha?',
          style: kLabelStyle,
        ),
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
    String pemail = _prefectureEmail.text;
    String ppasswd = _prefecturePassword.text;
    String pcode = _prefectureCode.text;
    print(pemail);
    if (pemail.isEmpty) {
      alertDialog("Por favor escreva seu email");
    } else if (ppasswd.isEmpty) {
      alertDialog("Por favor escreva sua senha");
    } else if (pcode.isEmpty) {
      alertDialog("Por favor escreva seu codigo");
    } else {
      await _dao.getLoginPrefecture(pemail, pcode, ppasswd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            print(userData);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const PrefectureHomeScreen()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog("Email ou senha invalidos");
        }
      }).catchError((error) {
        print(error);
        alertDialog("Erro ao logar");
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
            MaterialPageRoute(
                builder: (context) => const PrefectureRegisterScreen()));
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
              'Login Prefeitura',
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
                    vertical: 80.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _PrefectureLoginData(
                          Title: 'E-mail',
                          hintTitle: 'Digite o e-mail da prefeitura',
                          icon: Icons.email,
                          PrefectureText: _prefectureEmail),
                      const SizedBox(height: 30.0),
                      _PrefectureLoginData(
                          Title: 'Código da Prefeitura',
                          hintTitle: 'Digite o codigo da prefeitura',
                          icon: Icons.numbers,
                          PrefectureText: _prefectureCode),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _PrefecturePassoword(PrefectureText: _prefecturePassword),
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

class NetworkService {
  static Future getData() async {
    return await Future.delayed(const Duration(seconds: 2));
  }
}