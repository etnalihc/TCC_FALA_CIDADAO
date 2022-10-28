import 'package:firstapp/Database/Prefecture_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Localization_dao.dart';
import 'User_dao.dart';

Future<Database> getDatabase() async {
  //Diretorio local do app  //Path:  //final String path = join(await getDatabasesPath(), 'shomer.db');
  final String databasesPath = await getDatabasesPath();
  final String path = join(databasesPath, 'tcc_app.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(LocationDao.tableSql);
      db.execute(UserDao.tableSql);
      db.execute(PrefecDao.tableSql);
    },
    version: 1,
  );
}