import 'package:sqflite/sqflite.dart';
import 'PrefectureModel.dart';
import 'Create_DataBase.dart';

class PrefecDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_prefecID INTEGER PRIMARY KEY, '
      '$_prefecName TEXT, '
      '$_prefecCity TEXT, '
      '$_prefecState TEXT, '
      '$_prefecPassword TEXT, '
      '$_prefecEmail TEXT,'
      '$_prefecCode TEXT)';
  static const String _tableName = 'CreatePrefecture';
  static const String _prefecName = 'prefecName';
  static const String _prefecID = 'prefecID';
  static const String _prefecEmail = 'prefecEmail';
  static const String _prefecCity = 'prefecCity';
  static const String _prefecState = 'prefecState';
  static const String _prefecPassword = 'prefecPassword';
  static const String _prefecCode = 'prefecCode';

  Future<int> save(PrefecModel prefec) async {
    final Database db = await getDatabase();
    Map<String, dynamic> prefecMap = _toMap(prefec);
    return db.insert(
      _tableName,
      prefecMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deletePrefecture(int prefecId) async {
    final Database db = await getDatabase();
    var res = await db
        .delete(_tableName, where: '$_prefecID = ?', whereArgs: [prefecId]);
    return res;
  }

  Future<PrefecModel?> getLoginPrefecture(
      String pEmail, String pCode, String pPassword) async {
    final Database db = await getDatabase();
    var res = await db.query(_tableName,
        columns: [
          _prefecID,
          _prefecName,
          _prefecEmail,
          _prefecCity,
          _prefecState,
          _prefecPassword,
          _prefecCode,
        ],
        where: '$_prefecEmail =? AND $_prefecCode =? AND $_prefecPassword =? ',
        whereArgs: [pEmail, pCode, pPassword]);
    if (res.isNotEmpty) {
      print(res.first);
      var json = res.first;
      print(json['prefecName']);
      print(json['prefecCode']);
      print(json['prefecEmail']);
      return PrefecModel.fromJson(res.first);
    } else {
      return null;
    }
  }

    Future<int> updatePrefecture(PrefecModel prefecture) async {
    final Database db = await getDatabase();
    var res = await db.update(_tableName, prefecture.toJson(),
        where: '$_prefecID = ?', whereArgs: [prefecture.prefecID]);
    return res;
  }

  Future<List<PrefecModel>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<PrefecModel> prefectures = _toList(result);
    return prefectures;
  }

  Map<String, dynamic> _toMap(PrefecModel prefecture) {
    final Map<String, dynamic> prefectureMap = {};
    prefectureMap[_prefecName] = prefecture.prefecName;
    prefectureMap[_prefecEmail] = prefecture.prefecEmail;
    prefectureMap[_prefecCity] = prefecture.prefecCity;
    prefectureMap[_prefecState] = prefecture.prefecState;
    prefectureMap[_prefecPassword] = prefecture.prefecPassword;
    prefectureMap[_prefecCode] = prefecture.prefecCode;
    return prefectureMap;
  }

  List<PrefecModel> _toList(List<Map<String, dynamic>> result) {
    final List<PrefecModel> prefectures = [];
    for (Map<String, dynamic> row in result) {
      final PrefecModel prefecture = PrefecModel(
          row[_prefecID],
          row[_prefecName],
          row[_prefecEmail],
          row[_prefecCity],
          row[_prefecState],
          row[_prefecPassword],
          row[_prefecCode]);
      prefectures.add(prefecture);
    }
    print(prefectures);
    return prefectures;
  }
}