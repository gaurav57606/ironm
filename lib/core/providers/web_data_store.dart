import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebDataStore {
  static const String _prefix = 'ironm_web_db_';
  final SharedPreferences _prefs;

  WebDataStore(this._prefs);

  Future<void> save(String collection, String id, Map<String, dynamic> data) async {
    final key = '$_prefix${collection}_$id';
    await _prefs.setString(key, jsonEncode(data));
    
    // Maintain a list of IDs for the collection
    final idsKey = '$_prefix${collection}_ids';
    final ids = _prefs.getStringList(idsKey) ?? [];
    if (!ids.contains(id)) {
      ids.add(id);
      await _prefs.setStringList(idsKey, ids);
    }
  }

  Future<Map<String, dynamic>?> get(String collection, String id) async {
    final key = '$_prefix${collection}_$id';
    final data = _prefs.getString(key);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    final idsKey = '$_prefix${collection}_ids';
    final ids = _prefs.getStringList(idsKey) ?? [];
    final results = <Map<String, dynamic>>[];
    
    for (final id in ids) {
      final data = await get(collection, id);
      if (data != null) results.add(data);
    }
    return results;
  }

  Future<void> delete(String collection, String id) async {
    final key = '$_prefix${collection}_$id';
    await _prefs.remove(key);
    
    final idsKey = '$_prefix${collection}_ids';
    final ids = _prefs.getStringList(idsKey) ?? [];
    if (ids.contains(id)) {
      ids.remove(id);
      await _prefs.setStringList(idsKey, ids);
    }
  }

  Future<void> clear() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
