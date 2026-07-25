import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _key = 'efo_life_os_state';

  Future<Map<String, dynamic>> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  Future<void> saveState(Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state));
  }
}
