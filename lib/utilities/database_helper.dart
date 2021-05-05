import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:assignment_tindercarousel/models/tinder_user.dart' ;
import 'dart:async';


class DatabaseHelper {

  final String tinderUserTable = 'userTable' ;

  DatabaseHelper._() ;

  static final DatabaseHelper db = DatabaseHelper._() ;

  static Database _database;

  Future<Database> get database async {

    if(_database != null){
      return _database ;
    }
    _database =  await initDB();
    return _database;

  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'TinderDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) { },
        onCreate: (Database db, int version) async  {
          await db.execute("CREATE TABLE $tinderUserTable (uid INTEGER PRIMARY KEY, username_first TEXT, username_last TEXT, email TEXT, location_street TEXT, "
              "location_city TEXT, phone TEXT, dob TEXT, image_url TEXT)");
        }
    );
  }

  Future<int> insert(TinderUser user) async {
    Database db = await database;
    int id = await db.insert(tinderUserTable, user.toJson());
    return id;
  }

  Future<List<TinderUser>> getTinderUsers() async {
    final db = await database;
    var res = await db.query(tinderUserTable);
    List<TinderUser> tinderUsers = res.isNotEmpty ? res.map((user) => TinderUser.fromLocalDBJson(user)).toList() : [];
    return tinderUsers;
  }


  Future<int> getNumberOfSavedTinderUsers() async {
    final db = await database;
    var res = await db.query(tinderUserTable);
    List<TinderUser> tinderUsers = res.isNotEmpty ? res.map((user) => TinderUser.fromLocalDBJson(user)).toList() : [];

    if(tinderUsers != null || tinderUsers != []){
      return tinderUsers.length;
    }
    else {
      return 0 ;
    }

  }


  deleteAll() async {
    Database db = await database;
    await db.delete(tinderUserTable);
  }


}