// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, non_constant_identifier_names, sized_box_for_whitespace

import 'package:firstapp/Database/LocModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utilities/colors.dart';
import 'package:firstapp/Database/Localization_dao.dart';
import 'Prefecture_info_Screen.dart';

class PrefectureHistoryScreen extends StatefulWidget {
  const PrefectureHistoryScreen({Key? key}) : super(key: key);
  @override
  _PrefectureHistoryScreenState createState() =>
      _PrefectureHistoryScreenState();
}

class _PrefectureHistoryScreenState extends State<PrefectureHistoryScreen> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final _formKey = new GlobalKey<FormState>();

  final LocationDao _dao = LocationDao();

  @override
  Widget build(BuildContext context) {
    String status = 'Finalizado';
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          width: 250,
          child: Center(
            child: Text(
              'Histórico',
              style: kfontSize_28,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<LocationModel>>(
        key: _formKey,
        initialData: [],
        future: _dao.getLocationStatusF(status),
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
                                      Container(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 50,
                                            width: 250,
                                            child: RaisedButton(
                                              color: Colors.white,
                                              child: Text(
                                                local.type.toString(),
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