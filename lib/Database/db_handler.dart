
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_list_app/Database/data_model.dart';

class DBHelper {
  static Database? _db ;
  
  Future<Database?> get db async {
    if (_db != null) {
      return _db ;
    }
    _db = await initDatabase();
    return _db ;
  }
  
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory() ;
    String path = join(documentDirectory.path, 'todo.db') ;
    var db = await openDatabase(path, version: 1, onCreate: _onCreate) ;
    return db ;
  }
  
  

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT, status Text)"
    );
  }

  Future<DataModel> insert(DataModel dataModel) async {
    var dbClient = await db ;
    await dbClient!.insert('Tasks', dataModel.toMap()) ;
    return dataModel ;
  }

  Future<List<DataModel>> read() async {
    var dbClient = await db ;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('Tasks') ;
    return queryResult.map((e) => DataModel.fromMap(e)).toList() ;
  }

  Future<int> update(DataModel dataModel) async {
    var dbClient = await db ;
    return await dbClient!.update(
      'Tasks',
      dataModel.toMap(),
      where: 'id = ?',
      whereArgs: [dataModel.id]
    );
  }

  Future<int> delete(int id) async {
    var dbClient = await db ;
    return await dbClient!.delete(
      'Tasks',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> updatedStatus(int id, String status) async {
    var dbClient = await db ;
    return await dbClient!.rawUpdate('''UPDATE Tasks SET status = ? WHERE id = ?''', [status, id] );
    /*return await dbClient!.rawUpdate(
      'UPDATE Task SET status = ? WHERE id = ?', [status, id]
    );*/
  }
}