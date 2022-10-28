import 'package:sqflite/sqflite.dart';
import 'LocModel.dart';
import 'Create_DataBase.dart';

class LocationDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_locId INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_location TEXT, '
      '$_photo TEXT, '
      '$_info TEXT, '
      '$_type TEXT,'
      '$_status TEXT)';
  static const String _tableName = 'Localization';
  static const String _location = 'location';
  static const String _locId = 'id';
  static const String _photo = 'photo';
  static const String _info = 'info';
  static const String _type = 'type';
  static const String _status = 'status';

  Future<int> save(LocationModel location) async {
    final Database db = await getDatabase();
    Map<String, dynamic> locationMap = _toMap(location);
    return db.insert(_tableName, locationMap);
  }

  Future<int> delete(int id) async {
    final Database db = await getDatabase();
    return db.delete(
      _tableName,
      where: '$_locId = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateLocStatus(LocationModel loc) async {
    final Database db = await getDatabase();
    var res = await db.update(_tableName, loc.toJson(),
        where: '$_locId = ?', whereArgs: [loc.id]);
    return res;
  }

  Future<List<LocationModel>> getLocationStatusF(String status) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> res = await db.query(_tableName,
        columns: [
          _locId,
          _location,
          _photo,
          _info,
          _type,
          _status,
        ],
        where: '$_status =?',
        whereArgs: [status]);
    List<LocationModel> locStatus = _toList(res);
    return locStatus;
  }

  Future<List<LocationModel>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<LocationModel> locations = _toList(result);
    return locations;
  }

  Map<String, dynamic> _toMap(LocationModel location) {
    final Map<String, dynamic> locationMap = {};
    locationMap[_location] = location.lInfo;
    locationMap[_photo] = location.photo;
    locationMap[_info] = location.info;
    locationMap[_type] = location.type;
    locationMap[_status] = location.status;
    return locationMap;
  }

  List<LocationModel> _toList(List<Map<String, dynamic>> result) {
    final List<LocationModel> locations = [];
    for (Map<String, dynamic> row in result) {
      final LocationModel location = LocationModel(
        row[_locId],
        row[_location],
        row[_photo],
        row[_info],
        row[_type],
        row[_status],
      );
      locations.add(location);
    }
    print(locations);
    return locations;
  }
}