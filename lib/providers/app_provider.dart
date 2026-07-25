import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  Map<String, dynamic> _state = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;

  Future<void> load() async {
    _state = await _storage.loadState();
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

  dynamic get(String key) => _state[key];

  void setValue(String key, dynamic value) {
    _state[key] = value;
    notifyListeners();
    _storage.saveState(_state);
  }

  void toggleBool(String key) {
    setValue(key, !getBool(key));
  }
}
