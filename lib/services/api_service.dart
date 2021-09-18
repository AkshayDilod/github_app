import 'dart:convert';
import 'dart:io';


import '../model/git_data_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  List<GitDataModel> _gitDataList = [];
  Future<List<GitDataModel>> getGitData(int pageNo) async {
    final uri = Uri.parse(
        'https://api.github.com/users/JakeWharton/repos?page=$pageNo&per_page=15');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        Iterable list = jsonDecode(response.body);
        _gitDataList = list.map((e) => GitDataModel.fromMap(e)).toList();
      }
    } on SocketException {
     throw Exception('No Internet connection');
    } on HttpException {
     throw Exception("Service is unavailable");
    }
    return _gitDataList;
  }
}
