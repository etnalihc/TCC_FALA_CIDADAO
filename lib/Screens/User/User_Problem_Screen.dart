// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../Comm/ComHelp.dart';
import 'User_Home_Screen.dart';

class UserProblemScreen extends StatefulWidget {
  const UserProblemScreen({Key? key}) : super(key: key);

  @override
  _UserProblemScreenState createState() => _UserProblemScreenState();
}

class _UserProblemScreenState extends State<UserProblemScreen> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();
  final _userTextEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  SendEmail(String body) async {
    final Email email = Email(
      body: body,
      subject: 'Problema aplicativo',
      recipients: ['brunonavarro_chilante@hotmail.com'],
      //cc: ['cc@example.com'],
      //bcc: ['bcc@example.com'],
      //attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  Send() async {
    print(_userTextEmail);
    _formKey.currentState!.save();
    if (_userTextEmail.text.isEmpty) {
      alertDialog("Por favor escreva o conteudo do email");
    } else {
      SendEmail(_userTextEmail.text).whenComplete(
        () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const UserHomeScreen()),
            (Route<dynamic> route) => false,
          );
        },
      );
    }
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

  Widget _TextEmailsendBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Digite o Problema',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          decoration: kBoxDecorationStyle,
          height: 100.0,
          child: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 1, //Normal textInputField will be displayed
            maxLines: null, // when user presses enter it will adapt to it
            style: kOpenSansWhite,
            controller: _userTextEmail,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
            ),
          ),
        ),
      ],
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
              'Relatar Problema',
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
                      _TextEmailsendBox(),
                      const SizedBox(
                        height: 10,
                      ),
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
