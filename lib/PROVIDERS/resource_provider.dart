import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResourceProvider extends ChangeNotifier {
  static const _storageKey = 'resources';

  final List<Map<String, dynamic>> _resources = [];

  List<Map<String, dynamic>> get resources => List.unmodifiable(_resources);

  ResourceProvider() {
    _loadFromPrefs();
  }

  // ── Load saved resources on app start ──
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storageKey);
    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(raw);
      _resources.addAll(decoded.cast<Map<String, dynamic>>());
      notifyListeners();
    } else {
      // First launch — seed with default resources
      _resources.addAll(_defaultResources);
      await _saveToPrefs();
      notifyListeners();
    }
  }

  // ── Save current list to SharedPreferences ──
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_resources));
  }

  // ── Add a new resource (from Upload tab) ──
  Future<void> addResource(Map<String, dynamic> resource) async {
    _resources.add(resource);
    await _saveToPrefs();
    notifyListeners();
  }

  // ── Delete a resource by index ──
  Future<void> deleteResource(int index) async {
    _resources.removeAt(index);
    await _saveToPrefs();
    notifyListeners();
  }

  // ── Default resources shown on first launch ──
  static const List<Map<String, dynamic>> _defaultResources = [
    {
      'title': 'Conference Room A',
      'location': 'Block C, Floor 2',
      'capacity': '30 people',
      'category': 'Rooms',
      'resourcePic':
          'https://webbox.imgix.net/images/yquusvyjiwygqitw/064bfb4e-d1d8-47de-800c-b126e8a90335.jpg?auto=format,compress&fit=crop&crop=entropy',
    },
    {
      'title': 'Training Lab — 20 PCs',
      'location': 'ICT Block, Ground Floor',
      'capacity': '20 people',
      'category': 'Equipment',
      'resourcePic':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOvf0YUEs9owIhg8JNiwOeEksgCQBuvUsjvA&s',
    },
    {
      'title': 'Ardhi Football Pitch',
      'location': 'Kigamboni, Kings Academy',
      'capacity': '50 max',
      'category': 'Sports',
      'resourcePic':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaaSNxY4ipxlFoPXLlj12hTKJ2T333uaRkQA&s',
    },
  ];
}