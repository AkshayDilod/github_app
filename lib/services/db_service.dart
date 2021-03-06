import 'dart:io';

import '../model/git_data_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  final String _tbName = 'topic';

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "gitData.db");
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db
          .execute("CREATE TABLE $_tbName ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "name TEXT,"
              "description TEXT,"
              "watchers_count  INTEGER,"
              "language TEXT,"
              "open_issues_count INTEGER"
              ")")
          .whenComplete(() {
        print('TABLE CREATE SUCCESSFULLY');
      });
    });
  }

  insert(GitDataModel newEntry) async {
    try {
      final db = await initDB();
      var count = await db.insert(_tbName, newEntry.toMap());
      return count;
    } catch (e) {
      print(e);
    }
  }

  Future<List<GitDataModel>?> read(int _offset) async {
    List<GitDataModel> offlineData = [];
    try {
      final db = await initDB();
      var list = await db.query(_tbName, limit: 15, offset: _offset);
      if (list.isNotEmpty) {
        offlineData = list.map((e) => GitDataModel.fromMap(e)).toList();
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
    return offlineData;
  }
}
