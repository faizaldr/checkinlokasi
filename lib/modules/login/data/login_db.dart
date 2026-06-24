import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LoginDb {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "token.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE tokens (id INTEGER PRIMARY KEY AUTOINCREMENT, token TEXT) ",
        );
      },
    );
  }

  Future<int> saveToken(String token) async {
    final db = await database;
    return await db.insert("tokens", {'token': token});
  }
  Future<String?> getToken() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tokens', limit: 1);
    if (maps.isNotEmpty) {
      return (maps.first)['token'] as String;
    }
    return null;
  }
  Future<int> updateToken(String token) async {
    final db = await database;
    return await db.update('tokens', {'token': token});
  }
  Future<int> deleteToken(String token) async {
    final db = await database;
    return await db.delete('tokens');
  }
}
