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
      var res = await db.insert(_tbName, newEntry.toMap());
      return res;
    } catch (e) {
      print(e);
    }
  }

  Future<List<GitDataModel>> read() async {
    List<GitDataModel> offlineData = [];
    try {
      final db = await initDB();
      var res = await db.query(_tbName);
      offlineData = res.map((e) => GitDataModel.fromMap(e)).toList();
      for (var item in offlineData) {
        print(item.language);
      }
    } catch (e) {
      print(e);
    }
    return offlineData;
  }
}
