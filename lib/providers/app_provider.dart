import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  Map<String, dynamic> _state = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;

  Future<void> load() async {
    _state = await _storage.loadState();
    if (_state['journey_start_date'] == null) {
      final now = DateTime.now();
      _state['journey_start_date'] = '${now.year}-${now.month}-${now.day}';
      await _storage.saveState(_state);
    }
    _loaded = true;
    notifyListeners();
  }

  bool getBool(String key, {bool fallback = false}) {
    final v = _state[key];
    if (v is bool) return v;
    return fallback;
  }

  String getString(String key, {String fallback = ''}) {
    final v = _state[key];
    if (v is String) return v;
    return fallback;
  }

  int getInt(String key, {int fallback = 0}) {
    final v = _state[key];
    if (v is int) return v;
    return fallback;
  }

  dynamic get(String key) => _state[key];

  void setValue(String key, dynamic value) {
    _state[key] = value;
    notifyListeners();
    _storage.saveState(_state);
  }

  void toggleBool(String key) {
    setValue(key, !getBool(key));
  }

  List<bool> getBoolList(String key, int length) {
    final v = _state[key];
    if (v is List) {
      final list = v.map((e) => e == true).toList();
      if (list.length == length) return List<bool>.from(list);
    }
    return List<bool>.filled(length, false);
  }

  void setBoolListAt(String key, int length, int index, bool value) {
    final list = getBoolList(key, length);
    list[index] = value;
    setValue(key, list);
  }

  List<Map<String, dynamic>> getMapList(String key) {
    final v = _state[key];
    if (v is List) {
      return v.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  void setMapList(String key, List<Map<String, dynamic>> list) {
    setValue(key, list);
  }

  /// Counts every completed checklist item ever recorded (schedule, study, GK, bible).
  int lifetimeCompletedCount() {
    int count = 0;
    const prefixes = ['schedule_', 'daystudy_', 'nightstudy_', 'gk_', 'bible_'];
    _state.forEach((k, v) {
      if (v is List && prefixes.any((p) => k.startsWith(p))) {
        count += v.where((e) => e == true).length;
      }
    });
    return count;
  }
}
  void setMapList(String key, List<Map<String, dynamic>> list) {
    setValue(key, list);
  }
}
