// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, non_constant_identifier_names, sized_box_for_whitespace

import 'package:firstapp/Database/LocModel.dart';
import 'package:firstapp/Screens/Login.dart';
import 'package:firstapp/Screens/Prefecture/Prefecture_InfoData_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Comm/ComHelp.dart';
import '../../utilities/colors.dart';
import 'package:firstapp/Database/Localization_dao.dart';
import 'Prefecture_info_Screen.dart';
import 'Prefecture_Problem_Screen.dart';
import 'Prefecture_History_Screen.dart';

class PrefectureHomeScreen extends StatefulWidget {
  const PrefectureHomeScreen({Key? key}) : super(key: key);
  @override
  _PrefectureHomeScreenState createState() => _PrefectureHomeScreenState();
}

enum Menu { emvisualizacao, emandamento, finalizado }

class _PrefectureHomeScreenState extends State<PrefectureHomeScreen> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final _formKey = new GlobalKey<FormState>();

  String _prefecName = '';
  String _prefecEmail = '';
  String _prefecCity = '';
  String _prefecState = '';
  String _prefecPassword = '';
  String _prefecCode = '';

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      _prefecName = sp.getString("prefecName")!;
      _prefecEmail = sp.getString("prefecEmail")!;
      _prefecPassword = sp.getString("prefecPassword")!;
      _prefecCity = sp.getString("prefecCity")!;
      _prefecState = sp.getString("prefecState")!;
      _prefecCode = sp.getString('prefecCode')!;
    });
  }

  final LocationDao _dao = LocationDao();


  UpdateStatus(String loc, int locId, String info, String type, String status,
      String photo) async {

    LocationModel location =
        LocationModel(locId, loc, photo, info, type, status);
    await _dao.updateLocStatus(location).then((value) {
      if (value == 1) {
        print('tipo:$type, status:$status');
      } else {
        print('Error');
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('página principal')),
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
                    Text(_prefecName, style: kfontSize_20),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Histórico', style: kfontSize_18_black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrefectureHistoryScreen(),
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
                    builder: (context) => const PrefectureInfoDataScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Relatar problemas', style: kfontSize_18_black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrefectureProblemScreen(),
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
      body: FutureBuilder<List<LocationModel>>(
        key: _formKey,
        initialData: [],
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading')
                  ],
                ),
              );
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
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
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ListView.builder(
                                //physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final LocationModel local =
                                      snapshot.data![index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 70,
                                            width: 330,
                                            color: Colors.white,
                                            child: RaisedButton(
                                              color: Colors.white,
                                              child: Text(
                                                '${local.type.toString()} '
                                                ' Status:${local.status}',
                                                style: kfontSize_14,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PostInfo(
                                                      location: local.lInfo,
                                                      image: local.photo,
                                                      locInfo: local.info,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            height: 70,
                                            width: 60,
                                            color: Colors.white,
                                            child: PopupMenuButton<Menu>(
                                              elevation: 4,
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              icon: const Icon(
                                                Icons.more_vert,
                                                color: Colors.black,
                                              ),
                                              onSelected: (Menu item) async {
                                                setState(() {
                                                  if (item.name ==
                                                      'emandamento') {
                                                    UpdateStatus(
                                                        local.lInfo,
                                                        local.id,
                                                        local.info,
                                                        local.type,
                                                        'Em andamento',
                                                        local.photo);
                                                  } else if (item.name ==
                                                      'emvisualizacao') {
                                                    UpdateStatus(
                                                        local.lInfo,
                                                        local.id,
                                                        local.info,
                                                        local.type,
                                                        'Em vizualização',
                                                        local.photo);
                                                  } else if (item.name ==
                                                      'finalizado') {
                                                    UpdateStatus(
                                                        local.lInfo,
                                                        local.id,
                                                        local.info,
                                                        local.type,
                                                        'Finalizado',
                                                        local.photo);
                                                  } else {
                                                    alertDialog(
                                                        'Erro inesperado');
                                                  }
                                                  print(
                                                      local.status.toString());
                                                });
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry<Menu>>[
                                                const PopupMenuItem<Menu>(
                                                  value: Menu.emvisualizacao,
                                                  child:
                                                      Text('Em Visualização'),
                                                ),
                                                const PopupMenuItem<Menu>(
                                                  value: Menu.emandamento,
                                                  child: Text('Em andamento'),
                                                ),
                                                const PopupMenuItem<Menu>(
                                                  value: Menu.finalizado,
                                                  child: Text('Finalizado'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
          return Text('Unknown error');
        },
      ),
    );
  }
}