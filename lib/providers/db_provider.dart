import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:q_test/models/comments_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();

    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'comments.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Comments('
          'id INTEGER PRIMARY KEY,'
          'postId INTEGER,'
          'name TEXT,'
          'email TEXT,'
          'body TEXT'
          ')');
    });
  }

  insertComments(CommentsModel newComment) async {
    final db = await database;
    final response = await db.insert(
      'Comments',
      newComment.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return response;
  }

  Future<int> deleteAllComments() async {
    final db = await database;
    final response = await db.rawDelete('DELETE FROM Comments');

    return response;
  }

  Future<List<CommentsModel>> comments() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM Comments');

    final list = List.generate(maps.length, (index) {
      return CommentsModel(
        id: maps[index]['id'],
        body: maps[index]['body'],
        email: maps[index]['email'],
        name: maps[index]['name'],
        postId: maps[index]['postId'],
      );
    });

    return list;
  }
}
