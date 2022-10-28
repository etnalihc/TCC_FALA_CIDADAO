import 'package:sqflite/sqflite.dart';
import 'UserModel.dart';
import 'Create_DataBase.dart';

class UserDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_userID INTEGER PRIMARY KEY, '
      '$_userName TEXT, '
      '$_userCity TEXT, '
      '$_userState TEXT, '
      '$_userPassword TEXT, '
      '$_userEmail TEXT)';
  static const String _tableName = 'CreateUser';
  static const String _userName = 'userName';
  static const String _userID = 'userID';
  static const String _userEmail = 'userEmail';
  static const String _userCity = 'userCity';
  static const String _userState = 'userState';
  static const String _userPassword = 'userPassword';

  Future<int> save(UserModel user) async {
    final Database db = await getDatabase();
    Map<String, dynamic> userMap = _toMap(user);
    return db.insert(_tableName, userMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteUser(int userID) async {
    final Database db = await getDatabase();
    var res = await db
        .delete(_tableName, where: '$_userID = ?', whereArgs: [userID]);
    return res;
  }

  Future<int> updateUser(UserModel user) async {
    final Database db = await getDatabase();
    var res = await db.update(_tableName, user.toJson(),
        where: '$_userID = ?', whereArgs: [user.userID]);
    return res;
  }

  Future<UserModel?> getLoginUser(String uEmail, String uPassword) async {
    final Database db = await getDatabase();
    var res = await db.query(_tableName,
        columns: [
          _userID,
          _userName,
          _userEmail,
          _userCity,
          _userState,
          _userPassword,
        ],
        where: '$_userEmail =? AND $_userPassword =? ',
        whereArgs: [uEmail, uPassword]);
    if (res.isNotEmpty) {
      print(res.first);
      var json = res.first;
      print(json['userName']);
      print(json['userEmail']);
      return UserModel.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<List<UserModel>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<UserModel> users = _toList(result);
    return users;
  }

  Map<String, dynamic> _toMap(UserModel user) {
    final Map<String, dynamic> userMap = {};
    userMap[_userName] = user.userName;
    userMap[_userEmail] = user.userEmail;
    userMap[_userCity] = user.userCity;
    userMap[_userState] = user.userState;
    userMap[_userPassword] = user.userPassword;
    return userMap;
  }

  List<UserModel> _toList(List<Map<String, dynamic>> result) {
    final List<UserModel> users = [];
    for (Map<String, dynamic> row in result) {
      final UserModel user = UserModel(
        row[_userID],
        row[_userName],
        row[_userEmail],
        row[_userCity],
        row[_userState],
        row[_userPassword],
      );
      users.add(user);
    }
    print(users);
    return users;
  }
}