import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _apiResponse = '';
  String get apiResponse => _apiResponse;
  set apiResponse(String _value) {
    _apiResponse = _value;
  }

  String _error = 'No Error';
  String get error => _error;
  set error(String _value) {
    _error = _value;
  }

  String _test = '';
  String get test => _test;
  set test(String _value) {
    _test = _value;
  }

  DateTime? _time = DateTime.fromMillisecondsSinceEpoch(1698401880000);
  DateTime? get time => _time;
  set time(DateTime? _value) {
    _time = _value;
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
