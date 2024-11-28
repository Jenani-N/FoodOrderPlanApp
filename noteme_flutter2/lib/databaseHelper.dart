import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class databaseHelper {
  static final databaseHelper instance = databaseHelper._init();
  static Database? _database;
  databaseHelper._init();



  //Creating the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orderPlan.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  //creating the table for order plans
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orderPlan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        cost TEXT NOT NULL,
        food TEXT NOT NULL
      )
    ''');
  }

  //inserting into the database
  Future<int> insertOrder(Map<String, String> order) async {
    final db = await instance.database;
    return await db.insert('orderPlan', order);
  }

  //getting entries from database
  Future<List<Map<String, dynamic>>> fetchorderPlan() async {
    final db = await instance.database;
    return await db.query('orderPlan');
  }

  //deleting order plan entries from the db
  Future<int> deleteOrderPlan(int id) async {
    final db = await instance.database;
    return await db.delete(
      'orderPlan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //close database connection
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
