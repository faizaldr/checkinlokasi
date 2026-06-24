import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LoginDb {
  static Database? _database;

  Future<Database> get database async{
    if(_database !=null) return _database!;
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
          "CREATE TABLE tokens (id INTEGER PRUMARY KEY AUTOINCREMENT, token TEXT) ",
        );
      },
    );
  }
}
