// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, non_constant_identifier_names, sized_box_for_whitespace

import 'package:firstapp/Screens/Login.dart';
import 'package:firstapp/Screens/User/User_Info_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firstapp/utilities/colors.dart';
import 'package:firstapp/Screens/User/Photo_Screen.dart';
import 'User_History_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User_Problem_Screen.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final webscraper = WebScraper('https://gmconline.com.br');

  List<String> texts = [];
  List<Map<String, dynamic>> elements = [];
  List<String> links = [];

  String _userName = '';
  String _userEmail = '';
  String _userCity = '';
  String _userState = '';
  String _userPassword = '';

  @override
  void initState() {
    super.initState();
    GetWebData().whenComplete(() => getUserData());
    // getUserData();
  }

  Future<List<String>> getData() async {
    List<String> text = texts;

    return text;
  }

  Future<void> GetWebData() async {
    if (await webscraper.loadWebPage('/noticias/cidade/')) {
      texts = webscraper.getElementTitle('div.article-excerpt > p');
      elements = webscraper.getElement('h3.article-title > a', ['href']);
      print(elements);
      elements.forEach((element) {
        return links.add(element['attributes']['href']);
      });

      print(links);
      setState(() {});
    }
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _userName = sp.getString("userName")!;
      _userEmail = sp.getString("userEmail")!;
      _userPassword = sp.getString("userPassword")!;
      _userCity = sp.getString("userCity")!;
      _userState = sp.getString("userState")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_userName);
    print(_userEmail);
    print(_userPassword);
    print(_userCity);
    print(_userState);
    //getUserData();
    return Scaffold(
      appBar: AppBar(title: const Text('página pricipal - notícias')),
      drawer: Drawer(
        backgroundColor: const Color(0xFF6CA8F1),
        child: ListView(
          children: [
            SizedBox(
              height: 100.0,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_pin,
                      color: Colors.white,
                      size: 50,
                    ),
                    Text(_userName, style: kfontSize_20),
                  ],
                ),
              ),
            ),
            ListTile(
              title:
                  const Text('Histórico de envios', style: kfontSize_18_black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserHistoryScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Ajuda', style: kfontSize_18_black),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Configuração da conta',
                  style: kfontSize_18_black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserInfoScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Relatar erro no aplicativo', style: kfontSize_18_black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProblemScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Relatar uma ocorrência', style: kfontSize_18_black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PhotoScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            ListTile(
              title: const Text('Sair', style: kfontSize_18_Red),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                height: double.maxFinite,
                width: double.maxFinite,
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
              Container(
                height: double.maxFinite,
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      texts == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: <Widget>[
                                Container(
                                  height: 1050,
                                  width: double.maxFinite,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(12),
                                    itemCount: texts.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final text = texts[index];
                                      final element = elements[index];
                                      final link = links[index];
                                      print(link);
                                      //print(element);
                                      return Container(
                                        width: double.maxFinite,
                                        color: Colors.grey,
                                        child: Column(
                                          children: [
                                            RaisedButton(
                                              child: Text(
                                                element['title'].toString(),
                                                style: kfontSize_16_black,
                                              ),
                                              onPressed: () async {
                                                var url = Uri.parse(link);
                                                print(url);
                                                  await launchUrl(url);
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              text.toString(),
                                              style: kfontSize_16,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
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