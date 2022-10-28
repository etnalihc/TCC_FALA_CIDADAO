// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:firstapp/Screens/User/User_Login_Screen.dart';
import 'package:firstapp/Screens/Prefecture/Prefecture_Login_Screen.dart';
import 'package:firstapp/Database/Prefecture_dao.dart';
import 'package:firstapp/Database/PrefectureModel.dart';
import 'package:firstapp/Database/UserModel.dart';
import 'package:firstapp/Database/User_dao.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PrefecDao _pdao = PrefecDao();
  final UserDao _udao = UserDao();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {}

  Widget _ChoseLogin({
    required String title,
    required IconData icon,
    required VoidCallback onClick,
  }) {
    return Container(
      width: 200,
      height: 50.0,
      alignment: Alignment.topLeft,
      child: RaisedButton(
        //elevation: 0,
        color: Colors.white,
        //onPressed: onClick,
        onPressed: onClick,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            children: <Widget>[
              Icon(icon),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                title,
                style: kOpenSans,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Login',
                          style: kfontSize_28,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      const Text('Escolha a forma do login',
                          style: kfontSize_20),
                      const SizedBox(
                        height: 100.0,
                      ),
                      _ChoseLogin(
                        title: 'Usuário',
                        icon: Icons.person,
                        onClick: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserLoginScreen(),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      _ChoseLogin(
                        title: 'Prefeitura',
                        icon: Icons.house_sharp,
                        onClick: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PrefectureLoginScreen(),
                            ),
                          );
                        }),
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