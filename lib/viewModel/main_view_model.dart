import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../services/db_service.dart';
import '../model/git_data_model.dart';
import '../services/api_service.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel() {
    updatePage(0);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  bool loading = false;
  bool initialLoading = false;
  bool hasData = true;
  int page = 0;
  List<GitDataModel> gitData = [];
  List<GitDataModel> _temp = [];
  String error = '';

  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  updatePage(int pageNo) {
    page = pageNo;
    fetchGitData();
    notifyListeners();
  }

  getDataONRefresh() {
    initialLoading = true;
    updatePage(0);
    notifyListeners();
  }

  fetchGitData() async {
    final db = DBService();
    try {
      if (hasData) {
        loading = true;
        var list = await ApiService().getGitData(page);
        if (list.isNotEmpty) {
          _temp.addAll(list);
          gitData = [..._temp];
          for (var item in _temp) {
            db.insert(item);
          }
        } else {
          loading = false;
          hasData = false;
        }
      }
    } catch (e) {
      error = e.toString().split('Exception').last;
      _temp = await db.read();
      gitData = [..._temp];
    }
    loading = false;
    initialLoading = false;
    notifyListeners();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    notifyListeners();
  }
}
