// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:firstapp/Database/UserModel.dart';
import 'package:firstapp/Database/User_dao.dart';
import 'package:firstapp/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User_Home_Screen.dart';
import '../../Comm/ComHelp.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final _userName = TextEditingController();
  final _userEmail = TextEditingController();
  final _userCity = TextEditingController();
  final _userState = TextEditingController();
  final _userPassword = TextEditingController();
  int? _userId;
  final UserDao _dao = UserDao();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _userId = sp.getInt('userID');
      _userName.text = sp.getString("userName")!;
      _userEmail.text = sp.getString("userEmail")!;
      _userPassword.text = sp.getString("userPassword")!;
      _userCity.text = sp.getString("userCity")!;
      _userState.text = sp.getString("userState")!;
    });
  }

  Widget _UserData({
    required String Title,
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
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _UserPassoword(
      {required String Title, required TextEditingController userText}) {
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

  update() async {
    int uid = _userId!;
    String uname = _userName.text;
    String uemail = _userEmail.text;
    String upasswd = _userPassword.text;
    String ucity = _userCity.text;
    String ustate = _userState.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      UserModel user = UserModel(uid, uname, uemail, ucity, ustate, upasswd);
      await _dao.updateUser(user).then((value) {
        if (value == 1) {
          alertDialog("Successfully Updated");

          updateSP(user, true).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const UserHomeScreen()),
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
    int uid = _userId!;
    String uname = _userName.text;
    String uemail = _userEmail.text;
    String upasswd = _userPassword.text;
    String ucity = _userCity.text;
    String ustate = _userState.text;

    UserModel prefecture =
          UserModel(uid, uname, uemail, ucity, ustate, upasswd);
    await _dao.deleteUser(uid).then((value) {
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

  Future updateSP(UserModel user, bool add) async {
    final SharedPreferences sp = await _pref;

    if (add) {
      sp.setString("userName", user.userName);
      sp.setInt('userID', user.userID);
      sp.setString("userEmail", user.userEmail);
      sp.setString("userPassword", user.userPassword);
      sp.setString("userCity", user.userCity);
      sp.setString("userState", user.userState);
    } else {
      sp.remove('userID');
      sp.remove('userName');
      sp.remove('userEmail');
      sp.remove('userPassword');
      sp.remove('userCity');
      sp.remove('userState');
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
              'Dados do Usuário',
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
                          Title: 'Usuário',
                          icon: Icons.person_outline,
                          userText: _userName),
                      const SizedBox(height: 10.0),
                      _UserData(
                          Title: 'Estado',
                          icon: Icons.location_on,
                          userText: _userState),
                      const SizedBox(height: 10.0),
                      _UserData(
                          Title: 'Cidade',
                          icon: Icons.location_on,
                          userText: _userCity),
                      const SizedBox(height: 10.0),
                      _UserData(
                          Title: 'E-mail',
                          icon: Icons.email,
                          userText: _userEmail),
                      const SizedBox(height: 10.0),
                      _UserPassoword(
                        Title: 'Senha',
                        userText: _userPassword,
                      ),
                      _ShowCoverPassword(),
                      _UpdateBtn(),
                      const SizedBox(height: 20,),
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