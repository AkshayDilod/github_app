import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:github/helper/dependency.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../services/db_service.dart';
import '../model/git_data_model.dart';
import '../services/api_service.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  ApiService api = getIt<ApiService>();
  bool loading = false;
  bool initialLoading = false;
  bool hasData = true;
  bool hasLocalData = true;
  bool isRefreshPressed = false;
  bool isWifiEnable = false;
  static int page = 1;
  static int offset = 0;
  final List<GitDataModel>? gitData = [];
  List<GitDataModel>? _onlineDataList = [];
  List<GitDataModel>? _offlineDataList = [];

  String error = '';
  final _db = DBService();

  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  onPageScroll(int pageNo) {
    page = pageNo;
    fetchGitData();
  }

  getDataONRefresh() {
    initialLoading = true;
    isRefreshPressed = true;
    notifyListeners();
    onPageScroll(1);
  }

  initialDataLoading() {
    page = 1;
    initialLoading = true;
    notifyListeners();
    fetchGitData();
  }

  fetchGitData() async {
    loading = true;
    notifyListeners();
    try {
      if (hasData) {
        var list = await api.getGitData(page);
        if (list.isNotEmpty) {
          _onlineDataList = list;
        } else {
          loading = false;
          hasData = false;
        }
      }
    } catch (e) {
      error = e.toString().split('Exception').last;
    }
    loading = false;
    initialLoading = false;
    gitData!.addAll(_onlineDataList!);
    _insertDataIntoDB(_onlineDataList!);
    notifyListeners();
  }

  _insertDataIntoDB(List<GitDataModel> _list) {
    for (var item in _list) {
      _db.insert(item);
    }
  }

  initialLocalDataLoading() {
    initialLoading = true;
    notifyListeners();
    readLocalData(0);
  }

  readLocalData(int _offset) async {
    loading = true;
    notifyListeners();
    if (hasLocalData) {
      var list = await _db.read(_offset);
      if (list != null) {
        _offlineDataList = list;
        offset = _offlineDataList!.length + offset;
        await Future.delayed(const Duration(seconds: 2), () {
          gitData!.addAll(_offlineDataList!);
        });
      } else {
        hasLocalData = false;
        loading = false;
      }
    }
    loading = false;
    initialLoading = false;
    notifyListeners();
  }

  initWifiIs(bool wifi) {
    isWifiEnable = wifi;
    notifyListeners();
  }

  setWifiOnOff(bool isWifi) {
    WiFiForIoTPlugin.setEnabled(isWifi);
    if (isWifi) {
      WiFiForIoTPlugin.disconnect();
    } else {
      WiFiForIoTPlugin.isConnected();
    }
    isWifiEnable = isWifi;
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
