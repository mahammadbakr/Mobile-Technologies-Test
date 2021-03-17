import 'dart:async';
import 'dart:io';

import 'package:new_flutter_test/Models/UserModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "UserDB.db");
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User ("
          "id INTEGER PRIMARY KEY,"
          "IMEI INTEGER,"
          "first_name TEXT,"
          "last_name TEXT,"
          "doB TEXT,"
          "passport INTEGER,"
          "email TEXT,"
          "picture TEXT,"
          "deviceName TEXT,"
          "lat FLOAT,"
          "lng FLOAT"
          ")");
    });
  }

  newUser(User newUser) async {
    final db = await database;
    // var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM User");
    // int id = table.first["id"];
    var res = await db.rawInsert(
        "INSERT Into User (IMEI,first_name,last_name,doB,passport,email,picture,deviceName,lat,lng)"
        " VALUES (?,?,?,?,?,?,?,?,?,?)",
        [newUser.IMEI, newUser.firstName, newUser.lastName, newUser.doB,newUser.passport,newUser.email,newUser.picture,newUser.deviceName,newUser.lat,newUser.lng]);
    return res;
  }

  updateUser(User newUser) async {
    final db = await database;
    var res = await db.update("User", newUser.toMap(),
        where: "id = ?", whereArgs: [newUser.IMEI]);
    return res;
  }

  getUser(int IMEI) async {
    final db = await database;
    var res = await db.query("User", where: "id = ?", whereArgs: [IMEI]);
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }


  Future<List<User>> getAllUsers() async {
    final db = await database;
    var res = await db.query("User");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  deleteUser(int id) async {
    final db = await database;
    return db.delete("User", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from User");
  }
}
